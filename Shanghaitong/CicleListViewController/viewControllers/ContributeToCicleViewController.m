//
//  ContributeToCicleViewController.m
//  Shanghaitong
//
//  Created by anita on 14-4-22.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "ContributeToCicleViewController.h"
#import "CircleAbstractInfo.h"
#import "SHTTextField.h"
#import "SHTTextView.h"
#define PICKER_HEIGHT 216
@interface ContributeToCicleViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,SHTTextFieldDelegate,SHTTextViewDelegate>
@property (nonatomic,strong) UIAlertView *alerView;
@property (nonatomic,strong) UITableView *contributeTable;
@property (nonatomic,strong) SHTTextField *titleFeild;
@property (nonatomic,strong) SHTTextView *simpleView;
@property (nonatomic,strong) SHTTextView *detailView;
@property (nonatomic,strong) UIPickerView *circlePickerView;
@property (nonatomic,strong) NSMutableArray *circleTitleArray;
@property (nonatomic,strong) UIView * toolBarView;

@property (nonatomic,strong) UILabel *circleNameFeildLabel;
@property (nonatomic,strong) UILabel *placeHoderLabel;
@property (nonatomic,strong) UILabel *placeHoderLableSimple;
@property (nonatomic,strong) NSMutableArray *imagePickerArray;
@property (nonatomic,strong) NSMutableArray *imageIDArray;
@property (nonatomic) NSInteger imageIndex;
@property (nonatomic,strong) NSString *circleId;
@property (nonatomic,strong) NSString *circleAdminId;

@property (nonatomic) NSUInteger offset;
@property (nonatomic) BOOL canReload;
@property (nonatomic,strong) UIButton *imageBtn1;
@property (nonatomic,strong) UIButton *imageBtn2;
@property (nonatomic,strong) UIButton *imageBtn3;
@property (nonatomic,strong) UIButton *imageBtn4;

@property (nonatomic) SHTImageScanState state;
@property (nonatomic,strong)UIButton *guideTabBarBtn;
@property (nonatomic,strong) ABTabBar *tabBar;
@property (nonatomic) CGPoint tableCenter;
@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) UIButton * btn;
@property (nonatomic,strong) UIButton * simpleBtn;
@property (nonatomic,strong) UIButton * nameBtn;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;
@end

@implementation ContributeToCicleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
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
    [MobClick beginEvent:@"createThemePage"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"createThemePage"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.view.frame = CGRectMake(0, ORIGIN_Y, kScreenWidth, kScreenHeight - ORIGIN_Y);
    SharedApp.mainTabBarViewController.tabBar.hidden = YES;
    self.offset = 45;
    //展示图片方式
    self.state = SHTImageScanStateAll;
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:YES];
    self.navigationView.titleLabel.text = @"发布主题";
    self.navigationView.titleLabel.font = [UIFont fontWithName:@"heiti" size:22.0f];
    self.navigationView.titleLabel.font = [UIFont systemFontOfSize:22];
    self.circleTitleArray = [[NSMutableArray alloc]initWithObjects:nil, nil];
    self.imageIDArray = [[NSMutableArray alloc]initWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil];
    self.imagePickerArray = [[NSMutableArray alloc]initWithObjects:[NSNull null],[NSNull null],[NSNull null],[NSNull null], nil];
    
    self.contributeTable = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                        ORIGIN_Y, kScreenWidth,
                                                                        self.contentFrame.size.height + TabBarViewHeight)
                                                       style:UITableViewStylePlain];
    self.tableCenter = self.contributeTable.center;
    self.contributeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contributeTable.delegate = self;
    self.contributeTable.dataSource = self;
    [self.view addSubview:self.contributeTable];
    //加个补丁
    UIView *pactchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    pactchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pactchView];
    [self.view bringSubviewToFront:self.navigationView];
    [self.contributeTable reloadData];
    SharedApp.stayNotFirstPage = YES;
    self.guidButton.hidden = NO;
    [self.view bringSubviewToFront:self.guidButton];
    
    [NETWORK requestGetCircleListRequestResult:^(NSString *response) {
        if ([response isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            [self.view bringSubviewToFront:self.p];
        }
        else{
            NSDictionary *responseDict = [response objectFromJSONString];
            NSArray *dataArray = [responseDict objectForKey:@"data"];
            for (int i = 0; i < dataArray.count; i++) {
                CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
                info.circleID = [[[dataArray objectAtIndex:i] objectForKey:@"id"] stringValue];
                info.circleName = [[dataArray objectAtIndex:i] objectForKey:@"name"];
                info.circleAdminId = [[[dataArray objectAtIndex:i] objectForKey:@"admin_id"] stringValue];
                [self.circleTitleArray addObject:info];
            }
            self.toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, 320, 30)];
            self.toolBarView.backgroundColor = [AppTools colorWithHexString:@"#f9f9f9"];
            self.nameBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            self.nameBtn.frame = CGRectMake(260, 0, 60, 30);
            [self.nameBtn setTitle:@"完成" forState:UIControlStateNormal];
            [self.nameBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.nameBtn addTarget:self action:@selector(selectCircle) forControlEvents:UIControlEventTouchUpInside];
            [self.toolBarView addSubview:self.nameBtn];
            
            [self.view addSubview:self.toolBarView];
            self.circlePickerView  = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight + 30, kScreenWidth, 216)];
            self.circlePickerView.backgroundColor = [UIColor whiteColor];
            self.circlePickerView.delegate = self;
            self.circlePickerView.dataSource = self;
            self.circlePickerView.showsSelectionIndicator = YES;
            [self.view addSubview:self.circlePickerView];
        }
    }];
    
}
- (void)popCurrentViewController{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)guidBttonAction
{
    [super guidBttonAction];
    [self.view bringSubviewToFront:self.tabBar];
    self.tabBar.hidden = NO;
}

#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3 || indexPath.row == 2) {
        return 110;
    }
    else if (indexPath.row == 4){
        return 200;
    }
    else{
        return 45;
    }
}
#define height_Off 0
#define TITLE_COLOR @"#999999"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        if (indexPath.row == 0) {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 90, 35)];
            nameLabel.text = @"圈      子:";
            nameLabel.font = [UIFont systemFontOfSize:18.0f];
            nameLabel.textColor = [AppTools colorWithHexString:TITLE_COLOR];
            [cell.contentView addSubview:nameLabel];
            UIImage *downImage = [UIImage imageNamed:@"down_btn"];
            [downImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:
                                      CGRectMake(CGRectGetMaxX(nameLabel.frame), 7, 210, 29)];
            imageView.image = downImage;
            [cell.contentView addSubview:imageView];
            self.circleNameFeildLabel = [[UILabel alloc]init];
            self.circleNameFeildLabel.textAlignment = NSTextAlignmentLeft;
            if (IOS_VERSION >= 7.0) {
                self.circleNameFeildLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + 5, 5, 210, 35);
            }
            else{
                self.circleNameFeildLabel.frame = CGRectMake(CGRectGetMaxX(nameLabel.frame) + 5, 10, 210, 35);
            }
            self.circleNameFeildLabel.text = @"--- 请选择 ---";
            self.circleNameFeildLabel.userInteractionEnabled = YES;
            self.circleNameFeildLabel.font = [UIFont systemFontOfSize:16.0f];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleNameFeildBtnAction)];
            [self.circleNameFeildLabel addGestureRecognizer:tap];
            [cell.contentView addSubview:self.circleNameFeildLabel];
            UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height , 300, .8f)];
            sepratorLine.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:sepratorLine];
            sepratorLine.alpha =.2f;
        }
        if (indexPath.row == 1) {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 90, 35)];
            nameLabel.text = @"标      题:";
            nameLabel.font = [UIFont systemFontOfSize:18.0f];
            nameLabel.textColor = [AppTools colorWithHexString:TITLE_COLOR];
            [cell.contentView addSubview:nameLabel];
            self.titleFeild = [[SHTTextField alloc]initWithFrame:
                               CGRectMake(CGRectGetMaxX(nameLabel.frame)+1, 7, 220, 30)];
            self.titleFeild.font = [UIFont systemFontOfSize:16.0f];
            self.titleFeild.kmaxLength = 14;
            self.titleFeild.delegate = self;
            self.titleFeild.dele = self;
            self.titleFeild.returnKeyType = UIReturnKeyNext;
            self.titleFeild.placeHoderLabel.font = [UIFont systemFontOfSize:16.0f];
            self.titleFeild.placeHoderLabel.text = @"[标题名称,限定14个字]";
            [cell.contentView addSubview:self.titleFeild];
            
            UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(10, cell.frame.size.height - 1, 300, .8f)];
            sepratorLine.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:sepratorLine];
            sepratorLine.alpha =.2f;
        }
        if (indexPath.row == 2) {
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, height_Off, 90, 35)];
            nameLabel.text = @"简      介:";
            nameLabel.font = [UIFont systemFontOfSize:18.0f];
            nameLabel.textColor = [AppTools colorWithHexString:TITLE_COLOR];
            [cell.contentView addSubview:nameLabel];
            self.simpleView = [[SHTTextView alloc] initWithFrame:CGRectMake(99, height_Off, 220, 100)];
            self.simpleView.font = [UIFont systemFontOfSize:16.0f];
            self.simpleView.delegate = self;
            self.simpleView.dele = self;
            self.simpleView.kmaxLength = 42;
            self.simpleView.returnKeyType = UIReturnKeyNext;
            self.simpleView.placeHoderLabel.font = [UIFont systemFontOfSize:16.0f];
            self.simpleView.placeHoderLabel.text = @"[简介内容,限定42个字]";
            [cell.contentView addSubview:self.simpleView];
            
            UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(10, 110 - 1, 300, .8f)];
            sepratorLine.backgroundColor = [UIColor grayColor];
            [cell.contentView addSubview:sepratorLine];
            sepratorLine.alpha =.2f;
        }
        if(indexPath.row == 3){
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, height_Off, 90, 35)];
            nameLabel.text = @"描      述:";
            nameLabel.font = [UIFont systemFontOfSize:18.0f];
            nameLabel.textColor = [AppTools colorWithHexString:TITLE_COLOR];
            [cell.contentView addSubview:nameLabel];
            self.detailView = [[SHTTextView alloc]initWithFrame:CGRectMake(99, height_Off, 220, 100)];
            self.detailView.textColor = [UIColor blackColor];
            self.detailView.font = [UIFont systemFontOfSize:16.0f];
            self.detailView.delegate = self;
            self.detailView.dele = self;
            self.detailView.kmaxLength = UINT16_MAX;
            self.detailView.returnKeyType = UIReturnKeyNext;
            self.detailView.placeHoderLabel.font = [UIFont systemFontOfSize:16.0f];
            self.detailView.placeHoderLabel.text = @"[请填写描述内容]";
            [cell.contentView addSubview:self.detailView];
            
            UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(10, 110 - 1, 300, .8f)];
            sepratorLine.backgroundColor = [UIColor grayColor];
            sepratorLine.alpha =.2f;
            [cell.contentView addSubview:sepratorLine]; 
        }
        if (indexPath.row == 4) {
            if (self.state == SHTImageScanStateAdd) {
                self.imageBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.imageBtn1 setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
                [self.imageBtn1 addTarget:self action:@selector(selectedImageView:)
                         forControlEvents:UIControlEventTouchUpInside];
                self.imageBtn1.tag = 1;
                self.imageBtn1.frame = CGRectMake(20, 10, 60, 60);
                [cell.contentView addSubview:self.imageBtn1];
                self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                     action:@selector(handlLongPressGesture:)];
                [self.imageBtn1 addGestureRecognizer:self.longPressGesture];
            }
            else if (self.state == SHTImageScanStateAll){
                for (int i = 0; i < 4; i++) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(10 + 77 * i , 23, 70, 70);
                    [button setBackgroundImage:[UIImage imageNamed:@"addImage"]
                                      forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(selectedImageView:)
                     forControlEvents:UIControlEventTouchUpInside];
                    button.tag = i;
                    [cell.contentView addSubview:button];
                }
            }
            UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            commitBtn.frame = CGRectMake(10, 100, 300, 40);
            [commitBtn setBackgroundColor:[AppTools colorWithHexString:@"#FF8694"]];
            commitBtn.layer.cornerRadius = 2.0f;
            commitBtn.tag = 1000;
            [commitBtn setTitle:@"提 交" forState:UIControlStateNormal];
            [commitBtn addTarget:self action:@selector(commitContribute)
                forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:commitBtn];
            
            UILabel *declearLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, kScreenWidth - 10,30)];
            declearLabel.textAlignment = NSTextAlignmentLeft;
            declearLabel.font = [UIFont systemFontOfSize:14];
            declearLabel.textColor = [UIColor grayColor];
            declearLabel.text = @"需要通过管理员编审";
            [cell.contentView addSubview:declearLabel];
        }
    }
    return cell;
}
#pragma mark - selectCircleName
- (void)circleNameFeildBtnAction{
    [UIView animateWithDuration:0.25f animations:^{
        self.circlePickerView.frame = CGRectMake(0, kScreenHeight - 216, kScreenWidth, 216);
        self.toolBarView.frame = CGRectMake(0,kScreenHeight - 216 - 30, kScreenWidth, 30);
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.toolBarView];
    }];
}
#pragma mark - hidden
- (void)hiddenKeyboarden{
    [self.detailView resignFirstResponder];
    [self.simpleView resignFirstResponder];
}

- (void)keyboardWillAppear:(NSNotification *)noti{
    self.toolBarView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 30);
    self.circlePickerView.frame = CGRectMake(0, kScreenHeight + 30, kScreenWidth, 216);
    if ([self.simpleView isFirstResponder]) {
        NSDictionary *userInfo = [noti userInfo];
        self.simpleView.finishBtn.titleLabel.textColor = [UIColor blackColor];
        CGFloat duration  = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        CGPoint center = CGPointMake(160, self.view.center.y - 45);
        [UIView animateWithDuration:duration
                              delay:0
                            options:curve << 16
                         animations:^{
                             self.contributeTable.center = center;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    if ([self.detailView isFirstResponder]) {
        NSDictionary *userInfo = [noti userInfo];
//        CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.detailView.finishBtn.titleLabel.textColor = [UIColor blackColor];
        CGFloat duration  = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        CGPoint center = CGPointMake(160, self.view.center.y - 160);
        [UIView animateWithDuration:duration
                              delay:0
                            options:curve << 16
                         animations:^{
                             self.contributeTable.center = center;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    self.btn.titleLabel.textColor = [UIColor blackColor];
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
                         self.contributeTable.center = self.tableCenter;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.titleFeild isFirstResponder]) {
        [self.titleFeild resignFirstResponder];
    }
    if ([self.detailView isFirstResponder]) {
        [self.detailView resignFirstResponder];
    }
    if ([self.simpleView isFirstResponder]) {
        [self.simpleView resignFirstResponder];
    }
}
#pragma mark -SCroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.contributeTable) {
        if ([self.titleFeild isFirstResponder]) {
            [self.titleFeild resignFirstResponder];
        }
        if ([self.simpleView isFirstResponder]) {
            [self.simpleView resignFirstResponder];
        }
        if ([self.detailView isFirstResponder]) {
            [self.detailView resignFirstResponder];
        }
    }
}
#pragma mark - selectedbutton AppearPickerView
-(void)selectCircle{
    [UIView animateWithDuration:0.25f animations:^{
        self.circlePickerView.frame = CGRectMake(0, kScreenHeight + 30, kScreenWidth, 216);
        self.toolBarView.frame = CGRectMake(0,kScreenHeight, kScreenWidth, 30);
    } completion:^(BOOL finished) {
    }];
}
- (void)selectedImageView:(id)sender{
    UIActionSheet *sheet ;
    UIButton *button = (UIButton *)sender;
    sheet.tag = button.tag;
    self.imageIndex = button.tag;
    sheet  = [[UIActionSheet alloc]initWithTitle:@"选择照片"
                                        delegate:self
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:@"从照片库中取"
                               otherButtonTitles:@"拍照", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //从相册中取
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (buttonIndex) {
        case 0:
            //相册
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }
            break;
        case 1:
            //相机
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                return;
            }
            else{
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (self.state == SHTImageScanStateAdd) {
        [self performSelector:@selector(saveImage:) withObject:image];
    }
    else if (self.state == SHTImageScanStateAll){
        
        [self performSelector:@selector(saveAllImage:) withObject:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAllImage:(UIImage *)image{
    [self uploadImage:image];
}
- (void)deleteImageView:(UIButton *)button{
    UITableViewCell *cell = [self.contributeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    button.hidden = YES;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag >= 100 && view.tag < 1000 ) {
                //       [view removeFromSuperview];
            }
        }
    }
    [button removeFromSuperview];
    switch (button.tag - 100) {
        case 0:
            for (UIView *btnView in cell.contentView.subviews) {
                if ([btnView isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)btnView;
                    if (button.tag == 0) {
                        for (UIButton *deleteBtn in button.subviews) {
                            deleteBtn.hidden = YES;
                            
                        }
                        [button setImage:nil forState:UIControlStateNormal];
                        [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
                        [self.imageIDArray replaceObjectAtIndex:0 withObject:[NSNull null]];
                        [self.imagePickerArray replaceObjectAtIndex:0 withObject:[NSNull null]];
                    }
                }
            }
            break;
        case 1:
            for (UIView *btnView in cell.contentView.subviews) {
                if ([btnView isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)btnView;
                    if (button.tag == 1) {
                        for (UIButton *deleteBtn in button.subviews) {
                            deleteBtn.hidden = YES;
                        }
                        [button setImage:nil forState:UIControlStateNormal];
                        [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
                        [self.imageIDArray replaceObjectAtIndex:1 withObject:[NSNull null]];
                        [self.imagePickerArray replaceObjectAtIndex:1 withObject:[NSNull null]];
                    }
                }
            }
            break;
        case 2:
            for (UIView *btnView in cell.contentView.subviews) {
                if ([btnView isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)btnView;
                    if (button.tag == 2) {
                        for (UIButton *deleteBtn in button.subviews) {
                            deleteBtn.hidden = YES;
                        }
                        [button setImage:nil forState:UIControlStateNormal];
                        [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
                        [self.imageIDArray replaceObjectAtIndex:2 withObject:[NSNull null]];
                        [self.imagePickerArray replaceObjectAtIndex:2 withObject:[NSNull null]];
                    }
                }
            }
            break;
        case 3:
            for (UIView *btnView in cell.contentView.subviews) {
                if ([btnView isKindOfClass:[UIButton class]]) {
                    UIButton *button = (UIButton *)btnView;
                    if (button.tag == 3) {
                        for (UIButton *deleteBtn in button.subviews) {
                            deleteBtn.hidden = YES;
                        }
                        [button setImage:nil forState:UIControlStateNormal];
                        [button setBackgroundImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
                        [self.imageIDArray replaceObjectAtIndex:3 withObject:[NSNull null]];
                        [self.imagePickerArray replaceObjectAtIndex:3 withObject:[NSNull null]];
                    }
                }
            }
            break;
        default:
            break;
    }
}
- (void)saveImage:(UIImage *)image{
    switch (self.imageIndex) {
        case 1:
        {
            self.imageBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.imageBtn2 setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            self.imageBtn2.backgroundColor = [UIColor grayColor];
            [self.imageBtn2 addTarget:self action:@selector(selectedImageView:)
                     forControlEvents:UIControlEventTouchUpInside];
            self.imageBtn2.tag = 2;
            self.imageBtn2.frame = CGRectMake(20 + 70, 10, 60, 60);
            //加手势
            self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(handlLongPressGesture:)];
            [self.imageBtn2 addGestureRecognizer:self.longPressGesture];
            
            UITableViewCell *cell = [self.contributeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [cell.contentView addSubview:self.imageBtn2];
            [self.imageBtn1 setImage:nil forState:UIControlStateNormal];
            [self.imageBtn1 setBackgroundImage:image forState:UIControlStateNormal];
            [self uploadImage:image];
        }
            break;
        case 2:
        {
            self.imageBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.imageBtn3 setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            self.imageBtn3.backgroundColor = [UIColor grayColor];
            [self.imageBtn3 addTarget:self action:@selector(selectedImageView:)
                     forControlEvents:UIControlEventTouchUpInside];
            self.imageBtn3.tag = 3;
            self.imageBtn3.frame = CGRectMake(20 + 70 * 2, 10, 60, 60);
            self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(handlLongPressGesture:)];
            [self.imageBtn3 addGestureRecognizer:self.longPressGesture];
            UITableViewCell *cell = [self.contributeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [cell.contentView addSubview:self.imageBtn3];
            [self.imageBtn2 setImage:nil forState:UIControlStateNormal];
            [self.imageBtn2 setBackgroundImage:image forState:UIControlStateNormal];
            [self uploadImage:image];
            break;
        }
        case 3:
        {
            self.imageBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.imageBtn4 setImage:[UIImage imageNamed:@"addImage"]
                            forState:UIControlStateNormal];
            self.imageBtn4.backgroundColor = [UIColor grayColor];
            [self.imageBtn4 addTarget:self action:@selector(selectedImageView:)
                     forControlEvents:UIControlEventTouchUpInside];
            self.imageBtn4.tag = 4;
            self.imageBtn4.frame = CGRectMake(20 + 70*3, 10, 60, 60);
            self.longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(handlLongPressGesture:)];
            [self.imageBtn4 addGestureRecognizer:self.longPressGesture];
            UITableViewCell *cell = [self.contributeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            [cell.contentView addSubview:self.imageBtn4];
            [self uploadImage:image];
            [self.imageBtn3 setImage:nil forState:UIControlStateNormal];
            [self.imageBtn3 setBackgroundImage:image forState:UIControlStateNormal];
            break;
        }
        case 4:
        {
            [self uploadImage:image];
            [self.imageBtn4 setImage:nil forState:UIControlStateNormal];
            [self.imageBtn4 setBackgroundImage:image forState:UIControlStateNormal];
        }
        default:
            break;
    }
    
}
- (void)uploadImage:(UIImage *)image{
    NSData *imageData = UIImagePNGRepresentation(image);
    [NETWORK requestUploadPicWithImageData:imageData RequestResult:^(NSString *response) {
        if ([response isEqualToString:@"-1"]) {
            [self showNetworkErrorMessage:@"网络无法连接"];
            [self.view bringSubviewToFront:self.p];
            return ;
        }
        NSDictionary *responseDict = [response objectFromJSONString];
        NSDictionary *imageDict = [[responseDict objectForKey:@"data"] objectAtIndex:0];
        
        [self.imagePickerArray replaceObjectAtIndex:self.imageIndex withObject:image];
        [self.imageIDArray replaceObjectAtIndex:self.imageIndex withObject:[imageDict objectForKey:@"pic_id"]];
        
        UITableViewCell *cell = [self.contributeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        for (UIView *btnView in cell.contentView.subviews) {
            if ([btnView isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)btnView;
                if (button.tag == self.imageIndex) {
                    [button setImage:image forState:UIControlStateNormal];
                    //添加删除按键
                    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    deleteBtn.tag = button.tag + 100;
                    deleteBtn.frame = CGRectMake(5 + (deleteBtn.tag-100) * 77, 20, 20, 20);
                    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
                    [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:deleteBtn];
                }
            }
        }
        
    }];
}
#pragma mark - DeleteImage
- (void)handlLongPressGesture:(UILongPressGestureRecognizer *)longPress{
    
    UIButton *deleteImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteImageBtn.frame = CGRectMake(0, 0, 20, 20);
    deleteImageBtn.tag = longPress.view.tag;
    deleteImageBtn.hidden = NO;
    [deleteImageBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [longPress.view addSubview:deleteImageBtn];
    
}
#pragma mark - deleteImage
- (void)deleteImage:(UIButton *)button{
    switch (button.tag) {
        case 1:
        {
            //删除button上的视图
            for (UIView *view in self.imageBtn1.subviews) {
                view.hidden = YES;
            }
            [self.imageBtn1 setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [self.imageBtn1 setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        }
            
        case 2:{
            for (UIView *v in self.imageBtn2.subviews) {
                v.hidden = YES;
            }
            [self.imageBtn2 setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [self.imageBtn2 setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        }
        case 3:{
            for (UIView *v in self.imageBtn3.subviews) {
                v.hidden = YES;
            }
            [self.imageBtn3 setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [self.imageBtn3 setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        }
        case 4:{
            for (UIView *v in self.imageBtn4.subviews) {
                v.hidden = YES;
            }
            [self.imageBtn4 setImage:[UIImage imageNamed:@"addImage"] forState:UIControlStateNormal];
            [self.imageBtn4 setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [self.imagePickerArray removeObjectAtIndex:button.tag - 1];
    [self.imageIDArray removeObjectAtIndex:button.tag - 1];
    
}
#pragma mark - PickerViewDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.circleTitleArray count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    self.btn.titleLabel.textColor = [UIColor blackColor];
    CircleAbstractInfo *info = [[CircleAbstractInfo alloc]init];
    if (row == 0) {
        return @"--- 请选择 ---";
        self.circleAdminId = nil;
        self.circleId = nil;
    }else{
        if (self.circleTitleArray.count > 0) {
            info = [self.circleTitleArray objectAtIndex:row - 1];
            self.circleAdminId = info.circleAdminId;
        }
        return info.circleName;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
#pragma mark -PickViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        self.circleNameFeildLabel.text = @"---请选择---";
        self.circleId = nil;
        self.circleAdminId = nil;
        return;
    }
    else{
        if ([self.circleTitleArray count] > 0) {
            CircleAbstractInfo *info = [self.circleTitleArray objectAtIndex:row - 1];
            NSString *selectedName = info.circleName;
            self.circleNameFeildLabel.text = selectedName;
            self.circleId = info.circleID;
            self.circleAdminId = info.circleAdminId;
        }
    }
}

#pragma mark - Back
- (void)leftButtonClick
{
    self.circleAdminId = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - SHTTextViewDelegate
- (void)hiddenKeyboard{
    if ([self.simpleView isFirstResponder]) {
        [self.simpleView resignFirstResponder];
    }
    else{
        [self.detailView resignFirstResponder];
    }
}
#pragma mark -Keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.titleFeild) {
        [self.simpleView becomeFirstResponder];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.titleFeild.placeHoderLabel.hidden = YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.titleFeild) {
        if (range.length != 1) {
            if (range.location >= 14) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] || textField.text == nil) {
        self.titleFeild.placeHoderLabel.hidden = NO;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.simpleView) {
         self.simpleView.placeHoderLabel.hidden = YES;
    }
    else{
        self.detailView.placeHoderLabel.hidden = YES;
    }
}
#pragma mark -TextView
#define kMaxLengthSimple 42
- (void)keyboardChage:(NSNotification *)noti{
    if ([self.simpleView isFirstResponder]) {
        UITextView *textField = (UITextView *)noti.object;
        NSString *toBeString = textField.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > kMaxLengthSimple) {
                    textField.text = [toBeString substringToIndex:kMaxLengthSimple];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > kMaxLengthSimple) {
                textField.text = [toBeString substringToIndex:kMaxLengthSimple];
            }
        }
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"\n"]) {
        textView.text = nil;
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.simpleView) {
        if ([textView.text isEqualToString:@""]) {
            self.simpleView.placeHoderLabel.hidden = NO;
        }
    }
    else{
        if ([textView.text isEqualToString:@""]) {
            self.detailView.placeHoderLabel.hidden = NO;
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == self.simpleView && [text isEqualToString:@"\n"]) {
        [self.detailView becomeFirstResponder];
    }
    if (textView == self.simpleView) {
        if (range.length != 1) {
            if (range.location >= kMaxLengthSimple) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma  mark - commitInfo
- (void)commitContribute{
    if (!self.circleId) {
        [self showErrorMessage:@"请选择圈子"];
        [self.view bringSubviewToFront:self.p];
        return;
    }
    if([self.titleFeild.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == nil
       || [[self.titleFeild.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [self showErrorMessage:@"标题不能为空"];
        [self.view bringSubviewToFront:self.p];
        return;
    }
    else if([self.simpleView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == nil
            || [[self.simpleView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [self showErrorMessage:@"简介不能为空"];
        [self.view bringSubviewToFront:self.p];
        return;
    }
    else if([self.detailView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == nil
            || [[self.detailView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]){
        [self showErrorMessage:@"描述不能为空"];
        [self.view bringSubviewToFront:self.p];
        return;
    }
    [self showNetworkAnimation];
    [NETWORK requestContributeToCircleWithCircleId:self.circleId
                                      imageIdArray:self.imageIDArray
                                             title:self.titleFeild.text
                                            simple:self.simpleView.text
                                           content:self.detailView.text
                                     requestResult:^(NSString *response) {
                                         if ([response isEqualToString:@"-1"]) {
                                             [self hiddenNetworkAnimation];
                                             [self showNetworkErrorMessage:@"网络无法连接"];
                                             [self.view bringSubviewToFront:self.p];
                                             return ;
                                         }
                                         [self hiddenNetworkAnimation];
                                         if ([self.circleAdminId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserID]]) {
                                             [self showErrorMessage:@"提交成功"];
                                             [self.view bringSubviewToFront:self.p];
                                             [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                                              target:self
                                                                            selector:@selector(hiddenMessage)
                                                                            userInfo:nil
                                                                             repeats:NO];
                                             if (self.delegate && [self.delegate respondsToSelector:@selector(backToCircleThemeListWith:)]) {
                                                 [self.delegate backToCircleThemeListWith:self.circleAdminId];
                                             }
                                             NSLog(@"%@",[[response objectFromJSONString] objectForKey:@"status_code"]);
                                             if ([[[response objectFromJSONString] objectForKey:@"status_code"] integerValue] != 0) {
                                                 [self showErrorMessage:[NSString stringWithFormat:@"%@",[[response objectFromJSONString] objectForKey:@"status_desc"]]];
                                                 return;
                                             }
                                             [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                                              target:self
                                                                            selector:@selector(hiddenMessage)
                                                                            userInfo:nil
                                                                             repeats:NO];
                                         }
                                         else{
                                             if ([[[response objectFromJSONString] objectForKey:@"status_code"] integerValue] != 0) {
                                                 [self showErrorMessage:[NSString stringWithFormat:@"%@",[[response objectFromJSONString] objectForKey:@"status_desc"]]];
                                                 return;
                                             }
                                             [self showErrorMessage:@"提交成功"];
                                             [self.view bringSubviewToFront:self.p];
                                             [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                                              target:self
                                                                            selector:@selector(hiddenMessage)
                                                                            userInfo:nil
                                                                             repeats:NO];
                                             if (self.delegate && [self.delegate respondsToSelector:@selector(backToCircleThemeListWith:)]) {
                                                 [self.delegate backToCircleThemeListWith:self.circleAdminId];
                                             }
                                         }
                                     }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backToCircleThemeListWith:)]) {
        [self.delegate backToCircleThemeListWith:self.circleAdminId];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)hiddenMessage{
    [self hiddenNetworkAnimation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end