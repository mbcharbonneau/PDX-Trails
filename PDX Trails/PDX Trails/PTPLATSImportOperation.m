//
//  PTPLATSTrailImportOperation.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTPLATSImportOperation.h"
#import "PTTrail.h"
#import "PTTrailSegment.h"
#import "CHCSVParser.h"
#import "PTConstants.h"
#import "PTTrailhead.h"

@interface PTPLATSImportOperation() <CHCSVParserDelegate>

@property (strong) NSMutableDictionary *segmentsByIDs;
@property (strong) NSMutableDictionary *trailsByIDs;
@property (strong) PTTrail *currentTrail;
@property (assign) BOOL isParsing;
@property (assign) BOOL isComplete;

- (void)parseTrailheads;
- (void)parseTrailSegments;
- (void)parseTrails;

- (NSArray *)trailSegmentsMatchingIDs:(NSString *)string;
- (NSArray *)trailsMatchingIDs:(NSString *)string;

@end

@implementation PTPLATSImportOperation

- (void)parseTrailheads;
{
    NSAssert( ![NSThread isMainThread], @"must be called on background thread" );
    
    @try {
        
        NSURL *segmentsFileURL = [[NSBundle mainBundle] URLForResource:@"trailheads" withExtension:@"geojson"];
        NSData *data = [NSData dataWithContentsOfURL:segmentsFileURL];
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *features = root[@"features"];
        
        for ( NSDictionary *feature in features ) {
            
            NSDictionary *geometry = feature[@"geometry"];
            NSDictionary *properties = feature[@"properties"];
            NSArray *coordinates = geometry[@"coordinates"];
            NSArray *trails = [self trailsMatchingIDs:properties[@"trail_ids"]];
            
            double longitude = [coordinates[0] doubleValue];
            double latitude = [coordinates[1] doubleValue];

            PTTrailhead *trailhead = [PTTrailhead new];
            
            trailhead.coordinates = CLLocationCoordinate2DMake( latitude, longitude );
            trailhead.name = properties[@"name"];
            
            for ( PTTrail *trail in trails ) {

                NSMutableArray *trailheads = [trail.trailheads mutableCopy];
                [trailheads addObject:trailhead];
                trail.trailheads = [trailheads copy];
            }
        }
        
        self.importedTrails = [[self.trailsByIDs allValues] copy];
    }
    @catch (NSException *exception) {
        
        self.error = [[NSError alloc] initWithDomain:PTErrorDomain code:PTErrorCodeDataFormatError userInfo:nil];
    }
    @finally {
        
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        
        self.isParsing = NO;
        self.isComplete = YES;
        
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)parseTrailSegments;
{
    NSAssert( ![NSThread isMainThread], @"must be called on background thread" );
    
    @try {
        
        NSURL *segmentsFileURL = [[NSBundle mainBundle] URLForResource:@"trail_segments" withExtension:@"geojson"];
        NSData *data = [NSData dataWithContentsOfURL:segmentsFileURL];
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *features = root[@"features"];
        self.segmentsByIDs = [[NSMutableDictionary alloc] initWithCapacity:[features count]];
        
        for ( NSDictionary *feature in features ) {
            NSDictionary *geometry = feature[@"geometry"];
            NSDictionary *properties = feature[@"properties"];
            NSArray *coordinatePairs = geometry[@"coordinates"];
            
            NSInteger index, count = [coordinatePairs count];
            CLLocationCoordinate2D coordinates[count];
            
            for ( index = 0; index < count; index++ ) {
                NSArray *pair = coordinatePairs[index];
                double longitude = [pair[0] doubleValue];
                double latitude = [pair[1] doubleValue];
                coordinates[index] = CLLocationCoordinate2DMake( latitude, longitude );
            }
            
            PTTrailSegment *segment = [[PTTrailSegment alloc] initWithCoordinates:coordinates count:count];
            segment.identifier = properties[@"id"];
            [self.segmentsByIDs setObject:segment forKey:segment.identifier];
        }
    }
    @catch (NSException *exception) {
        
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        
        self.error = [[NSError alloc] initWithDomain:PTErrorDomain code:PTErrorCodeDataFormatError userInfo:nil];
        self.isParsing = NO;
        self.isComplete = YES;
        
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }

    [self parseTrails];
}

- (void)parseTrails;
{
    NSAssert( ![NSThread isMainThread], @"must be called on background thread" );

    NSURL *segmentsFileURL = [[NSBundle mainBundle] URLForResource:@"named_trails" withExtension:@"csv"];
    CHCSVParser *parser = [[CHCSVParser alloc] initWithContentsOfCSVFile:[segmentsFileURL path]];
    
    parser.delegate = self;
    [parser parse];
}

- (NSArray *)trailSegmentsMatchingIDs:(NSString *)string;
{
    NSArray *components = [string componentsSeparatedByString:@";"];
    NSMutableSet *segments = [[NSMutableSet alloc] initWithCapacity:[components count]];
    
    for ( NSString *segmentID in components ) {
        
        PTTrailSegment *segment = self.segmentsByIDs[segmentID];
        
        if ( segment == nil )
            continue;
        
        [segments addObject:segment];
    }

    return [segments allObjects];
}

- (NSArray *)trailsMatchingIDs:(NSString *)string;
{
    NSArray *components = [string componentsSeparatedByString:@";"];
    NSMutableSet *trails = [[NSMutableSet alloc] initWithCapacity:[components count]];
    
    for ( NSString *trailID in components ) {
        
        PTTrail *trail = self.trailsByIDs[trailID];
        
        if ( trail == nil )
            continue;
        
        [trails addObject:trail];
    }
    
    return [trails allObjects];
}

#pragma mark NSOperation

- (void)start;
{
    [self willChangeValueForKey:@"isExecuting"];
    self.isParsing = YES;
    [self parseTrailSegments];
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent;
{
    return YES;
}

- (BOOL)isExecuting;
{
    return self.isParsing;
}

- (BOOL)isFinished;
{
    return self.isComplete;
}

#pragma mark CHCSVParserDelegate

- (void)parserDidBeginDocument:(CHCSVParser *)parser;
{
    self.trailsByIDs = [[NSMutableDictionary alloc] init];
}

- (void)parserDidEndDocument:(CHCSVParser *)parser;
{
    [self parseTrailheads];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber;
{
    if ( recordNumber == 1 )
        return;
    
    self.currentTrail = [[PTTrail alloc] init];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber;
{
    if ( [self.currentTrail.identifier length] > 0 )
        [self.trailsByIDs setObject:self.currentTrail forKey:self.currentTrail.identifier];
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex;
{
    switch ( fieldIndex ) {
        case 0:
            self.currentTrail.name = field;
            break;
        case 1:
            self.currentTrail.segments = [self trailSegmentsMatchingIDs:field];
            break;
        case 2:
            self.currentTrail.identifier = field;
            break;
        default:
            break;
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error;
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    NSDictionary *userInfo = @{ NSUnderlyingErrorKey : error };
    self.error = [[NSError alloc] initWithDomain:PTErrorDomain code:PTErrorCodeDataFormatError userInfo:userInfo];
    self.isParsing = NO;
    self.isComplete = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
