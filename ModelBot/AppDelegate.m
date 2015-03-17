//
//  AppDelegate.m
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize jsonMate;
@synthesize jsonDict;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self initService];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initService
{
    jsonMate = [[JSONParseMate alloc] init];
}


- (IBAction)handleGenerate:(id)sender
{
    
    if ([self checkInput])
    {
        NSLog(@"self.jsonText:%@",self.jsonTextView.string);
        
        NSString *fileName = self.classField.stringValue;
        NSString *json = self.jsonTextView.string;
        jsonDict = [self convertJSONToDictionary:json];
        
        BOOL isValid = [self validateJSON];
        
        if(isValid)
        {
            ModelType modelType = [self checkModelType];
            [jsonMate generateModelWithName:fileName andType:modelType ofJSONContext:jsonDict];
        }
        
        NSLog(@"isValid:%@",isValid?@"YES":@"NO");
    }
    
   
}

- (BOOL)checkInput
{
    if (self.classField.stringValue.length==0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Notice"];
        [alert setInformativeText:@"Please input the class name in the field"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        [self.classField becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

/**
 *  检查json是否合法
 *
 *  @param JSONString json字符
 *
 *  @return 是否合法
 */
- (BOOL)validateJSON
{
    if ([NSJSONSerialization isValidJSONObject:jsonDict])
    {
        return YES;
    }
    
    return NO;
}

/**
 *  得到转换后的字典
 *
 *  @param jsonString json字符
 *
 *  @return 字典
 */
- (NSDictionary *)convertJSONToDictionary:(NSString *)jsonString
{
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    return dict;
}

/**
 *  检查选择的实体类型
 *
 *  @return 实体类型
 */
- (ModelType)checkModelType
{
    NSLog(@"self.typePopButton.value:%ld",(long)self.typePopButton.selectedTag);
    
    if (self.typePopButton.selectedTag==101)
    {
        return ModelType_MTLModel;
    }
    
    return ModelType_NSObject;
}
@end
