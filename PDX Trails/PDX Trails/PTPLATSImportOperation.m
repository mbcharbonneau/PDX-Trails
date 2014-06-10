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

@interface PTPLATSImportOperation() <CHCSVParserDelegate>

@property (strong) NSDictionary *segmentsByIDs;
@property (strong) NSMutableArray *namedTrails;
@property (assign) BOOL isParsing;

- (void)parseTrailSegments;
- (void)parseTrails;

@end

@implementation PTPLATSImportOperation

- (void)parseTrailSegments;
{
    NSAssert( ![NSThread isMainThread], @"must be called on background thread" );
    
    @try {
        
        NSURL *segmentsFileURL = [[NSBundle mainBundle] URLForResource:@"trail_segments" withExtension:@"geojson"];
        NSData *data = [NSData dataWithContentsOfURL:segmentsFileURL];
        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *features = root[@"features"];
        NSMutableDictionary *segments = [[NSMutableDictionary alloc] initWithCapacity:[features count]];
        
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
            [segments setObject:segment forKey:segment.identifier];
        }
        
        self.segmentsByIDs = [segments copy];
    }
    @catch (NSException *exception) {
        
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        
        self.error = [[NSError alloc] initWithDomain:PTErrorDomain code:PTErrorCodeDataFormatError userInfo:nil];
        self.isParsing = NO;
        
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
    return self.importedTrails != nil || self.error != nil;
}

#pragma mark CHCSVParserDelegate

- (void)parserDidBeginDocument:(CHCSVParser *)parser;
{
    NSLog( @"%@:%p began importing data.", NSStringFromClass( [self class] ), self );
    self.namedTrails = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(CHCSVParser *)parser;
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    NSLog( @"%@:%p finished import with %ld trails.", NSStringFromClass( [self class] ), self, (long)[self.namedTrails count] );
    self.importedTrails = [self.namedTrails copy];
    self.isParsing = NO;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber;
{
    if ( recordNumber == 1 )
        return;
    
    PTTrail *trail = [[PTTrail alloc] init];
    [self.namedTrails addObject:trail];
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex;
{
    PTTrail *currentTrail = [self.namedTrails lastObject];
    
    if ( fieldIndex == 0 ) {
    
        currentTrail.name = field;

    } else if ( fieldIndex == 1 ) {

        NSArray *segmentIDs = [field componentsSeparatedByString:@";"];
        
        for ( NSString *segmentID in segmentIDs ) {
            
            PTTrailSegment *segment = self.segmentsByIDs[segmentID];
            
            if ( segment == nil )
                continue;
            
            NSMutableArray *segments = [currentTrail.segments mutableCopy];
            [segments addObject:segment];
            currentTrail.segments = [segments copy];
        }
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error;
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    NSDictionary *userInfo = @{ NSUnderlyingErrorKey : error };
    self.error = [[NSError alloc] initWithDomain:PTErrorDomain code:PTErrorCodeDataFormatError userInfo:userInfo];
    self.isParsing = NO;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
