//
//  AnalyticsViewController.m
//  ModelBot
//
//  Created by welsonla on 15/7/15.
//  Copyright (c) 2015年 Timebot. All rights reserved.
//

#import "AnalyticsViewController.h"
#import "AnalyticsManager.h"

@interface AnalyticsViewController ()

@end

@implementation AnalyticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)loadData
{
    NSInteger filesCount   = [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_FILE_COUNT];
    NSInteger classesCount = [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_CLASS_COUNT];
    NSInteger lineCount    = [[NSUserDefaults standardUserDefaults] integerForKey:TOTAL_LINE_COUNT];
    
    self.totalFileLabel.stringValue  = [NSString stringWithFormat:@"%ld",filesCount];
    self.totalClassLabel.stringValue = [NSString stringWithFormat:@"%ld",classesCount];
    self.totalLinesLabel.stringValue = [NSString stringWithFormat:@"%ld",lineCount];
}



- (IBAction)handleReset:(id)sender {
    [AnalyticsManager reset];
    [self loadData];
}
@end
