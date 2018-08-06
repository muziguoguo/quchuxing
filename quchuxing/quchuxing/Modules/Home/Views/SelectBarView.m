//
//  SelectBarView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/30.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "SelectBarView.h"
#import "UIView+Draw.h"

@interface BarItemButton()
{
    UILabel *_titleLabel;
    UIView *_lineView;
}

@end

@implementation BarItemButton

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubView];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    if (title) {
        _title = title;
        _titleLabel.text = title;
    }
}

- (void)setTitleFont:(UIFont *)titleFont{
    if (titleFont) {
        _titleFont = titleFont;
        _titleLabel.font = titleFont;
    }
}

- (void)setNomalTitleColor:(UIColor *)nomalTitleColor{
    if (nomalTitleColor) {
        _nomalTitleColor = nomalTitleColor;
        _titleLabel.textColor = nomalTitleColor;
    }
}

#pragma mark --配置子视图
- (void)setSubView{
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [self addSubview:_titleLabel];
    
    _lineView = [[UIView alloc] init];
    [_lineView setHidden:YES];
    [self addSubview:_lineView];
}

#pragma mark --重写布局方法
- (void)layoutSubviews{
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
    
   _lineView.frame = CGRectMake(self.cur_w/4, self.cur_h-2, self.cur_w/2, 2);
    [_lineView gradualBackgroundColorWithCornerRadius:2 borderWidth:0 colors:nil locations:nil];
}

#pragma mark --重写按钮选中事件
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        _titleLabel.textColor = _selectTitleColor?_selectTitleColor:FrenchGrayColor;
        _lineView.hidden = NO;
    }
    else{
        _titleLabel.textColor = _nomalTitleColor?_nomalTitleColor:DarkGrayColor;
        _lineView.hidden = YES;
    }
}

@end

@interface SelectBarView()
{
    NSMutableArray *_itemViewArray;
    BarItemButton *_lastBtn;
}

@end

@implementation SelectBarView

#pragma mark --初始化方法
- (instancetype)initWithItems:(NSArray<NSString *> *)items withTitleFont:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor{
    self = [super init];
    if (self) {
        [self setSubviewsWithItems:items withTitleFont:font normalColor:normalColor selectedColor:selectedColor];
    }
    return self;
}

#pragma mark --配置子视图
- (void)setSubviewsWithItems:(NSArray *)items withTitleFont:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor{
    _itemViewArray = [NSMutableArray array];
    for (NSInteger i=0; i<items.count; i++) {
        BarItemButton *itemBtn = [[BarItemButton alloc] init];
        [itemBtn setTag:10+i];
        [itemBtn setTitle:items[i]];
        [itemBtn setTitleFont:font];
        [itemBtn setNomalTitleColor:normalColor];
        [itemBtn setSelectTitleColor:selectedColor];
        [itemBtn addTarget:self action:@selector(itemBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        [_itemViewArray addObject:itemBtn];
    }
}

#pragma mark --重写布局方法
- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger itemCount = _itemViewArray.count;
    __WeakSelf__ weakSelf = self;
    [_itemViewArray enumerateObjectsUsingBlock:^(UIButton *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(weakSelf.cur_w/itemCount*idx, 0, weakSelf.cur_w/itemCount, weakSelf.cur_h);
    }];
}

#pragma mark --选中第一个item
- (void)selectFirstItem{
    [self itemBtnResponse:_itemViewArray[0]];
}

#pragma mark --按钮响应事件
- (void)itemBtnResponse:(BarItemButton *)sender{
    if (_lastBtn != sender) {
        _lastBtn.selected = NO;
        _lastBtn = sender;
        sender.selected = YES;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:)]) {
        [_delegate selectedIndex:sender.tag-10];
    }
}


@end
