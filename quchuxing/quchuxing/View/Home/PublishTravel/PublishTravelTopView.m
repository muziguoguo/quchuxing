//
//  PublishTravelTopView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/13.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "PublishTravelTopView.h"
#import "AddressCellView.h"
#import "AMapLocationTool.h"

#define CellHeight 50
@interface PublishTravelTopView()<AddressCellViewDelegate, AMapSearchDelegate>
{
    ViewType _viewType; //视图类型
    UITextField *_currentTextField;
}

@property (weak, nonatomic) IBOutlet UIButton *navBackBtn;
@property (weak, nonatomic) IBOutlet UIView *addressTableView;
@property (weak, nonatomic) IBOutlet UIButton *addPointBtn;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (nonatomic, assign) NSInteger cellCounts;
@property (nonatomic, assign) BOOL hiddenAddBtn;
@property (nonatomic, strong) NSMutableArray<AddressCellView *> *cellsArray; //位置视图集合
@property (nonatomic, strong) NSMutableArray<AddressCellView *> *waypointCellArray; //途经点视图集合
@property (strong, nonatomic) AMapSearchAPI *search;  // 地图内的搜索API类
@property (nonatomic, strong) AddressCellView *foldCellView;    //折叠视图

@end

@implementation PublishTravelTopView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame viewType:(ViewType)viewType{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PublishTravelTopView" owner:self options:nil] lastObject];
        self.frame = frame;
        _viewType = viewType;
        _cellsArray = [NSMutableArray array];
        [self setUpView];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:StartLocationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:LocationUpdateSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:LocationUpdateFailureNotification object:nil];
    }
    return self;
}

#pragma mark == lazyLoad
- (AddressCellView *)foldCellView{
    if (!_foldCellView) {
        AddressCellView *foldView = [[AddressCellView alloc] initWithFrame:CGRectZero];
        foldView.isFold = YES;
        [foldView contentForCellWithIndex:1 totals:_cellCounts];
        [self.addressTableView addSubview:foldView];
        
        __WeakSelf__ weakSelf = self;
        [foldView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.addressTableView.width);
            make.height.equalTo(CellHeight);
            make.top.equalTo(weakSelf.addressTableView.top).offset(CellHeight);
            make.centerX.equalTo(weakSelf.addressTableView.centerX);
        }];
    }
    return _foldCellView;
}

#pragma mark --配置子视图
- (void)setUpView{
    if (_viewType == kPassengerPage) {
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(0, 1);
    }
    _cellCounts = 2;
    if (_viewType == kDriverPage) {
        [_navBackBtn setBackgroundImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
        [_navBackBtn setBackgroundImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateHighlighted];
    }
    else{
        [_navBackBtn setBackgroundImage:[UIImage imageNamed:@"btn_nav_close"] forState:UIControlStateNormal];
        [_navBackBtn setBackgroundImage:[UIImage imageNamed:@"btn_nav_close"] forState:UIControlStateHighlighted];
    }
    
    [self layoutForSubviews];
}

- (void)layoutForSubviews{
    __WeakSelf__ weakSelf = self;
    
    [_navBackBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(5);
        make.top.equalTo(KStatusBarHeight);
        make.height.width.equalTo(44);
    }];
    
    [_exchangeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.centerY.equalTo(weakSelf.centerY).offset(KStatusBarHeight/2);
        make.width.height.equalTo(20);
    }];
    
    [_addPointBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.exchangeBtn.left).offset(-15);
        make.width.height.equalTo(self.exchangeBtn);
        make.centerY.equalTo(self.exchangeBtn.centerY);
    }];
    
    self.hiddenAddBtn = _viewType==kPassengerPage?YES:NO;
    [self setViewForAddressView];

}

- (void)setViewForAddressView{
    __WeakSelf__ weakSelf = self;
    for (NSInteger i=0; i<2; i++) {
        AddressCellView *cellView = [[AddressCellView alloc] initWithFrame:CGRectZero];
        cellView.delegate = self;
        [_addressTableView addSubview:cellView];
        [cellView contentForCellWithIndex:i totals:2];
        [_cellsArray addObject:cellView];
        if (i==0) {
            cellView.isLocation = YES;
        }
        [cellView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.addressTableView.width);
            make.height.equalTo(CellHeight);
            make.top.equalTo(weakSelf.addressTableView.top).offset(i*CellHeight);
            make.centerX.equalTo(weakSelf.addressTableView.centerX);
        }];
    }
}

- (void)changeFrameWithIndex:(NSInteger)index{
    [self setHiddenAddBtn:_cellCounts==5?YES:NO];
    
    __WeakSelf__ weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger i=index; i<weakSelf.cellsArray.count; i++) {
            AddressCellView *cellView = weakSelf.cellsArray[i];
            [cellView setFrame:CGRectMake(cellView.cur_x, i*CellHeight, cellView.cur_w, cellView.cur_h)];
        }
        [self setFrame:CGRectMake(self.cur_x, self.cur_y, self.cur_w, weakSelf.cellCounts*CellHeight+KStatusBarHeight)];
    } completion:^(BOOL finished) {
        for (NSInteger i=index; i<weakSelf.cellsArray.count; i++) {
            AddressCellView *cellView = weakSelf.cellsArray[i];
            [cellView contentForCellWithIndex:i totals:weakSelf.cellsArray.count];
            [cellView updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.addressTableView.top).offset(i*CellHeight);
            }];
        }
    }];
}

#pragma mark --是否隐藏添加途经点按钮
- (void)setHiddenAddBtn:(BOOL)hiddenAddBtn{
    _addPointBtn.hidden = hiddenAddBtn;
    __WeakSelf__ weakSelf = self;
    [_addressTableView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.navBackBtn.right).offset(15);
        make.right.equalTo(hiddenAddBtn?weakSelf.exchangeBtn.left:weakSelf.addPointBtn.left).offset(-15);
        make.height.equalTo(CellHeight*weakSelf.cellCounts);
        make.top.equalTo(KStatusBarHeight);
    }];
}

#pragma mark == 折叠视图
- (void)foldAddressView{
    if (_cellsArray.count == 2) {
        return;
    }
    _cellCounts = 3;
    _waypointCellArray =[NSMutableArray arrayWithArray:[_cellsArray subarrayWithRange:NSMakeRange(1, _cellsArray.count-2)]];
    for (NSInteger i=1; i<_cellsArray.count-1; i++) {
        [_cellsArray[i] removeFromSuperview];
    }
    [_cellsArray removeObjectsInRange:NSMakeRange(1, _cellsArray.count-2)];
    [self changeFrameWithIndex:1];
    
    [self contentForFoldCellView];
    [self.addressTableView addSubview:self.foldCellView];
}

- (void)contentForFoldCellView{
    __WeakSelf__ weakSelf = self;
    NSMutableString *content = [NSMutableString stringWithFormat:@"经%ld地:", _waypointCellArray.count];
    [_waypointCellArray enumerateObjectsUsingBlock:^(AddressCellView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [content appendString:[(UITextField *)[obj viewWithTag:10] text]];
        if (idx != weakSelf.waypointCellArray.count-1) {
            [content appendString:@"、"];
        }
    }];
    [(UITextField *)[self.foldCellView viewWithTag:10] setText:content];
}

#pragma mark --按钮响应事件
- (IBAction)clickedNavbackBtn:(UIButton *)sender {
    if (_backToPrevious) {
        _backToPrevious();
    }
}

- (IBAction)clickedAddPointBtn:(UIButton *)sender {
    _cellCounts++;
    
    AddressCellView *pointCellView = [[AddressCellView alloc] initWithFrame:CGRectZero];
    [pointCellView contentForCellWithIndex:_cellCounts-2 totals:_cellCounts];
    [pointCellView setDelegate:self];
    [_addressTableView addSubview:pointCellView];
    [_cellsArray insertObject:pointCellView atIndex:_cellCounts-2];
    
    __WeakSelf__ weakSelf = self;
    [pointCellView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.addressTableView.width);
        make.height.equalTo(CellHeight);
        make.top.equalTo(weakSelf.addressTableView.top).offset((weakSelf.cellCounts-2)*CellHeight);
        make.centerX.equalTo(weakSelf.addressTableView.centerX);
    }];
    
    [self changeFrameWithIndex:_cellCounts-1];
}

- (IBAction)clickedExchangeBtn:(UIButton *)sender {
    _cellsArray =[NSMutableArray arrayWithArray:[[_cellsArray reverseObjectEnumerator] allObjects]];
    if (_waypointCellArray) {
        _waypointCellArray = [NSMutableArray arrayWithArray:[[_waypointCellArray reverseObjectEnumerator] allObjects]];
        [self contentForFoldCellView];
    }
    __WeakSelf__ weakSelf = self;
    [self changeFrameWithIndex:0];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.exchangeBtn.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    } completion:^(BOOL finished) {
        weakSelf.exchangeBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark --通知响应事件
- (void)locationNotiResponse:(NSNotification *)noti{
    NSString *content = nil;
    if ([noti.name isEqualToString:StartLocationNotification]) {
        content = @"正在获取当前位置";
    }
    else if ([noti.name isEqualToString:LocationUpdateSuccessNotification]){
        content = [noti.userInfo[@"ReGeocode"] valueForKeyPath:@"POIName"];
    }
    else{
        content = @"定位失败";
    }
    AddressCellView *startCell = [_addressTableView viewWithTag:50];
    AddressCellView *endCell = [_addressTableView viewWithTag:54];
    CLLocation *location = [AMapLocationTool sharedAMapLocation].location;
    if (startCell.isLocation) {
        startCell.content = content;
        if (location) {
            startCell.geoPoint = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        }
    }
    else{
        endCell.content = content;
        if (location) {
            endCell.geoPoint = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        }
    }
}

#pragma mark --AddressCellViewDelegate
- (void)deleteCellAtIndex:(NSInteger)index{
    _cellCounts--;
    UIView *deleteView = _cellsArray[index];
    [_cellsArray removeObjectAtIndex:index];
    [deleteView removeFromSuperview];
    deleteView = nil;
    [self changeFrameWithIndex:index];
}

- (void)searchValueChangedInAddressCell:(AddressCellView *)addressCell{
    if (_delegate && [_delegate respondsToSelector:@selector(searchValueChangedInAddressCell:)]) {
        [_delegate searchValueChangedInAddressCell:addressCell];
    }
}

- (void)editTextFieldInAddressCell:(AddressCellView *)addressCell{
    if (_delegate && [_delegate respondsToSelector:@selector(editTextFieldInAddressCell:)]) {
        [_delegate editTextFieldInAddressCell:addressCell];
    }
}

- (void)clickedTextFieldReturnBtnInAddressCell:(AddressCellView *)addressCell{
    for (AddressCellView *cellView in _cellsArray) {
        UITextField *field = [cellView viewWithTag:10];
        if (field.text.length == 0) {
            [field becomeFirstResponder];
            return;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickedTextFieldReturnBtnInAddressCell:cellArray:)]) {
        [_delegate clickedTextFieldReturnBtnInAddressCell:addressCell cellArray:_cellsArray];
    }
}

- (void)tapFoldAddressView{
    [_cellsArray insertObjects:_waypointCellArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, _waypointCellArray.count)]];
    _cellCounts = _cellsArray.count;
    [self.foldCellView removeFromSuperview];
    for (AddressCellView *view in _waypointCellArray) {
        [self.addressTableView addSubview:view];
    }
    [self changeFrameWithIndex:1];
    _waypointCellArray = nil;
}

@end








