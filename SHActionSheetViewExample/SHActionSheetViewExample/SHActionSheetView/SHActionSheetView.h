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


/**
 Model
 */
@interface SHActionSheetModel : NSObject
//标题头
@property (nonatomic, copy) NSString *title;
//取消按钮(可以为空有默认的)
@property (nonatomic, copy) NSString *cancel;
//特殊按钮
@property (nonatomic, copy) NSArray *specialArr;
//其他按钮
@property (nonatomic, copy) NSArray *messageArr;

@end


/**
 列表弹框
 */
@interface SHActionSheetView : UIView

/**
 初始化

 @param param 数据
 @param block 点击回调
 */
+ (SHActionSheetView *)showActionSheetWithParam:(SHActionSheetModel *)param block:(SHSelectBlock)block;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)dismiss;

@end


