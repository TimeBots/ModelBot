//
//  AppDelegate.h
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <
NSApplicationDelegate>

@property (weak) IBOutlet NSMenu      *modelMenu;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;


@property (weak) IBOutlet NSTextFieldCell *stateLabel;


@end

