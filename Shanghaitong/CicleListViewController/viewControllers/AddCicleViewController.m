//
//  AddCicleViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "AddCicleViewController.h"
#import "SHTTextView.h"
#import "SHTTextField.h"
@interface AddCicleViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,SHTTextViewDelegate,SHTTextFieldDelegate>
{
    SHTTextField *nameFeild;
    SHTTextView *reasonFeild;
}
@property (nonatomic,strong) UITableView *createCircleTable;
@property (nonatomic,strong)  UILabel *placeHoderLabel;
@property (nonatomic,strong) ABTabBar *tabBar;
@property (nonatomic,strong) UIButton *guideTabBarBtn;
@property (nonatomic,strong)  UIButton * btn;
@property (nonatomic) CGFloat offSet;
@property (nonatomic) CGPoint centerPoint;
@end

@implementation AddCicleViewController
#pragma mark - lifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillAppear:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
     [MobClick beginEvent:@"createCirclePage"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"createCirclePage"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:NO];
    self.navigationController.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.navigationView.titleLabel.text = @"创建圈子";
    self.navigationView.titleLabel.font = [UIFont fontWithName:@"heiti" size:22.0f];
    self.navigationView.titleLabel.font = [UIFont systemFontOfSize:22];
    self.createCircleTable = [[UITableView alloc]initWithFrame:CGRectMake(0, ORIGIN_Y, kScreenWidth, self.contentFrame.size.height) style:UITableViewStylePlain];
    self.createCircleTable.delegate  = self;
    self.createCircleTable.dataSource = self;
    self.createCircleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.centerPoint = self.createCircleTable.center;
    [self.view addSubview:self.createCircleTable];
    //加个补丁
    UIView *pactchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    pactchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pactchView];
    [self.view bringSubviewToFront:self.navigationView];
    self.offSet = 150;
    SharedApp.stayNotFirstPage = YES;

    self.guidButton.hidden = NO;
    [self.view bringSubviewToFront:self.guidButton];
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    [self.view bringSubviewToFront:self.view];
}
- (void)popCurrentViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark ----
- (void)keyboardWillAppear:(NSNotification *)noti{
    if ([reasonFeild isFirstResponder]) {
        NSDictionary *userInfo = [noti userInfo];
        reasonFeild.finishBtn.titleLabel.textColor = [UIColor blackColor];
        //设置table滚动距离
        CGFloat duration  = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        CGPoint center = CGPointMake(160, self.view.center.y - 45);
        [UIView animateWithDuration:duration
                              delay:0
                            options:curve << 16
                         animations:^{
                             self.createCircleTable.center = center;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)keyboardWillHidden:(NSNotification *)noti{
    NSDictionary *userInfo = [noti userInfo];
    //设置table滚动距离
    CGFloat duration  = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve << 16
                     animations:^{
                         self.createCircleTable.center = self.centerPoint;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)guidBttonAction
{
    [super guidBttonAction];
    [self.view bringSubviewToFront:self.tabBar];
    self.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        return 45;
    }
    if (indexPath.row == 2) {
        return 100;
    }
    else{
        return 150;
    }
}
#define TITLE_COLOR @"#555555"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifer = @"creatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        if (indexPath.row == 0) {
            UILabel *circleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 25)];
            circleNameLabel.text = @"圈子名称:";
            circleNameLabel.textColor = [AppTools colorWithHexString:@"#999999"];
            circleNameLabel.font = [UIFont systemFontOfSize:18.0];
            [cell.contentView addSubview:circleNameLabel];
            nameFeild = [[SHTTextField alloc]initWithFrame:CGRectMake(100, 8, 200, 25)];
            nameFeild.font = [UIFont systemFontOfSize:18.0f];
            nameFeild.kmaxLength = 11;
            nameFeild.dele = self;
            nameFeild.delegate = self;
            nameFeild.returnKeyType = UIReturnKeyNext;
            nameFeild.placeHoderLabel.text = @"[圈子名称,限定11个字]";
            [cell.contentView addSubview:nameFeild];
            
            UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(10, 43, 300, .8f)];
            sepratorLine.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:sepratorLine];
            sepratorLine.alpha =.2f;
            
        }
        if (indexPath.row == 1) {
            UILabel *reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 80, 30)];
            reasonLabel.font = [UIFont systemFontOfSize:18.0];
            reasonLabel.text = @"申请理由:";
            reasonLabel.textColor = [AppTools colorWithHexString:@"#999999"];
            [cell.contentView addSubview:reasonLabel];
            
            reasonFeild = [[SHTTextView alloc]initWithFrame:CGRectMake(100, 2, 200, 130)];
            reasonFeild.font = [UIFont systemFontOfSize:18.0f];
            reasonFeild.returnKeyType = UIReturnKeyDone;
            reasonFeild.kmaxLength = UINT16_MAX;
            reasonFeild.placeHoderLabel.text = @"[请填写申请理由]";
            reasonFeild.delegate = self;
            reasonFeild.dele = self;
            [cell.contentView addSubview:reasonFeild];
        }
        if (indexPath.row == 2) {
            UIButton *applayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            applayButton.frame = CGRectMake(10, 0, 300, 40);
            applayButton.layer.cornerRadius = 2.0f;
            applayButton.backgroundColor = [AppTools colorWithHexString:@"#FF8694"];
            [applayButton addTarget:self action:@selector(applayToCreatCircle) forControlEvents:UIControlEventTouchUpInside];
            [applayButton setTitle:@"申 请" forState:UIControlStateNormal];
            [cell.contentView addSubview:applayButton];
            
            UILabel *declearLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, kScreenWidth - 10,30)];
            declearLabel.textAlignment = NSTextAlignmentLeft;
            declearLabel.font = [UIFont systemFontOfSize:14];
            declearLabel.textColor = [UIColor grayColor];
            declearLabel.text = @"需要通过商海通编审";
            [cell.contentView addSubview:declearLabel];
        }
    }
    return cell;
}
- (void)hiddenKeyboard{
    [reasonFeild resignFirstResponder];
}
#pragma mark - Return
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == nameFeild) {
        [reasonFeild becomeFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    nameFeild.placeHoderLabel.hidden = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] || textField.text == nil) {
        nameFeild.placeHoderLabel.hidden = NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == nameFeild) {
        if (range.length != 1) {
            if (range.location >= 11) {
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (reasonFeild.text == nil || [reasonFeild.text isEqualToString:@""]) {
        reasonFeild.placeHoderLabel.hidden = NO;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    reasonFeild.placeHoderLabel.hidden = YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"\n"]) {
        textView.text = @"";
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
#pragma mark - uitableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [nameFeild resignFirstResponder];
    [reasonFeild resignFirstResponder];
}
#pragma  mark -ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.createCircleTable) {
        [nameFeild resignFirstResponder];
        [reasonFeild resignFirstResponder];
    }
}
#pragma mark - applay
- (void)applayToCreatCircle
{
    if (nameFeild.text == nil || [nameFeild.text isEqualToString:@""]) {
        [self showNetworkErrorMessage:@"申请名称不能为空"];
        [self.view bringSubviewToFront:self.p];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hiddenMessage) userInfo:nil repeats:NO];
        return;
    }
    if (reasonFeild.text == nil || [reasonFeild.text isEqualToString:@""]) {
        [self showNetworkErrorMessage:@"圈子理由不能为空"];
        [self.view bringSubviewToFront:self.p];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hiddenMessage) userInfo:nil repeats:NO];
        return;
    }
    [self showNetworkAnimation];
    [NETWORK requestCreateCircleWithCircleName:nameFeild.text circleDetail:reasonFeild.text requestResult:^(NSString *response) {
        if ([response isEqualToString:@"-1"]) {
            [self hiddenNetworkAnimation];
            [self showNetworkErrorMessage:@"网络无法连接"];
            [self.view bringSubviewToFront:self.p];
            return ;
        }
        //加载动画
        [self hiddenNetworkAnimation];
        if ([[[[response objectFromJSONString] objectForKey:SHTError_Code] stringValue] isEqualToString:@"0"]) {
            [self showNetworkErrorMessage:@"申请成功"];
            [self.view bringSubviewToFront:self.p];
            [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hiddenAlertView) userInfo:nil repeats:NO];
        }
        else{
            UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[[response objectFromJSONString] objectForKey:SHTError_desc] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alv show];
        }
    }];
    [nameFeild resignFirstResponder];
    [reasonFeild resignFirstResponder];
    
}
- (void)hiddenMessage{
    [self showErrorMessage:@"提交成功"];
    [self.view bringSubviewToFront:self.p];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)hiddenAlertView{
    [self hiddenNetworkAnimation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - back
- (void)leftButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    SharedApp.stayNotFirstPage = YES;
}
#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
