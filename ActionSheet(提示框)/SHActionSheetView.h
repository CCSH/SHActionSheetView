//
//  SHActionSheetView.h
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHActionSheetView;

typedef void (^SHActionSheetViewDidSelectButtonBlock)(SHActionSheetView *actionSheetView, NSInteger buttonIndex);

@interface SHActionSheetView : UIView

+ (SHActionSheetView *)showActionSheetWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle specialTitle:(NSString *)specialTitle otherTitles:(NSArray *)otherTitles handler:(SHActionSheetViewDidSelectButtonBlock)block;

- (void)show;
- (void)dismiss;

@end
