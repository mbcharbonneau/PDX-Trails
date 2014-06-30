//
//  PTAttribute.m
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import "PTAttribute.h"

@implementation PTAttribute

- (instancetype)initWithDictionary:(NSDictionary *)attributeData;
{
    NSParameterAssert( attributeData != nil );
    
    if ( self = [super init] ) {
        
        self.key = attributeData[@"key"];
        self.prompt = attributeData[@"prompt"];
        self.answers = attributeData[@"answers"];
        self.selectedAnswer = 0;
    }
    
    return self;
}

@end
