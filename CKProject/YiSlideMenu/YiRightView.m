//
//  YiRightView.m
//  YiSlideMenu
//
//  Created by coderyi on 15/3/8.
//  Copyright (c) 2015年 www.coderyi.com. All rights reserved.
//

#import "YiRightView.h"
#import "HttpHelper.h"
#import "SettingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YiRightView ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
    NSArray *dataArray;
    NSArray *imageArray;
    
    UIImageView *girlImageView;
    UIImageView *boyImageView;
    
    NSString *phone;
    NSString *username;
    NSNumber *sex;
    NSString *logo;
    NSString *address;
    
    UILabel *userLabel;
}

@end
@implementation YiRightView

- (id)initWithFrame:(CGRect)frame
{
    phone=@"";
    dataArray=[[NSArray alloc]initWithObjects:@"我的优惠券",@"性别",@"修改密码",@"电话",@"地址",@"联系我们",@"设置",@"退出登录", nil];
    imageArray=[[NSArray alloc]initWithObjects:@"ticket-",@"gender",@"password",@"phone",@"Location",@"contact",@"Settings-",@"LogOut", nil];
    self = [super initWithFrame:frame];
    if (self) {
        float viewWidth=frame.size.width;
        float viewHeight=frame.size.height;
        [self setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];

        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/2)];
        
       [headerView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
        userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(viewWidth*3/8, 0, viewWidth/4,viewWidth/4)];
        userImageView.layer.masksToBounds = YES;
        userImageView.layer.borderWidth=2;
        [userImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        userImageView.layer.cornerRadius = (userImageView.frame.size.width) / 2;
        [userImageView setImage:[UIImage imageNamed:@"logo"]];
        
        [headerView addSubview:userImageView];
        
        userLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, userImageView.frame.size.height+userImageView.frame.origin.y+10, viewWidth, 20)];
        [userLabel setText:@"Amy"];
        [userLabel setTextAlignment:NSTextAlignmentCenter];
        [userLabel setTextColor:[UIColor whiteColor]];
        [userLabel setFont:[UIFont systemFontOfSize:15]];
        [headerView addSubview:userLabel];
        [headerView setFrame:CGRectMake(0, 0, viewWidth, userLabel.frame.size.height+userLabel.frame.origin.y+15)];
        
        tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,20, viewWidth, viewHeight-64) style:UITableViewStylePlain];
        [self addSubview:tableView];
        tableView.dataSource=self;
        tableView.delegate=self;
        if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        tableView.showsVerticalScrollIndicator=NO;
        tableView.separatorStyle = NO;
        [tableView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
        [tableView setTableHeaderView:headerView];


    }
    return self;
}
-(void)setUserPhone:(NSString *)_phone{
    phone=_phone;
    [tableView reloadData];
}
-(void)setData:(NSDictionary *)dic{
    phone=[NSString stringWithFormat:@"%@",[dic objectForKey:@"tel"]];
    username=[NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
    sex=[dic objectForKey:@"sex"];
    address=[NSString stringWithFormat:@"%@",[dic objectForKey:@"addr"]];
    [userLabel setText:username];
    if ([dic objectForKey:@"logo"] && ![[dic objectForKey:@"logo"] isEqual:[NSNull null]]) {
        logo=[dic objectForKey:@"logo"];
        if (![logo isEqualToString:@""]) {
            [userImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
        }
    }
    [tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"CustomCell";
    NSLog(@"cellForRowAtIndexPath%ld",(long)[indexPath row]);
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SettingCell"owner:self options:nil]lastObject];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    [cell.titleLabel setText:[dataArray objectAtIndex:[indexPath row]]];
    [cell.logoImage setImage:[UIImage imageNamed:[imageArray objectAtIndex:[indexPath row]]]];
    [cell.rightView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    if([indexPath row]==1){
        UIButton *switchButton = [[UIButton alloc] initWithFrame:CGRectMake(cell.rightView.frame.size.width-10-38,  cell.rightView.frame.size.height/4, 38, 21)];
        [switchButton setUserInteractionEnabled:YES];
        [switchButton setBackgroundColor:[UIColor whiteColor]];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        [switchButton.layer setCornerRadius:11];
        //19 × 19
        girlImageView=[[UIImageView alloc]initWithFrame:CGRectMake(switchButton.frame.size.width-19, switchButton.frame.size.height/2-19/2, 19, 19)];
        [girlImageView setImage:[UIImage imageNamed:@"me_female_icon"]];
        [switchButton addSubview:girlImageView];
        
        boyImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, switchButton.frame.size.height/2-19/2, 19, 19)];
        [boyImageView setImage:[UIImage imageNamed:@"me_male_icon"]];
        [boyImageView setHidden:YES];
        [switchButton addSubview:boyImageView];
        if(sex!=nil){
            if([sex intValue]==1){
                [boyImageView setHidden:NO];
                [girlImageView setHidden:YES];
            }else{
                [boyImageView setHidden:YES];
                [girlImageView setHidden:NO];
            }
        }
    
        [cell.rightView addSubview:switchButton];
        
    }else if([indexPath row]==3){
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.rightView.frame.size.width-10, cell.rightView.frame.size.height)];
        [label setText:phone];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentRight];
        [cell.rightView addSubview:label];

        
    }else{//Chevron_ic-2
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(cell.rightView.frame.size.width-9-10, cell.rightView.frame.size.height/2-17/2, 9, 17)];
        [image setImage:[UIImage imageNamed:@"Chevron_ic-2"]];
        [cell.rightView addSubview:image];
    }

    // [cell.titleLabel setText:@"123"];
    return cell;
}

-(void)switchAction:(id)sender
{
    UIButton *switchButton = (UIButton*)sender;
    BOOL isButtonOn = switchButton.selected;
    [_delegate switchBtn:switchButton.selected];
    if (isButtonOn) {
        [boyImageView setHidden:YES];
        [girlImageView setHidden:NO];

        NSLog(@"isButtonOn TRUE");
    }else {
        [girlImageView setHidden:YES];
        [boyImageView setHidden:NO];
        NSLog(@"isButtonOn FALSE");
    }
    switchButton.selected=!switchButton.selected;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_delegate respondsToSelector:@selector(rightDidSelectRowAtIndexPath:)]) {
        [_delegate rightDidSelectRowAtIndexPath:indexPath];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
