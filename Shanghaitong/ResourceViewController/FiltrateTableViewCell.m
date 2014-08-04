//
//  FiltrateTableViewCell.m
//  Shanghaitong
//
//  Created by xuqiang on 14-7-11.
//  Copyright (c) 2014年 shanghaitong. All rights reserved.
//

#import "FiltrateTableViewCell.h"
#import "indItemInformation.h"
#import "areaItemInformation.h"

@interface FiltrateTableViewCell()
@property (nonatomic,strong)  NSMutableArray *views;
@end

@implementation FiltrateTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Configure Cell
- (void)configureWithAreaItems:(NSMutableArray *)items{
    self.bgScrollView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    self.views = [[NSMutableArray alloc] init];
    for (areaItemInformation *item in items) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont fontWithName:@"heiti" size:14.0f];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        btn.tag = [item.area_id intValue];
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitleColor:[AppTools colorWithHexString:@"#3e3e3e"] forState:UIControlStateNormal];
        [btn setTitleColor:[AppTools colorWithHexString:@"#4b72b3"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickAreaBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.views addObject:btn];
    }
    [self addViews:self.views toScrollView:self.bgScrollView];
}
- (void)configureWithIndustryItems:(NSMutableArray *)items{
    self.bgScrollView.clipsToBounds = YES;
    self.clipsToBounds = YES;
   self.views = [[NSMutableArray alloc] init];
    for (indItemInformation *item in items) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont fontWithName:@"heiti" size:14.0f];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [btn setTitle:item.name  forState:UIControlStateNormal];
        [btn setTitleColor:[AppTools colorWithHexString:@"#3e3e3e"] forState:UIControlStateNormal];
        [btn setTitleColor:[AppTools colorWithHexString:@"#4b72b3"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickIndustryBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1;
        [self.views addObject:btn];
    }
    [self addViews:self.views toScrollView:self.bgScrollView];
}
-(void) addViews:(NSMutableArray *) views toScrollView:(UIScrollView *)scorllView
{
    CGRect rect = CGRectMake(0, 0, 0, 0);
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
- (void)clickAreaBtn:(UIButton *)sender{
    //只移除一次 
    for (UIButton *btn in self.bgScrollView.subviews) {
        if (btn.selected == YES) {
            btn.selected = NO;
            break;
        }
    }
    
    sender.selected = YES;
     NSString *lastString = [NSString stringWithFormat:@"area=%d",sender.tag];
    [MobClick event:@"search" label:[NSString stringWithFormat:@"地区:%@",sender.titleLabel.text]];
     NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",DOMAIN_URL,URL_INDEX61,lastString];
    [self.delegate finishClickButtonWithUrl:urlString andCellIndex:2];
}
#pragma mark - Click
- (void)clickIndustryBtn:(UIButton *)sender{

    for (UIButton *btn in self.bgScrollView.subviews) {
        if (btn.selected == YES) {
           btn.selected = NO;
            break;
        }
    }
    sender.selected = YES;
    NSString *lastString = [NSString stringWithFormat:@"ind=%@",sender.titleLabel.text];
     [MobClick event:@"search" label:[NSString stringWithFormat:@"行业:%@",sender.titleLabel.text]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",DOMAIN_URL,URL_INDEX61,lastString];
    [self.delegate finishClickButtonWithUrl:urlString andCellIndex:1];
}
@end
