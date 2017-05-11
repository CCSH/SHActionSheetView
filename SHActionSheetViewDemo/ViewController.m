//
//  ViewController.m
//  SHActionSheetViewDemo
//
//  Created by CSH on 2017/5/10.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "ViewController.h"
#import "SHActionSheetView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SHActionSheetView *view = [SHActionSheetView showActionSheetWithTitle:@"标题" cancelTitle:@"取消" specialTitle:@"特殊" otherTitles:@[@"1",@"2",@"3",@"4",@"5"] handler:^(SHActionSheetView *actionSheetView, NSInteger buttonIndex) {
        
        NSLog(@"点击了%ld",(long)buttonIndex);
    }];
    [view show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
