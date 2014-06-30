//
//  PTTrailDataProvider.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

@import Foundation;
@import MapKit;

@class OTTrail;
@class PTAttribute;

#import "PTConstants.h"

@interface PTTrailDataProvider : NSObject

+ (instancetype)sharedDataProvider;

- (NSArray *)trailsForRegion:(MKCoordinateRegion)region;
- (NSArray *)filterQuestionsForMode:(PTUserMode)mode;

- (CGFloat)suitabilityOfTrail:(OTTrail *)trail;

- (void)userSelectedAnswer:(PTAttribute *)attribute;

@end
