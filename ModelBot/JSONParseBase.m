//
//  JSonParseMate.m
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "JSONParseBase.h"
#import "AnalyticsManager.h"
#import <objc/runtime.h>
#import "PrefixHeader.pch"

@implementation JSONParseBase

@synthesize delegate;


+ (instancetype)shareInstance{
    static id selfclass = nil;
    dispatch_once_t token;
    dispatch_once(&token, ^{
        selfclass = [[self alloc] init];
    });
    
    return selfclass;
}


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
//            [self generateObjectMapperSource:jsonDict];
            break;
        default:
            break;
    }
    
    mapedDict = [self parsePropertyTypes:jsonDict ofLanguageType:LanguageTypeObjectiveC];
    NSString *encodeString = [self getObjcEncoder];
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(parseMateDidFinishGenerateCode)])
    {
        [self.delegate parseMateDidFinishGenerateCode];
    }
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

- (NSDictionary *)parsePropertyTypes:(NSDictionary *)sourceDict ofLanguageType:(LanguageType)lanType{
    NSArray *keys = sourceDict.allKeys;
    NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
    
    for (NSInteger i=0; i< keys.count; i++)
    {
        NSString *dictKey = keys[i];
        id dictValue = sourceDict[dictKey];
        
        if ([dictKey isEqualToString:@"id"]) {
            dictKey = [dictKey capitalizedString];
        }
        
        //Number
        if ([dictValue isKindOfClass:[NSNumber class]]){
            
            //假设都为float类型
            CGFloat doubleValue = [dictValue doubleValue];
            
            //检测Float类型
            if ([ModelFunctionsMate checkDouble:doubleValue]){
                //Double
                propertyDict[dictKey] = langType == LanguageTypeObjectiveC ? @"double" : @"Double";
            }else{
                //Int
                propertyDict[dictKey] = langType == LanguageTypeObjectiveC ? @"NSInteger" : @"Int";
            }
        }else if([dictValue isKindOfClass:[NSArray class]]){
            //Array
            propertyDict[dictKey] = langType == LanguageTypeObjectiveC ? @"NSArray" : @"[AnyObject]?";
        }else if([dictValue isKindOfClass:[NSDictionary class]]){
            //Dictionary
            propertyDict[dictKey] = langType == LanguageTypeObjectiveC ? @"NSDictionary" : @"[AnyObject:AnyObject]?";
        }else{
            //String
            propertyDict[dictKey] = langType == LanguageTypeObjectiveC ? @"NSString" : @"String?";
        }
    }
    
    return propertyDict;
}


#pragma mark - Property Syntax
- (void)getPropertySyntax{
    
}

#pragma mark - Encoder

/**
 *  Objective-C Encoder
 *
 *  @return EncoderContent
 */
- (NSString *)getObjcEncoder{
    NSString *encodeContent = [NSString string];
    NSArray *keys = mapedDict.allKeys;
    for (NSString *key in keys) {
        NSString *typeName = mapedDict[key];
        NSString *encodeLine;
        if ([typeName isEqualToString:@"NSInteger"])
        {
            encodeLine = [NSString stringWithFormat:@"[aCoder encodeInteger:_%@ forKey:@\"%@\"];\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"double"])
        {
            encodeLine = [NSString stringWithFormat:@"[aCoder encodeDouble:_%@ forKey:@\"%@\"];\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Boolean"])
        {
            encodeLine = [NSString stringWithFormat:@"[aCoder encodeBool:_%@ forKey:@\"%@\"];\n\t\t",key,key];
        }else{
            encodeLine = [NSString stringWithFormat:@"[aCoder encodeObject:_%@ forKey:@\"%@\"];\n\t\t",key,key];
        }
        
        encodeContent = [encodeContent stringByAppendingString:encodeLine];
        
    }
    
    return encodeContent;
}

/**
 *  Swift Encoder
 *
 *  @return EncoderContent
 */
- (NSString *)getSwiftEncoder{
    NSString *encodeContent;
    NSArray *keys = mapedDict.allKeys;
    for (NSString *key in keys) {
        NSString *typeName = mapedDict[key];
        NSString *encodeLine;
        if ([typeName isEqualToString:@"Int"])
        {
            encodeLine = [NSString stringWithFormat:@"aCoder.encodeInteger(%@, forKey: \"%@\");\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Double"])
        {
            encodeLine = [NSString stringWithFormat:@"aCoder.encodeDouble(%@, forKey: \"%@\");\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Bool"])
        {
            encodeLine = [NSString stringWithFormat:@"aCoder.encodeBool(%@, forKey: \"%@\");\n\t\t",key,key];
        }
        else
        {
            encodeLine = [NSString stringWithFormat:@"[aCoder encodeObject:_%@ forKey:@\"%@\"];\n\t\t",key,key];
        }
        
        encodeContent = [encodeContent stringByAppendingString:encodeLine];
    }
    
    return encodeContent;
}


#pragma mark - Decoder
- (NSString *)getObjcDecoder{
    NSString *encodeContent = [NSString string];
    NSArray *keys = mapedDict.allKeys;
    for (NSString *key in keys) {
        NSString *typeName = mapedDict[key];
        NSString *encodeLine;
        if ([typeName isEqualToString:@"NSInteger"])
        {
            encodeLine = [NSString stringWithFormat:@"_%@ = [aDecoder decodeIntegerForKey:@\"%@\"];\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"double"])
        {
            encodeLine = [NSString stringWithFormat:@"_%@ = [aDecoder decodeDoubleForKey:@\"%@\"];\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Boolean"])
        {
            encodeLine = [NSString stringWithFormat:@"_%@ = [aDecoder decodeBoolForKey:@\%@\"];\n\t\t",key,key];
        }
        else
        {
            encodeLine = [NSString stringWithFormat:@"_%@ = [aDecoder decodeObjectForKey:@\"%@\"];\n\t\t",key,key];
        }
        
        encodeContent = [encodeContent stringByAppendingString:encodeLine];
    }
    
    return encodeContent;
}


- (NSString *)getSwiftDecoder{
    NSString *encodeContent;
    NSArray *keys = mapedDict.allKeys;
    for (NSString *key in keys) {
        NSString *typeName = mapedDict[key];
        NSString *encodeLine;
        if ([typeName isEqualToString:@"Int"])
        {
            encodeLine = [NSString stringWithFormat:@"%@ = aDecoder.decodeIntegerForKey(\"%@\") as Int\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Double"])
        {
            encodeLine = [NSString stringWithFormat:@"%@ = aDecoder.decodeDoubleForKey(\"%@\")\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Bool"])
        {
            encodeLine = [NSString stringWithFormat:@"%@ = aDecoder.decodeBoolForKey(\"%@\");\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"String"])
        {
            encodeLine = [NSString stringWithFormat:@"%@ = aDecoder.decodeObjectForKey(\"%@\") as? String\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Dictionary"])
        {
            encodeLine = [NSString stringWithFormat:@"%@ = (aDecoder.decodeObjectForKey(\"%@\") as? Dictionary<String,String>)!\n\t\t",key,key];
        }
        else if([typeName isEqualToString:@"Array"])
        {
            encodeLine = [NSString stringWithFormat:@"%@ = aDecoder.decodeObjectForKey(\"%@\") as? [String]!\n\t\t",key,key];
        }
        
        encodeContent = [encodeContent stringByAppendingString:encodeLine];
    }
    
    return encodeContent;
}

@end
