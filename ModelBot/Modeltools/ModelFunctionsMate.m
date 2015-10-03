//
//  ModelFunctionsMate.m
//  ModelBot
//
//  Created by welsonla on 15/10/1.
//  Copyright © 2015年 Timebot. All rights reserved.
//

#import "ModelFunctionsMate.h"

@implementation ModelFunctionsMate

+ (NSString *)getDate{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:now];
    return dateString;
}

+ (NSString *)getYear{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    NSString *dateString = [formatter stringFromDate:now];
    return dateString;
}

+ (void)savePreference:(MPreference *)preference{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:preference];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Preference"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (MPreference *)getPreference{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Preference"];
    MPreference *preference = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return preference;
}

@end
