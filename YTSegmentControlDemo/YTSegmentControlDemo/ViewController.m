//
//  ViewController.m
//  YTSegmentControlDemo
//
//  Created by 余婷 on 16/11/10.
//  Copyright © 2016年 余婷. All rights reserved.
//

#import "ViewController.h"
#import "YTSegmentControl/YTSegmentControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YTSegmentControl * segment = [[YTSegmentControl alloc] initWithItems:@[@"消息",@"电话"]];
    segment.frame = CGRectMake(0, 0, 100, 50);
    self.navigationItem.titleView = segment;
    [segment setTitleSelectedColor:[UIColor greenColor] normalColor:[UIColor redColor]];
    
    [segment addTarget:self action:@selector(segmentAction:)];
    
}

- (void)segmentAction:(YTSegmentControl*)segment{

    NSLog(@"%d被选中",segment.selectedIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
