//
//  AnalyticsManager.m
//  ModelBot
//
//  Created by welsonla on 15/7/15.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "AnalyticsManager.h"

@implementation AnalyticsManager

/**
 *  文件数
 *
 *  @return 生成的文件总数
 */
+ (NSInteger)fileCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_FILE_COUNT];
}

/**
 *  类的数量
 *
 *  @return 生成的类的总数
 */
+ (NSInteger)classCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_CLASS_COUNT];
}

/**
 *  代码行数
 *
 *  @return 生成的总的代码行数
 */
+ (NSInteger)lineCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_LINE_COUNT];
}

/**
 *  文件统计
 */
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

/**
 *  统计内容的行数
 *
 *  @param content 内容
 */
+ (void)calLines:(NSString *)content
{
    NSInteger lineCount = [AnalyticsManager lineCount];
 
    
    //code from: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/TextLayout/Tasks/CountLines.html
    NSInteger numberOfLines, index, stringLength = [content length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
    {
        index = NSMaxRange([content lineRangeForRange:NSMakeRange(index, 0)]);
    }
    
    lineCount = lineCount + numberOfLines;
    
    [[NSUserDefaults standardUserDefaults] setInteger:lineCount forKey:TOTAL_LINE_COUNT];
}

/**
 *  重置各种计数
 */
+ (void)reset
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TOTAL_CLASS_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TOTAL_FILE_COUNT];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TOTAL_LINE_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
