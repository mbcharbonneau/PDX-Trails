//
//  PTTrailFilterSelectionViewController.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTAttribute;

@interface PTTrailFilterSelectionViewController : UITableViewController

@property (readonly, nonatomic) PTAttribute *attribute;

- (instancetype)initWithAttribute:(PTAttribute *)attribute;

@end
