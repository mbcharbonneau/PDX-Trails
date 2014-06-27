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
#import "PTModeSelectionButton.h"
#import "PTTrailDataProvider.h"

@interface PTSidebarViewController ()

@property (strong, nonatomic) UIScrollView *modeSelectionScrollView;
@property (strong, nonatomic) UINavigationController *filterNavigationController;

- (IBAction)chooseMode:(UIButton *)sender;

- (void)loadButtons;

@end

@implementation PTSidebarViewController

#pragma mark PTUserDetailsViewController

- (IBAction)chooseMode:(UIButton *)sender;
{
    for ( UIButton *button in [self.modeSelectionScrollView subviews] ) {
        if ( button.tag > 0 ) {
            
            // Don't reload if the sender is already selected.
            
            if ( button.selected && button == sender )
                return;
            
            button.selected = button == sender;
            button.userInteractionEnabled = NO;
        }
    }
    
    if ( self.filterNavigationController.topViewController != nil ) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.filterNavigationController.view.layer addAnimation:transition forKey:kCATransition];
    }
    
    NSArray *filterAttributes = [[PTTrailDataProvider sharedDataProvider] filterQuestionsForMode:sender.tag];
    PTTrailFiltersViewController *controller = [[PTTrailFiltersViewController alloc] initWithFilterAttributes:filterAttributes];
    
    [self.filterNavigationController setViewControllers:@[controller] animated:NO];
}

#pragma mark PTUserDetailsViewController Private

- (void)loadButtons;
{
    UIScrollView *container = self.modeSelectionScrollView;
    
    PTModeSelectionButton *hiking = [[PTModeSelectionButton alloc] initWithMode:PTUserModeHiking];
    PTModeSelectionButton *cycling = [[PTModeSelectionButton alloc] initWithMode:PTUserModeCycling];
    PTModeSelectionButton *walking = [[PTModeSelectionButton alloc] initWithMode:PTUserModeWalking];
    PTModeSelectionButton *accessible = [[PTModeSelectionButton alloc] initWithMode:PTUserModeAccessible];
            
    [hiking addTarget:self action:@selector(chooseMode:) forControlEvents:UIControlEventTouchUpInside];
    [cycling addTarget:self action:@selector(chooseMode:) forControlEvents:UIControlEventTouchUpInside];
    [walking addTarget:self action:@selector(chooseMode:) forControlEvents:UIControlEventTouchUpInside];
    [accessible addTarget:self action:@selector(chooseMode:) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:hiking];
    [container addSubview:cycling];
    [container addSubview:walking];
    [container addSubview:accessible];
    
    NSDictionary *buttons = NSDictionaryOfVariableBindings( hiking, cycling, walking, accessible );
    NSDictionary *metrics = @{ @"width" : @(110.0f), @"height" : @(100.0f ) };
    
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[hiking(width)]-(1)-[cycling(width)]-(1)-[walking(width)]-(1)-[accessible(width)]|" options:0 metrics:metrics views:buttons]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[hiking(height)]|" options:0 metrics:metrics views:buttons]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cycling(height)]|" options:0 metrics:metrics views:buttons]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[walking(height)]|" options:0 metrics:metrics views:buttons]];
    [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[accessible(height)]|" options:0 metrics:metrics views:buttons]];
    
    container.contentSize = CGSizeMake( [[container subviews] count] * [metrics[@"width"] floatValue], [metrics[@"height"] floatValue] );
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.modeSelectionScrollView = [UIScrollView new];
    self.modeSelectionScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.modeSelectionScrollView.backgroundColor = [UIColor lightGrayColor];
    
    [self loadButtons];
    
    UILabel *helpLabel = [UILabel new];
    helpLabel.translatesAutoresizingMaskIntoConstraints = NO;
    helpLabel.text = NSLocalizedString( @"Describe the trails you're looking for, we'll highlight the best choices on the map.", @"" );
    helpLabel.numberOfLines = 2;
    helpLabel.textAlignment = NSTextAlignmentCenter;
    helpLabel.font = [UIFont PTAppFontOfSize:18.0f];
    helpLabel.textColor = [UIColor grayColor];
    
    UILabel *dataLabel = [UILabel new];
    dataLabel.translatesAutoresizingMaskIntoConstraints = NO;
    dataLabel.text = NSLocalizedString( @"Trail data provided by Oregon Metro and OpenStreetMap.", @"" );
    dataLabel.numberOfLines = 2;
    dataLabel.textAlignment = NSTextAlignmentCenter;
    dataLabel.font = [UIFont PTAppFontOfSize:14.0f];
    dataLabel.textColor = [UIColor lightGrayColor];
    
    self.filterNavigationController = [UINavigationController new];
    self.filterNavigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.filterNavigationController.view.backgroundColor = [UIColor blueColor];
    self.filterNavigationController.navigationBarHidden = YES;
    self.filterNavigationController.delegate = self;
    
    [self.view addSubview:self.modeSelectionScrollView];
    [self.view addSubview:helpLabel];
    [self.view addSubview:self.filterNavigationController.view];
    [self.view addSubview:dataLabel];
    [self addChildViewController:self.filterNavigationController];

    SWRevealViewController *revealController = self.revealViewController;
    UIView *filterNavControllerView = self.filterNavigationController.view;
    CGFloat margin = revealController.rightViewRevealOverdraw;
    NSDictionary *views = NSDictionaryOfVariableBindings( _modeSelectionScrollView, helpLabel, filterNavControllerView, dataLabel );
    NSDictionary *metrics = @{ @"margin_left" : @( margin ), @"padding_left" : @( margin + 20.0f ), @"padding_right" : @( 20.0f ), @"height" : @(100.0f), @"width" : @( [self.modeSelectionScrollView.subviews count] * 100.0f ), @"margin_top" : @(186.0f) };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding_left)-[helpLabel]-(padding_right)-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding_left)-[dataLabel]-(padding_right)-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin_left)-[_modeSelectionScrollView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_modeSelectionScrollView(height)]-(20)-[helpLabel]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin_left)-[filterNavControllerView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin_top)-[filterNavControllerView][dataLabel]-(20)-|" options:0 metrics:metrics views:views]];
    
    [self chooseMode:[[self.modeSelectionScrollView subviews] firstObject]];
}

- (UIStatusBarStyle)preferredStatusBarStyle;
{
    return UIStatusBarStyleLightContent;
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
    for ( UIView *view in self.modeSelectionScrollView.subviews ) {
        if ( view.tag > 0 ) {
            view.userInteractionEnabled = YES;
        }
    }
}

@end
