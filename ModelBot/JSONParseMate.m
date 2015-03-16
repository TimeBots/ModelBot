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
        NSString *className = NSStringFromClass([jsonValues[i] class]);
        NSString *classProperty = modelKeys[i];
        NSString *classValue = [jsonValues[i] stringValue];
        
        //坑爹的判断，为什么都是NSCFString
        if ([jsonValues[i] isKindOfClass:[NSNumber class]])
        {
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, assign) NSInteger %@;\n",classProperty];
        }
        else if([jsonValues[i] isKindOfClass:[NSString class]])
        {
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSString *%@;\n",classProperty];
        }
        else if([jsonValues[i] isKindOfClass:[NSArray class]])
        {
             properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSArray *%@;\n",classProperty];
        }
        
        NSLog(@"class:%@--%@----%s",[jsonValues[i] description],NSStringFromClass([classValue class]),object_getClassName(classValue));
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
