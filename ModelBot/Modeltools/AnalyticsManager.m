//
//  AnalyticsManager.m
//  ModelBot
//
//  Created by welsonla on 15/7/15.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "AnalyticsManager.h"

@implementation AnalyticsManager

+ (NSInteger)fileCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_FILE_COUNT];
}


+ (NSInteger)classCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_CLASS_COUNT];
}

+ (NSInteger)lineCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_LINE_COUNT];
}


+ (void)calFile
{
    NSInteger fileCount = [AnalyticsManager fileCount];
    NSInteger classCount = [AnalyticsManager classCount];
    
    classCount += 1;
    fileCount  += 2;
    [[NSUserDefaults standardUserDefaults] setInteger:classCount forKey:TOTAL_CLASS_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:fileCount forKey:TOTAL_FILE_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (void)calLines:(NSString *)content
{
    NSInteger lineCount = [AnalyticsManager lineCount];
    
    NSInteger numberOfLines, index, stringLength = [content length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
    {
        index = NSMaxRange([content lineRangeForRange:NSMakeRange(index, 0)]);
    }
    
    lineCount = lineCount + numberOfLines;
    
    [[NSUserDefaults standardUserDefaults] setInteger:lineCount forKey:TOTAL_LINE_COUNT];
}

+ (void)reset
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TOTAL_CLASS_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TOTAL_FILE_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TOTAL_LINE_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
