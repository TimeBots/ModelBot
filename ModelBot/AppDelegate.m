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
    [self initView];
    [self initService];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initView
{
//    self.jsonTextView.ShowsHighlight = YES;
//    self.jsonTextView.ShowsLineNumbers = YES;
    self.jsonTextView.delegate = self;
    [self.jsonTextView.textStorage setFont:[NSFont fontWithName:@"Helvetica" size:16]];
}

- (void)initService
{
    jsonMate = [[JSONParseMate alloc] init];
    jsonMate.delegate = self;
}


- (IBAction)handleGenerate:(id)sender
{
    
    if ([self checkInput])
    {
        self.stateLabel.textColor = [NSColor blackColor];
        
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
        else
        {
            [self showAert:@"" withMessage:@"This is not a validate JSON string, Please check"];
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

#pragma mark - JSONParseMate Delegate
- (void)parseMateDidStartGenerateCode
{
    self.stateLabel.stringValue = @"Start analytics....";
}

- (void)parseMateDidFinishGenerateCode
{
    self.stateLabel.stringValue = @"Generate success";
    self.stateLabel.textColor = [NSColor colorWithCalibratedRed:39/255.0f green:174/255.0f blue:96/255.0f alpha:1.0];
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"";
    alert.informativeText = @"Generate Success";
    [alert addButtonWithTitle:@"Show In Finder"];
    [alert addButtonWithTitle:@"View later"];
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
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
    
    NSString *className = self.classField.stringValue;
    
    NSURL *headerURL = [NSURL fileURLWithPath:[modelDirect stringByAppendingFormat:@"/%@.h",className]];
    NSURL *sourceURL = [NSURL fileURLWithPath:[modelDirect stringByAppendingFormat:@"/%@.m",className]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[headerURL,sourceURL]];

}


@end
