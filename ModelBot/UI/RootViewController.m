//
//  RootViewController.m
//  ModelBot
//
//  Created by welsonla on 15/7/14.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "RootViewController.h"
#import "AnalyticsManager.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize jsonDict;
@synthesize jsonMate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupService];
}

- (void)awakeFromNib
{
    [self setupView];
}

- (void)setupView
{
    self.containerView.alphaValue = 1.0f;
    self.containerView.layer.backgroundColor = CGColorCreateGenericRGB(238, 238, 238, 1.0f);
    self.containerView.layer.cornerRadius = 2.0f;
    self.containerView.layer.borderColor = [[NSColor lightGrayColor] CGColor];
    self.containerView.layer.borderWidth = 1;
    
    self.classTextField.focusRingType = NSFocusRingTypeNone;
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_ALL_AS_STRING])
    {
        self.checkButton.state = NSOnState;
    }
}

- (void)setupService
{
    jsonMate = [[JSONParseMate alloc] init];
    jsonMate.delegate = self;
}

- (BOOL)checkInput
{
    if (self.classTextField.stringValue.length==0)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Notice"];
        [alert setInformativeText:@"Please input the class name in the field"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
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
    NSInteger menuTag = self.typePopButton.selectedTag;
    return menuTag-100;
}

#pragma mark - JSONParseMate Delegate
- (void)parseMateDidStartGenerateCode
{
    
}

- (void)parseMateDidFinishGenerateCode
{
    [AnalyticsManager calFile];
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"";
    alert.informativeText = @"Generate Success";
    [alert addButtonWithTitle:@"Show In Finder"];
    [alert addButtonWithTitle:@"View later"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode==1000)
        {
            [self handleShowInFinder];
        }
    }];
}

- (void)showAert:(NSString *)title withMessage:(NSString *)message
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = title;
    alert.informativeText = message;
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}



- (void)handleShowInFinder
{
    //获取文件的路径~/Desk/Model/
    NSString *deskPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    NSString *modelDirect = [deskPath stringByAppendingPathComponent:@"Model"];
    
    //类名
    NSString *className = self.classTextField.stringValue;
    
    //选中头文件与source文件
    NSURL *headerURL = [NSURL fileURLWithPath:[modelDirect stringByAppendingFormat:@"/%@.h",className]];
    NSURL *sourceURL = [NSURL fileURLWithPath:[modelDirect stringByAppendingFormat:@"/%@.m",className]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[headerURL,sourceURL]];
    
}

- (IBAction)handleGenerate:(id)sender {
    
    if ([self checkInput])
    {        
        NSLog(@"self.jsonText:%@",self.jsonTextView.string);
        
        NSString *fileName = self.classTextField.stringValue;
        NSString *json = self.jsonTextView.string;
        jsonDict = [self convertJSONToDictionary:json];
        
        BOOL isValid = [self validateJSON];
        
        if(isValid)
        {
            ModelType modelType = [self checkModelType];
            [jsonMate generateModelWithName:fileName andType:modelType ofJSONContext:jsonDict];
        }
        else
        {
            [self showAert:@"" withMessage:@"This is not a validate JSON string, Please check"];
        }
        
        NSLog(@"isValid:%@",isValid?@"YES":@"NO");
    }
}

- (IBAction)handleCheck:(id)sender {
    if (self.checkButton.state == NSOnState)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_ALL_AS_STRING];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_ALL_AS_STRING];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
