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

@interface PTTrailInfoViewController ()

@property (strong, nonatomic) PTTrail *trail;
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
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:self.tableView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings( titleLabel, _tableView );
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[titleLabel]-(20)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[titleLabel]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[_tableView]-(20)-|" options:0 metrics:nil views:views]];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.trail.segments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [self class] ) forIndexPath:indexPath];
    PTTrailSegment *segment = [self.trail.segments objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [segment description];
    cell.textLabel.font = [UIFont systemFontOfSize:10.0f];
    cell.textLabel.numberOfLines = 3;
    
    return cell;
}

#pragma mark UITableViewDelegate



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
