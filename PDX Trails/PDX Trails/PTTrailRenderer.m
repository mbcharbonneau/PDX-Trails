//
//  PTTrailRenderer.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/5/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailRenderer.h"
#import "PTTrail.h"
#import "PTConstants.h"
#import "PTTrailSegment.h"

@interface PTTrailRenderer()
@end

@implementation PTTrailRenderer

#pragma mark PTTrailRenderer

- (instancetype)initWithTrail:(PTTrail *)trail;
{
    if ( self = [super initWithOverlay:trail] ) {
        
        self.strokeColor = [UIColor PTBlueTintColor];
        self.lineWidth = 4.0;
    }
    
    return self;
}

- (void)setIsSelected:(BOOL)isSelected;
{
    self.strokeColor = isSelected ? [UIColor redColor] : [UIColor PTBlueTintColor];

    if ( _isSelected != isSelected )
        [self setNeedsDisplay];
    
    _isSelected = isSelected;
}

- (PTTrail *)trail;
{
    return self.overlay;
}

#pragma mark MKOverlayPathRenderer

- (void)createPath;
{
    PTTrail *trail = (PTTrail *)self.overlay;
    UIBezierPath *path = [UIBezierPath new];
    
    for ( PTTrailSegment *segment in trail.segments )
    {
        NSInteger index, count = [segment.coordinates count];
        
        for ( index = 0; index < count; index++ ) {
            CLLocationCoordinate2D coordinate;
            [segment.coordinates[index] getValue:&coordinate];
            
            MKMapPoint mapPoint = MKMapPointForCoordinate( coordinate );
            CGPoint point = [self pointForMapPoint:mapPoint];
            
            if ( index == 0 )
                [path moveToPoint:point];
            else
                [path addLineToPoint:point];
        }
    }
    
    self.path = path.CGPath;
}

#pragma mark MKOverlayRenderer

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context;
{
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
}

@end
