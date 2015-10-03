//
//  PreferenceController.m
//  ModelBot
//
//  Created by welsonla on 15/10/3.
//  Copyright © 2015年 Timebot. All rights reserved.
//

#import "PreferenceController.h"
#import "MPreference.h"

@interface PreferenceController ()

@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSTextField *copyrightField;

@end

@implementation PreferenceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"偏好设置";
    
    MPreference *preference = [ModelFunctionsMate getPreference];
    if (preference) {
        self.authorField.stringValue = preference.Author;
        self.copyrightField.stringValue = preference.Copyright;
    }else{
        self.authorField.stringValue = @"Timebot";
        self.copyrightField.stringValue = @"Timebot";
    }
}


- (void)viewWillDisappear{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    MPreference *preference = [[MPreference alloc] init];
    preference.Author = self.authorField.stringValue;
    preference.Copyright = self.copyrightField.stringValue;
    
    [ModelFunctionsMate savePreference:preference];
}

@end
