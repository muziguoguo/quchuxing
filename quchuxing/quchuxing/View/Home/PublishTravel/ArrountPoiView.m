//
//  ArrountPoiView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/21.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "ArrountPoiView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "PoiTableViewCell.h"
#import <MJRefresh.h>

@interface ArrountPoiView()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *poiTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation ArrountPoiView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ArrountPoiView" owner:self options:nil] lastObject];
        [_cancelBtn gradualBackgroundColorWithCornerRadius:8 borderWidth:0 colors:nil locations:nil bounds:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH-30, 50)];
        [self setTableView];
    }
    return self;
}

- (void)setTableView{
    __WeakSelf__ weakSelf = self;
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        if (weakSelf.page == 1) {
            [weakSelf setIsRefreshHeader:NO];
            return;
        }
        weakSelf.page--;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(headerRefreshWithPage:)]) {
            [weakSelf.delegate headerRefreshWithPage:weakSelf.page];
        }
        else{
            [weakSelf.poiTableView.mj_header endRefreshing];
        }
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    _poiTableView.mj_header = header;
    
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        if (weakSelf.page == 20) {
            [weakSelf setIsRefreshFooter:NO];
            return;
        }
        weakSelf.page++;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(footerRefreshWithPage:)]) {
            [weakSelf.delegate footerRefreshWithPage:weakSelf.page];
        }
    }];
    [footer setState:MJRefreshStateIdle];
    _poiTableView.mj_footer = footer;
}

#pragma mark == 属性操作
- (void)setPage:(NSInteger)page{
    _page = page;
    if (page == 1) {
        [(MJRefreshStateHeader *)_poiTableView.mj_header setTitle:@"当前是第一页,已经没有上一页啦..." forState:MJRefreshStateIdle];
        [(MJRefreshStateHeader *)_poiTableView.mj_header setTitle:@"当前是第一页,已经没有上一页啦..." forState:MJRefreshStatePulling];
        [(MJRefreshStateHeader *)_poiTableView.mj_header setTitle:@"当前是第一页,已经没有上一页啦..." forState:MJRefreshStateRefreshing];
    }
    else{
        [(MJRefreshStateHeader *)_poiTableView.mj_header setTitle:[NSString stringWithFormat:@"下拉加载第%ld页", page-1] forState:MJRefreshStateIdle];
        [(MJRefreshStateHeader *)_poiTableView.mj_header setTitle:@"松开即可刷新" forState:MJRefreshStatePulling];
        [(MJRefreshStateHeader *)_poiTableView.mj_header setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    }
    
    if (page == 20) {
        [(MJRefreshBackStateFooter *)_poiTableView.mj_footer setTitle:@"当前是最后一页,已经没有下一页啦..." forState:MJRefreshStateIdle];
        [(MJRefreshBackStateFooter *)_poiTableView.mj_footer setTitle:@"当前是最后一页,已经没有下一页啦..." forState:MJRefreshStatePulling];
        [(MJRefreshBackStateFooter *)_poiTableView.mj_footer setTitle:@"当前是最后一页,已经没有下一页啦..." forState:MJRefreshStateRefreshing];
    }
    else{
        [(MJRefreshBackStateFooter *)_poiTableView.mj_footer setTitle:[NSString stringWithFormat:@"上拉加载第%ld页", page+1] forState:MJRefreshStateIdle];
        [(MJRefreshBackStateFooter *)_poiTableView.mj_footer setTitle:@"松开即可刷新" forState:MJRefreshStatePulling];
        [(MJRefreshBackStateFooter *)_poiTableView.mj_footer setTitle:@"正在刷新..." forState:MJRefreshStateRefreshing];
    }
}

- (void)setTitle:(NSString *)title{
    if (title) {
        _title = title;
        _titleLabel.text = title;
    }
}

- (void)setPoiArray:(NSArray *)poiArray{
    if (poiArray) {
        _poiArray = poiArray;
        [self.poiTableView reloadData];
        [self.poiTableView setContentOffset:CGPointZero];
    }
}

- (void)setIsRefreshHeader:(BOOL)isRefreshHeader{
    _isRefreshHeader = isRefreshHeader;
    if (isRefreshHeader) {
        [self.poiTableView.mj_header beginRefreshing];
    }
    else{
        [self.poiTableView.mj_header endRefreshing];
    }
}

- (void)setIsRefreshFooter:(BOOL)isRefreshFooter{
    _isRefreshFooter = isRefreshFooter;
    if (isRefreshFooter) {
        [self.poiTableView.mj_footer beginRefreshing];
    }
    else{
        [self.poiTableView.mj_footer endRefreshing];
    }
}

#pragma mark == 隐藏当前视图
- (void)hidden{
    __WeakSelf__ weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.frame = CGRectMake(weakSelf.cur_x, weakSelf.cur_h, weakSelf.cur_w, weakSelf.cur_h);
    } completion:^(BOOL finished) {
        [weakSelf updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([weakSelf superview]).offset(weakSelf.cur_h);
        }];
        self.hidden = YES;
    }];
}

#pragma mark == 按钮响应事件
- (IBAction)clickedCancelBtn:(id)sender {
    [self hidden];
}

#pragma mark == UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiCellIdentifer"];
    if (!cell) {
        cell = [[PoiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PoiCellIdentifer"];
    }
    return cell;
}

#pragma mark == UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [(PoiTableViewCell *)cell setPoiData:self.poiArray[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedCellWithPoiData:)]) {
        [_delegate selectedCellWithPoiData:self.poiArray[indexPath.row]];
    }
    [self hidden];
}

#pragma mark == 点击屏幕事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidden];
}


@end






