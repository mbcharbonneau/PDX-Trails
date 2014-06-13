//
//  PTTrailFilterSelectionViewController.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTTrailFilterSelectionViewController.h"
#import "PTAttribute.h"

@interface PTTrailFilterSelectionViewController ()
@end

@implementation PTTrailFilterSelectionViewController

#pragma mark PTTrailFilterSelectionViewController

- (instancetype)initWithAttribute:(PTAttribute *)attribute;
{
    if ( self = [super initWithStyle:UITableViewStylePlain] ) {
        
        _attribute = attribute;
    }
    
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass( [self class] )];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.attribute.answers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass( [self class] ) forIndexPath:indexPath];
    NSString *title = self.attribute.answers[indexPath.row];
    
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
