//
//  PTRootMapViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTRootMapViewController.h"
#import "SWRevealViewController.h"
#import "PTTrailDataProvider.h"
#import "PTTrailInfoViewController.h"
#import "PTConstants.h"
#import "PTTrailRenderer.h"
#import "PTTrailOverlay.h"
#import "OTOpenTrails.h"
#import "PTMapOverlayView.h"

#define METERS_PER_MILE 1609.344

@interface PTRootMapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) PTMapOverlayView *mapOverlayView;
@property (strong, nonatomic) UIToolbar *addressOverlayView;
@property (strong, nonatomic) UIButton *currentLocationButton;
@property (strong, nonatomic) UIButton *trailInfoButton;
@property (strong, nonatomic) UILabel *trailTitleLabel;
@property (strong, nonatomic) UILabel *trailSubtitleLabel;
@property (strong, nonatomic) OTTrail *selectedTrail;

- (IBAction)zoomToCurrentLocation:(id)sender;
- (IBAction)zoomToPortland:(id)sender;
- (IBAction)trailInfo:(id)sender;

- (void)mapTouch:(UITapGestureRecognizer *)recognizer;
- (void)importOperationFinished:(NSNotification *)aNotification;

@end

@implementation PTRootMapViewController

#pragma mark PTRootMapViewController Private

- (IBAction)zoomToCurrentLocation:(id)sender;
{
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}
    
- (IBAction)zoomToPortland:(id)sender;
{
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake( 45.517106, -122.671848 );
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance( zoomLocation, 3.0 * METERS_PER_MILE, 3.0 * METERS_PER_MILE );
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (IBAction)trailInfo:(id)sender;
{
    PTTrailInfoViewController *controller = [[PTTrailInfoViewController alloc] initWithTrail:self.selectedTrail];
    controller.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)mapTouch:(UITapGestureRecognizer *)recognizer;
{
    if ( ( recognizer.state & UIGestureRecognizerStateRecognized ) != UIGestureRecognizerStateRecognized )
        return;
    
    CGPoint location = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    MKMapPoint mapPoint = MKMapPointForCoordinate( coordinate );
    
    CGFloat maxPixels = 8.0;
    CGPoint boundryPoint = CGPointMake( location.x + maxPixels, location.y + maxPixels );
    CLLocationCoordinate2D boundryCoordinate = [self.mapView convertPoint:boundryPoint toCoordinateFromView:self.mapView];
    double maxMeters = MKMetersBetweenMapPoints( MKMapPointForCoordinate( coordinate ), MKMapPointForCoordinate( boundryCoordinate ) );
    
    double nearestDistance = MAXFLOAT;
    PTTrailOverlay *nearestOverlay = nil;
    
    for ( PTTrailOverlay *overlay in self.mapView.overlays ) {
        
        PTTrailRenderer *renderer = (PTTrailRenderer *)[self.mapView rendererForOverlay:overlay];
        double distance = [overlay metersFromPoint:mapPoint];
        
        if ( distance < nearestDistance && distance < maxMeters ) {
            nearestDistance = distance;
            nearestOverlay = overlay;
        }
        
        renderer.isSelected = NO;
    }
    
    if ( nearestOverlay != nil ) {
        [self.mapView insertOverlay:nearestOverlay atIndex:[self.mapView.overlays count]];
        ((PTTrailRenderer *)[self.mapView rendererForOverlay:nearestOverlay]).isSelected = YES;
    }
    
    self.selectedTrail = nearestOverlay.trail;
}

- (void)setSelectedTrail:(OTTrail *)selectedTrail;
{
    _selectedTrail = selectedTrail;
    self.trailTitleLabel.text = selectedTrail.name ?: @"";
    self.trailSubtitleLabel.text = selectedTrail.trailDescription ?: @"";
    self.trailInfoButton.hidden = selectedTrail == nil;
}

- (void)importOperationFinished:(NSNotification *)aNotification;
{
    MKCoordinateRegion region;
    NSArray *trails = [[PTTrailDataProvider sharedDataProvider] trailsForRegion:region];
    
    for ( OTTrail *trail in trails )
        [self.mapView addOverlay:[[PTTrailOverlay alloc] initWithTrail:trail]];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTouch:)];
    
    self.mapView = [MKMapView new];
    self.mapView.delegate = self;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mapView addGestureRecognizer:recognizer];
    
    self.mapOverlayView = [PTMapOverlayView new];
    self.mapOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mapOverlayView.zoomButton addTarget:self action:@selector(zoomToPortland:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addressOverlayView = [UIToolbar new];
    self.addressOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressOverlayView.translucent = YES;
    self.addressOverlayView.barTintColor = [UIColor PTGreenTintColor];
    
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = NSLocalizedString( @"Search by Trail or Address", @"" );
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIButton *button = [UIButton new];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor redColor];
    [button addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentLocationButton = [UIButton new];
    self.currentLocationButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentLocationButton.backgroundColor = [UIColor redColor];
    [self.currentLocationButton addTarget:self action:@selector(zoomToCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];

    self.trailInfoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    self.trailInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailInfoButton.hidden = YES;
    self.trailInfoButton.tintColor = [UIColor grayColor];
    [self.trailInfoButton addTarget:self action:@selector(trailInfo:) forControlEvents:UIControlEventTouchUpInside];

    self.trailTitleLabel = [UILabel new];
    self.trailTitleLabel.numberOfLines = 1;
    self.trailTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailTitleLabel.textColor = [UIColor grayColor];
    self.trailTitleLabel.textAlignment = NSTextAlignmentRight;
    self.trailTitleLabel.font = [UIFont PTBoldAppFontOfSize:20.0f];
    self.trailTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.trailSubtitleLabel = [UILabel new];
    self.trailSubtitleLabel.numberOfLines = 2;
    self.trailSubtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailSubtitleLabel.textColor = [UIColor lightGrayColor];
    self.trailSubtitleLabel.textAlignment = NSTextAlignmentRight;
    self.trailSubtitleLabel.font = [UIFont PTAppFontOfSize:18.0f];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapOverlayView];
    [self.view addSubview:self.addressOverlayView];
    [self.view addSubview:self.currentLocationButton];
    [self.view addSubview:self.trailInfoButton];
    [self.view addSubview:self.trailTitleLabel];
    [self.view addSubview:self.trailSubtitleLabel];
    
    [self.addressOverlayView addSubview:searchBar];
    [self.addressOverlayView addSubview:button];
    
    NSDictionary *views = NSDictionaryOfVariableBindings( _mapView, _mapOverlayView, _trailTitleLabel, _trailSubtitleLabel, _addressOverlayView, searchBar, button, _currentLocationButton, _trailInfoButton );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapOverlayView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapOverlayView]|" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_addressOverlayView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addressOverlayView(70.0)]" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_trailTitleLabel(400.0)]-(10)-[_trailInfoButton(44.0)]-(20.0)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_trailSubtitleLabel(400.0)]-(10)-[_trailInfoButton(44.0)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_trailSubtitleLabel][_trailTitleLabel]-(20)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_trailInfoButton]-(20)-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_currentLocationButton(44.0)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_currentLocationButton(44.0)]-(20)-|" options:0 metrics:nil views:views]];

    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-160.0-[searchBar]-96.0-[button(44.0)]-20.0-|" options:0 metrics:nil views:views]];
    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[searchBar(44.0)]" options:0 metrics:nil views:views]];
    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[button(44.0)]" options:0 metrics:nil views:views]];
    
    [self zoomToPortland:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importOperationFinished:) name:PTDataImportOperationFinishedNotification object:nil];
    [PTTrailDataProvider sharedDataProvider]; // remove later
}

- (UIStatusBarStyle)preferredStatusBarStyle;
{
    return UIStatusBarStyleLightContent;
}

#pragma mark NSObject

- (instancetype)init;
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PTDataImportOperationFinishedNotification object:nil];
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance( userLocation.location.coordinate, 3.0 * METERS_PER_MILE, 3.0 * METERS_PER_MILE );
    [self.mapView setRegion:viewRegion animated:YES];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;
{
    PTTrailRenderer *renderer = [[PTTrailRenderer alloc] initWithOverlay:overlay];
    return renderer;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
{
    [UIView animateWithDuration:0.1 animations:^{
        self.addressOverlayView.alpha = 0.6f;
    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;
{
    [UIView animateWithDuration:0.1 animations:^{
        self.addressOverlayView.alpha = 1.0f;
    }];
    
    if ( [self.mapView.overlays count] == 0 )
        return;
    
    BOOL areOverlaysVisible = NO;
    
    for ( id<MKOverlay> overlay in self.mapView.overlays ) {
        
        areOverlaysVisible = MKMapRectIntersectsRect( self.mapView.visibleMapRect, [overlay boundingMapRect] );
        
        if ( areOverlaysVisible )
            break;
    }
    
    self.mapOverlayView.showsNoTrailsMessage = !areOverlaysVisible;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{

}

@end
