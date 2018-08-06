//
//  LocationTableViewCell.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "LocationTableViewCell.h"

@interface LocationTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *getForceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation LocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView setBackgroundColor:kAppMainLightGrayColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [_getForceLabel drawCornerWithRadius:8 connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:UICOLOR_FROM_RGB(255, 152, 0, 1)];
    [_locationView setBackgroundColor:[UIColor whiteColor]];
    [_locationView.layer setCornerRadius:10];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setLocationText:(NSString *)locationText{
    if (locationText) {
        _locationLabel.text = locationText;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
