//
//  ProjectTimePicker.m
//  CKProject
//
//  Created by furui on 16/8/7.
//  Copyright © 2016年 furui. All rights reserved.
//

#import "ProjectTimePicker.h"
@interface ProjectTimePicker()
{
    NSArray *dataArray;
    NSArray *weekDayArray;
    NSArray *dayLabelArray;
    NSMutableArray *weekDayBtnArray;
    NSMutableArray *morningBtnArray;
    NSMutableArray *afternoonBtnArray;
    NSMutableArray *nightBtnArray;
    NSMutableArray *timeLabelArray;
    
    UIColor *normalColor;
    UIColor *lightColor;
    UIColor *noColor;
    
    NSDictionary *nowdata;
    
    NSMutableDictionary *timeDictionary;
    
    UIView *weekSelectView;
    UIView *nextWeekSelectView;
    UIView *nowWeekView;
    
    NSNumber *weekId;
    NSNumber *weekNum;
    NSString *beginTime;
    UILabel *nextTitleLabel;
    UILabel *titleLabel;
    
    BOOL isNowWeek;
}
@end

@implementation ProjectTimePicker


- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    isNowWeek=YES;
    dataArray=[[NSArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
    weekDayArray=[[NSArray alloc]initWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];
    dayLabelArray=[[NSArray alloc]initWithObjects:@"上午",@"下午",@"晚上",nil];
    weekDayBtnArray=[[NSMutableArray alloc]init];
    morningBtnArray=[[NSMutableArray alloc]init];
    afternoonBtnArray=[[NSMutableArray alloc]init];
    nightBtnArray=[[NSMutableArray alloc]init];
    timeLabelArray=[[NSMutableArray alloc]init];
    timeDictionary=[[NSMutableDictionary alloc]init];
    normalColor=[UIColor blackColor];
    lightColor=[UIColor colorWithRed:1 green:75.f/255.f blue:75.f/255.f alpha:1.0];
    noColor=[UIColor colorWithRed:123.f/255.f green:131.f/255.f blue:146.f/255.f alpha:1.0];
    if (self) {
        
        
        
    }
    return self;
}
-(void)changeDataRes:(NSString *)key{
    NSArray *dic=[nowdata objectForKey:key];
    NSMutableArray *multArray0=[[NSMutableArray alloc]init];
    NSMutableArray *multArray1=[[NSMutableArray alloc]init];
    NSMutableArray *multArray2=[[NSMutableArray alloc]init];
    NSMutableArray *multArray3=[[NSMutableArray alloc]init];
    NSMutableArray *multArray4=[[NSMutableArray alloc]init];
    NSMutableArray *multArray5=[[NSMutableArray alloc]init];
    NSMutableArray *multArray6=[[NSMutableArray alloc]init];
    for(NSDictionary *dmm in dic){
        NSNumber *weeks=[dmm objectForKey:@"weeks"];
        switch ([weeks intValue]) {
            case 0:
            {
                [multArray0 addObject:dmm];
            }
                break;
            case 1:
            {
                [multArray1 addObject:dmm];
                
            }
                break;
            case 2:
            {
                [multArray2 addObject:dmm];
                
            }
                break;
            case 3:
            {
                [multArray3 addObject:dmm];
                
            }
                break;
            case 4:
            {
                [multArray4 addObject:dmm];
                
            }
                break;
            case 5:
            {
                [multArray5 addObject:dmm];
                
            }
                break;
            case 6:
            {
                [multArray6 addObject:dmm];
                
            }
                break;
        }
    }
    [timeDictionary removeAllObjects];
    [timeDictionary setObject:multArray0 forKey:@"0"];
    [timeDictionary setObject:multArray1 forKey:@"1"];
    [timeDictionary setObject:multArray2 forKey:@"2"];
    [timeDictionary setObject:multArray3 forKey:@"3"];
    [timeDictionary setObject:multArray4 forKey:@"4"];
    [timeDictionary setObject:multArray5 forKey:@"5"];
    [timeDictionary setObject:multArray6 forKey:@"6"];
    
    NSLog(@"setData%@",nowdata);

}
-(void)setData:(NSDictionary *)data{
    nowdata=data;
    weekId=[NSNumber numberWithInt:0];
    weekNum=[NSNumber numberWithInt:0];
    beginTime=@"";
    [self changeDataRes:@"now_week"];
    
}
-(void)setWeekDayStatues:(NSString *)str{
    NSDictionary *dic=[nowdata objectForKey:@"list"];
    NSDictionary *weekData=[dic objectForKey:str];
    for(UILabel *label in weekDayBtnArray){
        NSLog(@"%ld",(long)label.tag);
        int tag=(int)label.tag;
        if(tag==0){
            tag=7;
        }
        NSString *str=[NSString stringWithFormat:@"%d",tag];
        NSDictionary *item=[weekData objectForKey:str];
        NSNumber *statues=[item objectForKey:@"status"];
        [label.layer setMasksToBounds:NO];
        [label.layer setBorderColor:[UIColor clearColor].CGColor];

        switch ([statues intValue]) {
            case 1:
                [label setTextColor:[UIColor blackColor]];
                break;
            case 2:
                [label setTextColor:[UIColor grayColor]];
                break;
            default:
                break;
        }
    }
    
    
}
-(void)initView:(CGRect *)frame
{
    CGRect rx = [ UIScreen mainScreen ].bounds;
    int screenWidth=rx.size.width;
    nextWeekSelectView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/14.8, 4, screenWidth-screenWidth/14.8*2, screenWidth/8)];
    [nextWeekSelectView setBackgroundColor:[UIColor colorWithRed:133.f/255.f green:52.f/255.f blue:52.f/255.f alpha:1]];
   // [nextWeekSelectView.layer setCornerRadius:10];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:nextWeekSelectView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = nextWeekSelectView.bounds;
    maskLayer.path = maskPath.CGPath;
    nextWeekSelectView.layer.mask  = maskLayer;
    [self addSubview:nextWeekSelectView];
    //下周            大小：36px   37px
    nextTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(nextWeekSelectView.frame.size.width/2-screenWidth/17.8, screenWidth/22, screenWidth/17.8*2, screenWidth/17.8)];
    [nextTitleLabel setText:@"下周"];
    UITapGestureRecognizer *nextGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setNextMonthDate)];
    [nextTitleLabel setUserInteractionEnabled:YES];
    [nextTitleLabel addGestureRecognizer:nextGesture];
    [nextTitleLabel setFont:[UIFont systemFontOfSize:screenWidth/20]];
    [nextTitleLabel setTextColor:[UIColor colorWithRed:133.f/255.f green:133.f/255.f blue:133.f/255.f alpha:1]];
    [nextTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [nextWeekSelectView addSubview:nextTitleLabel];
    
    UIButton *nextLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/7.2,  nextWeekSelectView.frame.size.height/2-4, 5, 8)];
    [nextLeftButton setImage:[UIImage imageNamed:@"icon_previous"] forState:UIControlStateNormal];
    [nextLeftButton setAlpha:0.7];
    [nextLeftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [nextLeftButton setEnlargeEdge:20];
    [nextWeekSelectView addSubview:nextLeftButton];
    
    UIButton *nextRightButton = [[UIButton alloc] initWithFrame:CGRectMake(nextWeekSelectView.frame.size.width - screenWidth/7.2-10, nextWeekSelectView.frame.size.height/2-4, 5, 8)];
    [nextRightButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [nextRightButton setAlpha:0.7];
    [nextRightButton setEnlargeEdge:20];

    [nextRightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [nextWeekSelectView addSubview:nextRightButton];

    //
    nowWeekView=[[UIView alloc]initWithFrame:CGRectMake(screenWidth/32, screenWidth/8, screenWidth-screenWidth/16, screenWidth/0.9)];
    [nowWeekView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:nowWeekView];
    
    weekSelectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, nowWeekView.frame.size.width, screenWidth/6.5)];
    [weekSelectView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:116.f/255.f blue:116.f/255.f alpha:1.0]];
  //  [weekSelectView.layer setCornerRadius:10];
    maskPath = [UIBezierPath bezierPathWithRoundedRect:weekSelectView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = weekSelectView.bounds;
    maskLayer.path = maskPath.CGPath;
    weekSelectView.layer.mask  = maskLayer;
    [nowWeekView addSubview:weekSelectView];
    //本周            大小：36px   37px
    titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(weekSelectView.frame.size.width/2-screenWidth/17.8, screenWidth/17.8, screenWidth/17.8*2, screenWidth/17.8)];
    [titleLabel setText:@"本周"];
    nextGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setNextMonthDate)];
    [titleLabel setUserInteractionEnabled:YES];
    [titleLabel addGestureRecognizer:nextGesture];
    [titleLabel setFont:[UIFont systemFontOfSize:screenWidth/17.8]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [weekSelectView addSubview:titleLabel];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/7.2, weekSelectView.frame.size.height/2-4, 5, 8)];
    [leftButton setImage:[UIImage imageNamed:@"icon_previous"] forState:UIControlStateNormal];
    [leftButton setEnlargeEdge:20];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [weekSelectView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(weekSelectView.frame.size.width - screenWidth/7.2-10, weekSelectView.frame.size.height/2-4, 5, 8)];
    [rightButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [rightButton setEnlargeEdge:20];
    [rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [weekSelectView addSubview:rightButton];
    
    UIView *timeView=[[UIView alloc]initWithFrame:CGRectMake(0, weekSelectView.frame.size.height+weekSelectView.frame.origin.y, weekSelectView.frame.size.width, nowWeekView.frame.size.height-(weekSelectView.frame.size.height+weekSelectView.frame.origin.y))];
    [timeView setBackgroundColor:[UIColor whiteColor]];
  //  [timeView.layer setCornerRadius:10];
    [nowWeekView addSubview:timeView];
    //s t w s
    for(int i=0;i<[dataArray count];i++){
        NSString *str=[dataArray objectAtIndex:i];
        UILabel *topTitle=[[UILabel alloc]initWithFrame:CGRectMake(weekSelectView.frame.size.width/7*i, weekSelectView.frame.size.height+weekSelectView.frame.origin.y+screenWidth/13.3, weekSelectView.frame.size.width/7, screenWidth/20)];
        [topTitle setText:str];
        [topTitle setTextAlignment:NSTextAlignmentCenter];
        [topTitle setFont:[UIFont systemFontOfSize:screenWidth/20]];
        [topTitle setTextColor:[UIColor colorWithRed:51.f/255.f green:54.f/255.f blue:59.f/255.f alpha:1.0]];
        [nowWeekView addSubview:topTitle];
    }
    //66 65 间隔16
    for(int i=0;i<[weekDayArray count];i++){
        NSString *str=[weekDayArray objectAtIndex:i];
        UILabel *topTitle=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/34*(i+1)+screenWidth/10*i, weekSelectView.frame.size.height+weekSelectView.frame.origin.y+screenWidth/6.4, screenWidth/10, screenWidth/10)];
        [topTitle setText:str];
        [topTitle setFont:[UIFont systemFontOfSize:screenWidth/26.7]];
        [topTitle setTextAlignment:NSTextAlignmentCenter];
        [topTitle setTextColor:[UIColor colorWithRed:123.f/255.f green:131.f/255.f blue:146.f/255.f alpha:1.0]];
        [topTitle.layer setCornerRadius:screenWidth/20];
        [topTitle.layer setMasksToBounds:NO];
        [topTitle setTextColor:[UIColor blackColor]];
        [topTitle.layer setBorderWidth:0];
        [topTitle setTag:i];
        UITapGestureRecognizer *getsure=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weekGesture:)];
        [topTitle addGestureRecognizer:getsure];
        [topTitle setUserInteractionEnabled:YES];
        [nowWeekView addSubview:topTitle];
        [weekDayBtnArray addObject:topTitle];
    }
    for(int i=0;i<[dayLabelArray count];i++){
        //上午
        UILabel *morningLabel=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/18.8,weekSelectView.frame.size.height+weekSelectView.frame.origin.y+screenWidth/3.4+screenWidth/8.5*i+screenWidth/23.7*i, screenWidth/23.7*2, screenWidth/23.7)];
        [morningLabel setText:[dayLabelArray objectAtIndex:i]];
        [morningLabel setTextAlignment:NSTextAlignmentLeft];
        [morningLabel setFont:[UIFont systemFontOfSize:screenWidth/23.7]];
        [nowWeekView addSubview:morningLabel];
    }
    [self initTimeView:@"0"];
    //34px  54px    宽度：492px高度：80px
    UILabel *orderProject=[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/11.8, nowWeekView.frame.size.height-screenWidth/18.8-screenWidth/8, screenWidth/1.3, screenWidth/8)];
    [orderProject setText:@"预约课程"];//大小：32px
    [orderProject setTextColor:[UIColor whiteColor]];
    [orderProject setTextAlignment:NSTextAlignmentCenter];
    [orderProject setBackgroundColor:[UIColor colorWithRed:1 green:99.f/255.f blue:99.f/255.f alpha:1.0]];
    UITapGestureRecognizer *getsure=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(orderGesture:)];
    [orderProject addGestureRecognizer:getsure];
    [orderProject setUserInteractionEnabled:YES];
    [nowWeekView addSubview:orderProject];
    CGRect Tframe=self.frame;
    Tframe.origin.y=Tframe.origin.y+self.frame.size.height-(nowWeekView.frame.size.height+nowWeekView.frame.origin.y);
    Tframe.size.height=nowWeekView.frame.size.height+nowWeekView.frame.origin.y;
     [self setFrame:Tframe];
}
-(void)initTimeView:(NSString *)time {
    if([timeLabelArray count]>0){
        for(UIView *view in timeLabelArray){
            [view removeFromSuperview];
        }
    }
    CGRect rx = [ UIScreen mainScreen ].bounds;
    int screenWidth=rx.size.width;
    //236   宽度：67px高度：19px  50
    int tagA=-1;
    int tagB=-1;
    int tagC=-1;

    NSMutableArray *array=[timeDictionary objectForKey:time];
    for(int i=0;i<[array count];i++){
        NSDictionary *dic=[array objectAtIndex:i];
        NSLog(@"dic====>%@",[dic objectForKey:@"man"]);
        int man=[(NSNumber *)[dic objectForKey:@"man"] intValue];
        int status=[(NSNumber *)[dic objectForKey:@"status"] intValue];
        int paddingwidth=screenWidth/12.8;
        int offset=screenWidth/22;
        int x=offset+(screenWidth/9.5+paddingwidth)*i;
        int y=screenWidth/2.7+weekSelectView.frame.size.height+weekSelectView.frame.origin.y;
        switch (man) {
            case 1:{
                tagA=i;
                y=screenWidth/2.7+weekSelectView.frame.size.height+weekSelectView.frame.origin.y;
            }
                break;
            case 2:{
                if(tagB==-1 && tagA>-1){
                    tagB=i;
                }
                if(tagB==-1 && i==0){//当上午没课时
                    tagB=i;
                }
                y=screenWidth/1.9+weekSelectView.frame.size.height+weekSelectView.frame.origin.y;
                x=offset+(screenWidth/9.5+paddingwidth)*(i-tagB);
            }
                break;
            case 3:{
//                if(i-tagC>=1){
//                    tagC=i;
//                }
                if(tagC==-1){
                    tagC=i;
                }
                
                y=screenWidth/1.4+weekSelectView.frame.size.height+weekSelectView.frame.origin.y;
                x=offset+(screenWidth/9.5+paddingwidth)*(i-tagC);
            }
                break;
        }
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(x,y, screenWidth/6, screenWidth/26.7)];
        [timeLabel setText:[dic objectForKey:@"begintime"]];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setTag:i];
        [timeLabel setFont:[UIFont systemFontOfSize:screenWidth/26.7]];
        UITapGestureRecognizer *getsure=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeGesture:)];
        [timeLabel addGestureRecognizer:getsure];
        [timeLabel setUserInteractionEnabled:YES];
        if(status!=1){
            [timeLabel setTextColor:[UIColor grayColor]];
        }
        [nowWeekView addSubview:timeLabel];
        [timeLabelArray addObject:timeLabel];
    }
    
}

-(void)orderGesture:(UITapGestureRecognizer *)getsure{
    NSLog(@"orderGesture");
    [_pickerDelegate orderClick:weekId withWeekNum:weekNum withBegintime:beginTime];
}
-(void)dismiss{
    [self setHidden:YES];
}
-(void)show{
    [self setHidden:NO];
}
-(void)setPreviousMonthDate{
    for(UILabel *label in timeLabelArray){
        [label removeFromSuperview];
    }
    if(isNowWeek){
        isNowWeek=NO;
        weekId=[NSNumber numberWithInt:1];
        [self changeDataRes:@"next_week"];
        [self setWeekDayStatues:@"next_week"];
        [nextTitleLabel setText:@"本周"];
        [titleLabel setText:@"下周"];
        [self initTimeView:[NSString stringWithFormat:@"%d",[weekNum intValue] ]];
        
    }else{
        isNowWeek=YES;
        weekId=[NSNumber numberWithInt:0];
        [nextTitleLabel setText:@"下周"];
        [titleLabel setText:@"本周"];
        [self changeDataRes:@"now_week"];
        [self setWeekDayStatues:@"now_week"];
        [self initTimeView:[NSString stringWithFormat:@"%d",[weekNum intValue]  ]];
    }
}
-(void)setNextMonthDate{
    NSLog(@"setNextMonthDate");
    for(UILabel *label in timeLabelArray){
        [label removeFromSuperview];
    }
    if(isNowWeek){
        isNowWeek=NO;
        [self changeDataRes:@"next_week"];
        [self setWeekDayStatues:@"next_week"];
        [nextTitleLabel setText:@"本周"];
        [titleLabel setText:@"下周"];
        [self initTimeView:[NSString stringWithFormat:@"%d",[weekNum intValue] ]];

    }else{
        isNowWeek=YES;
        [nextTitleLabel setText:@"下周"];
        [titleLabel setText:@"本周"];
        [self setWeekDayStatues:@"now_week"];
        [self changeDataRes:@"now_week"];
        [self initTimeView:[NSString stringWithFormat:@"%d",[weekNum intValue]  ]];
    }

}
-(void)timeGesture:(UITapGestureRecognizer *)getsure{
    NSInteger *selectId=(NSInteger *)getsure.view.tag;
    for(UILabel *label in timeLabelArray){
        if(label.tag==selectId){
            if(label.textColor !=[UIColor grayColor]){
                beginTime=label.text;
                [label setTextColor:[UIColor colorWithRed:1 green:75.f/255.f blue:75.f/255.f alpha:1.0]];
            }
        }else{
            
            if(label.textColor !=[UIColor grayColor]){
                [label setTextColor:[UIColor blackColor]];
            }
        }
    }
    
}
-(void)weekGesture:(UITapGestureRecognizer *)getsure{
    NSInteger *selectId=(NSInteger *)getsure.view.tag;
    for(UILabel *label in weekDayBtnArray){
        if(label.tag==selectId){
            if(label.textColor !=[UIColor grayColor]){
                [label.layer setMasksToBounds:YES];
                [label setTextColor:[UIColor colorWithRed:1 green:75.f/255.f blue:75.f/255.f alpha:1.0]];
                [label.layer setBorderColor:[UIColor colorWithRed:1 green:75.f/255.f blue:75.f/255.f alpha:1.0].CGColor];
                [label.layer setBorderWidth:2];
                for(UILabel *label in timeLabelArray){
                    [label removeFromSuperview];
                }
                int num=(int)getsure.view.tag;
                weekNum=[NSNumber numberWithInt:num];
                [self initTimeView:[NSString stringWithFormat:@"%d",num ]];

            }
        }else{
            if(label.textColor !=[UIColor grayColor]){
            [label.layer setMasksToBounds:NO];
            [label setTextColor:[UIColor blackColor]];
            [label.layer setBorderWidth:0];
            }
        }
    }
    
}
@end