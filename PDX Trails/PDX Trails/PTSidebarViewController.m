//
//  PTSidebarViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTSidebarViewController.h"
#import "PTConstants.h"
#import "SWRevealViewController.h"
#import "PTAttribute.h"
#import "PTTrailFiltersViewController.h"

@interface PTSidebarViewController ()

@property (strong, nonatomic) UIScrollView *modeSelectionScrollView;
@property (strong, nonatomic) UINavigationController *filterNavigationController;

- (IBAction)chooseMode:(id)sender;

@end

@implementation PTSidebarViewController

#pragma mark PTUserDetailsViewController

- (IBAction)chooseMode:(id)sender;
{
    PTAttribute *a = [PTAttribute new];
    a.key = @"1";
    a.prompt = @"hello";
    
    if ( self.filterNavigationController.topViewController != nil ) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.filterNavigationController.view.layer addAnimation:transition forKey:kCATransition];
    }
    
    PTTrailFiltersViewController *controller = [[PTTrailFiltersViewController alloc] initWithFilterAttributes:@[a]];
    [self.filterNavigationController setViewControllers:@[controller] animated:NO];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.modeSelectionScrollView = [UIScrollView new];
    self.modeSelectionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modeSelectionScrollView.backgroundColor = [UIColor lightGrayColor];
    
    NSArray *items = @[PTNameForMode( PTUserModeHiking ), PTNameForMode( PTUserModeWalking ), PTNameForMode( PTUserModeCycling ), PTNameForMode( PTUserModeAccessible ), PTNameForMode( PTUserModeRunning )];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor PTBlueTintColor];
    [segmentedControl setDividerImage:nil forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl addTarget:self action:@selector(chooseMode:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *helpLabel = [UILabel new];
    helpLabel.translatesAutoresizingMaskIntoConstraints = NO;
    helpLabel.text = NSLocalizedString( @"Tell us a little about yourself, and we'll show you trails in your neighborhood.", @"" );
    helpLabel.numberOfLines = 2;
    helpLabel.textAlignment = NSTextAlignmentCenter;
    helpLabel.font = [UIFont PTAppFontOfSize:18.0f];
    helpLabel.textColor = [UIColor grayColor];
    
    self.filterNavigationController = [UINavigationController new];
    self.filterNavigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.filterNavigationController.view.backgroundColor = [UIColor blueColor];
    self.filterNavigationController.navigationBarHidden = YES;
    self.filterNavigationController.delegate = self;
    
    [self.modeSelectionScrollView addSubview:segmentedControl];
    [self.view addSubview:self.modeSelectionScrollView];
    [self.view addSubview:helpLabel];
    [self.view addSubview:self.filterNavigationController.view];
    [self addChildViewController:self.filterNavigationController];

    SWRevealViewController *revealController = self.revealViewController;
    UIView *filterNavControllerView = self.filterNavigationController.view;
    CGFloat margin = revealController.rightViewRevealOverdraw;
    NSDictionary *views = NSDictionaryOfVariableBindings( _modeSelectionScrollView, segmentedControl, helpLabel, filterNavControllerView );
    NSDictionary *metrics = @{ @"margin_left" : @( margin ), @"padding_left" : @( margin + 20.0f ), @"padding_right" : @( 20.0f ), @"height" : @(100.0f), @"width" : @( [items count] * 100.0f ), @"margin_top" : @(186.0f) };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[segmentedControl(width)]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segmentedControl(height)]-(20)-[helpLabel]" options:0 metrics:metrics views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding_left)-[helpLabel]-(padding_right)-|" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin_left)-[_modeSelectionScrollView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_modeSelectionScrollView(height)]" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin_left)-[filterNavControllerView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin_top)-[filterNavControllerView]|" options:0 metrics:metrics views:views]];
    
    [self chooseMode:segmentedControl];
}

#pragma mark NSObject

- (instancetype)init;
{
    if ( self = [super initWithNibName:nil bundle:nil] ) {
        
//        _childViewConstraints = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    // add code to disable / enable buttons to prevent crash
    NSLog(@"HERE");
}

@end
