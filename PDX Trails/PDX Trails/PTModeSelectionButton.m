//
//  PTModeSelectionButton.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTModeSelectionButton.h"
#import "PTConstants.h"

@implementation PTModeSelectionButton

- (instancetype)initWithMode:(PTUserMode)mode;
{
    if ( self = [super init] ) {
        
        UIImage *temp = [[UIImage imageNamed:@"Power.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        self.tag = mode;
        self.titleLabel.font = [UIFont PTBoldAppFontOfSize:18.0f];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.tintColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor grayColor];

        [self setTitle:PTNameForMode( mode ) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor PTBlueTintColor] forState:UIControlStateSelected];

        switch ( mode ) {
            case PTUserModeHiking:
                [self setImage:temp forState:UIControlStateNormal];
                break;
            case PTUserModeCycling:
                [self setImage:temp forState:UIControlStateNormal];
                break;
            case PTUserModeWalking:
                [self setImage:temp forState:UIControlStateNormal];
                break;
            case PTUserModeAccessible:
                [self setImage:temp forState:UIControlStateNormal];
                break;
            case PTUserModeRunning:
                break;
        }        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected;
{
    [super setSelected:selected];
    
    self.tintColor = selected ? [UIColor PTBlueTintColor] : [UIColor whiteColor];
}

@end
