//
//  AddressTableViewCell.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/13.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "AddressCellView.h"
#import "AMapLocationTool.h"

@interface AddressCellView()<UITextFieldDelegate>
{
    NSString *_startPoint;  //起点
    NSString *_endPoint;    //终点
}

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@end

@implementation AddressCellView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AddressCellView" owner:self options:nil] lastObject];
        self.frame = frame;
        _addressField.delegate = self;
        _startPoint = @"正在获取当前位置";
        _endPoint = @"";
    }
    return self;
}

- (void)setContent:(NSString *)content{
    if (content) {
        _addressField.text = content;
    }
}

- (void)setIsLocation:(BOOL)isLocation{
    _isLocation = isLocation;
    if (isLocation) {
        _addressField.text = [AMapLocationTool sharedAMapLocation].locationText;
        CLLocation *location = [AMapLocationTool sharedAMapLocation].location;
        if (location) {
            self.geoPoint = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        }
    }
}

- (void)contentForCellWithIndex:(NSInteger)index totals:(NSInteger)totals{
    self.tag = index==totals-1?54:50+index;
    NSString *placeholder = nil;
    NSString *imageName = nil;
    if (index == 0) {
        placeholder = @"请输入起点";
        imageName = @"icon_start";
        _iconBtn.enabled = NO;
    }
    else if (index == totals-1){
        placeholder = @"您要去哪儿";
        imageName = @"icon_end";
        _iconBtn.enabled = NO;
    }
    else{
        _addressField.textColor = UICOLOR_FROM_RGB(97, 98, 102, 1);
        if (_isFold) {
            _iconBtn.enabled = NO;
            imageName = @"btn_dot";
            _addressField.enabled = NO;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFoldView)];
            [self addGestureRecognizer:tap];
        }
        else{
            placeholder = [NSString stringWithFormat:@"请输入途经点%ld", index];
            imageName = @"icon_delete";
            _iconBtn.enabled = YES;
        }
    }
    _addressField.placeholder = placeholder;
    UIImage *image = [UIImage imageNamed:imageName];
    [_iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_iconBtn setBackgroundImage:image forState:UIControlStateHighlighted];
}

#pragma mark --文本框内容改变事件
- (IBAction)AddressChangedValueResponse:(UITextField *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(searchValueChangedInAddressCell:)]) {
        [_delegate searchValueChangedInAddressCell:self];
    }
}

#pragma mark --按钮响应事件
- (IBAction)clickedDeleteBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteCellAtIndex:)]) {
        [_delegate deleteCellAtIndex:self.tag-50];
    }
}

#pragma mark == 单击手势响应事件
- (void)tapFoldView{
    if (_delegate && [_delegate respondsToSelector:@selector(tapFoldAddressView)]) {
        [_delegate tapFoldAddressView];
    }
}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(editTextFieldInAddressCell:)]) {
        [_delegate editTextFieldInAddressCell:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(clickedTextFieldReturnBtnInAddressCell:)]) {
        [_delegate clickedTextFieldReturnBtnInAddressCell:self];
    }
    return YES;
}

@end
