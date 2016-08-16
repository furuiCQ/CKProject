//
//  SortViewController.m
//  CKProject
//
//  Created by furui on 15/12/1.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "SortViewController.h"
#import "ProjectTableCell.h"
#import "ProjectListViewController.h"
#import "OrganismListViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomLabel.h"
#import "ProgressHUD/ProgressHUD.h"
@interface SortViewController
()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *tableArray;
    UILabel *titleLabel;
    NSString *str1;
    
    NSMutableArray *selcedIdArray;
    NSArray *selectImageArray;
    NSIndexPath *selectIndex;
    NSArray *normalImageArray;
    
}

@end

@implementation SortViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize tabArray;
@synthesize bottomHeight;
@synthesize projectTableView;
@synthesize orgTableView;
@synthesize httpProjectArray;
@synthesize projectDictionary;
@synthesize httpOrgArray;
@synthesize orgDictionary;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    [ProgressHUD show:@"加载中"];
    [self initTitle];
    [self initSwitchBtn];
    tableArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",nil];
    selcedIdArray=[[NSMutableArray alloc]init];
    selectImageArray=[NSArray arrayWithObjects:@"dance_pressed_ic",@"Language_pressed_ic",@"sports_pressed_ic",@"music_pressed_ic",@"Vocational-and-technical_pressed_ic",@"Wushu_pressed_ic" ,@"paint_pressed_ic" ,@"open-book_pressed_ic" ,@"Health-and-beauty_pressed_ic" ,@"classroom_pressed_ic" ,@"Study-abroad_pressed_ic",nil];
    normalImageArray=[NSArray arrayWithObjects:@"dance_nor_ic",@"Language_nor_ic",@"sports_nor_ic",@"music_nor_ic",@"Vocational-and-technical_nor_ic",@"Wushu_nor_ic" ,@"paint_nor_ic",@"open-book_nor_ic" ,@"Health-and-beauty_nor_ic" ,@"classroom_nor_ic" ,@"Study-abroad_nor_ic",nil];
    [self initProjectTableView];
    [self initOrgTableView];
    [projectTableView setHidden:NO];
    [orgTableView setHidden:YES];
    [self getLessonGroup];
    [self getInstList];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)getData
{
    NSArray *zjArray=[NSArray arrayWithObjects:@"早教",nil];
    NSArray *musciArray=[NSArray arrayWithObjects:@"钢琴",@"打击乐器",@"弦乐器",@"管乐器",@"声乐",@"古典乐器",@"其他",nil];
    NSArray *yyArray=[NSArray arrayWithObjects:@"英语",@"日语",@"书法",@"国学",@"其他",nil];
    NSArray *ydArray=[NSArray arrayWithObjects:@"足球",@"篮球",@"网球",@"高尔夫球",@"马术",@"壁球",@"击剑",@"跆拳道",@"武术",@"早教运动",@"其他",nil];
    NSArray *acArray=[NSArray arrayWithObjects:@"美术",@"表演",@"主持",@"舞蹈",@"摄影",@"其他",nil];
    NSArray *tbArray=[NSArray arrayWithObjects:@"小学",@"初中",@"高中",@"其他",nil];
    NSArray *bkArray=[NSArray arrayWithObjects:@"出国备考",@"艺术备考",@"其他",nil];
    NSArray *jnArray=[NSArray arrayWithObjects:@"平面设计",@"程序开发",@"其他",nil];
    NSArray *jzArray=[NSArray arrayWithObjects:@"健身房",@"美颜保养",@"瘦身",@"其他",nil];
    
    projectDictionary=[[NSMutableArray alloc]init];
    
    [projectDictionary addObject:@"早教"];
    [projectDictionary addObject:@"音乐类"];
    [projectDictionary addObject:@"语言/国学"];
    [projectDictionary addObject:@"运动类"];
    [projectDictionary addObject:@"艺术类"];
    [projectDictionary addObject:@"同步课堂"];
    [projectDictionary addObject:@"备考类"];
    [projectDictionary addObject:@"设计/技能"];
    [projectDictionary addObject:@"家长汇"];
    
    orgDictionary=[[NSMutableArray alloc]init];
    
    [orgDictionary addObject:zjArray];
    [orgDictionary addObject:musciArray];
    [orgDictionary addObject:yyArray];
    [orgDictionary addObject:ydArray];
    [orgDictionary addObject:acArray];
    [orgDictionary addObject:tbArray];
    [orgDictionary addObject:bkArray];
    [orgDictionary addObject:jnArray];
    [orgDictionary addObject:jzArray];
    
}

//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    [cityLabel setBackgroundColor:[UIColor greenColor]];
    [cityLabel setText:@"未知"];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"分类"];
    [searchLabel setTextColor:[UIColor whiteColor]];
    //新建右上角的图形
    msgLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-self.view.frame.size.width/6, 0, self.view.frame.size.width/6, titleHeight)];
    [msgLabel setBackgroundColor:[UIColor greenColor]];
    [msgLabel setText:@"未知"];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    
    //[titleView addSubview:cityLabel];
    //[titleView addSubview:msgLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
    
    
}

-(void)initSwitchBtn{
    int width=self.view.frame.size.width;
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight+20+0.5, width, titleHeight*3/4)];
    [topView setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
    [self.view addSubview:topView];
    NSArray *array = [NSArray arrayWithObjects:@"体验课",@"机构", nil];
    tabArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[array count]; i++) {
        TopBar *topBar=[[TopBar alloc]initWithFrame:CGRectMake(width/[array count]*i, 0, width/[array count], titleHeight)];
        [topBar addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBar setTag:i];
        [topBar setText:[array objectAtIndex:i]];
        [topBar initView];
        if(i==[array count]-1){
            [topBar setIsEnd:YES];
        }
        if(i==0){
            [topBar setChecked:YES];
            [topBar setIconColor:[UIColor colorWithRed:1.0 green:77.f/255.f blue:77.f/255.f alpha:1.0]];
            [topBar setTextColor:[UIColor colorWithRed:1.0 green:77.f/255.f blue:77.f/255.f alpha:1.0]];
        }else{
            [topBar setChecked:NO];
            [topBar setIconColor:[UIColor blackColor]];
            [topBar setTextColor:[UIColor blackColor]];
            
        }
        [topBar setLabelFont:[UIFont systemFontOfSize:width/22.8]];
        [topBar setLineViewFill];
        [topView addSubview:topBar];
        [tabArray addObject:topBar];
    }
}
-(void)onClick:(id)sender{
    TopBar *topBar=(TopBar *)sender;
    for (NSObject *object in tabArray) {
        TopBar *b=(TopBar *)object;
        if(b.tag!=topBar.tag){
            [b setChecked:NO];
            [b setIconColor:[UIColor blackColor]];
            [b setTextColor:[UIColor blackColor]];
        }else{
            [b setChecked:YES];
            [b setIconColor:[UIColor colorWithRed:1.0 green:77.f/255.f blue:77.f/255.f alpha:1.0]];
            [b setTextColor:[UIColor colorWithRed:1.0 green:77.f/255.f blue:77.f/255.f alpha:1.0]];
            
        }
    }
    switch (topBar.tag) {
        case 0:
        {
            [projectTableView setHidden:NO];
            [orgTableView setHidden:YES];
            [projectTableView reloadData];
            
            
        }
            break;
        case 1:
        {
            [orgTableView reloadData];
            [orgTableView setHidden:NO];
            [projectTableView setHidden:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)initProjectTableView{
    bottomHeight=49;
    
    projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  titleHeight+20+0.5+titleHeight*3/4
                                                                  ,
                                                                  self.view.frame.size.width,
                                                                  self.view.frame.size.height-(titleHeight+20+0.5+titleHeight*3/4)-bottomHeight)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [projectTableView setBackgroundColor:[UIColor whiteColor]];
    projectTableView.dataSource                        = self;
    projectTableView.delegate                          = self;
    projectTableView.rowHeight                         = self.view.bounds.size.height/7;
    projectTableView.separatorStyle = NO;
    projectTableView.tag=0;
    [self.view addSubview:projectTableView];
}
-(void)initOrgTableView{
    bottomHeight=49;
    
    orgTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,
                                                              titleHeight+20+0.5+titleHeight*3/4,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height-(titleHeight+20+0.5+titleHeight*3/4)-bottomHeight)];
    NSLog(@"%f",self.tabBarController.view.frame.size.height);
    [orgTableView setBackgroundColor:[UIColor whiteColor]];
    orgTableView.dataSource                        = self;
    orgTableView.delegate                          = self;
    orgTableView.rowHeight                         = self.view.bounds.size.height/7;
    orgTableView.tag=1;
    
    [self.view addSubview:orgTableView];
}


#pragma mark - 数据源方法
#pragma mark 返回分组数
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //  NSLog(@"计算每组(组%i)行数",section);
    //  KCContactGroup *group1=_contacts[section];
    
    if (tableView.tag==0) {
        if ([httpProjectArray count]>0 && httpProjectArray!=nil) {
            return [httpProjectArray count];
        }
        return [projectDictionary count];
    }else{
        if ([httpOrgArray count]>0 && httpOrgArray!=nil) {
            return [httpProjectArray count];
        }
        return [orgDictionary count];
    }
}
#pragma mark - UIView animation
//Spring Animation
- (void)dismisAnimation{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
//                //UIView animate动画:仿钉钉弹出添加按钮,从顶部弹到指定位置
//                [UIView animateWithDuration:1.f delay:0.02*(btn.tag) usingSpringWithDamping:0.6f initialSpringVelocity:1.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    btn.frame = CGRectMake(btn.frame.origin.x, -300, btn.frame.size.width,btn.frame.size.height);
//                } completion:^(BOOL finished) {
//                }];
//   });
}
-(void)showAnimation{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
//        //UIView animate动画:仿钉钉弹出添加按钮,从顶部弹到指定位置
//        [UIView animateWithDuration:1.f delay:(0.2-0.02*(btn.tag)) usingSpringWithDamping:1.0f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            btn.frame = CGRectMake(btn.frame.origin.x, (y+paddingHeight+width/9.1)*(btn.tag), btn.frame.size.width,btn.frame.size.height);
//        } completion:^(BOOL finished) {
//        }];
//    });
//
}
#pragma mark返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath是一个结构体，记录了组和行信息
    UITableViewCell *cell;
    
    if (tableView.tag==0) {
        cell  = [[SortProjectListTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        int width=self.view.frame.size.width;
        SortProjectListTableCell *dataCell=(SortProjectListTableCell *)cell;
        NSDictionary *projectDic=[httpProjectArray objectAtIndex:[indexPath row]];
        if ([projectDic objectForKey:@"logo"] && ![[projectDic objectForKey:@"logo"] isEqual:[NSNull null]]) {
            NSString *logo=[projectDic objectForKey:@"logo"];
            if(logo!=nil && ![logo isEqualToString:@""]&& ![logo isEqual:[NSNull null]])
            {
                [dataCell.logoImage sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                
            }else{
                [dataCell.logoImage setImage:[UIImage imageNamed:@"instlist_defalut"]];
            }
        }else{
            [dataCell.logoImage setImage:[UIImage imageNamed:@"instlist_defalut"]];
        }
        [dataCell.titleLabel setText:[NSString stringWithFormat:@"%@",[[httpProjectArray objectAtIndex:[indexPath row]]objectForKey:@"title"]]];
        
        NSInteger number=0;
        if ([httpProjectArray count]>0 && httpProjectArray!=nil) {
            NSArray *lesson=[[httpProjectArray objectAtIndex:[indexPath row]]objectForKey:@"lesson_group"];
            number=[lesson count];
        }else{
            number=[[orgDictionary objectAtIndex:[indexPath row]] count];
        }
        UITapGestureRecognizer *allGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAllPorjectListViewController:)];
        [dataCell.moreLabel addGestureRecognizer:allGesture];
        [dataCell.moreLabel setTag:[indexPath row]];
        bool isSelected=false;
        if([selectIndex row] ==[indexPath row]){
            if([selcedIdArray count]>0){
                isSelected=true;
            }
        }
        for (int i=0; i<number; i++) {
            int paddingheight=width/45.7;//每组的高度
            int offset=width/4.2;
            int paddingwidth=width/16;
            int controlWidth=width/5.7;
            int controlHeight=width/12.5;
            UIControl *control=[[UIControl alloc]init];
            float y=0;
            float x=0;
            x=offset+(paddingwidth+controlWidth)*(i%3);
            y=(paddingheight+controlHeight)*(i/3)+dataCell.titleLabel.frame.size.height+dataCell.titleLabel.frame.origin.y+paddingwidth;
            [control setFrame:CGRectMake(x, y, width/5.7, width/12.5)];
            
            if ([httpProjectArray count]>0 && httpProjectArray!=nil) {
                NSArray *lesson=[[httpProjectArray objectAtIndex:[indexPath row]]objectForKey:@"lesson_group"];
                str1=[[lesson objectAtIndex:i]objectForKey:@"title"];
            }else{
                str1=[[orgDictionary objectAtIndex:[indexPath row]]objectAtIndex:i];
                
            }
            //111*51
            CustomLabel *itemLabel=[[CustomLabel alloc]initWithFrame:CGRectMake(0, 0, width/5.7, width/12.5)];
            UITapGestureRecognizer *getsture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goProjectListViewController:)];
            [itemLabel addGestureRecognizer:getsture];
            [itemLabel setUserInteractionEnabled:YES];
            [itemLabel setSuperID:(int)[indexPath row]];
            [itemLabel setSubID:i];
            [itemLabel setText:str1];
            [itemLabel setFont:[UIFont systemFontOfSize:width/35.5]];
            [itemLabel setTextAlignment:NSTextAlignmentCenter];
            [itemLabel setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
            itemLabel.layer.masksToBounds=YES;
            itemLabel.layer.cornerRadius=3;
            itemLabel.layer.borderColor=[UIColor colorWithRed:237.f/255.f green:237.f/255.f blue:237.f/255.f alpha:1.0].CGColor;
            itemLabel.layer.borderWidth=1;
            [itemLabel setFrame:CGRectMake((control.frame.size.width-itemLabel.frame.size.width)/2, 0, itemLabel.frame.size.width, itemLabel.frame.size.height)];
            [itemLabel setBackgroundColor:[UIColor colorWithRed:248.f/255.f green:248.f/255.f blue:248.f/255.f alpha:1.0]];
            if(isSelected==true){
                [control addSubview:itemLabel];
                [dataCell addSubview:control];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
//                    //UIView animate动画:仿钉钉弹出添加按钮,从顶部弹到指定位置
//                    [UIView animateWithDuration:1.f delay:(0.2-0.02*(i)) usingSpringWithDamping:1.0f initialSpringVelocity:15.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        CGRect frame=cell.frame;
//                        frame.size.height=control.frame.origin.y+control.frame.size.height+width/26.7;
//                        cell.frame=frame;
//                    } completion:^(BOOL finished) {
//                    }];
//                });
                
                [dataCell.titleLabel setTextColor:[UIColor colorWithRed:255.f/255.f green:82.f/255.f blue:82.f/255.f alpha:1.0]];
                [dataCell.moreLabel setTextColor:[UIColor colorWithRed:50.f/255.f green:60.f/255.f blue:63.f/255.f alpha:1.0]];
                [cell setBackgroundColor:[UIColor colorWithRed:234.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0]];
                [dataCell.goImage setImage:[UIImage imageNamed:@"arrow_light"]];
                [dataCell.logoImage setImage:[UIImage imageNamed:[selectImageArray objectAtIndex:[indexPath row]]]];
            }else{
                [cell setBackgroundColor:[UIColor whiteColor]];
                [dataCell.titleLabel setTextColor:[UIColor colorWithRed:50.f/255.f green:60.f/255.f blue:63.f/255.f alpha:1.0]];
                [dataCell.moreLabel setTextColor:[UIColor colorWithRed:50.f/255.f green:60.f/255.f blue:63.f/255.f alpha:1.0]];
                [dataCell.goImage setImage:[UIImage imageNamed:@"arrow"]];
                [dataCell.logoImage setImage:[UIImage imageNamed:[normalImageArray objectAtIndex:[indexPath row]]]];
            }
        }
        //}
    }else if(tableView.tag==1 ){
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSString *str;
        int width=self.view.frame.size.width;
        titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(width/35.6, width/21, width, width/26.7)];
        [titleLabel setFont:[UIFont systemFontOfSize:width/26.7]];
        [cell addSubview:titleLabel];
        NSDictionary *inset=[httpOrgArray objectAtIndex:[indexPath row]];
        
        str= [inset objectForKey:@"title"];
        [titleLabel setText:[NSString stringWithFormat:@"%@",str]];
        UIControl  *moreControl=[[UIControl alloc]initWithFrame:CGRectMake(width-width/10-width/20-width/25, width/21, width/10+width/20, width/16)];
        [moreControl setUserInteractionEnabled:YES];
        [moreControl setTag:[indexPath row]];
        [moreControl addTarget:self action:@selector(onMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, width/10, width/26.7)];
        [moreLabel setText:@"更多"];
        [moreLabel setTextAlignment:NSTextAlignmentCenter];
        [moreLabel setFont:[UIFont systemFontOfSize:width/26.7]];
        UIImageView *rightView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_btn"]];
        //10 × 17
        [rightView setFrame:CGRectMake(width/10, 0, width/35, width/22)];
        [moreControl addSubview:moreLabel];
        [moreControl addSubview:rightView];
        [cell addSubview:moreControl];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y+width/30,width, 0.5)];
        [lineView setBackgroundColor:[UIColor colorWithRed:229.f/255.f green:229.f/255.f blue:229.f/255.f alpha:1.0]];
        [cell addSubview:lineView];
        
        NSArray *instList=[inset objectForKey:@"inst"];
        if ([instList count]>0) {
            for (int i=0; i<[instList count]; i++) {
                float x=0;
                float y=0;
                x=width/21+(width*3/7+width/23)*(i%2);
                y=width/21+lineView.frame.origin.y+width/35.6+(width/3.8+width/23)*((int)(i/2));
                NSDictionary *inst=[instList objectAtIndex:i];
                UIView *line2View;
                if(i==2){
                    line2View=[[UIView alloc]initWithFrame:CGRectMake(0, y,width, width/40)];
                    [line2View setBackgroundColor:[UIColor colorWithRed:241.f/255.f green:243.f/255.f blue:247.f/255.f alpha:1.0]];
                    [cell addSubview:line2View];
                }
                if(i==2){
                    y=line2View.frame.size.height+y+width/32;
                }
                if(i==3){
                    y=line2View.frame.size.height+y+width/16;
                }
                
                UIImageView *instImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y, width*3/7, width/3.8)];
                //  instImageView.layer.masksToBounds = YES;
                //  instImageView.layer.cornerRadius = 3.0f;
                UITapGestureRecognizer *getsture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goOrganDetialsViewController:)];
                [instImageView addGestureRecognizer:getsture];
                [instImageView setUserInteractionEnabled:YES];
                NSNumber *orgId=[[instList objectAtIndex:i]objectForKey:@"id"];
                [instImageView setTag:[orgId intValue]];
                UILabel *imageTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, width/3.8-width/15, instImageView.frame.size.width, width/15)];
                [imageTitle setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5]];
                [imageTitle setTextAlignment:NSTextAlignmentCenter];
                [imageTitle setFont:[UIFont boldSystemFontOfSize:width/26.7]];
                [imageTitle setTextColor:[UIColor whiteColor]];
                [imageTitle setText:@"汉昌培训"];
                [instImageView addSubview:imageTitle];
                if ([inst objectForKey:@"biglogo"] && ![[inst objectForKey:@"biglogo"] isEqual:[NSNull null]]) {
                    NSString *logo=[inst objectForKey:@"biglogo"];
                    if(logo!=nil && ![logo isEqualToString:@""]&& ![logo isEqual:[NSNull null]])
                    {
                        [instImageView sd_setImageWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:logo]]];
                        
                    }else{
                        [instImageView setImage:[UIImage imageNamed:@"instlist_defalut"]];
                    }
                }else{
                    [instImageView setImage:[UIImage imageNamed:@"instlist_defalut"]];
                }
                
                if ([inst objectForKey:@"title"] && ![[inst objectForKey:@"title"] isEqual:[NSNull null]]) {
                    [imageTitle setText:[NSString stringWithFormat:@"%@",[inst objectForKey:@"title"]]];
                    
                }
                [cell addSubview:instImageView];
                if (i==[instList count]-1) {
                    CGRect frame=cell.frame;
                    frame.size.height=instImageView.frame.origin.y+instImageView.frame.size.height+width/22.8;
                    cell.frame=frame;
                }
                
            }
        }
        
    }
    return cell;
}
-(void)onMoreClick:(id)sender{
    
    //    NSString *ct=[inst objectForKey:@"title];
    //    NSUserDefaults *st=[NSUserDefaults standardUserDefaults];
    //    [st setObject:ct forKey:@"biname"];
    
    UIControl *control=(UIControl *)sender;
    int indexrow=(int)control.tag;
    OrganismListViewController *organismListViewController=[[OrganismListViewController alloc]init];
    NSDictionary *dic=[httpOrgArray objectAtIndex:indexrow] ;
    NSNumber *orgId=[dic objectForKey:@"id"];
    
    NSString *cb=[dic objectForKey:@"title"];
    NSUserDefaults *st=[NSUserDefaults standardUserDefaults];
    [st setObject:cb forKey:@"biname"];
    
    [organismListViewController setProjectID:orgId];
    [self presentViewController:organismListViewController animated:YES completion:nil];
}
-(void)goOrganDetialsViewController:(UITapGestureRecognizer *)gestrue{
    NSNumber *orgID=[NSNumber numberWithInt:(int)(gestrue.view.tag)];
    
    OrganDetailsViewController *projectListViewController=[[OrganDetailsViewController alloc]init];
    [projectListViewController setAritcleId:orgID];
    [self presentViewController:projectListViewController animated:YES completion:nil];
    
    
}
-(void)goAllPorjectListViewController:(UITapGestureRecognizer *)gestrue{
    NSLog(@"goAllPorjectListViewController");
        UIView *view=gestrue.view;
        int tag=(int)view.tag;
        ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
        NSDictionary *dic=[httpProjectArray objectAtIndex:tag] ;
        NSNumber *orgId=[dic objectForKey:@"id"];
        NSString *title=[dic objectForKey:@"title"];
        [projectListViewController setProjectID:orgId];
        [projectListViewController setProjectSubID:[NSNumber numberWithInt:0]];
        [projectListViewController setTitleName:title];
        [self presentViewController:projectListViewController animated:YES completion:nil];
}
-(void)goProjectListViewController:(UITapGestureRecognizer *)gestrue{
    CustomLabel *label=(CustomLabel *)gestrue.view;
    ProjectListViewController *projectListViewController=[[ProjectListViewController alloc]init];
    NSDictionary *dic=[httpProjectArray objectAtIndex:label.superID] ;
    NSNumber *orgId=[dic objectForKey:@"id"];
    
    NSArray *lesson=[dic objectForKey:@"lesson_group"];
    NSDictionary *data=[lesson objectAtIndex:label.subID];
    NSNumber *subId=[data objectForKey:@"id"];
    [projectListViewController setTitleName:label.text];
    NSLog(@"str1----------\n\n\n%@",str1);
    [projectListViewController setProjectID:orgId];
    [projectListViewController setProjectSubID:subId];
    [self presentViewController:projectListViewController animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    if (tableView.tag==0) {
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        selectIndex=indexPath;
        if([selcedIdArray count]>0){
            NSIndexPath *lastPath=[selcedIdArray objectAtIndex:0];
            if(lastPath==indexPath){
                [selcedIdArray removeAllObjects];
            }else{
                [selcedIdArray insertObject:selectIndex atIndex:0];
            }
        }else{
            [selcedIdArray insertObject:selectIndex atIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    if (tableView.tag==0) {
        cell = [self tableView:projectTableView cellForRowAtIndexPath:indexPath];
        
    }else if(tableView.tag==1){
        cell = [self tableView:orgTableView cellForRowAtIndexPath:indexPath];
    }
    return cell.frame.size.height;
    
}
-(void)getLessonGroup{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getLessonGroup:self success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    httpProjectArray=(NSArray *)model.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [projectTableView reloadData];
                    });
                    
                    
                }else{
                    
                }
                [ProgressHUD dismiss];
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
                [ProgressHUD dismiss];
                
            }
        }];
        
        
    });
}
-(void)getInstList{
    static NSString * const DEFAULT_LOCAL_AID = @"500100";
    NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
    NSNumber *aid=[formatter numberFromString:DEFAULT_LOCAL_AID];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [HttpHelper getInsetList:aid success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                    httpOrgArray=(NSArray *)model.result;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [orgTableView reloadData];
                    });
                }else{
                    
                }
                
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
        }];
        
        
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end