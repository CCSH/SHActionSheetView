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
    
    NSMutableArray *messageArr = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 10; i++) {
        [messageArr addObject:[NSString stringWithFormat:@"第%d个",i]];
    }

    SHActionSheetModel *model = [[SHActionSheetModel alloc]init];
    model.title = @"标题";
    model.messageArr = messageArr;
    model.specialArr = @[@2,@3];

    SHActionSheetView *view = [[SHActionSheetView alloc]init];
    view.model = model;
    view.style = SHActionSheetStyle_system;
    [view show];

    view.block = ^(SHActionSheetView *sheetView, NSInteger buttonIndex) {

    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
