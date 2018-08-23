//
//  IntroView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/26.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "IntroView.h"
#import "LastIntroView.h"

@interface IntroView()

@property (nonatomic, strong) UIScrollView *scorllView;


@end

@implementation IntroView

- (instancetype)initWithFrame:(CGRect)frame pages:(NSInteger)pages image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
        [self setSubViewWithPages:pages];
        [self subViewForScorllWithPages:pages image:image];
    }
    return self;
}

#pragma mark --配置子视图
- (void)setSubViewWithPages:(NSInteger)pages{
    _scorllView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scorllView.contentSize = CGSizeMake(self.cur_w*pages, self.cur_h);
    _scorllView.pagingEnabled = YES;
    _scorllView.bounces = NO;
    [self addSubview:_scorllView];
}

#pragma mark --配置scrollView子视图
- (void)subViewForScorllWithPages:(NSInteger)pages image:(UIImage *)image{
    
    for(NSInteger i=0; i<pages; i++){
        UIImageView *imageView = nil;
        if (i == pages-1) {
            imageView = [[[NSBundle mainBundle] loadNibNamed:@"LastIntroView" owner:self options:nil] lastObject];
            __WeakSelf__ weakself = self;
            [(LastIntroView *)imageView setClickedLogin:^{
                CATransition *animation = [CATransition animation];
                animation.type = @"fade";
                animation.duration = 1.0;
                [weakself removeFromSuperview];
            }];
        }
        else
            imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i*_scorllView.cur_w, 0, _scorllView.cur_w, _scorllView.cur_h);
        imageView.userInteractionEnabled = YES;
        imageView.layer.contents = (__bridge id)image.CGImage;
        imageView.layer.contentsRect = CGRectMake(i*(1.0/pages), 0, 1.0/pages, 1);
        [_scorllView addSubview:imageView];
    }
}

@end







