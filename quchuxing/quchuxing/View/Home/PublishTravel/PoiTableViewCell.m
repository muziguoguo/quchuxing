//
//  PoiTableViewCell.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/21.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "PoiTableViewCell.h"

@interface PoiTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *poiLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation PoiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PoiTableViewCell" owner:self options:nil] lastObject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setPoiData:(AMapPOI *)poiData{
    if (poiData) {
        _poiData = poiData;
        _poiLabel.text = poiData.name;
        NSString *text = nil;
        if (poiData.distance<1000) {
            text = [NSString stringWithFormat:@"%ld米   %@", poiData.distance, poiData.address];
        }
        else{
            text = [NSString stringWithFormat:@"%.1f公里   %@", poiData.distance/1000.0, poiData.address];
        }
        _descriptionLabel.text = text;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
