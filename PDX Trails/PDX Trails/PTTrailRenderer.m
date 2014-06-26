//
//  PTTrailRenderer.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/5/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailRenderer.h"
#import "PTTrailOverlay.h"
#import "PTConstants.h"
#import "OTTrail.h"

@interface PTTrailRenderer()
@end

@implementation PTTrailRenderer

#pragma mark PTTrailRenderer

- (void)setIsSelected:(BOOL)isSelected;
{
    self.strokeColor = isSelected ? [UIColor redColor] : [UIColor PTBlueTintColor];
    self.lineWidth = isSelected ? 6.0 : 4.0f;
    
    if ( _isSelected != isSelected )
        [self setNeedsDisplay];
    
    _isSelected = isSelected;
}

#pragma mark MKOverlayPathRenderer

- (void)createPath;
{
    PTTrailOverlay *overlay = (PTTrailOverlay *)self.overlay;
    UIBezierPath *path = [UIBezierPath new];
    
    for ( OTTrailSegment *segment in overlay.trail.segments )
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

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay;
{
    if ( self = [super initWithOverlay:overlay] ) {
        
        self.strokeColor = [UIColor PTBlueTintColor];
        self.lineWidth = 4.0;
    }

    return self;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context;
{
    [super drawMapRect:mapRect zoomScale:zoomScale inContext:context];
}

@end
