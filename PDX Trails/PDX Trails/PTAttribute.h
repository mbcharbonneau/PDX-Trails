//
//  PTAttribute.h
//  PDX Trails
//
//  Created by mbcharbonneau on 6/11/14.
//  Copyright (c) 2014 Code for Portland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTAttribute : NSObject

@property (strong) NSString *key;
@property (strong) NSString *prompt;
@property (strong) NSArray *answers;
@property (assign) NSInteger selectedAnswer;

- (instancetype)initWithDictionary:(NSDictionary *)attributeData;

- (NSPredicate *)trailPredicate;

@end
