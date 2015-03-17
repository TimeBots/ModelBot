//
//  JSonParseMate.m
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "JSONParseMate.h"

@implementation JSONParseMate

- (void)generateModelWithName:(NSString *)fileName andType:(ModelType)classType ofJSONContext:(NSDictionary *)jsonDict
{
    modelName = fileName;
    modelType = classType;
    
    switch (modelType) {
        case ModelType_NSObject:
            {
                [self generateHeaderFile:jsonDict];
            }
            break;
        case ModelType_MTLModel:
            {
                [self generateHeaderFile:jsonDict];
            }
            break;
        default:
            break;
    }
}

- (void)generateHeaderFile:(NSDictionary *)jsonDict{
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
    NSString *path;
    if (modelType==ModelType_NSObject)
    {
        path = [[NSBundle mainBundle] pathForResource:TemplateNSObject ofType:@"tpl"];
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:TemplateMTLModel ofType:@"tpl"];
    }
    
    //读取模板的内容
    NSString *templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //拼装模板
    NSString *context = [NSString stringWithFormat:templateText,modelName,properties];
    
    NSLog(@"properties:--- %@",context);
    [self writeToHeaderFile:context];
    [self writeToSourceFile:nil];
}

- (void)writeToHeaderFile:(NSString *)context
{
    NSString *deskPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    NSString *modelDirect = [deskPath stringByAppendingPathComponent:@"Model"];
    
    //检查Model文件夹是否存在，不存在进行创建
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:modelDirect isDirectory:&isDir])
    {
        NSLog(@"not exist:%@",modelDirect);
        [[NSFileManager defaultManager] createDirectoryAtPath:modelDirect withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //拼接实体的类地址，放到Model文件夹中
    NSString *filePath = [deskPath stringByAppendingFormat:@"/Model/%@.h",modelName];
    
    NSError *error;
    [[context dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    NSLog(@"WriteError:%@",error.description);
}


- (void)writeToSourceFile:(NSString *)source
{
    
}

@end
