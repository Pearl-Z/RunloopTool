//
//  ViewController.m
//  runloopTest
//
//  Created by xcz on 16/6/4.
//  Copyright © 2016年 Pearl-Z. All rights reserved.
//

#import "ViewController.h"
#import "ZZRunloopTool.h"

static NSString *IDENTIFIER = @"IDENTIFIER";

static CGFloat CELL_HEIGHT = 135.f;

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *exampleTableView;;

@property(nonatomic,strong) ZZRunloopTool *runLoopTool;

@end

@implementation ViewController

- (ZZRunloopTool *)runLoopTool{
    if (!_runLoopTool) {
        _runLoopTool = [[ZZRunloopTool alloc] init];
    }
    return _runLoopTool;
}

+ (void)task_5:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    for (NSInteger i = 1; i <= 5; i++) {
        [[cell.contentView viewWithTag:i] removeFromSuperview];
    }
}

+ (void)task_1:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd - Drawing index is top priority", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 1;
    [cell.contentView addSubview:label];
}

+ (void)task_2:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath  {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 20, 85, 85)];
    imageView.tag = 2;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
}

+ (void)task_3:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath  {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 20, 85, 85)];
    imageView.tag = 3;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [cell.contentView addSubview:imageView];
   
}

+ (void)task_4:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath  {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 99, 300, 35)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0 green:100.f/255.f blue:0 alpha:1];
    label.text = [NSString stringWithFormat:@"%zd - Drawing large image is low priority. Should be distributed into different run loop passes.", indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.tag = 4;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 85, 85)];
    imageView.tag = 5;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"spaceship" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:imageView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 399;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.currentIndexPath = indexPath;
    [ViewController task_5:cell indexPath:indexPath];
    [ViewController task_1:cell indexPath:indexPath];
    [self.runLoopTool addTask:^void(void) {
        NSLog(@"1--%@",cell.currentIndexPath);
        if ([cell.currentIndexPath isEqual:indexPath]) {
            [ViewController task_2:cell indexPath:indexPath];
        }
    } withKey:indexPath];
    [self.runLoopTool addTask:^void(void) {
        NSLog(@"2--%@",cell.currentIndexPath);
        if ([cell.currentIndexPath isEqual:indexPath]) {
            [ViewController task_3:cell indexPath:indexPath];
        }
    } withKey:indexPath];
    [self.runLoopTool addTask:^void(void) {
        NSLog(@"3--%@",cell.currentIndexPath);
        if ([cell.currentIndexPath isEqual:indexPath]) {
            [ViewController task_4:cell indexPath:indexPath];
        }
    } withKey:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}


- (void)loadView {
    self.view = [UIView new];
    self.exampleTableView = [UITableView new];
    self.exampleTableView.delegate = self;
    self.exampleTableView.dataSource = self;
    [self.view addSubview:self.exampleTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.exampleTableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.exampleTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
