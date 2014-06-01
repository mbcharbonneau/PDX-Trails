//
//  PTUserDetailsViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTUserDetailsViewController.h"

@interface PTUserDetailsViewController ()

@end

@implementation PTUserDetailsViewController

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
}

#pragma mark NSObject

- (instancetype)init;
{
    return [self initWithNibName:nil bundle:nil];
}

@end
