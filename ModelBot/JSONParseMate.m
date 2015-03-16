//
//  JSonParseMate.m
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "JSONParseMate.h"

@implementation JSONParseMate

- (void)generateModelWithType:(ModelType)modelType ofJSON:(NSDictionary *)jsonDict
{
    switch (modelType) {
        case ModelType_NSObject:
            {
                [self generateNSObjectFile:jsonDict];
            }
            break;
        case ModelType_MTLModel:
            {
                [self generateNSObjectFile:jsonDict];
            }
            break;
        default:
            break;
    }
}

- (void)generateNSObjectFile:(NSDictionary *)jsonDict{
    NSArray *modelKeys = jsonDict.allKeys;
    NSArray *jsonValues = jsonDict.allValues;
    
    NSString *properties = @"";
    
    for (NSInteger i=0; i< modelKeys.count; i++)
    {
        NSString *classProperty = modelKeys[i];
        
        //坑爹的判断，为什么都是NSCFString, NSCFNumber
        if ([jsonValues[i] isKindOfClass:[NSNumber class]])
        {
            //封装integer类型
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, assign) NSInteger %@;\n",classProperty];
        }
        else if([jsonValues[i] isKindOfClass:[NSString class]])
        {
            //封装string类型
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSString *%@;\n",classProperty];
        }
        else if([jsonValues[i] isKindOfClass:[NSArray class]])
        {
            //封装array类型
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSArray *%@;\n",classProperty];
        }
        else if([jsonValues[i] isKindOfClass:[NSDictionary class]])
        {
            //封装array类型
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSDictionary *%@;\n",classProperty];
        }
        
    }
    
    //获取模板地址
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Template_NSObject" ofType:@""];
    
    //读取模板的内容
    NSString *templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //拼装模板
    NSString *context = [NSString stringWithFormat:templateText,@"ssss",properties];
    
    
    NSLog(@"properties:%@ --- %@ --- %@",properties,templateText,context);
}

@end
