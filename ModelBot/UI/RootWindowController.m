//
//  RootWindowController.m
//  ModelBot
//
//  Created by welsonla on 15/7/14.
//  Copyright © 2015年 Timebot. All rights reserved.
//

#import "RootWindowController.h"

@interface RootWindowController ()

@end

@implementation RootWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.analyticsItem.image = [NSImage imageNamed:@"line_graph"];
    self.analyticsItem.label = @"统计";
    self.analyticsItem.minSize = CGSizeMake(60, 40);
    self.analyticsItem.view.layer.backgroundColor = [[NSColor redColor] CGColor];
    [self.toolbar insertItemWithItemIdentifier:@"NSToolbarCustomizeToolbarItem" atIndex:0];

    self.configItem.label = @"设置";
    self.configItem.minSize = CGSizeMake(60, 40);
    
}

- (IBAction)showAnalytics:(id)sender {
    printf("ok");
}
@end
