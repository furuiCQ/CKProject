//
//  YiRightView.m
//  YiSlideMenu
//
//  Created by coderyi on 15/3/8.
//  Copyright (c) 2015年 www.coderyi.com. All rights reserved.
//

#import "YiRightView.h"
#import "SettingCell.h"
@interface YiRightView ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
    NSArray *dataArray;
}

@end
@implementation YiRightView

- (id)initWithFrame:(CGRect)frame
{
    dataArray=[[NSArray alloc]initWithObjects:@"我的优惠券",@"性别",@"修改密码",@"电话",@"地址",@"联系我们",@"设置",@"退出登录", nil];
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
        
        UILabel *userLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, userImageView.frame.size.height+userImageView.frame.origin.y+10, viewWidth, 20)];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"CustomCell";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SettingCell"owner:self options:nil]lastObject];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    [cell.titleLabel setText:[dataArray objectAtIndex:[indexPath row]]];
    // [cell.titleLabel setText:@"123"];
    return cell;
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
