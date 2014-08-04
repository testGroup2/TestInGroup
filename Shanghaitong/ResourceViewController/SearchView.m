//
//  SearchView.m
//  Shanghaitong
//
//  Created by xuqiang on 14-7-10.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "SearchView.h"
#import "UserInformation.h"
#import "FiltrateTableViewCell.h"
@interface SearchView()<UITableViewDataSource,UITableViewDelegate,FiltrateTableViewCellDelegate>
@property (nonatomic,strong) UITableView * normalTable;
@end

@implementation SearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeView];
    }
    return self;
}
- (void)makeView{
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.bgScrollView.delegate = self;
    [self addSubview:self.bgScrollView];
    self.hotLabelView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, 310,100)];
    self.hotLabelView.layer.cornerRadius = 3.0f;
    self.hotLabelView.layer.shadowRadius = 1.0f;
    self.hotLabelView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.hotLabelView.layer.shadowOffset = CGSizeMake(0, 0);
    self.hotLabelView.layer.shadowOpacity = 1;
    self.hotLabelView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:self.hotLabelView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 25)];
    nameLabel.text = @"热门标签";
    nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    nameLabel.textColor = [AppTools colorWithHexString:@"#949494"];
    nameLabel.backgroundColor = [UIColor whiteColor];
    [self.hotLabelView addSubview:nameLabel];
    UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(10, 32, 280, .5f)];
    sepratorLine.backgroundColor = [AppTools colorWithHexString:@"#e7e7e7"];
    [self.hotLabelView addSubview:sepratorLine];
    self.bgScrollView.contentSize = CGSizeMake(320,kScreenHeight - ORIGIN_Y + 5);
}

#define BTN_WIDTH 83
#define BTN_HEIGHT 44
- (void)configureHotLabelData:(NSArray *)hotData andNormalData:(NSMutableArray *)nomarlData{
    CGRect rect;
    for (int i = 0; i < hotData.count; i++) {
        UIButton *labelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        labelBtn.backgroundColor = [UIColor whiteColor];
        [labelBtn setTitleColor:[AppTools colorWithHexString:@"#3e3e3e"] forState:UIControlStateNormal];
        labelBtn.layer.borderWidth = 1.0f;
        labelBtn.layer.borderColor = [[AppTools colorWithHexString:@"#dedddd"] CGColor];
        labelBtn.layer.shadowColor = [[AppTools colorWithHexString:@"#eaeaea"] CGColor];
        labelBtn.layer.shadowOffset = CGSizeMake(.1, .5);
        [labelBtn setTitle:hotData[i] forState:UIControlStateNormal];
        labelBtn.titleLabel.font = [UIFont fontWithName:@"heiti" size:14.0f];
        labelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        labelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        labelBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        labelBtn.titleLabel.numberOfLines = 2;
        [labelBtn addTarget:self action:@selector(labelClickAction:) forControlEvents:UIControlEventTouchUpInside];
        labelBtn.frame = CGRectMake(15, 42, BTN_WIDTH, BTN_HEIGHT);
        if (i % 3 == 0) {
            labelBtn.frame = CGRectMake(15, 42 + 55*(i/3), BTN_WIDTH, BTN_HEIGHT);
        }
        else if(i % 3 == 1){
            labelBtn.frame = CGRectMake(25 + BTN_WIDTH, 42 + 55*(i/3) , BTN_WIDTH, BTN_HEIGHT);
        }
        else{
            labelBtn.frame = CGRectMake(35 + BTN_WIDTH * 2, 42 + 55*(i/3), BTN_WIDTH, BTN_HEIGHT);
        }
        
//        if (i % 3 == 0) {
//            labelBtn.center = CGPointMake(15 + BTN_WIDTH/2, 35 + 55*(i/3) + BTN_HEIGHT/2);
//        }
//        else if(i % 3 == 1){
//            labelBtn.center = CGPointMake(25 + BTN_WIDTH/2 + BTN_WIDTH, 35 + 55*(i/3) + BTN_HEIGHT/2);
//        }
//        else{
//            labelBtn.center = CGPointMake(35 + BTN_WIDTH/2 + BTN_WIDTH * 2, 35 + 55*(i/3) + BTN_HEIGHT/2);
//        }
        
        [self.hotLabelView addSubview:labelBtn];
        if (i == hotData.count - 1) {
            rect = labelBtn.frame;
        }
    }
    self.hotLabelView.frame = CGRectMake(10, 13, 300, CGRectGetMaxY(rect)+15);
//    self.nomarlLabelView.frame = CGRectMake(10, CGRectGetMaxY(self.hotLabelView.frame)+10, 300, 120);
    [self makeNormalView];
}
- (void)makeNormalView{
    
    UserInformation *userInfo = [UserInformation downloadDatadefaultManager];
    NSData *aData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectAreaFileName]];
    self.area = userInfo._areaArray.count>0 ? userInfo._areaArray : (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:aData];
    NSData *iData = [NSData dataWithContentsOfFile:[[AppTools getSandboxOfDocuments] stringByAppendingPathComponent:kProjectIndFileName]];
    self.industry = userInfo._indArray.count>0 ? userInfo._indArray : (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:iData];
    
    self.normalTable = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.hotLabelView.frame)+10, 300, 120) style:UITableViewStylePlain];
    if (IOS_VERSION >= 7.0) {
        self.normalTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    self.normalTable.layer.cornerRadius = 3.0f;
    self.normalTable.layer.shadowRadius = 2.0f;
    self.normalTable.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.normalTable.layer.shadowOffset = CGSizeMake(0, 0);
    self.normalTable.layer.shadowOpacity = 1;
    self.normalTable.backgroundColor = [UIColor whiteColor];
    self.normalTable.delegate = self;
    self.normalTable.dataSource = self;
    self.normalTable.bounces = NO;
    [self.bgScrollView addSubview:self.normalTable];
    if (self.nomarlLabelView.frame.origin.y + 120 > kScreenHeight - ORIGIN_Y - TabBarViewHeight) {
        self.bgScrollView.contentSize = CGSizeMake(320, self.normalTable.frame.origin.y + 120 + 10);
    }
}
#pragma mark - UITableViewDatasource & delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 41;
    }
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    static NSString *cellIdentier = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentier];
    }
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 42, 21)];
        nameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        nameLabel.text = @"常用";
        nameLabel.textColor = [AppTools colorWithHexString:@"#949494"];
        [cell.contentView addSubview:nameLabel];
        UIView *sepratorLine = [[UIView alloc]initWithFrame:CGRectMake(60, 12, 1, 16)];
        sepratorLine.backgroundColor = [AppTools colorWithHexString:@"#6c6a6a"];
        [cell.contentView addSubview:sepratorLine];
        
        UIButton *latestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [latestBtn setTitle:@"最新资源" forState:UIControlStateNormal];
        latestBtn.frame = CGRectMake(70, 5, 80, 30);
        latestBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [latestBtn setTitleColor:[AppTools colorWithHexString:@"#3e3e3e"] forState:UIControlStateNormal];
        [latestBtn setTitleColor:[AppTools colorWithHexString:@"#4b72b3"] forState:UIControlStateSelected];
        latestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [latestBtn setBackgroundColor:[AppTools colorWithHexString:@"#eaeaea"]];
        latestBtn.layer.cornerRadius = 12.0f;
        latestBtn.tag = 100;
        [latestBtn addTarget:self action:@selector(latestClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:latestBtn];
        
        UIButton *intrestedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        intrestedBtn.frame = CGRectMake(170, 5, 80, 30);
        [intrestedBtn setTitle:@"最感兴趣" forState:UIControlStateNormal];
        [intrestedBtn setBackgroundColor:[UIColor grayColor]];
        intrestedBtn.layer.cornerRadius = 12.0f;
        intrestedBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [intrestedBtn setTitleColor:[AppTools colorWithHexString:@"#3e3e3e"] forState:UIControlStateNormal];
        [intrestedBtn setTitleColor:[AppTools colorWithHexString:@"#4b72b3"] forState:UIControlStateSelected];
        intrestedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [intrestedBtn setBackgroundColor:[AppTools colorWithHexString:@"#eaeaea"]];
        intrestedBtn.tag = 101;
        [intrestedBtn addTarget:self action:@selector(latestClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:intrestedBtn];
        
        return cell;
    }
    else{
        FiltrateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FiltrateTableViewCell" owner:nil options:nil] lastObject];
            cell.delegate  = self;
        }
        if (indexPath.row == 1) {
            cell.nameLabel.text = @"行业";
            
            [cell configureWithIndustryItems:self.industry];
            
        }
        else{
            cell.nameLabel.text = @"地区";
            [cell configureWithAreaItems:self.area];
        }
        return cell;
    }
    
}

- (void)finishClickButtonWithUrl:(NSString *)urlStr andCellIndex:(NSInteger)index{
    if (index == 1) {
        FiltrateTableViewCell *cell = (FiltrateTableViewCell *)[self.normalTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        for (UIButton *button in cell.bgScrollView.subviews) {
            NSLog(@"%@",button);
            if ([button isKindOfClass:[UIButton class]]) {
                if (button.selected == YES) {
                    button.selected = NO;
                }
            }
           
        }
    }
    else{
        FiltrateTableViewCell *cell = (FiltrateTableViewCell *)[self.normalTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        for (UIButton *button in cell.bgScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) {
                if (button.selected == YES) {
                    button.selected = NO;
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Resoucequeding" object:nil userInfo:@{@"url":urlStr}];
}
#pragma mark - ClickActions
- (void)labelClickAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    [self.delegate sendBackWithKeyword:btn.titleLabel.text andTag:nil];
}
- (void)latestClick:(UIButton *)btn{
    UITableViewCell *cell = [self.normalTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (btn.tag == 100) {
        UIButton * button = (UIButton *)[cell.contentView viewWithTag:101];
        button.selected = NO;
        if (btn.selected == NO) {
            btn.selected = YES;
        }
    }
    if (btn.tag == 101) {
        UIButton * button = (UIButton *)[cell.contentView viewWithTag:100];
        button.selected = NO;
        if (btn.selected == NO) {
            btn.selected = YES;
        }
    }
   
    [self.delegate searchDirectWithType:btn.tag - 100];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.delegate sendResignFirstResponder];
}
- (void)clearTagColor{
    [self.normalTable reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
