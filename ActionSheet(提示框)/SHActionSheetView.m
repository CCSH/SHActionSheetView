//
//  SHActionSheetView.m
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHActionSheetView.h"

#define kRowHeight 48.0f
#define kRowLineHeight 0.5f
#define kSeparatorHeight 5.0f

//标题字体大小
#define kTitleFontSize 13.0f
//其他字体大小
#define kButtonTitleFontSize 17.0f

//背景颜色
#define kBackColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]

//提示框下方线颜色
#define kViewLineColor [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f]
//下方分割线颜色
#define kSeparatorColor [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]
//选择栏背景颜色
#define kNormalColor [UIColor whiteColor]
//选择栏按住背景颜色
#define kHighlightedColor [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]

//头部标题字体颜色
#define kHeadTitleTextColor [UIColor redColor]
//特殊按钮字体颜色
#define kSpecialBtnTextColor [UIColor orangeColor]
//其他按钮字体颜色
#define kBtnTextColor [UIColor grayColor]

@interface SHActionSheetView () {
    UIView      *_backView;
    UIView *_actionSheetView;
    CGFloat _actionSheetHeight;
    BOOL        _isShow;
}
//标题
@property (nonatomic, copy) NSString *title;
//取消按钮
@property (nonatomic, copy) NSString *cancelTitle;
//特殊按钮
@property (nonatomic, copy) NSString *specialTitle;
//其他按钮
@property (nonatomic, copy) NSArray *otherTitles;
//回调
@property (nonatomic, copy) SHActionSheetViewDidSelectButtonBlock selectRowBlock;

@end

@implementation SHActionSheetView

- (instancetype)init {
    self = [super init];
    if (self)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle specialTitle:(NSString *)specialTitle otherTitles:(NSArray *)otherTitles handler:(SHActionSheetViewDidSelectButtonBlock)block{
    self = [self init];
    
    if (self)
    {
        //初始化
        _title = title;
        _cancelTitle = cancelTitle;
        _specialTitle = specialTitle;
        _otherTitles = otherTitles;
        _selectRowBlock = block;
        
        //背景
        _backView = [[UIView alloc] initWithFrame:self.frame];
        _backView.backgroundColor = kBackColor;
        _backView.alpha = 0.0f;
        [self addSubview:_backView];
        
        //选择视图
        _actionSheetView = [[UIView alloc] init];
        _actionSheetView.backgroundColor = kViewLineColor;
        [self addSubview:_actionSheetView];
        
        CGFloat offy = 0;
        CGFloat width = self.frame.size.width;
        
        UIImage *normalImage = [self imageWithColor:kNormalColor];
        UIImage *highlightedImage = [self imageWithColor:kHighlightedColor];
        
        //标题
        if (_title.length)
        {
            CGFloat spacing = 15.0f;
            
            CGFloat titleHeight = ceil([_title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + spacing*2;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, titleHeight)];
            titleLabel.backgroundColor = kNormalColor;
            titleLabel.textColor = kHeadTitleTextColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleLabel.numberOfLines = 0;
            titleLabel.text = _title;
            [_actionSheetView addSubview:titleLabel];
            
            offy += titleHeight+kRowLineHeight;
        }
        
        //特殊按钮
        if (_specialTitle.length)
        {
            UIButton *specialBtn= [[UIButton alloc] init];
            specialBtn.frame = CGRectMake(0, offy, width, kRowHeight);
            specialBtn.tag = _otherTitles.count;
            specialBtn.backgroundColor = [UIColor whiteColor];
            specialBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [specialBtn setTitleColor:kSpecialBtnTextColor forState:UIControlStateNormal];
            [specialBtn setTitle:_specialTitle forState:UIControlStateNormal];
            [specialBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
            [specialBtn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [specialBtn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:specialBtn];
            
            offy += kRowHeight+kRowLineHeight;
        }
        
        //其他按钮
        if (_otherTitles.count)
        {
            for (int i = 0; i < _otherTitles.count; i++)
            {
                UIButton *btn = [[UIButton alloc] init];
                btn.frame = CGRectMake(0, offy, width, kRowHeight);
                btn.tag =  _otherTitles.count - i - 1;
                btn.backgroundColor = [UIColor whiteColor];
                btn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
                
                if ([_otherTitles[btn.tag] isKindOfClass:[NSAttributedString class]]) {
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithAttributedString:_otherTitles[btn.tag]];
                    [str addAttributes:@{NSForegroundColorAttributeName:kBtnTextColor} range:NSMakeRange(0, str.length)];
                    [btn setAttributedTitle:str forState:UIControlStateNormal];
                }else{
                    
                    [btn setTitleColor:kBtnTextColor forState:UIControlStateNormal];
                    [btn setTitle:_otherTitles[btn.tag] forState:UIControlStateNormal];
                }
                
                [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
                [btn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                [_actionSheetView addSubview:btn];
                
                offy += kRowHeight+kRowLineHeight;
            }
            
            offy -= kRowLineHeight;
        }
        
        //分隔线
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, offy, width, kSeparatorHeight)];
        separatorView.backgroundColor = kSeparatorColor;
        [_actionSheetView addSubview:separatorView];
        
        offy += kSeparatorHeight;
        
        //取消按钮
        UIButton *cancelBtn = [[UIButton alloc] init];
        cancelBtn.frame = CGRectMake(0, offy, width, kRowHeight);
        cancelBtn.tag = -1;
        cancelBtn.backgroundColor = kNormalColor;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
        [cancelBtn setTitleColor:kBtnTextColor forState:UIControlStateNormal];
        [cancelBtn setTitle:_cancelTitle?: NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(didSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_actionSheetView addSubview:cancelBtn];
        
        offy += kRowHeight;
        
        _actionSheetHeight = offy;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
    }
    
    return self;
}

+ (SHActionSheetView *)showActionSheetWithTitle:(NSString *)title cancelTitle:(NSString *)cancelTitle specialTitle:(NSString *)specialTitle otherTitles:(NSArray *)otherTitles handler:(SHActionSheetViewDidSelectButtonBlock)block{
    
    SHActionSheetView *actionSheetView = [[SHActionSheetView alloc] initWithTitle:title cancelTitle:cancelTitle specialTitle:specialTitle otherTitles:otherTitles handler:block];
    return actionSheetView;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_backView];
    if (!CGRectContainsPoint([_actionSheetView frame], point))
    {
        [self dismiss];
    }
}

- (void)didSelectAction:(UIButton *)button {
    if (_selectRowBlock)
    {
        NSInteger index = button.tag;
        
        _selectRowBlock(self, index);
    }
    
    [self dismiss];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - public

- (void)show {
    if(_isShow) return;
    
    _isShow = YES;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        _backView.alpha = 1.0;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-_actionSheetHeight, CGRectGetWidth(self.frame), _actionSheetHeight);
    } completion:NULL];
}

- (void)dismiss {
    _isShow = NO;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        _backView.alpha = 0.0;
        
        _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




#pragma mark - 销毁
- (void)dealloc {
    self.title= nil;
    self.cancelTitle = nil;
    self.specialTitle = nil;
    self.otherTitles = nil;
    self.selectRowBlock = nil;
    
    _actionSheetView = nil;
    _backView = nil;
}

@end
