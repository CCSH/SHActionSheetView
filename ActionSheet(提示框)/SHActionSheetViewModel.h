//
//  SHActionSheetViewModel.h
//  SHActionSheetViewDemo
//
//  Created by CSH on 2017/6/27.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHActionSheetViewModel : NSObject

//标题头
@property (nonatomic, copy) NSString *title;
//取消按钮(可以为空有默认的)
@property (nonatomic, copy) NSString *cancelTitle;
//特殊按钮
@property (nonatomic, copy) NSArray *specialTitles;
//其他按钮
@property (nonatomic, copy) NSArray *otherTitles;

@end
