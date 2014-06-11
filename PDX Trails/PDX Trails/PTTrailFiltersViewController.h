//
//  PTTrailFiltersViewController.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTTrailFiltersViewController : UITableViewController

@property (readonly, nonatomic) NSArray *attributes;

- (instancetype)initWithFilterAttributes:(NSArray *)attributes;

@end
