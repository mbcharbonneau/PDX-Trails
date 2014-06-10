//
//  PTTrail.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrail.h"
#import "PTTrailSegment.h"

@interface PTTrail()

@end

@implementation PTTrail

#pragma mark MKOverlay

- (MKMapRect)boundingMapRect;
{
    UIBezierPath *path = [UIBezierPath new];
    
    for ( PTTrailSegment *segment in self.segments )
    {
        NSInteger index, count = [segment.coordinates count];
        
        for ( index = 0; index < count; index++ ) {
            CLLocationCoordinate2D coordinate;
            [segment.coordinates[index] getValue:&coordinate];
            
            MKMapPoint mapPoint = MKMapPointForCoordinate( coordinate );
            CGPoint point = CGPointMake( mapPoint.x, mapPoint.y );
            
            if ( index == 0 )
                [path moveToPoint:point];
            else
                [path addLineToPoint:point];
        }
    }
    
    CGRect bounds = [path bounds];
    MKMapRect map = MKMapRectMake( bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height );
    
    return map;
}

- (CLLocationCoordinate2D)coordinate;
{
    MKMapRect bounds = [self boundingMapRect];
    return CLLocationCoordinate2DMake( MKMapRectGetMidX( bounds ), MKMapRectGetMidY( bounds ) );
}

#pragma mark NSObject

- (id)init;
{
    if ( self = [super init] ) {
        self.segments = @[];
    }
    
    return self;
}

#pragma mark KVO Compliance

+ (NSSet *)keyPathsForValuesAffectingBoundingMapRect;
{
    return [NSSet setWithObjects:@"segments", nil];
}

+ (NSSet *)keyPathsForValuesAffectingCoordinate;
{
    return [NSSet setWithObjects:@"segments", nil];
}

@end
