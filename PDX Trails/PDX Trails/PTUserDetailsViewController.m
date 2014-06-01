//
//  PTUserDetailsViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTUserDetailsViewController.h"

@interface PTUserDetailsViewController ()

@property (strong, nonatomic) UIScrollView *modeSelectionScrollView;

@end

@implementation PTUserDetailsViewController

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.modeSelectionScrollView = [UIScrollView new];
    self.modeSelectionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *items = @[NSLocalizedString( @"Hiking", @"" ), NSLocalizedString( @"Cycling", @"" ), NSLocalizedString( @"Accessible", @"" ), NSLocalizedString( @"Running", @"" )];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    
    [self.view addSubview:segmentedControl];
    
}

#pragma mark NSObject

- (instancetype)init;
{
    return [self initWithNibName:nil bundle:nil];
}

@end
