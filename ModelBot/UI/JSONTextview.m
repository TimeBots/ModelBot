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
    
    self.string = @"";
    
    NSPasteboard *pastboard = [NSPasteboard generalPasteboard];
    NSString* jsonString = [pastboard  stringForType:NSPasteboardTypeString];
    
    id JSONObj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    if ([NSJSONSerialization isValidJSONObject:JSONObj])
    {
        // create the JSONSyntaxHighilight Object
        JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:JSONObj];
        
        // place the text into the view
        self.string = @"\n";
        NSMutableAttributedString *jsonString = [[jsh highlightJSON] mutableCopy];
//        [jsonString setAttributedString:@{(NSString *)NSFontAttributeName:[NSFont fontWithName:@"Helvetica" size:16]}];
//        [jsonString setAttributes:@{NSFontAttributeName:[NSFont fontWithName:@"Hei" size:16]} range:NSRangeFromString(jsonString.string)];
        [self insertText:jsonString];
    }
    else
    {
        [NSApp sendAction:@selector(paste:) to:[[self window] firstResponder] from:self];
    }
    

}

@end
