//
//  PTTrail.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface PTTrail : NSObject <MKOverlay>

@property (strong) NSString *identifier;
@property (strong) NSString *name;
@property (strong) NSString *description;
@property (strong) NSArray *attributes;
@property (strong) NSArray *segments;
@property (strong) NSArray *trailheads;

@end
