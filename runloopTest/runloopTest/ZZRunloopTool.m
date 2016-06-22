//
//  ZZRunloopTool.m
//  runloopTest
//
//  Created by xcz on 16/6/5.
//  Copyright © 2016年 Pearl-Z. All rights reserved.
//

#import "ZZRunloopTool.h"
#import <objc/runtime.h>

@interface ZZRunloopTool()

@property(nonatomic,assign) CFRunLoopObserverRef observer;

@property (nonatomic, strong) NSMutableArray *tasks;

@property (nonatomic, strong) NSMutableArray *tasksKeys;

@end


@implementation ZZRunloopTool


- (void)removeAllTasks {
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopCommonModes);
    [self.tasks removeAllObjects];
    [self.tasksKeys removeAllObjects];
}

- (void)addTask:(ZZRunloopToolTaskUnit)task withKey:(id)key{
    if (!CFRunLoopContainsObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopCommonModes)) {
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopCommonModes);
    }
    [self.tasks addObject:task];
    [self.tasksKeys addObject:key];
}


- (instancetype)init
{
    if ((self = [super init])) {
        _tasks = [NSMutableArray array];
        _tasksKeys = [NSMutableArray array];
        _observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, YES, LONG_MAX,^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
            //这个方法将创建一个 Source 0 任务，分发到指定线程的 RunLoop 中，在给定的 Mode 下执行
            [self performSelector:@selector(runLoopWorkTaskCallBack:) onThread:[NSThread mainThread] withObject:self waitUntilDone:NO modes:@[NSRunLoopCommonModes]];
        });
        
    }
    return self;
}

- (void)dealloc{
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
}



- (void)runLoopWorkTaskCallBack:(ZZRunloopTool *)runLoopTool{
//    NSLog(@"-----%@",runLoopTool.tasks);
    if (runLoopTool.tasks.count == 0) {
        return;
    }
    
    ZZRunloopToolTaskUnit unit  = runLoopTool.tasks.firstObject;
    unit();
    [runLoopTool.tasks removeObjectAtIndex:0];
    [runLoopTool.tasksKeys removeObjectAtIndex:0];
    
    if (!runLoopTool.tasks.count) {
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _observer, kCFRunLoopCommonModes);
    }
}

@end



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
