//
//  PTOSMFormatter.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/30/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTOSMFormatter : NSFormatter

- (NSString *)stringForTags:(NSDictionary *)OSMTags;

@end
