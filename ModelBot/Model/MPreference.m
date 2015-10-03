//
//  MPreference.m
//  ModelBot
//
//  Created by welsonla on 15/10/3.
//  Copyright © 2015年 Timebot. All rights reserved.
//

#import "MPreference.h"

@implementation MPreference

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _Author    = [aDecoder decodeObjectForKey:@"Author"];
        _Copyright = [aDecoder decodeObjectForKey:@"Copyright"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.Author    forKey:@"Author"];
    [aCoder encodeObject:self.Copyright forKey:@"Copyright"];
}

@end
