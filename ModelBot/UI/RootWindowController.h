//
//  RootWindowController.h
//  ModelBot
//
//  Created by welsonla on 15/7/14.
//  Copyright © 2015年 Timebot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RootWindowController : NSWindowController<NSToolbarDelegate>

@property (weak) IBOutlet NSToolbar *toolbar;

@property (weak) IBOutlet NSToolbarItem *analyticsItem;

@property (weak) IBOutlet NSToolbarItem *configItem;


- (IBAction)showAnalytics:(id)sender;

@end
