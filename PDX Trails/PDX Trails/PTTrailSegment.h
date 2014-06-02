//
//  PTTrailSegment.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface PTTrailSegment : NSObject

@property (strong) NSString *identifier;
@property (strong) NSString *name;
@property (strong) NSArray *coordinates;

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count;

@end
