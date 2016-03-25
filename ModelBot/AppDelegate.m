//
//  AppDelegate.m
//  ModelBot
//
//  Created by welsonla on 15-3-16.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "AppDelegate.h"
#import <AppKit/AppKit.h>
#import "RootWindowController.h"

#define kAlwaysOnTop @"AlwaysOnTop"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [Fabric with:@[[Crashlytics class]]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kAlwaysOnTop]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAlwaysOnTop];
    }
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {

}

- (void)applicationWillResignActive:(NSNotification *)notification{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:kAlwaysOnTop]){
        //make the window always on top
        NSWindow *window = [NSApp mainWindow];
        [window setLevel:NSFloatingWindowLevel];
    }
}

- (void)applicationWillHide:(NSNotification *)notification{
}

- (void)applicationWillBecomeActive:(NSNotification *)notification{

}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if(!flag)
    {
        //reopen the close window
        id window;
        for(window in sender.windows)
        {
            NSWindow *w = window;
            [w makeKeyAndOrderFront:self];
        }
    }
    return YES;
}

- (IBAction)handleWindowState:(id)sender {
    NSMenuItem *alwaysOnTopItem = sender;
    NSInteger state = alwaysOnTopItem.state;
    NSWindow *window = [NSApp mainWindow];
    if (state == 1) {
        alwaysOnTopItem.state = 0;
        window.hidesOnDeactivate = YES;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAlwaysOnTop];
    }else{
        alwaysOnTopItem.state = 1;
        window.hidesOnDeactivate = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAlwaysOnTop];
    }

    NSLog(@"alwaysOnTop.state:%zd",state);
}
@end
