//
//  PTConstants.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTConstants.h"

static NSString *PTDataImportOperationFinishedNotification = @"PTDataImportOperationFinishedNotification";
static NSString *PTErrorDomain = @"PTErrorDomain";

NSString *PTNameForMode( PTUserMode mode ) {
    
    NSString *name;
    
    switch ( mode ) {
        case PTUserModeWalking:
            name = NSLocalizedString( @"Walking", @"" );
            break;
        case PTUserModeHiking:
            name = NSLocalizedString( @"Hiking", @"" );
            break;
        case PTUserModeCycling:
            name = NSLocalizedString( @"Cycling", @"" );
            break;
        case PTUserModeAccessible:
            name = NSLocalizedString( @"Accessible", @"" );
            break;
        case PTUserModeRunning:
            name = NSLocalizedString( @"Running", @"" );
            break;
    }
    
    return name;
}

@implementation UIColor (PTConstants)

+ (UIColor *)PTBlueTintColor;
{
    return [UIColor colorWithRed:0.0f/255.0f green:169.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
}

+ (UIColor *)PTGreenTintColor;
{
    return [UIColor colorWithRed:152.0f/255.0f green:199.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
}

@end

