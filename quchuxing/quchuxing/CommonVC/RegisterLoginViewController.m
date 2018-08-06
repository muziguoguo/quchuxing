//
//  LoginViewController.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "RegisterLoginViewController.h"
#import "LoginView.h"

@interface RegisterLoginViewController ()

@end

@implementation RegisterLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    LoginView *loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] lastObject];
    [self.view addSubview:loginView];
    loginView.frame = CGRectMake(10, 120, self.view.cur_w-20, 320);
    loginView.loginType = kWithoutLogin;
    [loginView drawCornerWithRadius:8 connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:[UIColor whiteColor]];
    __WeakSelf__ weakSelf = self;
    [loginView setDismissVC:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
