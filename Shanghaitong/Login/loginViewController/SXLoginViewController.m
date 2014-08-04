//
//  SXLoginViewController.m
//  shangxin
//
//  Created by jianping on 14-1-23.
//  Copyright (c) 2014年 ZHIsland. All rights reserved.
//

#import "SXLoginViewController.h"
#import "ZHOpenPlatformClient.h"//开放平台客户端
#import "ZHAppProfile.h"//应用程序概要文件
#import "ZHLoginRes.h"//登录
#import "AppDelegate.h"
#import "CircleDatabase.h"
#import "NetworkCenter.h"
#import "UserInformation.h"
#import "HeartBeat.h"
#import "ShowProtocolViewController.h"
#import <CommonCrypto/CommonCrypto.h>
NSString    *labelbackgroundColor = @"#88A1B9";
NSString    *userKuangBackgroundColor = @"#56606F";
NSString    *passKuangBackgroundColor = @"#56606F";
NSString    *userTextFieldBackgroundColor = @"#cccfd2";
NSString    *passTextFieldBackgroundColor = @"#cccfd2";
@interface SXLoginViewController ()
@end

@implementation SXLoginViewController
- (id)init
{
    return [super initWithNibName:@"SXLoginViewController" bundle:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameField) {
        [self.pwdField becomeFirstResponder];
    }
   else if (textField == self.pwdField) {
    [self.nameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    //NSCharacterSet 许多字符或者数字或者符号的组合
    NSString *email = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *password = [self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (email.length == 0) {
        [self showAlert:@"请填写手机号" animated:YES withTag:1000];
        return NO;
    }
    if (password.length == 0) {
        [self showAlert:@"请填写密码" animated:YES withTag:1001];
        return NO;
    }
    //加正则检验手机号
    if (![self judgeUserName]) {
        [self showAlert:@"手机号不合法" animated:YES];
        return NO;
    }
    [self showProgress:@"正在登录" animated:YES];
    [self login:email pwd: password];
    }
    return YES;
}
#pragma mark - judgeUserName
- (BOOL)judgeUserName{
    //手机号正则验证
    NSString *userNameMatch = @"^[0-9]{11}$";
    NSPredicate *regexTextUserName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameMatch];
    if (![regexTextUserName evaluateWithObject:self.nameField.text]) {
       
        return NO;
    }
    else {
        return YES;
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameField.delegate = self;
    self.pwdField.delegate = self;
    if (iPhone5Srceen) {
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(61, 505, 202, 55);
        label.textColor = [AppTools colorWithHexString:labelbackgroundColor];
        label.font = [UIFont systemFontOfSize:18];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"中国商业资源对接俱乐部";
        [self.view addSubview:label];
       
    }else {
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(61, 425, 202, 55);
        label.textColor = [AppTools colorWithHexString:labelbackgroundColor];
        label.font = [UIFont systemFontOfSize:18];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"中国商业资源对接俱乐部";
        [self.view addSubview:label];
    }
 
    self.userKuang.backgroundColor=[AppTools colorWithHexString:userKuangBackgroundColor];
    self.passKuang.backgroundColor=[AppTools colorWithHexString:passKuangBackgroundColor];
    
    self.nameField.textColor =[ AppTools colorWithHexString:userTextFieldBackgroundColor];
    self.pwdField.textColor =[AppTools colorWithHexString:passTextFieldBackgroundColor];
    
    self.nameField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessAccount];
    self.nameField.superview.layer.borderColor = [UIColor colorWithRed:0xdb green:0xdb blue:0xdb alpha:0].CGColor;

    self.nameField.superview.layer.borderWidth = 0.5f;
    self.nameField.superview.layer.cornerRadius = 2.0f;
    self.nameField.superview.clipsToBounds = YES;
    
    self.pwdField.superview.layer.borderColor = [UIColor colorWithRed:0xdb green:0xdb blue:0xdb alpha:0].CGColor;
    self.pwdField.superview.layer.borderWidth = 0.5f;
    self.pwdField.superview.layer.cornerRadius = 2.0f;
    self.pwdField.superview.clipsToBounds = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAccessAccount]) {
        self.nameField.text = [[NSUserDefaults standardUserDefaults]
                               objectForKey:kAccessAccount];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (BOOL)shouldAutorotate
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return NO;
    }
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)login:(NSString *)name pwd:(NSString *)pwd
{
//    [[ZHOpenPlatformClient sharedInstance] login:name password:pwd withDelegate:self];
    
    [NETWORK loginWithUserName:name password:pwd requestResult:^(NSString *response) {
        if ([response isEqualToString:@"-1"]) {
            [self hideProgress:YES];
            [self showAlert:@"无网络连接" animated:YES];
            return ;
        }
        if ([response isEqualToString:@"-2"]) {
            [self hideProgress:YES];
            [self showAlert:@"请求超时" animated:YES];
            return ;
        }
        
        NSDictionary* res = (NSDictionary*)[response objectFromJSONString];
        if ([[res objectForKey:@"code"] intValue] != 0) {
            NSDictionary *alertDict = [res objectForKey:@"msg"];
            NSString *alertMsg = [alertDict objectForKey:@"data"];
            [self hideProgress:YES];
            [self showAlert:alertMsg animated:YES];
            return ;
        }
        UserInformation *userInformation = [UserInformation downloadDatadefaultManager];
        userInformation._userDataDict = res;
        [userInformation analysisLoginFinshData];
        [self hideProgress:YES];
//        [[NSUserDefaults standardUserDefaults] setObject: forKey:kAccessToken];
        [[NSUserDefaults standardUserDefaults] setObject:[self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kAccessAccount];
        [[NSUserDefaults standardUserDefaults] setObject:[self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kAccessPassword];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kAccessProtocal]) {
            SharedApp.window.rootViewController = [[ShowProtocolViewController alloc] init];
        }else{
            //注册成功，将deviceToken保存到应用服务器数据库中
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
            NSString *dToken = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
            NSString *requestURLString = [NSString stringWithFormat:@"%@%@", DOMAIN_URL, UPLOAD_DEVICETOKEN_URL];;
            NSString *target = [[self md5:[AppTools getDeviceUuid]] substringWithRange:NSMakeRange(8, 16)];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURLString]];
            [request setPostValue:token forKey:@"token"];
            [request setPostValue:@"2" forKey:@"client"];
            [request setPostValue:dToken forKey:@"deviceToken"];
            [request setPostValue:target forKey:@"target"];
            [request startAsynchronous];
            [SharedApp showWebController];
            [SharedApp.mainTabBarViewController.tabBar tabTouchUpInside:[SharedApp.mainTabBarViewController.tabBar.buttonArray objectAtIndex:ButtonIndexPro]];
        }
    }];
}
- (NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
//跳转到界面
- (void)onSuccess:(id) content fromRequest:(ZHHttpBaseTask *)task
{    
    [self hideProgress:YES];
    [[NSUserDefaults standardUserDefaults] setObject:[self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kAccessAccount];
    [[NSUserDefaults standardUserDefaults] setObject:[self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:kAccessPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SharedApp showWebController];
}

- (void)onFailed:(NSError*)error fromRequest:(ZHHttpBaseTask *)task
{
    [self hideProgress:YES];
    [self showNetError:error];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_nameField release];
    [_pwdField release];
    [super dealloc];
}

- (IBAction)login:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    //NSCharacterSet 许多字符或者数字或者符号的组合
    NSString *email = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.pwdField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (email.length == 0) {
        [self showAlert:@"请填写手机号" animated:YES withTag:1000];
        return;
    }
    if (password.length == 0) {
        [self showAlert:@"请填写密码" animated:YES withTag:1001];
        return;
    }
    if (![self judgeUserName]) {
        [self showAlert:@"手机号不合法" animated:YES];
        return ;
    }

    [self showProgress:@"正在登录" animated:YES];
    [DATABASE deleteCurrentUserInfo];
    
    [self login:email pwd: password];
}

- (IBAction)hideKeyboard:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.pwdField resignFirstResponder];
    
}
//将显示键盘
- (void)willShowKeyboard:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = self.nameField.superview.superview.frame;
    if ([[UIScreen mainScreen] bounds].size.height > 480) {
        frame.origin.y = -60;
    } else {
        frame.origin.y = -150;
    }
    [UIView animateWithDuration:duration animations:^{
        self.nameField.superview.superview.frame = frame;
    }];
}
//将隐藏键盘
- (void)willHideKeyboard:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame = self.nameField.superview.superview.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:duration animations:^{
        self.nameField.superview.superview.frame = frame;
    }];
}

@end
