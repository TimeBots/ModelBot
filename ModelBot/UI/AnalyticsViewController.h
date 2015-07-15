//
//  AnalyticsViewController.h
//  ModelBot
//
//  Created by welsonla on 15/7/15.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AnalyticsViewController : NSViewController

@property (weak) IBOutlet NSTextFieldCell *totalClassLabel;
@property (weak) IBOutlet NSTextFieldCell *totalFileLabel;
@property (weak) IBOutlet NSTextFieldCell *totalLinesLabel;


- (IBAction)handleReset:(id)sender;

@end
