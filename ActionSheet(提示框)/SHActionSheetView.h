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

+ (SHActionSheetView *)showActionSheetWithTitle:(NSString *)title CancelTitle:(NSString *)cancelTitle SpecialTitles:(NSArray *)specialTitles OtherTitles:(NSArray *)otherTitles Block:(SHActionSheetViewDidSelectButtonBlock)block;

- (void)show;
- (void)dismiss;

@end


