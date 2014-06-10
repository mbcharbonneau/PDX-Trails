//
//  PTTrailRenderer.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/5/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import MapKit;

@class PTTrail;

@interface PTTrailRenderer : MKOverlayPathRenderer

@property (assign, nonatomic) BOOL isSelected;

- (instancetype)initWithTrail:(PTTrail *)trail;

- (PTTrail *)trail;

@end
