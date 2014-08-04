//
//  AlertTableViewController.m
//  AlertView
//
//  Created by Liv on 14-3-18.
//  Copyright (c) 2014年 levy. All rights reserved.
//

#import "ResourceAlertTableViewController.h"
#import "UserInformation.h"
#import "userItemInformation.h"
#import "areaItemInformation.h"
#import "indItemInformation.h"

NSString    *imageViewXianBackgroundColor2 = @"#394659";
@interface ResourceAlertTableViewController () <UITextFieldDelegate>
@property (nonatomic,strong)  NSMutableArray *btnArr;
@property (strong,nonatomic) NSMutableArray *areaBtns;
@property (strong,nonatomic) NSMutableArray *indBtns;
@property (strong,nonatomic) NSMutableArray *allBtns;
@property(strong,nonatomic)NSMutableDictionary * allBtnsDic;

@property (strong,nonatomic) NSString *areaString;
@property (strong,nonatomic) NSString *indString;

@end

@implementation ResourceAlertTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.frame = CGRectMake(0, 50, 320, 120);
		UserInformation *userInfo = [UserInformation downloadDatadefaultManager];
        
        NSData *aData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectAreaFileName]];
        self.areas = userInfo._areaArray.count>0 ? userInfo._areaArray : (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:aData];
        NSData *iData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectIndFileName]];
        self.inds = userInfo._indArray.count>0 ? userInfo._indArray : (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:iData];

        self.areaBtns = [[NSMutableArray alloc] init];
        self.indBtns = [[NSMutableArray alloc] init];
        self.allBtns = [[NSMutableArray alloc] init];
        self.allBtnsDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:75.0/255.0 green:89.0/255.0 blue:112.0/255.0 alpha:1.0];
    self.btnArr = [[NSMutableArray alloc]init];
    self.tableView.scrollEnabled = NO;
    [self.tableView setSeparatorColor:[UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,-8,self.view.frame.size.width, 80)];

    UIButton *btn1 = [[UIButton alloc]init];
    [btn1 setTitle:@"最新资源" forState:UIControlStateNormal];
     btn1.tag = 5000;
    [btn1 setBackgroundImage:[UIImage imageNamed:@"Resouce1last.png"] forState:UIControlStateNormal];
    [btn1 setFrame:CGRectMake(20, 15, 130, 30)];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn1 addTarget:self action:@selector(ziyuan) forControlEvents:UIControlEventTouchUpInside];
	
    UIButton *btn2 =  [[UIButton alloc]init];
	[btn2 setTitle:@"最感兴趣" forState:UIControlStateNormal];
	[btn2 setBackgroundImage:[UIImage imageNamed:@"Resouce0last.png"] forState:UIControlStateNormal];
     btn2.tag = 5001;
	[btn2 setFrame:CGRectMake(168, btn1.frame.origin.y, 130, 30)];
     btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn2 addTarget:self action:@selector(ganxingqu) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, btn1.frame.origin.y+btn1.frame.size.height+5, 320, 30)];
    [backView setBackgroundColor:[UIColor colorWithRed:104.0/255.0 green:117.0/255.0 blue:140.0/255.0 alpha:1.0]];
    UIImageView * imageViewleft = [[UIImageView alloc]initWithFrame:CGRectMake(17,5, 18, 18)];
    imageViewleft.image = [UIImage imageNamed:@"loudou.png"];
    [backView addSubview:imageViewleft];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(44,-4, 38, 38)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"筛选";
    label.font = [UIFont systemFontOfSize:16];
    [backView addSubview:label];
    
    [view addSubview:backView];
 	[view addSubview:btn1];
	[view addSubview:btn2];

  	self.tableView.tableHeaderView = view;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,55)];
    UIImageView * imageViewXian = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 0.5)];
    imageViewXian.backgroundColor =[AppTools colorWithHexString:imageViewXianBackgroundColor2];
    [view1 addSubview:imageViewXian];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(98, 9, 120, 30)];
         btn.tag = 5002;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
     [btn setBackgroundImage:[UIImage imageNamed:@"Resqueding.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickEnter2:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
	self.tableView.tableFooterView = view1;
}

-(void) ziyuan
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX59];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ziyuan" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];
    UIButton * button1 = (UIButton *)[self.view viewWithTag:5000];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"ResslcButton", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResslcButton" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shaixuanButton" object:self userInfo:dic];
    [_tsPopViewController dismissPopoverAnimatd:YES];
}

-(void) ganxingqu
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DOMAIN_URL,URL_INDEX60];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ganxingqu" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];
    UIButton * button1 = (UIButton *)[self.view viewWithTag:5001];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"ResslcButton1", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResslcButton1" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shaixuanButton" object:self userInfo:dic];
    [_tsPopViewController dismissPopoverAnimatd:YES];

}
-(void) clickEnter2:(UIButton *)button
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
            if ([obj isKindOfClass:[indItemInformation class]]) {
                indItemInformation *i = (indItemInformation *) obj;
                NSString * ind = [NSString  stringWithFormat:@"ind=%@",i.indID];
                self.indString = ind;
            }
        }
        lastString = [NSString stringWithFormat:@"%@&%@",self.areaString,self.indString];
    }
    if (!lastString) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",DOMAIN_URL,URL_INDEX61,lastString];
    NSLog(@"queding is %@",urlString);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Resoucequeding" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:urlString,@"urlString", nil]];
    UIButton * button1 = (UIButton *)[self.view viewWithTag:5002];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:button1,@"ResslcButton2", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResslcButton2" object:self userInfo:dic];
    [_tsPopViewController dismissPopoverAnimatd:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = @"Cell";
    UITableViewCell *cell = nil ;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.backgroundColor = [UIColor colorWithRed:75.0/255.0 green:89.0/255.0 blue:112.0/255.0 alpha:1.0];

   	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(50, -7, self.view.frame.size.width-5, cell.frame.size.height-5)];
	sv.scrollEnabled = YES;
	sv.showsHorizontalScrollIndicator = NO;
	sv.showsVerticalScrollIndicator = NO;
	sv.backgroundColor = [UIColor clearColor];
    [sv becomeFirstResponder];
    
 	NSMutableArray *views = [[NSMutableArray alloc] init];
 	CGRect labFrame = CGRectMake(12, 3,70, 20);
    CGRect imageViewFrame =CGRectMake(38, 1,1, 20);
	if (indexPath.row == 0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:labFrame];
		lbl.text = @"地区";
        lbl.backgroundColor = [UIColor clearColor];
		lbl.textColor = [UIColor whiteColor];
		lbl.font = [UIFont systemFontOfSize:15];
		[sv addSubview:lbl];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = imageViewFrame;
        imageView.backgroundColor = [UIColor colorWithRed:57.0/255.0 green:70.0/255.0 blue:89.0/255.0 alpha:1.0];
        [lbl addSubview:imageView];
        for (areaItemInformation *item in self.areas) {
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
		[cell.contentView addSubview:lbl];
		[cell.contentView addSubview:sv];
    }
	if (indexPath.row == 1) {
		UILabel *lbl = [[UILabel alloc] initWithFrame:labFrame];
		lbl.text = @"行业";
        lbl.backgroundColor = [UIColor clearColor];
		lbl.textColor = [UIColor whiteColor];
		lbl.font = [UIFont systemFontOfSize:15];
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
   		[cell.contentView addSubview:lbl];
		[cell.contentView addSubview:sv];
  	}
	[self addViews:views toScrollView:sv];
    NSLog(@"cell height : %f",cell.frame.size.height);
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

@end
