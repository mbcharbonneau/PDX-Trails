//
//  PTTrailOverlay.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/20/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailOverlay.h"

@interface PTTrailOverlay()

@property (strong, nonatomic) UIBezierPath *cachedPath;

- (UIBezierPath *)mapPath;

@end

@implementation PTTrailOverlay

#pragma mark PTTrailOverlay

- (instancetype)initWithTrail:(OTTrail *)trail;
{
    NSParameterAssert( trail != nil );
    
    if ( self = [super init] ) {
        _trail = trail;
    }
    
    return self;
}

- (double)metersFromPoint:(MKMapPoint)point;
{
    double trailDistance = MAXFLOAT;

    for ( OTTrailSegment *segment in self.trail.segments ) {
        
        NSUInteger idx;
        double segmentDistance = MAXFLOAT;
        
        for ( idx = 0; idx < [segment.coordinates count] - 1; idx++ ) {
            
            CLLocationCoordinate2D coordinateA, coordinateB;
            MKMapPoint pointA, pointB;
            
            [segment.coordinates[idx] getValue:&coordinateA];
            [segment.coordinates[idx + 1] getValue:&coordinateB];

            pointA = MKMapPointForCoordinate( coordinateA );
            pointB = MKMapPointForCoordinate( coordinateB );
            
            double deltaX = pointB.x - pointA.x;
            double deltaY = pointB.y - pointA.y;
            
            if ( deltaX == 0.0 && deltaY == 0.0 )
                continue;
            
            double u = ( ( point.x - pointA.x ) * deltaX + ( point.y - pointA.y ) * deltaY ) / ( deltaX * deltaX + deltaY * deltaY );
            MKMapPoint closestPoint;
            
            if ( u < 0.0 ) {
                closestPoint = pointA;
            }
            else if (u > 1.0) {
                closestPoint = pointB;
            }
            else {
                closestPoint = MKMapPointMake( pointA.x + u * deltaX, pointA.y + u * deltaY );
            }
            
            segmentDistance = MIN( segmentDistance, MKMetersBetweenMapPoints( closestPoint, point ) );
        }
        
        trailDistance = MIN( trailDistance, segmentDistance );
    }
    
    return trailDistance;
}

- (UIBezierPath *)mapPath;
{
    if ( self.cachedPath == nil ) {
        
        self.cachedPath = [UIBezierPath new];
        
        for ( OTTrailSegment *segment in self.trail.segments ) {
            NSInteger index, count = [segment.coordinates count];
            
            for ( index = 0; index < count; index++ ) {
                CLLocationCoordinate2D coordinate;
                [segment.coordinates[index] getValue:&coordinate];
                
                MKMapPoint mapPoint = MKMapPointForCoordinate( coordinate );
                CGPoint point = CGPointMake( mapPoint.x, mapPoint.y );
                
                if ( index == 0 )
                    [self.cachedPath moveToPoint:point];
                else
                    [self.cachedPath addLineToPoint:point];
            }
        }
    }
    
    return self.cachedPath;
}

- (void)setTrail:(OTTrail *)trail;
{
    [self willChangeValueForKey:@"trail"];
    _cachedPath = nil;
    _trail = trail;
    [self didChangeValueForKey:@"trail"];
}

#pragma mark MKOverlay

- (MKMapRect)boundingMapRect;
{
    UIBezierPath *path = [self mapPath];
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
