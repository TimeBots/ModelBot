//
//  JSonParseMate.h
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, LanguageType){
    LanguageTypeObjectiveC,
    LangageTypeSwift,
};

@protocol JSONParseDelegate <NSObject>

- (void)parseMateDidStartGenerateCode;

- (void)parseMateDidFinishGenerateCode;

@end

@interface JSONParseBase : NSObject
{
    NSString  *modelName;
    ModelType  modelType;
    LanguageType langType;
    NSDictionary *mapedDict;
}

@property (nonatomic, weak) id<JSONParseDelegate> delegate;

+ (instancetype)shareInstance;

- (void)getnerateModelWithDictionary:(NSDictionary *)json;

- (void)generateModelWithName:(NSString *)fileName andType:(ModelType)classType ofJSONContext:(NSDictionary *)jsonDict;

- (NSDictionary *)parsePropertyTypes:(NSDictionary *)sourceDict ofLanguageType:(LanguageType)lanType;

- (NSString *)templeteTagReplace:(NSString *)content;

- (void)writeToHeaderFile:(NSString *)properties;

- (void)writeToSourceFile:(NSString *)source;

- (void)writeToSwiftFile:(NSArray *)hookArray;

@end
