//
//  PTFilterCell.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 6/1/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTFilterCell.h"
#import "PTConstants.h"

@implementation PTFilterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    if ( self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier] ) {
        
        self.textLabel.font = [UIFont PTBoldAppFontOfSize:16.0f];
        self.detailTextLabel.font = [UIFont PTAppFontOfSize:16.0f];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return self;
}

@end
