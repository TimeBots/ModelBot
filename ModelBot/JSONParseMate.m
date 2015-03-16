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
        
        
        NSLog(@"className:%s--value:%@",object_getClassName(jsonValues[i]),jsonValues[i]);
        BOOL isMetaClass = 
        properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) %@ *%@;\n",className,classProperty];
        NSLog(@"properties:%@",properties);
    }
    
}

@end
