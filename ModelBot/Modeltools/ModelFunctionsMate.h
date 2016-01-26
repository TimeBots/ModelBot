//
//  ModelFunctionsMate.h
//  ModelBot
//
//  Created by welsonla on 15/10/1.
//  Copyright © 2015年 Timebot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPreference.h"

@interface ModelFunctionsMate : NSObject

+ (NSString *)getDate;


+ (NSString *)getYear;


+ (void)savePreference:(MPreference *)preference;


+ (MPreference *)getPreference;

+ (BOOL)checkDouble:(double)doubleValue;

@end
