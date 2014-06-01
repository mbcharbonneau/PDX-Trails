//
//  PTTrail.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTTrail : NSObject

@property (strong) NSArray *segments;
@property (strong) NSString *name;
@property (strong) NSString *identifier;
@property (strong) NSString *description;

@end