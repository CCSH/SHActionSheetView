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
    
    NSMutableArray *otherArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 60; i++) {
        
        [otherArr addObject:[NSString stringWithFormat:@"第%d个",i]];
    }
    
    SHActionSheetView *view = [SHActionSheetView showActionSheetWithTitle:@"这是标题" CancelTitle:@"这是取消按钮" SpecialTitles:@[@"3",@"2"] OtherTitles:otherArr Block:^(SHActionSheetView *actionSheetView, NSInteger buttonIndex) {
        NSLog(@"点击%ld",(long)buttonIndex);
    }];
    [view show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
