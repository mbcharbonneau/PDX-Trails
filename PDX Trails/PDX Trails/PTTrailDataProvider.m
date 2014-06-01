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
    
    trail.name = @"West Side Test Trail";
    trail.identifier = @"1";
    trail.description = @"TEST DATA";
    trail.polyline = segment;
    
    
    
    coords[0] = CLLocationCoordinate2DMake(45.51263, -122.668134);
    coords[1] = CLLocationCoordinate2DMake(45.512406, -122.668055);
    coords[2] = CLLocationCoordinate2DMake(45.507983, -122.666163);
    
    
    PTTrail *trail2 = [PTTrail new];
    MKPolyline *segment2 = [MKPolyline polylineWithCoordinates:coords count:3];
    
    trail2.name = @"East Side Test Trail";
    trail2.identifier = @"1";
    trail2.description = @"TEST DATA";
    trail2.polyline = segment2;


    
    return @[trail, trail2];
}

@end
