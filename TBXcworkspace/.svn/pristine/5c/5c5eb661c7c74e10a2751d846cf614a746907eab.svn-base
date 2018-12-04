//
//  TBH5SourceModel.m
//  TBBusiness
//
//  Created by Apple on 2018/6/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBH5SourceModel.h"

@implementation TBH5SourceModel

#pragma mark - 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.moduleVersion     forKey:MODULE_VERSION];
    [aCoder encodeObject:self.module            forKey:MODULE];
    [aCoder encodeObject:self.moduleId          forKey:MODULE_ID];
    [aCoder encodeObject:self.path              forKey:PATH];
    [aCoder encodeObject:self.files             forKey:FILES];
}

#pragma mark - 解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.moduleVersion      = [aDecoder decodeObjectForKey:MODULE_VERSION];
        self.module             = [aDecoder decodeObjectForKey:MODULE];
        self.moduleId           = [aDecoder decodeObjectForKey:MODULE_ID];
        self.path               = [aDecoder decodeObjectForKey:PATH];
        self.files              = [aDecoder decodeObjectForKey:FILES];
    }
    
    return self;
}
@end
