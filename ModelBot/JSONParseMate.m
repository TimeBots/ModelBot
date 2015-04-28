//
//  JSonParseMate.m
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "JSONParseMate.h"

@implementation JSONParseMate

@synthesize delegate;

- (void)generateModelWithName:(NSString *)fileName andType:(ModelType)classType ofJSONContext:(NSDictionary *)jsonDict
{
    modelName = [fileName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                  withString:[[fileName substringToIndex:1] uppercaseString]];
    modelType = classType;
    
    //生成header与source文件中的内容
    [self generateSourceContext:jsonDict];
}

- (void)generateSourceContext:(NSDictionary *)jsonDict{
    
    if (delegate && [delegate respondsToSelector:@selector(parseMateDidStartGenerateCode)])
    {
        [delegate parseMateDidStartGenerateCode];
    }
    
    NSArray *modelKeys = jsonDict.allKeys;
    NSArray *jsonValues = jsonDict.allValues;
    
    NSString *properties = @"";
    NSString *synthesize = @"";
    
    for (NSInteger i=0; i< modelKeys.count; i++)
    {
        NSString *classProperty = modelKeys[i];
        
        //---------------------------------
        //-----------Header Code-----------
        //---------------------------------
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
        
        //---------------------------------
        //-----------Source Code-----------
        //---------------------------------
        //组装source文件中的数据
        if (modelType == ModelType_NSObject)
        {
            synthesize = [synthesize stringByAppendingFormat:@"@synthesize %@;\n",modelKeys[i]];
        }
        else
        {
            synthesize = [synthesize stringByAppendingFormat:@"@\"%@\":@\"%@\"",modelKeys[i],modelKeys[i]];
            if(i<(modelKeys.count-1))
            {
               synthesize = [synthesize stringByAppendingString:@",\n\t\t"];
            }
        }
        
    }
    
    
    //write to header file
    [self writeToHeaderFile:properties];
    
    //write to source file
    [self writeToSourceFile:synthesize];
    
    if (delegate && [delegate respondsToSelector:@selector(parseMateDidFinishGenerateCode)])
    {
        [delegate parseMateDidFinishGenerateCode];
    }
}

- (NSString *)getFilePathIsHeader:(BOOL)isHeader
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
    NSString *filePath ;
    
    if (isHeader)
    {
        filePath = [deskPath stringByAppendingFormat:@"/Model/%@.h",modelName];
    }
    else
    {
        filePath = [deskPath stringByAppendingFormat:@"/Model/%@.m",modelName];
    }
    
    return filePath;
}

/**
 *  write to header file
 *
 *  @param properties NSString
 */
- (void)writeToHeaderFile:(NSString *)properties
{
    //获取模板地址
    NSString *path;
    if (modelType==ModelType_NSObject)
    {
        path = [[NSBundle mainBundle] pathForResource:HeaderNSObject ofType:@"tpl"];
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:HeaderMTLModel ofType:@"tpl"];
    }
    
    //读取模板的内容
    NSString *templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //拼装模板
    NSString *context = [NSString stringWithFormat:templateText,modelName,properties];
   
    NSString *filePath = [self getFilePathIsHeader:YES];
    
    NSError *error;
    [[context dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    NSLog(@"WriteError:%@",error.description);
}

/**
 *  write to source code
 *
 *  @param source NSString
 */
- (void)writeToSourceFile:(NSString *)source
{
    //获取模板地址
    NSString *path;
    if (modelType==ModelType_NSObject)
    {
        path = [[NSBundle mainBundle] pathForResource:SourceNSObject ofType:@"tpl"];
    }
    else
    {
        path = [[NSBundle mainBundle] pathForResource:SourceMTLModel ofType:@"tpl"];
    }
    
    //读取模板的内容
    NSString *templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //拼装模板
    NSString *context = [NSString stringWithFormat:templateText,modelName,modelName,source];

    
    NSString *sourcePath = [self getFilePathIsHeader:NO];
    
    NSError *error;
    [[context dataUsingEncoding:NSUTF8StringEncoding] writeToFile:sourcePath atomically:YES];
    NSLog(@"WriteError:%@",error.description);
}

@end
