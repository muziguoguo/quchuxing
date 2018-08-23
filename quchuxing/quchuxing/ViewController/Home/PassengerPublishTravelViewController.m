//
//  PassengerPublishTravelViewController.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/13.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "PassengerPublishTravelViewController.h"
#import "PublishTravelTopView.h"
#import "AMapLocationTool.h"
#import "MySearchResultView.h"
#import "MyLocation.h"
#import "MyRecordManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "AddressCellView.h"
#import "ArrountPoiView.h"

@interface PassengerPublishTravelViewController ()<UINavigationControllerDelegate, MySearchResultViewDelegate, PublishTravelTopViewDelegate, AMapSearchDelegate,  MAMapViewDelegate, AMapNaviDriveManagerDelegate, ArrountPoiViewDelegate>
{
    UITextField *_lastCurrentField;
    UITextField *_currentField;
    ViewType _type;
    MBProgressHUD *_hud;
    NSArray *_addressCellArray;
}

@property (nonatomic, strong) MySearchResultView *resultView;
@property (nonatomic, strong) PublishTravelTopView *topView;
@property (strong, nonatomic) MAMapView *mapView;  //地图
@property (strong, nonatomic) AMapSearchAPI *search;  // 地图内的搜索API类
@property (strong, nonatomic) AMapRoute *route;  //路径规划信息
@property (nonatomic, strong) NSMutableDictionary<NSString *, AMapGeoPoint *> *locationDic;
@property (nonatomic, strong) AddressCellView *handleCell;
@property (nonatomic, strong) ArrountPoiView *poiView;

@end

@implementation PassengerPublishTravelViewController

- (void)dealloc{
    [[AMapNaviDriveManager sharedInstance] stopNavi];
    [[AMapNaviDriveManager sharedInstance] setDelegate:nil];
    // [[AMapNaviDriveManager sharedInstance] removeDataRepresentative:self.driveView];
}

- (instancetype)initWithType:(ViewType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.delegate =self;
    self.tabBarController.tabBar.hidden = YES;
    [self initSearch];
    [self initDriveManager];
    [self setUpView];
}

- (void)initSearch{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}

- (void)initDriveManager
{
    //请在 dealloc 函数中执行 [AMapNaviDriveManager destroyInstance] 来销毁单例
    [[AMapNaviDriveManager sharedInstance] setDelegate:self];
}

#pragma mark == 配置子视图
- (void)setUpView{
    _lastCurrentField = nil;
    
    _topView = [[PublishTravelTopView alloc] initWithFrame:CGRectMake(0, 0, self.view.cur_w, 100+KStatusBarHeight) viewType:_type];
    _topView.delegate = self;
    __WeakSelf__ weakSelf = self;
    [_topView setBackToPrevious:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:_topView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self location];
}

- (void)location{
    if (!_isLoctaionSuccess) {
        __WeakSelf__ weakSelf = self;
        [[AMapLocationTool sharedAMapLocation] startLocationWithSuccess:^(NSDictionary *infoDic) {
            weakSelf.isLoctaionSuccess = YES;
        } failure:^(NSError *error) {
            //未开启定位服务，提示用户开启
            if (error.code == 2) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开定位开关" message:@"定位服务未开启,请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许趣出行使用定位服务" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
                UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                [alert addAction:setAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark == lazyLoad
- (NSMutableDictionary<NSString *,AMapGeoPoint *> *)locationDic{
    if (!_locationDic) {
        _locationDic = [NSMutableDictionary dictionary];
    }
    return _locationDic;
}

- (MySearchResultView *)resultView{
    if (!_resultView) {
        _resultView = [[MySearchResultView alloc] initWithFrame:CGRectZero];
        [_resultView setDelegate:self];
        [_resultView updateAddressSetting];
        [self.view addSubview:_resultView];
        
        __WeakSelf__ weakSelf = self;
        [_resultView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.view.width);
            make.centerX.equalTo(weakSelf.view.centerX);
            make.top.equalTo(weakSelf.topView.bottom).offset(5);
            make.bottom.equalTo(weakSelf.view.bottom).offset(kTabBarHeight);
        }];
    }
    return _resultView;
}

- (ArrountPoiView *)poiView{
    if (!_poiView) {
        _poiView = [[ArrountPoiView alloc] initWithFrame:CGRectMake(0, self.view.cur_h, self.view.cur_w, self.view.cur_h)];
        [_poiView setHidden:YES];
        [_poiView setDelegate:self];
        [self.view addSubview:_poiView];

        __WeakSelf__ weakSelf = self;
        [_poiView makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(weakSelf.view);
            make.centerX.equalTo(weakSelf.view);          make.top.equalTo(weakSelf.view.top).offset(weakSelf.view.cur_h);
        }];
    }
    return _poiView;
}

#pragma mark == 地理编码
- (void)geocodeRequsestWithAddressCell:(AddressCellView *)addressCell{
    _handleCell = addressCell;
    UITextField *field = [addressCell viewWithTag:10];
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc] init];
    request.city = [[AMapLocationTool sharedAMapLocation] city];
    request.address = field.text;
    [self.search AMapGeocodeSearch:request];
}

#pragma mark == 搜索周边
- (void)searchPoiArroundRequestWithPage:(NSInteger)page{
    self.poiView.page = page;
    AMapPOIAroundSearchRequest *arrountRequest = [[AMapPOIAroundSearchRequest alloc] init];
    AMapLocationTool *tool = [AMapLocationTool sharedAMapLocation];
    arrountRequest.location = [AMapGeoPoint locationWithLatitude:tool.location.coordinate.latitude longitude:tool.location.coordinate.longitude];
    arrountRequest.keywords = [(UITextField *)[_handleCell viewWithTag:10] text];
    /* 综合排序. */
    arrountRequest.sortrule = 1;
    arrountRequest.page = page;
    arrountRequest.offset = 10;
    arrountRequest.requireExtension = YES;
    arrountRequest.radius = 50000;
    [self.search AMapPOIAroundSearch:arrountRequest];
}

#pragma mark == 规划路径
- (void)routeRequestWithCellArray:(NSArray<AddressCellView *> *)cellArray{
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.strategy = 5; //驾车导航策略,5-多策略（同时使用速度优先、费用优先、距离优先三个策略）
    
    /* 出发点. */
    navi.origin = [cellArray firstObject].geoPoint;
    
    NSMutableArray *waypoints = [NSMutableArray array];
    for (NSInteger i = 1; i<cellArray.count-1; i++) {
        [waypoints addObject:cellArray[i].geoPoint];
    }
    navi.waypoints = waypoints;
    /* 目的地. */
    navi.destination = [cellArray lastObject].geoPoint;
    
    [self.search AMapDrivingRouteSearch:navi];
}

#pragma mark == PublishTravelTopViewDelegate
- (void)searchValueChangedInAddressCell:(AddressCellView *)addressCell{
    addressCell.geoPoint = nil;
    [self.locationDic setValue:addressCell.geoPoint forKey:[NSString stringWithFormat:@"%ld", addressCell.tag-50]];
    
    [self.resultView searchTipsByKeyword:[(UITextField *)[addressCell viewWithTag:10] text]];
    //搜索的时候不显示历史记录
    self.resultView.poiArray = nil;
    if ([(UITextField *)[addressCell viewWithTag:10] text].length != 0) {
        self.resultView.historyArray = nil;
    }
}

- (void)editTextFieldInAddressCell:(AddressCellView *)addressCell{
    _currentField = [addressCell viewWithTag:10];
    if (_lastCurrentField != _currentField) {
        self.resultView.historyArray = [[MyRecordManager sharedInstance] historyArray];
        
        self.resultView.poiArray = nil;
    }
    _lastCurrentField = _currentField;
}

- (void)clickedTextFieldReturnBtnInAddressCell:(AddressCellView *)addressCell cellArray:(NSArray<AddressCellView *> *)cellArray{
    _addressCellArray = cellArray;
    [_currentField resignFirstResponder];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (AddressCellView *cellView in cellArray) {
        if (!cellView.geoPoint) {
            [self geocodeRequsestWithAddressCell:cellView];
            return;
        }
    }
    
    [self.topView foldAddressView];
    [self routeRequestWithCellArray:cellArray];
}

#pragma mark == MySearchResultViewDelegate
- (void)resultListView:(MySearchResultView *)listView didPOISelected:(MyLocation *) poi{
    _currentField.text = poi.name;
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:poi.coordinate.latitude longitude:poi.coordinate.longitude];
    AddressCellView *cellView = (AddressCellView *)[_currentField superview];
    cellView.geoPoint = point;
    [self.locationDic setValue:cellView.geoPoint forKey:[NSString stringWithFormat:@"%ld", cellView.tag-50]];
    [[MyRecordManager sharedInstance] addHistoryRecord:poi];
}

- (void)didResultListViewScroll:(MySearchResultView *)listView{
    [_currentField resignFirstResponder];
}

- (void)didResultListViewEndScroll:(MySearchResultView *)listView{
    [_currentField becomeFirstResponder];
}

#pragma mark == ArrountPoiViewDelegate
- (void)selectedCellWithPoiData:(AMapPOI *)poiData{
    [(UITextField *)[_handleCell viewWithTag:10] setText:poiData.name];
    _handleCell.geoPoint = poiData.location;
    [self clickedTextFieldReturnBtnInAddressCell:nil cellArray:_addressCellArray];
}

- (void)headerRefreshWithPage:(NSInteger)page{
    [self searchPoiArroundRequestWithPage:page];
}

- (void)footerRefreshWithPage:(NSInteger)page{
    [self searchPoiArroundRequestWithPage:page];
}

#pragma mark - AMapSearchDelegate
//当路径规划搜索请求发生错误时，会调用代理的此方法
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSString *text = @"网络错误";
    if ([request isKindOfClass:[AMapRouteSearchBaseRequest class]]) {
        text = @"路径规划失败";
    }
    [_hud.label setText:text];
    [_hud hideAnimated:YES afterDelay:0.7];
    DLog(@"Error: %@", error)
}

//地理编码完成回调
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    DLog(@"地理编码完成回调")
    [_hud hideAnimated:YES];
    for (AMapGeocode *geocode in response.geocodes) {
        DLog(@"%f,   %f", geocode.location.latitude, geocode.location.longitude)
    }
    for (AMapGeocode *geocode in response.geocodes) {
        _handleCell.geoPoint = geocode.location;
        return;
    }
    //地理编码失败，则发起周边搜索
    [self searchPoiArroundRequestWithPage:1];
}

//周边搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.poiView setIsRefreshFooter:NO];
    [self.poiView setIsRefreshHeader:NO];
    DLog(@"周边搜索回调")
    if (response.pois.count == 0)
    {
        return;
    }
    
    if (request.page > 1) {
        [self.poiView setPoiArray:response.pois];
        return;
    }
    
    [self.poiView setPoiArray:response.pois];
    NSString *title = nil;
    if (_handleCell.tag == 50) {
        title = @"确认起点";
    }
    else if (_handleCell.tag == 54){
        title = @"确认终点";
    }
    else{
        title = @"确认途经点";
    }
    [self.poiView setTitle:title];
    
    [self.poiView setHidden:NO];
    [_hud hideAnimated:YES];
    __WeakSelf__ weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.poiView.frame = CGRectMake(0, 0, weakSelf.view.cur_w, weakSelf.view.cur_h);
    } completion:^(BOOL finished) {
        [weakSelf.poiView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.top).offset(0);
        }];
    }];
    
}

//路径规划搜索完成回调.
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    [_hud hideAnimated:YES];
    DLog(@"路径规划完成")
}

#pragma mark == UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isMemberOfClass:[PassengerPublishTravelViewController class]] ) {
        self.customNavBar.hidden = YES;
    }
    else{
        if ([viewController isKindOfClass:[BaseViewController class]]) {
            if (![(BaseViewController *)viewController customNavBar].hidden) {
                [(BaseViewController *)viewController customNavBar].hidden = NO;
            }
        }
    }
}


@end
