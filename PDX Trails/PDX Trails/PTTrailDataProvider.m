//
//  PTTrailDataProvider.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailDataProvider.h"
#import "PTTrail.h"

@implementation PTTrailDataProvider

+ (instancetype)sharedDataProvider;
{
    static id dataProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataProvider = [[self alloc] init];
    });
    
    return dataProvider;
}

- (NSArray *)trailsForRegion:(MKCoordinateRegion)region;
{
    CLLocationCoordinate2D coords[3];
    
    coords[0] = CLLocationCoordinate2DMake(45.517892, -122.670287);
    coords[1] = CLLocationCoordinate2DMake(45.517106, -122.671848);
    coords[2] = CLLocationCoordinate2DMake(45.511847, -122.674679);
    
    PTTrail *trail = [PTTrail new];
    MKPolyline *segment = [MKPolyline polylineWithCoordinates:coords count:3];
    
    trail.name = @"TEST TRAIL";
    trail.identifier = @"1";
    trail.description = @"TEST DATA";
    trail.polyline = segment;
    
    return @[trail];
}

@end
