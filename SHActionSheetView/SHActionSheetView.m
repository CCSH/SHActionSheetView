//
//  SHActionSheetView.m
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHActionSheetView.h"
//#import "SHActionSheetModel.h"

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
#define kSheetMaskColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
//选择栏背景颜色
#define kSheetBackColor [UIColor whiteColor]
//提示框下方线颜色
#define kSheetViewLineColor [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f]
//下方分割线颜色
#define kSheetSeparatorColor [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]
//头部标题字体颜色
#define kSheetHeadTextColor [UIColor blackColor]
//特殊按钮字体颜色
#define kSheetSpecialTextColor [UIColor orangeColor]
//其他按钮字体颜色
#define kSheetOtherTextColor [UIColor colorWithRed:38/255.0f green:51/255.0f blue:76/255.0f alpha:1.0f]

@implementation SHActionSheetModel

- (NSString *)cancel{
    if (!_cancel.length) {
        return @"取消";
    }
    return _cancel;
}

@end

@interface SHActionSheetView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, assign) BOOL isShow;

//数据
@property (nonatomic, strong) SHActionSheetModel *model;

//回调
@property (nonatomic, copy) SHSelectBlock selectBlock;

@end

@implementation SHActionSheetView

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self){
        
      
    }
    return self;
}

- (UIView *)backView{
    if (!_backView) {
        //蒙版
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_backView];
    }
    return _backView;
}

- (UITableView *)listView{
    if (!_listView) {
        
        _listView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0) style:UITableViewStylePlain];
        _listView.backgroundColor = kSheetBackColor;
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorColor = kSheetViewLineColor;
        _listView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _listView.showsVerticalScrollIndicator = NO;
        _listView.bounces = NO;
        [self.contentView addSubview:_listView];
    }
    return _listView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        _contentView.backgroundColor = [UIColor orangeColor];
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (instancetype)initActionSheetWithParam:(SHActionSheetModel *)param block:(SHSelectBlock)block{
    
    self = [self init];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.model = param;
        self.selectBlock = block;
        self.backView.backgroundColor = kSheetMaskColor;
        
        CGFloat safeBottom = ([UIApplication sharedApplication].statusBarFrame.size.height != 20) ? 34 : 0;
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        //头部+内容+分割线+底部
        CGFloat headH = _model.title.length ? kSheetHeadHeight : 0;
        CGFloat viewH = MIN(_model.messageArr.count, kSheetMaxCellNum) * kSheetCellHeight;
        CGFloat listH = headH + viewH;
        
        CGFloat view_y = 0;
        
        self.listView.frame = CGRectMake(0, view_y, width, listH);
        view_y = CGRectGetMaxY(self.listView.frame);
        
        //分割线
        UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, view_y, width, kSheetSeparatorHeight)];
        separator.backgroundColor = kSheetSeparatorColor;
        [self.contentView addSubview:separator];
        view_y = CGRectGetMaxY(separator.frame);
        
        //取消按钮
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, view_y, width, kSheetFootHeight)];
        cancelBtn.backgroundColor = kSheetBackColor;
        cancelBtn.tag = -1;
        cancelBtn.opaque = YES;
        cancelBtn.titleLabel.font = kSheetOtherFontSize;
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:self.model.cancel forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:cancelBtn];
        view_y = CGRectGetMaxY(cancelBtn.frame);
        
        //适配全面屏
        UIView *safeView = [[UIView alloc]init];
        safeView.frame = CGRectMake(0, view_y, width, safeBottom);
        safeView.backgroundColor = kSheetBackColor;
        [self.contentView addSubview:safeView];
        view_y = CGRectGetMaxY(safeView.frame);
        
        CGRect frame = self.contentView.frame;
        frame.size.height = view_y;
        frame.origin.y = height - view_y;
        
        self.contentView.frame = frame;
    }
    
    return self;
}

+ (SHActionSheetView *)showActionSheetWithParam:(SHActionSheetModel *)param block:(SHSelectBlock)block{
    
    SHActionSheetView *sheetView = [[SHActionSheetView alloc] initActionSheetWithParam:param block:block];
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    //设置内容
    if ([obj isKindOfClass:[NSAttributedString class]]) {
        
        cell.textLabel.attributedText = obj;
    }else if ([obj isKindOfClass:[NSString class]]){
        
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
    
    //回调
    if (self.selectBlock){
        self.selectBlock(self, indexPath.row);
    }
    
    [self dismiss];
}

#pragma mark - 取消点击
- (void)cancelAction:(UIButton *)button {
    
    //回调
    if (self.selectBlock){
        NSInteger index = button.tag;
        self.selectBlock(self, index);
    }
    
    [self dismiss];
}

#pragma mark - public
- (void)show {
    if(self.isShow) {
        return;
    }
    
    self.isShow = YES;
    
    //从下到上
    __block CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height;
    self.contentView.frame = frame;
    self.backView.alpha = 1;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
        self.contentView.frame = frame;
        
    } completion:NULL];
}

- (void)dismiss {
    self.isShow = NO;
    //从上到下
    __block CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
    self.contentView.frame = frame;
    self.backView.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = self.frame.size.height;
        self.contentView.frame = frame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
