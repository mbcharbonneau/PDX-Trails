//
//  PTSegmentTableViewCell.m
//  PDX Trails
//
//  Created by mbcharbonneau on 7/16/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTSegmentTableViewCell.h"
#import "PTConstants.h"

@implementation PTSegmentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    if ( self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] ) {
        
        self.textLabel.font = [UIFont PTAppFontOfSize:16.0f];
        self.detailTextLabel.font = [UIFont PTAppFontOfSize:12.0f];
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    
    return self;
}

- (void)setSegment:(OTTrailSegment *)segment;
{
    static MKDistanceFormatter *formatter = nil;
    
    if ( formatter == nil )
        formatter = [[MKDistanceFormatter alloc] init];
    
    _segment = segment;
    
    NSString *detail = [formatter stringFromDistance:self.segment.distance];
    NSString *surface = segment.openStreetMapTags[@"surface"];
    
    if ( [surface length] > 0 ) {
        detail = [detail stringByAppendingFormat:NSLocalizedString( @", %@", @"" ), surface];
    }
    
    self.textLabel.text = segment.name ?: NSLocalizedString( @"Trail Segment", @"" );
    self.detailTextLabel.text = detail;
}

@end
