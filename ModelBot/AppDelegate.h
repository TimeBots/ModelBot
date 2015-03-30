//
//  AppDelegate.h
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSonParseMate.h"

@interface AppDelegate : NSObject <
NSApplicationDelegate,
JSONParseDelegate,
NSTextViewDelegate,
NSTextStorageDelegate,
NSToolbarDelegate>

@property (weak) IBOutlet NSButton    *generateButton;
@property (weak) IBOutlet NSMenu      *modelMenu;
@property (weak) IBOutlet NSTextField *classField;
@property (weak) IBOutlet NSPopUpButton *typePopButton;
@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (weak) IBOutlet NSToolbar *menuBar;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSToolbarItem *runBarItem;

@property (nonatomic, strong) JSONParseMate *jsonMate;
@property (nonatomic, strong) NSDictionary *jsonDict;
@property (weak) IBOutlet NSTextFieldCell *stateLabel;

- (IBAction)handleGenerate:(id)sender;

@end

