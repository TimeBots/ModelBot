//
//  JSONObjectMapper.m
//  ModelBot
//
//  Created by welsonla on 16/3/23.
//  Copyright © 2016年 Timebot. All rights reserved.
//

#import "JSONObjectMapper.h"

@implementation JSONObjectMapper

- (void)generateObjectMapperSource:(NSDictionary *)jsonDict{
    NSArray *modelKeys = jsonDict.allKeys;
    NSArray *jsonValues = jsonDict.allValues;
    
    NSMutableString *properties = [[NSMutableString alloc] init];
    NSMutableString *mapper = [[NSMutableString alloc] init];
    
    for (NSInteger i=0; i< modelKeys.count; i++)
    {
        id dictValue = jsonValues[i];
        NSString *dictKey = modelKeys[i];
        
        if ([dictKey isEqualToString:@"id"]) {
            dictKey = [dictKey capitalizedString];
        }
        
        //mapper
        [mapper appendFormat:@"\t\t%@ <- map[\"%@\"]\n",dictKey,dictKey];
        
        //Number
        if ([dictValue isKindOfClass:[NSNumber class]])
        {
            
            //假设都为float类型
            CGFloat doubleValue = [dictValue doubleValue];
            
            //检测Float类型
            if ([ModelFunctionsMate checkDouble:doubleValue])
            {
                [properties appendFormat:@"\tvar %@:Double?\n",dictKey];
            }
            else
            {
                [properties appendFormat:@"\tvar %@:Int?\n",dictKey];
            }
            
            
        }
        else if([dictValue isKindOfClass:[NSArray class]])
        {
            //封装array类型
            [properties appendFormat:@"\tvar %@:[AnyObject]?\n",dictKey];
        }
        else if([dictValue isKindOfClass:[NSDictionary class]])
        {
            //封装dictionary类型
            [properties appendFormat:@"\tvar %@:[String:AnyObject]?\n",dictKey];
        }
        else
        {
            //封装string类型
            [properties appendFormat:@"\tvar %@:String?\n",dictKey];
        }
    }
    
    //write to source file
    [self writeToSwiftFile:@[properties,mapper]];
}

@end
