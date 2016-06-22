//
//  UITableViewCell+ZZRunloopTool.m
//  ZZRunloopToolDemo
//
//  Created by xcz on 16/6/22.
//  Copyright © 2016年 Pearl-Z. All rights reserved.
//

#import "UITableViewCell+ZZRunloopTool.h"
#import <objc/runtime.h>

@implementation UITableViewCell (ZZRunloopTool)

@dynamic currentIndexPath;

- (NSIndexPath *)currentIndexPath {
    NSIndexPath *indexPath = objc_getAssociatedObject(self, @selector(currentIndexPath));
    return indexPath;
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    objc_setAssociatedObject(self, @selector(currentIndexPath), currentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
