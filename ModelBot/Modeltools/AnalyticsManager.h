//
//  AnalyticsManager.h
//  ModelBot
//
//  Created by welsonla on 15/7/15.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsManager : NSObject

/**
 *  文件数
 *
 *  @return 生成的文件总数
 */
+ (NSInteger)fileCount;

/**
 *  类的数量
 *
 *  @return 生成的类的总数
 */
+ (NSInteger)classCount;

/**
 *  代码行数
 *
 *  @return 生成的总的代码行数
 */
+ (NSInteger)lineCount;


/**
 *  重置各种计数
 */
+ (void)reset;


/**
 *  文件统计
 */
+ (void)calFile;

/**
 *  统计内容的行数
 *
 *  @param content 内容
 */
+ (void)calLines:(NSString *)content;

@end
