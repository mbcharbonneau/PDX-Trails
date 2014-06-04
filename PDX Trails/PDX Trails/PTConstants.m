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
