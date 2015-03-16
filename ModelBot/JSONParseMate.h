//
//  JSonParseMate.h
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface JSONParseMate : NSObject

- (void)generateModelWithType:(ModelType)modelType ofJSON:(NSDictionary *)jsonDict;

@end
