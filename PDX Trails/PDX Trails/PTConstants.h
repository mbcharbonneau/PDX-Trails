//
//  PTConstants.h
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM( NSUInteger, PTUserMode )
{
    PTUserModeWalking,
    PTUserModeHiking,
    PTUserModeCycling,
    PTUserModeAccessible,
    PTUserModeRunning
};

NSString *PTNameForMode( PTUserMode mode );
