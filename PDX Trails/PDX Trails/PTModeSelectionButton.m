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
        
        self.tag = mode;
        self.titleLabel.font = [UIFont PTBoldAppFontOfSize:18.0f];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.tintColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        
        [self setTitleColor:[UIColor PTBlueTintColor] forState:UIControlStateSelected];

        UIImage *icon = nil;
        
        switch ( mode ) {
            case PTUserModeHiking:
                icon = [UIImage imageNamed:@"hiking.png"];
                break;
            case PTUserModeCycling:
                icon = [UIImage imageNamed:@"cycling.png"];
                break;
            case PTUserModeWalking:
                icon = [UIImage imageNamed:@"walking.png"];
                break;
            case PTUserModeAccessible:
                icon = [UIImage imageNamed:@"isa.png"];
                break;
            case PTUserModeRunning:
                break;
        }
        
        [self setImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected;
{
    [super setSelected:selected];
    
    self.tintColor = selected ? [UIColor PTBlueTintColor] : [UIColor whiteColor];
}

@end
