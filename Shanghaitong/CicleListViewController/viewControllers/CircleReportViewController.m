//
//  CircleReportViewController.m
//  Shanghaitong
//
//  Created by Steve Wang on 14-6-28.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "CircleReportViewController.h"
#import "AFNetworking.h"
#import "PopupSmallView.h"

@interface CircleReportViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, PopupSmallViewDelegate>

@property (nonatomic, strong)   UITableView *reportTable;
@property (nonatomic, strong)   UIImageView *hook;
@property (nonatomic, strong)   UIActivityIndicatorView *indicator;
@property (nonatomic, strong)   NSArray     *choice_reasion_items;
@property (nonatomic, assign)   int         report_type;
@property (nonatomic, copy)     NSString    *report_content;

@end

@implementation CircleReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _choice_reasion_items = @[@"其他", @"违背法律和法规", @"暴力色情", @"诈骗和虚假信息", @"骚扰"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customMakeNavigationBarHasLeftButton:YES withHasRightButton:NO];
    self.navigationView.titleLabel.text = @"举报主题";
    self.navigationView.titleLabel.font = [UIFont fontWithName:@"heiti" size:22.0f];
    self.navigationView.titleLabel.font = [UIFont systemFontOfSize:22];
    
    _reportTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationView.frame.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-self.navigationView.frame.size.height) style:UITableViewStylePlain];
    _reportTable.delegate = self;
    _reportTable.dataSource = self;
    _reportTable.backgroundColor = [AppTools colorWithHexString:@"#e1e0de"];
    _reportTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _reportTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_reportTable];
    
    _report_type = 0;
    
    UITapGestureRecognizer *hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedHideKeyboardGesture:)];
    [_reportTable addGestureRecognizer:hideKeyboard];
    
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavigationViewDelegate -

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 540;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentification = @"cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentification];
        cell.contentView.backgroundColor = tableView.backgroundColor;
        
        NSString *descript_string = @"      商海通平台一直努力为您打造健康交流的环境。我们坚决反对违法、色情、欺诈，侵权等信息内容。欢迎您积极举报不良的主题，以便我们更及时和精确地处理。";
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize dSize = [descript_string sizeWithFont:font constrainedToSize:CGSizeMake(cell.contentView.frame.size.width-10*2, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel *rDescript = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, dSize.width, dSize.height)];
        rDescript.text = descript_string;
        rDescript.numberOfLines = 0;
        rDescript.backgroundColor = [UIColor clearColor];
        rDescript.font = font;
        [cell.contentView addSubview:rDescript];
        
        UILabel *choice_reason = [[UILabel alloc] initWithFrame:CGRectMake(rDescript.frame.origin.x, rDescript.frame.origin.y+rDescript.frame.size.height, rDescript.frame.size.width, 30)];
        choice_reason.backgroundColor = [UIColor clearColor];
        choice_reason.text = @"请选择举报原因：";
        choice_reason.font = font;
        [cell.contentView addSubview:choice_reason];
        
        UIImage *btnone = [UIImage imageNamed:@"boxone"];
        UIImage *btntwo = [UIImage imageNamed:@"boxtwo"];
        UIImage *btnthree = [UIImage imageNamed:@"boxthree"];
        UIImage *hook = [UIImage imageNamed:@"hook"];
        
        float choice_item_height = 40;
        for (int i = 0; i < 5; i++) {
            UIButton *choice_item = [[UIButton alloc] initWithFrame:CGRectMake(choice_reason.frame.origin.x, choice_reason.frame.origin.y+choice_reason.frame.size.height+i*choice_item_height, choice_reason.frame.size.width, choice_item_height)];
            choice_item.tag = i; // tag值代表举报的类型[0 1 2 3 4]
            
            if (i == 0) {
                [choice_item setBackgroundImage:btnone forState:UIControlStateNormal];
            }else if (i == 4) {
                [choice_item setBackgroundImage:btnthree forState:UIControlStateNormal];
            }else {
                [choice_item setBackgroundImage:btntwo forState:UIControlStateNormal];
            }
            [choice_item addTarget:self action:@selector(pressed_choice_item:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:choice_item];
            
            UILabel *choice_item_title = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, choice_item.frame.size.height-5*2)];
            choice_item_title.text = [_choice_reasion_items objectAtIndex:i];
            choice_item_title.backgroundColor = [UIColor clearColor];
            [choice_item addSubview:choice_item_title];
            
            if (!_hook) {
                _hook = [[UIImageView alloc] initWithImage:hook];
                _hook.frame = CGRectMake(choice_item.frame.size.width-20-15, 10, 25, 20);
                [choice_item addSubview:_hook];
            }
        }
        
        UILabel *input_reason = [[UILabel alloc] initWithFrame:CGRectMake(rDescript.frame.origin.x, choice_reason.frame.origin.y+choice_reason.frame.size.height+5*choice_item_height+10, rDescript.frame.size.width, 30)];
        input_reason.backgroundColor = [UIColor clearColor];
        input_reason.text = @"请填写举报原因：";
        input_reason.font = font;
        [cell.contentView addSubview:input_reason];
        
        UIView *input_reason_background_view = [[UIView alloc] initWithFrame:CGRectMake(input_reason.frame.origin.x, input_reason.frame.origin.y+input_reason.frame.size.height, input_reason.frame.size.width, 100)];
        input_reason_background_view.layer.borderColor = [UIColor grayColor].CGColor;
        input_reason_background_view.layer.borderWidth = 1;
        input_reason_background_view.layer.cornerRadius = 5;
        input_reason_background_view.layer.masksToBounds = NO;
        input_reason_background_view.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:input_reason_background_view];
        
        UITextView *input_reason_view = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, input_reason.frame.size.width, 100)];
        input_reason_view.delegate = self;
        input_reason_view.backgroundColor = [UIColor clearColor];
        [input_reason_background_view addSubview:input_reason_view];
        
        UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(input_reason_background_view.frame.origin.x, input_reason_background_view.frame.origin.y+input_reason_background_view.frame.size.height+35, input_reason_view.frame.size.width, 40)];
        [submit addTarget:self action:@selector(pressed_submit:) forControlEvents:UIControlEventTouchUpInside];
        [submit setTitle:@"确认举报" forState:UIControlStateNormal];
        [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submit setBackgroundColor:[AppTools colorWithHexString:@"#FF8694"]];
        submit.layer.cornerRadius = 2.5;
        submit.layer.masksToBounds = NO;
        [cell.contentView addSubview:submit];

    }
    return cell;
}

#pragma mark - Target Action -

- (void)pressed_choice_item:(UIButton *)button
{
    NSLog(@"pressed button tag: %d", button.tag);
    [self tappedHideKeyboardGesture:nil];
    [_hook removeFromSuperview];
    [button addSubview:_hook];
    
    _report_type = button.tag;
}

- (void)tappedHideKeyboardGesture:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)pressed_submit:(UIButton *)button
{
    [self tappedHideKeyboardGesture:nil];
    
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-25, [UIScreen mainScreen].bounds.size.height/2-25, 25, 25)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_indicator];
        [_indicator startAnimating];
    }
    
    NSLog(@"_report_type: %d", _report_type);
    NSLog(@"_topic_id: %d", _topic_id);
    NSLog(@"_report_content: %@", _report_content);
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken];
    
    if (!_report_content || [_report_content isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入举报的理由" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        [_indicator stopAnimating];

        return;
    }
    
    NSDictionary *post_request_dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:_report_type], @"type",
                                       [NSNumber numberWithInt:_topic_id], @"msg_id",
                                       _report_content, @"content",
                                       token, @"token", nil];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    [client postPath:@"circle/msg_report.json" parameters:post_request_dict success:^(AFHTTPRequestOperation *operation, id responseObject){
        [_indicator stopAnimating];

        id parse_data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"parse_data: %@", parse_data);
        if (!parse_data) {
            NSLog(@"举报请求提交失败");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"举报请求提交失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        if ([parse_data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)parse_data;
            int status = [[dict objectForKey:@"status_code"] integerValue];
            if (status == 0) {
                NSLog(@"举报请求提交成功");
                PopupSmallView *pop = [[PopupSmallView alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-30-20, 300, 30) withMessage:@"提交成功，我们会在24小时之内处理您的请求"];
                pop.delegate = self;
                [self.view addSubview:pop];
            }else {
                NSLog(@"举报请求提交失败");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"举报请求提交失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [_indicator stopAnimating];

        NSLog(@"举报请求提交失败，请稍后重试");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"举报请求提交失败，请稍后重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];

    }];
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _report_content = textView.text;
}

#pragma mark - NSNotificationCenter -

- (void)inputKeyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSDictionary *dict = notification.userInfo;
    CGFloat duration =[ dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [dict[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGRect rect = _reportTable.frame;
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:curve<<16
                              animations:^{
                                  [_reportTable setContentOffset:CGPointMake(0, keyboardBounds.size.height+30)];
                                  _reportTable.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, [UIScreen mainScreen].bounds.size.height-self.navigationView.frame.size.height- keyboardBounds.size.height);
                                  
    } completion:^(BOOL finished) {
        
    }];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification
{
    CGRect keyboardBounds = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration =[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    CGRect rect = _reportTable.frame;
    [self.view sendSubviewToBack:self.reportTable];
    [UIView animateWithDuration:duration delay:0
                        options:curve << 16
                     animations:^{
        _reportTable.frame = CGRectMake(rect.origin.x,
                                        64,
                                        rect.size.width,
                                        rect.size.height + keyboardBounds.size.height);
                         
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - PopupSmallViewDelegate -

- (void)popupViewDidDisappear
{
    [self leftButtonClick];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
