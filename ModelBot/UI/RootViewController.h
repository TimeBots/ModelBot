//
//  RootViewController.h
//  ModelBot
//
//  Created by welsonla on 15/7/14.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONParseMate.h"
#import "JSONTextview.h"

@interface RootViewController : NSViewController<JSONParseDelegate>

@property (weak) IBOutlet NSView *containerView;
@property (weak) IBOutlet NSTextFieldCell *classTextField;
@property (weak) IBOutlet NSPopUpButton *typePopButton;
@property (nonatomic, strong) JSONParseMate *jsonMate;
@property (nonatomic, strong) NSDictionary *jsonDict;
@property (unsafe_unretained) IBOutlet JSONTextview *jsonTextView;
@property (weak) IBOutlet NSButtonCell *checkButton;

- (IBAction)handleGenerate:(id)sender;

- (IBAction)handleCheck:(id)sender;
@end
