//
//  AlertTableViewController.m
//  AlertView
//
//  Created by Liv on 14-3-18.
//  Copyright (c) 2014年 levy. All rights reserved.
//

#import "ProjectAlertTableViewController.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "areaItemInformation.h"
#import "indItemInformation.h"
#import "demandItemInformation.h"
#import "TSPopoverController.h"
NSString    *imageViewXianBackgroundColor = @"#394659";
NSString    *imageViewBlockingBackgroundColor = @"#4b5970";
@interface ProjectAlertTableViewController ()

@property (nonatomic,strong) NSMutableArray *btnArr;
@property (strong,nonatomic) NSMutableArray *areaBtns;
@property (strong,nonatomic) NSMutableArray *indBtns;
@property (strong,nonatomic) NSMutableArray *demBtns;
@property (strong,nonatomic) NSMutableArray *allBtns;
@property (strong,nonatomic) NSMutableDictionary * allBtnsDic;
@property (strong,nonatomic) UITextField *tf;

@property (strong,nonatomic) NSString *areaString;
@property (strong,nonatomic) NSString *indString;
@property (strong,nonatomic) NSString *demString;
@property (nonatomic,strong) UIView   *backView2;
@property (nonatomic,strong) UIView *view1 ;

@end

@implementation ProjectAlertTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
 		UserInformation *userInfo = [UserInformation downloadDatadefaultManager];
        NSData *aData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectAreaFileName]];
        self.areas = userInfo._areaArray.count>0 ? userInfo._areaArray : (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:aData];
        NSData *iData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectIndFileName]];
        self.inds = userInfo._indArray.count>0 ? userInfo._indArray : (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:iData];

        NSData *dData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectDemandFileName]];
        self.dems = userInfo._demandArray.count>0 ? userInfo._demandArray : (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:dData];
        self.areaBtns = [[NSMutableArray alloc] init];
        self.indBtns = [[NSMutableArray alloc] init];
        self.demBtns = [[NSMutableArray alloc] init];
        self.allBtns = [[NSMutableArray alloc] init];
        self.allBtnsDic = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}
//键盘return键收键盘
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.tf resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.btnArr = [[NSMutableArray alloc] init];
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = [UIColor colorWithRed:75 green:89 blue:112 alpha:0];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0]];
    
    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setTitle:@"最新互动" forState:UIControlStateNormal];
    btn1.tag = 700;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"hudonglast.png"] forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake(15, 68, 90, 30)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn1 addTarget:self action:@selector(hudong) forControlEvents:UIControlEventTouchUpInside];
    
	UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"fabulast.png"] forState:UIControlStateNormal];
	[btn2 setTitle:@"最新发布" forState:UIControlStateNormal];
    btn2.tag = 701;
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
	[btn2 setFrame:CGRectMake(115, 68, 90, 30)];
    [btn2 addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];
    
	UIButton *btn3 = [[UIButton alloc]init];
	[btn3 setTitle:@"最感兴趣" forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"xingqulast.png"] forState:UIControlStateNormal];
    btn3.tag = 702;
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
	[btn3 setFrame:CGRectMake(215,68, 90, 30)];
    [btn3 addTarget:self action:@selector(xingqu) forControlEvents:UIControlEventTouchUpInside];
    //表格的头部试图
 	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,-8,self.view.frame.size.width,145)];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 108, 320, 30)];
    [backView setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:117.0/255.0 blue:140.0/255.0 alpha:1.0]];
    
    UIImageView * imageViewleft = [[UIImageView alloc]initWithFrame:CGRectMake(17,5, 18, 18)];
    imageViewleft.image = [UIImage imageNamed:@"loudou.png"];
    [backView addSubview:imageViewleft];
   
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(44,-4, 38, 38)];
    label.textColor = [UIColor whiteColor];
    label.text = @"筛选";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16];
    [backView addSubview:label];
    
    self.backView2 = [[UIView alloc]initWithFrame:CGRectMake(0,8, 320, 50)];
    [self.backView2 setBackgroundColor:[UIColor colorWithRed:49.0/255.0 green:59.0/255.0 blue:81.0/255.0 alpha:1.0]];
    
    self.tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 240, 30)];
    self.tf.borderStyle = UITextBorderStyleRoundedRect;
    self.tf.backgroundColor = [UIColor whiteColor];
    
    NSString * string =[NSString stringWithFormat:@" 请输入要搜索的内容"];
    self.tf.font =[UIFont systemFontOfSize:13];
    UIColor *  color = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: color}];
    self.tf.delegate = self;
    [self.backView2 addSubview:self.tf];

    [view addSubview:self.backView2];
    
    [view addSubview:backView];
 	[view addSubview:btn1];
	[view addSubview:btn2];
	[view addSubview:btn3];
  	self.tableView.tableHeaderView = view;
    
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,120)];
    UIImageView * imageViewXian = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320, 0.5)];
    imageViewXian.backgroundColor =[AppTools colorWithHexString:imageViewXianBackgroundColor];
    [self.view1 addSubview:imageViewXian];
    
   	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 8, 120, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setBackgroundImage:[UIImage imageNamed:@"Resqueding.png"] forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.tag = 703;
    [btn addTarget:self action:@selector(clickEnter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view1 addSubview:btn];
    
    UIButton *btnsearch = [[UIButton alloc] initWithFrame:CGRectMake(270,12, 27, 27)];
    [btnsearch setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    btnsearch.tag = 704;
    [btnsearch addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.backView2 addSubview:btnsearch];
    self.tableView.tableFooterView = self.view1;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame2:) name:UIKeyboardWillHideNotification object:nil];

}
-(void) hudong
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX12];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hudong" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];
    UIButton * button1 = (UIButton *)[self.view viewWithTag:700];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"slcButton", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectButton" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectshaixuanButton" object:self userInfo:dic];
    [_tsPopViewController dismissPopoverAnimatd:YES];
}

-(void) fabu
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX13];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fabu" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];
    UIButton * button1 = (UIButton *)[self.view viewWithTag:701];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"slcButton1", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectButton1" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectshaixuanButton" object:self userInfo:dic];
    [_tsPopViewController dismissPopoverAnimatd:YES];
}

-(void) xingqu
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX14];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"xingqu" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];
    UIButton * button1 = (UIButton *)[self.view viewWithTag:702];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"slcButton2", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectButton2" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectshaixuanButton" object:self userInfo:dic];
    [_tsPopViewController dismissPopoverAnimatd:YES];
}
-(void) clickEnter:(UIButton *)button
{
    NSString * lastString = nil;
    for (UIButton * button in self.allBtns) {
        if (button.selected == YES) {
            NSLog(@"selected button is %@",[button titleForState:UIControlStateNormal]
                  );
            id obj = [self.allBtnsDic objectForKey:[button titleForState:UIControlStateNormal]];
            if ([obj isKindOfClass:[areaItemInformation class]]) {
                areaItemInformation *a = (areaItemInformation *) obj;
                NSString * area = [NSString  stringWithFormat:@"area=%@",a.area_id];
                self.areaString = area;
            }
            if ([obj isKindOfClass:[demandItemInformation class]]) {
                demandItemInformation *d = (demandItemInformation *) obj;
                NSString * demand = [NSString  stringWithFormat:@"demand=%@",d.demandID];
                self.demString = demand;
            }
            if ([obj isKindOfClass:[indItemInformation class]]) {
                indItemInformation *i = (indItemInformation *) obj;
                 NSString * ind = [NSString  stringWithFormat:@"ind=%@",i.indID];
                self.indString = ind;
            }
        }
        lastString = [NSString stringWithFormat:@"%@&%@&%@",self.areaString,self.demString,self.indString];
    }
    if (!lastString) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",DOMAIN_URL,URL_INDEX15,lastString];
    NSLog(@"queding is %@",urlString);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"queding" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];

    UIButton * button1 = (UIButton *)[self.view viewWithTag:703];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"slcButton3", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectButton3" object:self userInfo:dic];
    [_tsPopViewController dismissPopoverAnimatd:YES];
}

-(void)clickSearch
{
    NSString * lastString2;
    if ([self.tf.text isEqualToString:@""] || self.tf.text == nil) {
        return;
    }
    lastString2 = [NSString stringWithFormat:@"key=%@",self.tf.text];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",DOMAIN_URL,URL_INDEX16,lastString2];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"sousuo" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];
    UIButton * button1 = (UIButton *)[self.view viewWithTag:704];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"slcButton4", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectButton4" object:self userInfo:dic];
    
    [_tsPopViewController dismissPopoverAnimatd:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = @"Cell";
    UITableViewCell *cell ;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = [UIColor colorWithRed:75.0/255.0 green:89.0/255.0 blue:112.0/255.0 alpha:1.0];
    cell.imageView.frame = CGRectMake(0, 0, 10, 10);
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(50,-7, self.view.frame.size.width-5, cell.frame.size.height-5)];
	sv.scrollEnabled = YES;
	sv.showsHorizontalScrollIndicator = NO;
	sv.showsVerticalScrollIndicator = NO;
	sv.backgroundColor = [UIColor clearColor];
	NSMutableArray *views = [[NSMutableArray alloc] init];
	CGRect labFrame = CGRectMake(12, 3,70, 20);
    CGRect imageViewFrame =CGRectMake(38, 1,1, 20);
	
    if (indexPath.row == 0) {
		UILabel *lbl = [[UILabel alloc] initWithFrame:labFrame];
		lbl.text = @"地区";
		lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor clearColor];
		lbl.font = [UIFont systemFontOfSize:15];
		[sv addSubview:lbl];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = imageViewFrame;
        imageView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0];
        [lbl addSubview:imageView];
        for (areaItemInformation *item in self.areas) {
            NSLog(@"item: %@", item);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:179.0/255.0 green:192.0/255.0 blue:214.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:134.0/255.0 blue:148.0/255.0 alpha:1.0] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 0;
            [views addObject:btn];
            [self.allBtnsDic setObject:item forKey:[btn titleForState:UIControlStateNormal]];
            [self.areaBtns addObject:btn];
        }
		[cell addSubview:lbl];
		[cell addSubview:sv];
    }
    
	if (indexPath.row == 1) {
		UILabel *lbl = [[UILabel alloc] initWithFrame:labFrame];
		lbl.text = @"行业";
		lbl.textColor = [UIColor whiteColor];
		lbl.font = [UIFont systemFontOfSize:15];
        lbl.backgroundColor = [UIColor clearColor];
		[sv addSubview:lbl];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = imageViewFrame;
        imageView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0];
        [lbl addSubview:imageView];
        for (indItemInformation *item in self.inds) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:item.name  forState:UIControlStateNormal];
            
            [btn setTitleColor:[UIColor colorWithRed:179.0/255.0 green:192.0/255.0 blue:214.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:134.0/255.0 blue:148.0/255.0 alpha:1.0] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1;
            [views addObject:btn];
            [self.allBtnsDic setObject:item forKey:[btn titleForState:UIControlStateNormal]];
            [self.indBtns addObject:btn];
        }
		[cell addSubview:lbl];
		[cell addSubview:sv];
	}
	
    if (indexPath.row == 2) {
		UILabel *lbl = [[UILabel alloc] initWithFrame:labFrame];
		lbl.text = @"需求";
		lbl.font = [UIFont systemFontOfSize:15];
		lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor clearColor];
		[sv addSubview:lbl];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = imageViewFrame;
        imageView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0];
        [lbl addSubview:imageView];
        for (demandItemInformation *item in self.dems) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
             btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor colorWithRed:179.0/255.0 green:192.0/255.0 blue:214.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:134.0/255.0 blue:148.0/255.0 alpha:1.0] forState:UIControlStateSelected];
            [btn setTitle:item.des forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 2;
            [views addObject:btn];
            [self.demBtns addObject:btn];
            [self.allBtnsDic setObject:item forKey:[btn titleForState:UIControlStateNormal]];
        }
		[cell.contentView addSubview:lbl];
		[cell.contentView addSubview:sv];
	}
	[self addViews:views toScrollView:sv];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tf resignFirstResponder];
}

//单选
-(void) clickBtn : (id) sender
{
    UIButton *btn = (UIButton*) sender;
    if (btn.tag ==0) {
        for (UIButton *bt in self.areaBtns) {
            if (bt.selected == YES) {
              bt.selected = NO;
            }
        }
    }
    if (btn.tag == 1) {
        for (UIButton *bt in self.indBtns) {
            if (bt.selected == YES) {
                bt.selected = NO;
            }
        }
    }
    if (btn.tag == 2) {
        for (UIButton *bt in self.demBtns) {
            if (bt.selected == YES) {
                bt.selected = NO;
            }
        }
    }
    btn.selected = !btn.selected;
    [self.allBtns addObject:btn];
}

-(void) addViews:(NSMutableArray *) views toScrollView:(UIScrollView *)scorllView
{
    CGRect rect = CGRectMake(0, 6, 0, 0);
    CGRect scrollViewRect = CGRectZero;
    for (UIButton *v in views) {
        CGSize sizeV = [v.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(200, 30) lineBreakMode:NSLineBreakByCharWrapping];
            rect.size = CGSizeMake(sizeV.width, 30);
            v.frame = rect;
            rect.origin.x += v.frame.size.width+15;
        scrollViewRect.size.width += v.frame.size.width + 16;
        scrollViewRect.size.height = v.frame.size.height;
        [scorllView addSubview:v];
    }
    scorllView.contentSize = CGSizeMake(scrollViewRect.size.width + 15, scrollViewRect.size.height);
}

//#pragma mark - Keyboard Notification -
//- (void)keyboardWillChangeFrame:(NSNotification *)notification
//{
//    NSLog(@"keyboardWillChangeFrame");
//    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardBounds;
//    [keyboardBoundsValue getValue:&keyboardBounds];
//    NSLog(@"height = %f",keyboardBounds.size.height);
//    [self adjustPanelsWithKeybordHeight:keyboardBounds.size.height];
//}
//- (void)keyboardWillChangeFrame2:(NSNotification *)notification
//{
//    NSLog(@"keyboardWillChangeFrame");
//    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardBounds;
//    [keyboardBoundsValue getValue:&keyboardBounds];
//    NSLog(@"height = %f",keyboardBounds.size.height);
//    [self adjustPanelsWithKeybordHeight2:keyboardBounds.size.height];
//    
//}
//-(void)adjustPanelsWithKeybordHeight:(float)height
//{
//    self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
//}
//-(void)adjustPanelsWithKeybordHeight2:(float)height
//{
//    self.tableView.frame = CGRectMake(0, 10, self.tableView.frame.size.width, self.tableView.frame.size.height);
//}

@end
