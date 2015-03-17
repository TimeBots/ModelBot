//
//  JSonParseMate.h
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@protocol JSONParseDelegate <NSObject>

- (void)parseMateDidStartGenerateCode;

- (void)parseMateDidFinishGenerateCode;

@end

@interface JSONParseMate : NSObject
{
    NSString  *modelName;
    ModelType  modelType;
}

@property (nonatomic, weak) id<JSONParseDelegate> delegate;

- (void)generateModelWithName:(NSString *)fileName andType:(ModelType)classType ofJSONContext:(NSDictionary *)jsonDict;

@end
