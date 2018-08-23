//
//  SHActionSheetView.h
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHActionSheetView;

//回调
typedef void (^SHSelectBlock)(SHActionSheetView *sheetView, NSInteger buttonIndex);

@interface SHActionSheetView : UIView

/**
 初始化

 @param title 标题
 @param cancel 取消
 @param messageArr 内容(NSString、NSAttributedString)
 @param specialArr 特殊按钮位置集合
 @param block 点击回调
 */
+ (SHActionSheetView *)showActionSheetWithTitle:(NSString *)title cancel:(NSString *)cancel messageArr:(NSArray *)messageArr specialArr:(NSArray *)specialArr block:(SHSelectBlock)block;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)dismiss;

@end


