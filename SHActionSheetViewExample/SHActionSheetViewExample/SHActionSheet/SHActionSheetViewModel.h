//
//  SHActionSheetViewModel.h
//  SHActionSheetViewDemo
//
//  Created by CSH on 2017/6/27.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHActionSheetView.h"

@interface SHActionSheetViewModel : NSObject

//标题头
@property (nonatomic, copy) NSString *title;
//取消按钮(可以为空有默认的)
@property (nonatomic, copy) NSString *cancel;
//特殊按钮
@property (nonatomic, copy) NSArray *specialArr;
//其他按钮
@property (nonatomic, copy) NSArray *messageArr;
//回调
@property (nonatomic, copy) SHSelectBlock selectBlock;

@end
