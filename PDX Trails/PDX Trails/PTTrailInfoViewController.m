//
//  PTTrailInfoViewController.m
//  PDX Trails
//
//  Created by Marc Charbonneau on 5/31/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailInfoViewController.h"
#import "PTTrail.h"
#import "PTTrailSegment.h"
#import "PTTrailhead.h"
#import "PTTrailRenderer.h"

@interface PTTrailInfoViewController ()

@property (strong, nonatomic) PTTrail *trail;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UITapGestureRecognizer *backgroundTapRecognizer;
@property (strong, nonatomic) UITableView *tableView;

- (void)backgroundTap:(UITapGestureRecognizer *)recognizer;

@end

@implementation PTTrailInfoViewController

#pragma mark PTTrailInfoViewController

-(instancetype)initWithTrail:(PTTrail *)trail;
{
    NSParameterAssert( trail != nil );
    
    if ( self = [super initWithNibName:nil bundle:nil] ) {
        
        _trail = trail;
    }
    
    return self;
}

#pragma mark PTTrailInfoViewController Private

- (void)backgroundTap:(UITapGestureRecognizer *)recognizer;
{
    if ( recognizer.state != UIGestureRecognizerStateEnded )
        return;
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = self.trail.name;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont systemFontOfSize:24.0f];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass( [self class] )];
    
    self.mapView = [MKMapView new];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.scrollEnabled = NO;
    
    MKMapRect mapRect = self.trail.boundingMapRect;
    mapRect = MKMapRectInset( mapRect, MKMapRectGetWidth( mapRect ) * -0.1, MKMapRectGetHeight( mapRect ) * -0.1 );
    
    [self.mapView addOverlay:self.trail];
    [self.mapView setRegion:MKCoordinateRegionForMapRect( mapRect ) animated:YES];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.mapView];

    NSDictionary *views = NSDictionaryOfVariableBindings( titleLabel, _tableView, _mapView );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[titleLabel]-(20)-[_mapView(350)]-(20)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[titleLabel]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[_mapView(350)]" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_tableView(==titleLabel)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-(20)-[_tableView]|" options:0 metrics:nil views:views]];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    self.backgroundTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    self.backgroundTapRecognizer.cancelsTouchesInView = NO;
    
    [self.view.window addGestureRecognizer:self.backgroundTapRecognizer];
}

#pragma mark NSObject

- (void)dealloc;
{
    [self.backgroundTapRecognizer.view removeGestureRecognizer:self.backgroundTapRecognizer];
    self.backgroundTapRecognizer = nil;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return section == 0 ? [self.trail.segments count] : [self.trail.trailheads count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [self class] ) forIndexPath:indexPath];

    if ( indexPath.section == 0 ) {
        
        PTTrailSegment *segment = self.trail.segments[indexPath.row];
        
        cell.textLabel.text = [segment description];
        cell.textLabel.font = [UIFont systemFontOfSize:10.0f];
        cell.textLabel.numberOfLines = 3;
        
    } else if ( indexPath.section == 1 ) {
        
        PTTrailhead *trailhead = self.trail.trailheads[indexPath.row];
        
        cell.textLabel.text = trailhead.name;
        cell.textLabel.font = [UIFont systemFontOfSize:10.0f];
        cell.textLabel.numberOfLines = 1;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

#pragma mark MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;
{
    PTTrail *trail = overlay;
    PTTrailRenderer *renderer = [[PTTrailRenderer alloc] initWithTrail:trail];
    return renderer;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
