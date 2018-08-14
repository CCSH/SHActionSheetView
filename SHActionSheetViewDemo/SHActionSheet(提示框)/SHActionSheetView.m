//
//  SHActionSheetView.m
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHActionSheetView.h"
#import "SHActionSheetViewModel.h"

#define mark - 高度
//头部高度
#define kSheetHeadHeight 48.0f
//中间高度
#define kSheetCellHeight 48.0f
//下方分割高度
#define kSheetSeparatorHeight 5.0f
//底部高度
#define kSheetFootHeight 48.0f

#pragma mark  - 个数
//最多展示几个选项
#define kSheetMaxCellNum 6

#pragma mark  - 字体
//标题字体大小
#define kSheetTitleFontSize [UIFont systemFontOfSize:13.0f]
//其他字体大小
#define kSheetOtherFontSize [UIFont systemFontOfSize:17.0f]

#pragma mark  - 颜色
//蒙版颜色
#define kSheetMaskColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]
//选择栏背景颜色
#define kSheetBackColor [UIColor whiteColor]
//提示框下方线颜色
#define kSheetViewLineColor [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f]
//下方分割线颜色
#define kSheetSeparatorColor [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f]
//头部标题字体颜色
#define kSheetHeadTextColor [UIColor redColor]
//特殊按钮字体颜色
#define kSheetSpecialTextColor [UIColor orangeColor]
//其他按钮字体颜色
#define kSheetOtherTextColor [UIColor grayColor]

@interface SHActionSheetView ()<UITableViewDelegate,UITableViewDataSource> {
    UIView      *_backView;
    UITableView *_actionSheetView;
    CGFloat _actionSheetHeight;
    BOOL        _isShow;
}

//参数
@property (nonatomic, strong) SHActionSheetViewModel *model;
//回调
@property (nonatomic, copy) SHSelectBlock selectBlock;

@end

@implementation SHActionSheetView

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    self = [super init];
    if (self)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = frame;
    }
    
    return self;
}

- (instancetype)initActionSheetWithTitle:(NSString *)title cancel:(NSString *)cancel messageArr:(NSArray *)messageArr specialArr:(NSArray *)specialArr block:(SHSelectBlock)block{
    
    self = [self init];
    if (self)
    {
        //初始化
        self.model = [[SHActionSheetViewModel alloc]init];
        //设置标题
        self.model.title = title;
        //设置按钮
        self.model.messageArr = messageArr;
        //设置特殊按钮
        self.model.specialArr = specialArr;
        //设置取消按钮
        self.model.cancel = cancel;
        //设置回调
        self.model.selectBlock = block;
        
        //蒙版
        _backView = [[UIView alloc] initWithFrame:self.frame];
        _backView.backgroundColor = kSheetMaskColor;
        _backView.alpha = 0;
        [self addSubview:_backView];
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        //头部+中间最多个点击+分割线+底部
        CGFloat headH = _model.title.length?kSheetHeadHeight:0;
        CGFloat viewH = ((_model.messageArr.count <= kSheetMaxCellNum)?_model.messageArr.count:kSheetMaxCellNum)*kSheetCellHeight;
        CGFloat cancelH = kSheetSeparatorHeight + kSheetFootHeight;
        _actionSheetHeight = headH + viewH;
        
        //选择视图
        _actionSheetView = [[UITableView alloc] initWithFrame:CGRectMake(0,height - _actionSheetHeight - cancelH , width, _actionSheetHeight) style:UITableViewStylePlain];
        _actionSheetView.backgroundColor = kSheetBackColor;
        _actionSheetView.delegate = self;
        _actionSheetView.dataSource = self;
        _actionSheetView.separatorColor = kSheetViewLineColor;
        _actionSheetView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _actionSheetView.showsVerticalScrollIndicator = NO;
        _actionSheetView.bounces = NO;
        [self addSubview:_actionSheetView];
        
        //下方视图
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, height - cancelH, self.frame.size.width, cancelH)];
        footView.backgroundColor = kSheetBackColor;
        
        //分割线
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, footView.frame.size.width, kSheetSeparatorHeight)];
        separator.backgroundColor = kSheetSeparatorColor;
        [footView addSubview:separator];
        
        //取消按钮
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kSheetSeparatorHeight, footView.frame.size.width, kSheetFootHeight)];
        cancelBtn.tag = -1;
        cancelBtn.opaque = YES;
        cancelBtn.titleLabel.font = kSheetOtherFontSize;
        [cancelBtn setTitleColor:kSheetOtherTextColor forState:UIControlStateNormal];
        [cancelBtn setTitle:self.model.cancel?: NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:cancelBtn];
        [self addSubview:footView];
    }
    
    return self;
}

+ (SHActionSheetView *)showActionSheetWithTitle:(NSString *)title cancel:(NSString *)cancel messageArr:(NSArray *)messageArr specialArr:(NSArray *)specialArr block:(SHSelectBlock)block{

    SHActionSheetView *sheetView = [[SHActionSheetView alloc] initActionSheetWithTitle:title cancel:cancel messageArr:messageArr specialArr:specialArr block:block];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:sheetView];
    return sheetView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.model.title.length?kSheetHeadHeight:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kSheetCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    //设置数据
    [self setCellDataSoureWithCell:cell IndexPath:indexPath];
    
    return cell;
}

- (void)setCellDataSoureWithCell:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    
    cell.textLabel.font = kSheetOtherFontSize;
    cell.textLabel.textColor = kSheetOtherTextColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    id obj = self.model.messageArr[indexPath.row];
    
    for (NSString *index in self.model.specialArr) {
        if ([index intValue] == indexPath.row) {
            cell.textLabel.textColor = kSheetSpecialTextColor;
            break;
        }
    }
    
    if ([obj isKindOfClass:[NSAttributedString class]]) {
        
        cell.textLabel.attributedText = obj;
    }else{
        cell.textLabel.text = obj;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headView;
    
    if (self.model.title.length) {
        headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSheetHeadHeight)];
        headView.backgroundColor = kSheetBackColor;
        headView.textColor = kSheetHeadTextColor;
        headView.textAlignment = NSTextAlignmentCenter;
        headView.font = kSheetOtherFontSize;
        headView.text = self.model.title;
        headView.layer.cornerRadius = 1;
        headView.layer.borderColor = kSheetViewLineColor.CGColor;
        headView.layer.borderWidth = 0.5;
    }
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.model.selectBlock){
        
        self.model.selectBlock(self, indexPath.row);
    }
    
    [self dismiss];
}

#pragma mark - 取消点击
- (void)cancelAction:(UIButton *)button {
    if (self.model.selectBlock)
    {
        NSInteger index = button.tag;
        
        self.model.selectBlock(self, index);
    }
    
    [self dismiss];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_backView];
    if (!CGRectContainsPoint([_actionSheetView frame], point))
    {
        [self dismiss];
    }
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
    
    _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _actionSheetHeight);
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        _actionSheetView.frame = CGRectMake(0,self.frame.size.height - (_actionSheetHeight + kSheetSeparatorHeight + kSheetFootHeight) , self.frame.size.width, _actionSheetHeight);
        _backView.alpha = 1;
    } completion:NULL];
}

- (void)dismiss {
    _isShow = NO;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        _backView.alpha = 0.0;
        _actionSheetView.frame = CGRectMake(0,self.frame.size.height , self.frame.size.width, _actionSheetHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 销毁
- (void)dealloc {
    self.model= nil;
    
    _actionSheetView = nil;
    _backView = nil;
}

@end
