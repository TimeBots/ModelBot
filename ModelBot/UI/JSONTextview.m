//
//  JSONTextview.m
//  ModelBot
//
//  Created by welsonla on 15-3-17.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "JSONTextview.h"
#import "JSONSyntaxHighlight.h"

@implementation JSONTextview

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
    if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
        // The command key is the ONLY modifier key being pressed.
        if ([[event charactersIgnoringModifiers] isEqualToString:@"x"]) {
            return [NSApp sendAction:@selector(cut:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"c"]) {
            return [NSApp sendAction:@selector(copy:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
            
//            return [super performKeyEquivalent:event];
            return [NSApp sendAction:@selector(handlePaste:) to:[[self window] firstResponder] from:self];
        } else if ([[event charactersIgnoringModifiers] isEqualToString:@"a"]) {
            return [NSApp sendAction:@selector(selectAll:) to:[[self window] firstResponder] from:self];
        }
    }
    return [super performKeyEquivalent:event];
}


- (BOOL)canBecomeKeyView
{
    return YES;
}

- (void)handlePaste:(NSEvent *)evnet
{
    NSLog(@"past in textview");
    
    
    NSPasteboard *pastboard = [NSPasteboard generalPasteboard];
    NSString *jsonString = [pastboard  stringForType:NSPasteboardTypeString];
    
    if (jsonString.length==0)
    {
        return;
    }
    
    
    id JSONObj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    if ([NSJSONSerialization isValidJSONObject:JSONObj])
    {
        self.richText = YES;
        
        JSONSyntaxHighlight *jsonSytax = [[JSONSyntaxHighlight alloc] initWithJSON:JSONObj];
        NSMutableAttributedString *jsonAttributedString = [[jsonSytax highlightJSON] mutableCopy];
        [self.textStorage setAttributedString:jsonAttributedString];
    }
    else
    {
        self.richText = NO;
        self.textColor = [NSColor purpleColor];
        self.font = [NSFont fontWithName:@"Monaco" size:16];
        [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
    }
    

}

@end
