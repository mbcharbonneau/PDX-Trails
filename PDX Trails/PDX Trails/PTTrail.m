//
//  PTTrail.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrail.h"
#import "PTTrailSegment.h"

@implementation PTTrail

#pragma mark PTTrail

- (MKPolyline *)polyline;
{
    NSMutableArray *linestring = [NSMutableArray new];
    
    for ( PTTrailSegment *segment in self.segments ) {
        [linestring addObjectsFromArray:segment.coordinates];
    }
    
    NSInteger index, count = [linestring count];
    CLLocationCoordinate2D coordinates[count];
    
    for ( index = 0; index < count; index++ ) {
        CLLocationCoordinate2D coordinate;
        [linestring[index] getValue:&coordinate];
        coordinates[index] = coordinate;
    }
    
    return [MKPolyline polylineWithCoordinates:coordinates count:count];
}

#pragma mark MKOverlay

- (MKMapRect)boundingMapRect;
{
    return [self polyline].boundingMapRect;
}

- (CLLocationCoordinate2D)coordinate;
{
    return [self polyline].coordinate;
}

#pragma mark NSObject

- (id)init;
{
    if ( self = [super init] ) {
        self.segments = @[];
    }
    
    return self;
}

@end
