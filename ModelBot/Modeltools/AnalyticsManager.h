//
//  AnalyticsManager.h
//  ModelBot
//
//  Created by welsonla on 15/7/15.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsManager : NSObject

+ (NSInteger)fileCount;

+ (NSInteger)classCount;

+ (NSInteger)lineCount;

+ (void)reset;

+ (void)calFile;

+ (void)calLines:(NSString *)content;

@end
