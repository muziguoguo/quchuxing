//
//  MySearchResultView.m
//  iOS-trip-search
//
//  Created by hanxiaoming on 2017/5/24.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "MySearchResultView.h"
#import "MyLocationHeaderCell.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MyCity.h"
#import "MyLocation.h"
#import "AMapLocationTool.h"
#import "MyRecordManager.h"

@interface MySearchResultView ()<UITableViewDelegate, UITableViewDataSource, MyLocationHeaderCellDelegate, AMapSearchDelegate>
{
    NSString *_city;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MyLocation *home;
@property (nonatomic, strong) MyLocation *company;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapInputTipsSearchRequest *currentTipRequest;
@property (nonatomic, strong) UIView *listContainerView;

@end

static NSString *kCellIdentifier = @"cellIdentifier";
static NSString *kLocationCellIdentifier = @"locationCellIdentifier";

@implementation MySearchResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _city = nil;
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:StartLocationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:LocationUpdateSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:LocationUpdateFailureNotification object:nil];
        _showsAddressSettingCell = YES;
        [self initSearch];
        [self initTableView];
    }
    return self;
}

- (void)initSearch
{
    //search
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyLocationHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kLocationCellIdentifier];
    
    [self addSubview:self.tableView];
    
}

#pragma mark - Interfaces

- (void)setShowsAddressSettingCell:(BOOL)showsAddressSettingCell
{
    _showsAddressSettingCell = showsAddressSettingCell;
    
    [self.tableView reloadData];
}

#pragma mark --配置数据，刷新视图
- (void)setPoiArray:(NSArray<MyLocation *> *)poiArray
{
    _poiArray = poiArray;
    
    [self.tableView reloadData];
}

- (void)setHistoryArray:(NSArray<MyLocation *> *)historyArray
{
    _historyArray = historyArray;
    
    [self.tableView reloadData];
}

#pragma mark --更新地址配置
- (void)updateAddressSetting
{
    _home = [MyRecordManager sharedInstance].home;
    _company = [MyRecordManager sharedInstance].company;
    
    [self.tableView reloadData];
}

#pragma mark --查找
- (void)searchTipsByKeyword:(NSString *)keyword{
    if (keyword.length == 0) {
        return;
    }
    AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
    request.city = _city;
    request.cityLimit = NO;
    request.keywords = keyword;
    
    [self.search AMapInputTipsSearch:request];
    
    self.currentTipRequest = request;
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_showsAddressSettingCell && indexPath.section == 0) {
        return 0;
    }
    
    return 60;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (section == 0) {
        result = 1;
    }
    else if (section == 1) {
        result = self.historyArray.count;
    }
    else if (section == 2) {
        result = self.poiArray.count;
    }
    
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currentIdentifier = kCellIdentifier;
    
    if (_showsAddressSettingCell && indexPath.section == 0) {
        currentIdentifier = kLocationCellIdentifier;
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currentIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:currentIdentifier];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (_showsAddressSettingCell && indexPath.section == 0)
    {
        MyLocationHeaderCell *locationCell = (MyLocationHeaderCell *)cell;
        locationCell.delegate = self;
        locationCell.homeLabel.text = self.home.name ?: @"设置家的地址";
        locationCell.companyLabel.text = self.company.name ?: @"设置公司地址";
    }
    else
    {
        cell.imageView.image = nil;
        MyLocation *poi = nil;
        
        if (indexPath.section == 1) {
            poi = self.historyArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"icon_time"];
        }
        else if (indexPath.section == 2) {
            poi = self.poiArray[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"icon_time"];
        }
        
        cell.textLabel.text = poi.name;
        cell.detailTextLabel.text = poi.address;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_showsAddressSettingCell && indexPath.section == 0)
    {
        
    }
    else
    {
        MyLocation *poi = nil;
        if (indexPath.section == 1) {
            poi = self.historyArray[indexPath.row];
        }
        else if (indexPath.section == 2) {
            poi = self.poiArray[indexPath.row];
        }

        if ([self.delegate respondsToSelector:@selector(resultListView:didPOISelected:)])
        {
            [self.delegate resultListView:self didPOISelected:poi];
        }
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(didResultListViewScroll:)]) {
        [self.delegate didResultListViewScroll:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(didResultListViewEndScroll:)]) {
        [self.delegate didResultListViewEndScroll:self];
    }
}

#pragma mark --通知响应事件
- (void)locationNotiResponse:(NSNotification *)noti{
    if ([noti.name isEqualToString:LocationUpdateSuccessNotification]){
        _city = [noti.userInfo[@"ReGeocode"] valueForKeyPath:@"city"];
    }
    else{
        _city = nil;
    }
}

#pragma mark - MyLocationHeaderCellDelegate

- (void)didLocationCellHomeButtonTapped:(MyLocationHeaderCell *)listView
{
    if ([self.delegate respondsToSelector:@selector(resultListView:didHomeSelected:)]) {
        [self.delegate resultListView:self didHomeSelected:self.home];
    }
}

- (void)didLocationCellCompanyButtonTapped:(MyLocationHeaderCell *)listView
{
    if ([self.delegate respondsToSelector:@selector(resultListView:didCompanySelected:)]) {
        [self.delegate resultListView:self didCompanySelected:self.company];
    }
}

#pragma mark --AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"search error :%@", error);
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (self.currentTipRequest == request) {
        NSMutableArray *locations = [NSMutableArray array];
        for (AMapTip *tip in response.tips) {
            MyLocation *loc = [MyLocation locationWithTip:tip city:request.city];
            if (loc) {
                [locations addObject:loc];
            }
        }
        
        self.poiArray = locations;
    }
}


@end
