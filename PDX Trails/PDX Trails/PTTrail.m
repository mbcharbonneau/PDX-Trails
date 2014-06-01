//
//  PTTrail.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrail.h"

@implementation PTTrail

#pragma mark MKOverlay

- (MKMapRect)boundingMapRect;
{
    return self.polyline.boundingMapRect;
}

- (CLLocationCoordinate2D)coordinate;
{
    return self.polyline.coordinate;
}

@end
