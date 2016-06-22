//
//  ZZRunloopTool.h
//  runloopTest
//
//  Created by xcz on 16/6/5.
//  Copyright © 2016年 Pearl-Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ZZRunloopToolTaskUnit)(void);

@interface ZZRunloopTool : NSObject

- (void)addTask:(ZZRunloopToolTaskUnit)task withKey:(id)key;

- (void)removeAllTasks;

@end
