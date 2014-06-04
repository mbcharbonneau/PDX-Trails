//
//  PTPLATSTrailImportOperation.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTPLATSTrailImportOperation.h"
#import "PTTrail.h"
#import "PTTrailSegment.h"

@interface PTPLATSTrailImportOperation()

- (NSDictionary *)trailSegmentsByIdentifier;
- (NSArray *)trailsFromSegments:(NSDictionary *)segments;

@end

@implementation PTPLATSTrailImportOperation

- (void)main;
{
    @autoreleasepool {
        
        NSDictionary *segments = [self trailSegmentsByIdentifier];
        NSArray *trails = [self trailsFromSegments:segments];
        
        self.importedTrails = trails;
    }
}

- (NSDictionary *)trailSegmentsByIdentifier;
{
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
    
    return [segments copy];
}

- (NSArray *)trailsFromSegments:(NSDictionary *)segments;
{
    return nil;
}

@end
