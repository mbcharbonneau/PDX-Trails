//
//  PTTrailOverlay.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/20/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailOverlay.h"

@implementation PTTrailOverlay

- (instancetype)initWithTrail:(OTTrail *)trail;
{
    NSParameterAssert( trail != nil );
    
    if ( self = [super init] ) {
        _trail = trail;
    }
    
    return self;
}

#pragma mark MKOverlay

- (MKMapRect)boundingMapRect;
{
    UIBezierPath *path = [UIBezierPath new];
    
    for ( OTTrailSegment *segment in self.trail.segments )
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

#pragma mark KVO Compliance

+ (NSSet *)keyPathsForValuesAffectingBoundingMapRect;
{
    return [NSSet setWithObjects:@"trail", nil];
}

+ (NSSet *)keyPathsForValuesAffectingCoordinate;
{
    return [NSSet setWithObjects:@"trail", nil];
}


@end
