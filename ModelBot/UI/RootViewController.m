//
//  RootViewController.m
//  ModelBot
//
//  Created by welsonla on 15/7/14.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize jsonDict;
@synthesize jsonMate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupService];
}

- (void)setupView
{
    self.containerView.alphaValue = 1.0f;
    self.containerView.layer.backgroundColor = CGColorCreateGenericRGB(238, 238, 238, 1.0f);
    self.containerView.layer.cornerRadius = 2.0f;
    self.containerView.layer.borderColor = [[NSColor lightGrayColor] CGColor];
    self.containerView.layer.borderWidth = 1;
    
    self.classTextField.focusRingType = NSFocusRingTypeNone;
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:PropertyState])
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
        
//        [self.classTextField];
        
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

#pragma mark - JSONParseMate Delegate
- (void)parseMateDidStartGenerateCode
{
//    self.stateLabel.stringValue = @"Start analytics....";
}

- (void)parseMateDidFinishGenerateCode
{
//    self.stateLabel.stringValue = @"Generate success";
//    self.stateLabel.textColor = [NSColor colorWithCalibratedRed:39/255.0f green:174/255.0f blue:96/255.0f alpha:1.0];
    
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
    
    NSString *deskPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    NSString *modelDirect = [deskPath stringByAppendingPathComponent:@"Model"];
    
    NSString *className = self.classTextField.stringValue;
    
    NSURL *headerURL = [NSURL fileURLWithPath:[modelDirect stringByAppendingFormat:@"/%@.h",className]];
    NSURL *sourceURL = [NSURL fileURLWithPath:[modelDirect stringByAppendingFormat:@"/%@.m",className]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[headerURL,sourceURL]];
    
}

- (IBAction)handleGenerate:(id)sender {
    
    if ([self checkInput])
    {
//        self.stateLabel.textColor = [NSColor blackColor];
        
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
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PropertyState];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PropertyState];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
