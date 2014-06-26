//
//  PTTrailOverlay.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/20/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTOpenTrails.h"

@interface PTTrailOverlay : NSObject <MKOverlay>

@property (strong, nonatomic) OTTrail *trail;

- (instancetype)initWithTrail:(OTTrail *)trail;

- (double)metersFromPoint:(MKMapPoint)point;

@end
