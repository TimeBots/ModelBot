//
//  JSonParseMate.m
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "JSONParseMate.h"
#import "AnalyticsManager.h"

@implementation JSONParseMate

@synthesize delegate;

- (void)generateModelWithName:(NSString *)fileName andType:(ModelType)classType ofJSONContext:(NSDictionary *)jsonDict
{
    if (delegate && [delegate respondsToSelector:@selector(parseMateDidStartGenerateCode)])
    {
        [delegate parseMateDidStartGenerateCode];
    }
    
    //首字母大写
    modelName = [fileName stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                                  withString:[[fileName substringToIndex:1] uppercaseString]];
    modelType = classType;
    
    
    //生成header与source文件中的内容
    switch (modelType) {
        case ModelType_MTLModel:
        case ModelType_NSObject:
            [self generateSourceContext:jsonDict];
            break;
        case ModelType_Swift:
        case ModelType_ObjectMapper:
            [self generateObjectMapperSource:jsonDict];
            break;
        default:
            break;
    }
    
}

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
                [properties appendFormat:@"\tvar %@:Float?\n",dictKey];
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
    
    if (delegate && [delegate respondsToSelector:@selector(parseMateDidFinishGenerateCode)])
    {
        [delegate parseMateDidFinishGenerateCode];
    }

}

- (void)generateSourceContext:(NSDictionary *)jsonDict{
    
    NSArray *modelKeys = jsonDict.allKeys;
    NSArray *jsonValues = jsonDict.allValues;
    
    NSString *properties = @"";
    NSString *synthesize = @"";
    
    
    BOOL state = [[NSUserDefaults standardUserDefaults] boolForKey:IS_ALL_AS_STRING];
    
    for (NSInteger i=0; i< modelKeys.count; i++)
    {
        
        
        //---------------------------------
        //-----------Header Code-----------
        //---------------------------------
        
        id dictValue = jsonValues[i];
        NSString *dictKey = modelKeys[i];
        
        if ([dictKey isEqualToString:@"id"]) {
            dictKey = [dictKey capitalizedString];
        }
        
        //all as stirng
        //将不是数组和字典的数据转换为string
        if (state && (![dictValue isKindOfClass:NSArray.class]||![dictValue isKindOfClass:NSDictionary.class])) {
            dictValue = nil;
        }
        
        NSLog(@"typeof:%@--value:%@",NSStringFromClass([dictValue class]),dictValue);
        
        //Number
        if ([dictValue isKindOfClass:[NSNumber class]])
        {
            
            //假设都为float类型
            CGFloat doubleValue = [dictValue doubleValue];
            
            //检测Float类型
            if ([ModelFunctionsMate checkDouble:doubleValue])
            {
               properties = [properties stringByAppendingFormat:@"@property (nonatomic, assign) double %@;\n",dictKey];
            }
            else
            {
               properties = [properties stringByAppendingFormat:@"@property (nonatomic, assign) NSInteger %@;\n",dictKey];
            }
            
            
        }
        else if([dictValue isKindOfClass:[NSArray class]])
        {
            //封装array类型
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSArray *%@;\n",dictKey];
        }
        else if([dictValue isKindOfClass:[NSDictionary class]])
        {
            //封装dictionary类型
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSDictionary *%@;\n",dictKey];
        }
        else
        {
            //封装string类型
            properties = [properties stringByAppendingFormat:@"@property (nonatomic, strong) NSString *%@;\n",dictKey];
        }
        
        //---------------------------------
        //-----------Source Code-----------
        //---------------------------------
        //组装source文件中的数据
        if (modelType == ModelType_NSObject)
        {
            //normal source file
            synthesize = [synthesize stringByAppendingFormat:@"@synthesize %@;\n",dictKey];
        }
        else
        {
            //mantle source file is a dictionary
            synthesize = [synthesize stringByAppendingFormat:@"@\"%@\":@\"%@\"",dictKey,modelKeys[i]];
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
    NSString *context = [NSString stringWithFormat:templateText,properties];
   
    //替换源码中的标签符号
    context = [self templeteTagReplace:context];
    
    NSString *filePath = [self getFilePathIsHeader:YES];
    
    NSError *error;
    [[context dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    NSLog(@"WriteError:%@",error.description);
    
    //统计头文件行数
    [AnalyticsManager calLines:context];
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
    NSString *context = [NSString stringWithFormat:templateText,source];

    //替换源码中的标签符号
    context = [self templeteTagReplace:context];
    
    
    NSString *sourcePath = [self getFilePathIsHeader:NO];
    
    NSError *error;
    [[context dataUsingEncoding:NSUTF8StringEncoding] writeToFile:sourcePath atomically:YES];
    NSLog(@"WriteError:%@",error.description);
    
    //统计source文件行数
    [AnalyticsManager calLines:context];
}


- (void)writeToSwiftFile:(NSArray *)hookArray
{
    //获取模板地址
    NSString *path;
    NSString *templateName;
    switch (modelType) {
        case ModelType_Swift:
            templateName = SwiftModel;
            break;
        case ModelType_ObjectMapper:
            templateName = SwiftObjectMapper;
            break;
            
        default:
            break;
    }
    
    path = [[NSBundle mainBundle] pathForResource:templateName ofType:@"tpl"];
    
    //读取模板的内容
    NSString *templateText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //拼装模板
    for (NSInteger i=0; i< hookArray.count; i++) {
        NSString *hook = [NSString stringWithFormat:@"{$hook%zd}",i];
        templateText = [templateText stringByReplacingOccurrencesOfString:hook
                                                          withString:hookArray[i]];
    }
    
    //替换源码中的标签符号
    templateText = [self templeteTagReplace:templateText];
    
    NSString *filePath = [self getFilePathIsHeader:YES];
    filePath = [filePath stringByReplacingCharactersInRange:NSMakeRange(filePath.length-1, 1) withString:@"swift"];
    
    NSError *error;
    BOOL result = [[templateText dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    NSLog(@"WriteError:%@--result:%@",error.description,result?@"YES":@"NO");
    NSLog(@"filePath:%@",filePath);
    
    //统计头文件行数
    [AnalyticsManager calLines:templateText];
}

- (NSString *)templeteTagReplace:(NSString *)content{
    //文件名
    content = [content stringByReplacingOccurrencesOfString:@"{$filename}" withString:modelName];
    
    //时间
    content = [content stringByReplacingOccurrencesOfString:@"{$date}" withString:[ModelFunctionsMate getDate]];
    
    //年
    content = [content stringByReplacingOccurrencesOfString:@"{$year}" withString:[ModelFunctionsMate getYear]];
    
    
    MPreference *preference = [ModelFunctionsMate getPreference];
    
    content = [content stringByReplacingOccurrencesOfString:@"{$author}" withString:preference.Author];
    
    content = [content stringByReplacingOccurrencesOfString:@"{$copyright}" withString:preference.Copyright];
    
    return content;
}

@end
