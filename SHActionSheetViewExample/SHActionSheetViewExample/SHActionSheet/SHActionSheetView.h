//
//  SHActionSheetView.h
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHActionSheetView;

typedef void (^SHSelectBlock)(SHActionSheetView *sheetView, NSInteger buttonIndex);

@interface SHActionSheetView : UIView

+ (SHActionSheetView *)showActionSheetWithTitle:(NSString *)title cancel:(NSString *)cancel messageArr:(NSArray *)messageArr specialArr:(NSArray *)specialArr block:(SHSelectBlock)block;

- (void)show;
- (void)dismiss;

@end


