//
//  AppDelegate.h
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSonParseMate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSButton    *generateButton;
@property (weak) IBOutlet NSMenu      *modelMenu;
@property (weak) IBOutlet NSTextField *classField;
@property (weak) IBOutlet NSPopUpButton *typePopButton;
@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;

@property (nonatomic, strong) JSONParseMate *jsonMate;
@property (nonatomic, strong) NSDictionary *jsonDict;

- (IBAction)handleGenerate:(id)sender;

@end

