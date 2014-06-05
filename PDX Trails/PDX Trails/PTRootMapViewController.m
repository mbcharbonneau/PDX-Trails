//
//  PTRootMapViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTRootMapViewController.h"
#import "SWRevealViewController.h"
#import "PTTrail.h"
#import "PTTrailDataProvider.h"
#import "PTTrailInfoViewController.h"
#import "PTConstants.h"

#define METERS_PER_MILE 1609.344
#define ADDRESS_OVERLAY_ALPHA 0.4f

@interface PTRootMapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UIView *mapOverlayView;
@property (strong, nonatomic) UIView *addressOverlayView;
@property (strong, nonatomic) UIButton *currentLocationButton;
@property (strong, nonatomic) UIButton *trailInfoButton;
@property (strong, nonatomic) UILabel *trailTitleLabel;
@property (strong, nonatomic) UILabel *trailSubtitleLabel;
@property (strong, nonatomic) PTTrail *selectedTrail;

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
    CGPoint location = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    MKMapPoint mapPoint = MKMapPointForCoordinate( coordinate );
    PTTrail *found = nil;
    
    for ( PTTrail *trail in self.mapView.overlays ) {
        
        MKMapRect boundingBox = [trail boundingMapRect];
        MKPolylineRenderer *renderer = (MKPolylineRenderer *)[self.mapView rendererForOverlay:trail];

        if ( MKMapRectContainsPoint( boundingBox, mapPoint ) ) {
            found = trail;
            renderer.lineWidth = 6.0f;
        } else {
            renderer.lineWidth = 4.0f;
        }
        
        [renderer setNeedsDisplay];
    }

    [self setSelectedTrail:found];
}

- (void)setSelectedTrail:(PTTrail *)selectedTrail;
{
    _selectedTrail = selectedTrail;
    self.trailTitleLabel.text = selectedTrail.name ?: @"";
    self.trailSubtitleLabel.text = selectedTrail.description ?: @"";
    self.trailInfoButton.hidden = selectedTrail == nil;
}

- (void)importOperationFinished:(NSNotification *)aNotification;
{
    MKCoordinateRegion region;
    NSArray *trails = [[PTTrailDataProvider sharedDataProvider] trailsForRegion:region];
    
    for ( PTTrail *trail in trails )
        [self.mapView addOverlay:trail];
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
    
    self.mapOverlayView = [UIView new];
    self.mapOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapOverlayView.userInteractionEnabled = NO;
    self.mapOverlayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    self.addressOverlayView = [UIView new];
    self.addressOverlayView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressOverlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.addressOverlayView.alpha = ADDRESS_OVERLAY_ALPHA;
    
    UITextField *textField = [UITextField new];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.delegate = self;
    textField.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
    textField.layer.cornerRadius = 4.0f;
    textField.textColor = [UIColor whiteColor];
    
    SWRevealViewController *revealController = [self revealViewController];
    
    UIButton *button = [UIButton new];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = [UIColor redColor];
    [button addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentLocationButton = [UIButton new];
    self.currentLocationButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.currentLocationButton.backgroundColor = [UIColor redColor];
    [self.currentLocationButton addTarget:self action:@selector(zoomToCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];

    self.trailInfoButton = [UIButton new];
    self.trailInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailInfoButton.backgroundColor = [UIColor redColor];
    self.trailInfoButton.hidden = YES;
    [self.trailInfoButton addTarget:self action:@selector(trailInfo:) forControlEvents:UIControlEventTouchUpInside];

    self.trailTitleLabel = [UILabel new];
    self.trailTitleLabel.numberOfLines = 1;
    self.trailTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailTitleLabel.textColor = [UIColor grayColor];
    self.trailTitleLabel.textAlignment = NSTextAlignmentRight;
    self.trailTitleLabel.font = [UIFont systemFontOfSize:20.0f];
    self.trailTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.trailSubtitleLabel = [UILabel new];
    self.trailSubtitleLabel.numberOfLines = 2;
    self.trailSubtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.trailSubtitleLabel.textColor = [UIColor lightGrayColor];
    self.trailSubtitleLabel.textAlignment = NSTextAlignmentRight;
    self.trailSubtitleLabel.font = [UIFont systemFontOfSize:18.0f];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapOverlayView];
    [self.view addSubview:self.addressOverlayView];
    [self.view addSubview:self.currentLocationButton];
    [self.view addSubview:self.trailInfoButton];
    [self.view addSubview:self.trailTitleLabel];
    [self.view addSubview:self.trailSubtitleLabel];
    [self.addressOverlayView addSubview:textField];
    [self.addressOverlayView addSubview:button];
    
    NSDictionary *views = NSDictionaryOfVariableBindings( _mapView, _mapOverlayView, _trailTitleLabel, _trailSubtitleLabel, _addressOverlayView, textField, button, _currentLocationButton, _trailInfoButton );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_mapOverlayView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_mapOverlayView]|" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_addressOverlayView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_addressOverlayView(84.0)]" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_trailTitleLabel(400.0)]-(10)-[_trailInfoButton(44.0)]-(20.0)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_trailSubtitleLabel(400.0)]-(10)-[_trailInfoButton(44.0)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_trailTitleLabel][_trailSubtitleLabel]-(20)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_trailInfoButton(44.0)]-(20)-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_currentLocationButton(44.0)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_currentLocationButton(44.0)]-(20)-|" options:0 metrics:nil views:views]];

    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-160.0-[textField]-96.0-[button(44.0)]-20.0-|" options:0 metrics:nil views:views]];
    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[textField(44.0)]" options:0 metrics:nil views:views]];
    [self.addressOverlayView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.0-[button(44.0)]" options:0 metrics:nil views:views]];
    
    [self zoomToPortland:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importOperationFinished:) name:PTDataImportOperationFinishedNotification object:nil];
    [PTTrailDataProvider sharedDataProvider]; // remove later
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
    PTTrail *trail = overlay;
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:trail.polyline];
    renderer.strokeColor = [UIColor PTBlueTintColor];
    renderer.lineWidth = 4.0;
    return renderer;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    self.addressOverlayView.alpha = 1.0f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    self.addressOverlayView.alpha = ADDRESS_OVERLAY_ALPHA;
}

@end
