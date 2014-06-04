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

typedef NS_ENUM( NSUInteger, PTErrorCode )
{
    PTErrorCodeUnknown = 0
};

static NSString *PTDataImportOperationFinishedNotification;
static NSString *PTErrorDomain;

NSString *PTNameForMode( PTUserMode mode );

@interface UIColor (PTConstants)

+ (UIColor *)PTBlueTintColor;
+ (UIColor *)PTGreenTintColor;

@end
