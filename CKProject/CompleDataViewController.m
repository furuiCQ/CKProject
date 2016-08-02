//
//  CompleDataViewController.m
//  CKProject
//
//  Created by furui on 15/12/11.
//  Copyright © 2015年 furui. All rights reserved.
//

#import "CompleDataViewController.h"
#import "HttpHelper.h"
@interface CompleDataViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@property NSNumber *selectProvId;
@property NSNumber *selectCityId;
@property NSString *localData;

@end

@implementation CompleDataViewController
@synthesize titleHeight;
@synthesize cityLabel;
@synthesize searchLabel;
@synthesize msgLabel;
@synthesize bottomHeight;
@synthesize cityTextFiled;
@synthesize userTextFiled;
@synthesize pasTextFiled;
@synthesize addressTextFiled;
@synthesize phone;
@synthesize password;
@synthesize alertView;
static const NSArray *CITY_STR_ARRAY;
static const NSArray *CITY_ID_ARRAY;
static NSString * const DXPlaceholderColorKey = @"placeholderLabel.textColor";

+ (void)initialize
{
    // do not run for derived classes
    if (self != [CompleDataViewController class])
        return;
    CITY_STR_ARRAY=@[@"北京市",@"天津市",@"河北省",@"山西省",@"内蒙古",@"辽宁省",@"吉林省",@"黑龙江",@"上海市",@"江苏省",@"浙江省",@"安徽省",@"福建省",@"江西省",@"山东省",@"河南省",@"湖北省",@"湖南省",@"广东省",@"广西",@"海南省",@"重庆市",@"四川省",@"贵州省",@"云南省",@"西藏",@"陕西省",@"甘肃省",@"青海省",@"宁夏",@"新疆",@"台湾省",@"香港",@"澳门"];
    CITY_ID_ARRAY = @[@110000,@120000,@130000,@140000,@150000,@210000,@220000,@230000,@310000,@320000,@330000,@340000,@350000,@360000,@370000,@410000,@420000,@430000,@440000,@450000,@460000,@500000,@510000,@520000,@530000,@540000,@610000,@620000,@630000,@640000,@650000,@710000,@810000,@820000];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectProvId=[[NSNumber alloc]init];
    _selectCityId=[[NSNumber alloc]init];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:237.f/255.f green:238.f/255.f blue:239.f/255.f alpha:1.0]];
    
    [self initTitle];
    [self initCotentView];
    [self initPickView];
    [self getPickerData];
    [self getText];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)getText{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSError *error = [[NSError alloc]init];
    _localData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化顶部菜单栏
-(void)initTitle{
    //设置顶部栏
    titleHeight=44;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, titleHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    //新建左上角Label
    cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/6, titleHeight)];
    [cityLabel setTextAlignment:NSTextAlignmentCenter];
    cityLabel.userInteractionEnabled=YES;//
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_logo"]];
    [imageView setFrame:CGRectMake(self.view.frame.size.width/12-self.view.frame.size.width/35/2, titleHeight/2-self.view.frame.size.width/20/2, self.view.frame.size.width/35, self.view.frame.size.width/20)];
    [cityLabel addSubview:imageView];
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disMiss:)];
    [cityLabel addGestureRecognizer:gesture];
    
    //新建查询视图
    searchLabel=[[UILabel alloc]initWithFrame:(CGRectMake(self.view.frame.size.width/4, titleHeight/8, self.view.frame.size.width/2, titleHeight*3/4))];
    //  [searchLabel setBackgroundColor:[UIColor whiteColor]];
    [searchLabel setTextAlignment:NSTextAlignmentCenter];
    [searchLabel setText:@"完善资料"];
    
    [titleView addSubview:cityLabel];
    [titleView addSubview:searchLabel];
    [self.view addSubview:titleView];
}
-(void)initCotentView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    
    userTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40, width, titleHeight)];
    [userTextFiled setBackgroundColor:[UIColor whiteColor]];
    [userTextFiled setPlaceholder:@"请输入昵称"];
    [userTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
    [userTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [userTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self setTextFieldLeftPadding:userTextFiled forWidth:width/21];
    [self.view addSubview:userTextFiled];
    
    cityTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40+titleHeight+0.5, width, titleHeight)];
    [cityTextFiled setBackgroundColor:[UIColor whiteColor]];
    [cityTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
    [cityTextFiled setText:@"省、市、区"];
    [cityTextFiled setEnabled:NO];
    [cityTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
    [cityTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
    [self setTextFieldLeftPadding:cityTextFiled forWidth:width/21];
    [self.view addSubview:cityTextFiled];
    
    
//    addressTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, titleHeight+20+width/40+titleHeight*2+1, width, titleHeight)];
//    [addressTextFiled setBackgroundColor:[UIColor whiteColor]];
//    [addressTextFiled setPlaceholder:@"详细地址"];
//    [addressTextFiled setFont:[UIFont systemFontOfSize:width/26.7]];
//    [addressTextFiled setTextColor:[UIColor colorWithRed:61.f/255.f green:66.f/255.f blue:69.f/255.f alpha:1.0]];
//    [addressTextFiled setValue:[UIColor colorWithRed:155.f/255.f green:155.f/255.f blue:155.f/255.f alpha:1.0] forKeyPath:DXPlaceholderColorKey];
//    [self setTextFieldLeftPadding:addressTextFiled forWidth:width/21];
//    [self.view addSubview:addressTextFiled];
//    
    
    
    UILabel *loginLabel=[[UILabel alloc]initWithFrame:CGRectMake((width-width*7/9)/2, height-width/45.7-titleHeight, width*7/9, width/8.6)];
    
    UITapGestureRecognizer *loginRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goLoginViewController)];
    loginLabel.userInteractionEnabled=YES;
    [loginLabel addGestureRecognizer:loginRecognizer];
    [loginLabel setText:@"开启蹭课之旅"];
    [loginLabel setFont:[UIFont systemFontOfSize:width/26.7]];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [loginLabel setTextColor:[UIColor whiteColor]];
    [loginLabel setBackgroundColor:[UIColor colorWithRed:250.f/255.f green:113.f/255.f blue:34.f/255.f alpha:1.0]];
    loginLabel.layer.borderColor=[UIColor orangeColor].CGColor;
    loginLabel.layer.cornerRadius=16.0;
    loginLabel.layer.borderWidth = 1; //要设置的描边宽
    loginLabel.layer.masksToBounds=YES;
    [self.view addSubview:loginLabel];
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
        [userTextFiled resignFirstResponder];
  
}

-(void)initPickView{
    int width=self.view.frame.size.width;
    int height=self.view.frame.size.height;
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, height-width/45.7-titleHeight-width*2/3, width, width*2/3)];
    pickerView.delegate=self;
    
    [self.view addSubview:pickerView];
}
#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
    
    NSString *provice=[self.provinceArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *city=[self.cityArray objectAtIndex:[pickerView selectedRowInComponent:1]];
    NSString *town=@"";
    if([self.townArray count]>0){
        town=[self.townArray objectAtIndex:[pickerView selectedRowInComponent:2]];
    }
    [self setProviceID:provice andCityID:city andTown:town];
    
    
    [cityTextFiled setText:[[provice stringByAppendingString:city]stringByAppendingString:town]];
    
}
-(void)setProviceID:(NSString *)prvoice andCityID:(NSString *)city andTown:(NSString *)town{
    NSLog(@"prvoice%@",prvoice);
    NSLog(@"city%@",city);
    NSLog(@"town%@",town);
    
    NSRange rang  = [_localData rangeOfString:city];
    NSLog(@"%@",NSStringFromRange(rang));
    NSString *str=[_localData substringWithRange:NSMakeRange(rang.location-10, rang.length+18)];
    NSLog(@"%@",str);
    NSLog(@"%lu",(unsigned long)[str length]);
    NSArray *dataArray=[str componentsSeparatedByString:NSLocalizedString(@",", nil)];
    NSString *provStr=[dataArray objectAtIndex:2];
    NSString *cityStr=[dataArray objectAtIndex:0];
    cityStr=[cityStr substringWithRange:NSMakeRange(1, cityStr.length-2)];
    NSNumberFormatter *formater=[[NSNumberFormatter alloc]init];
    _selectCityId=[formater numberFromString:cityStr];
    _selectProvId=[formater numberFromString:provStr];
    
    
}

-(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth
{
    CGRect frame = textField.frame;
    frame.size.width = leftWidth;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftview;
}

-(void)showClause{
    //展示协议
}

-(void)goLoginViewController{
    NSString *username=userTextFiled.text;
    NSString *address=[cityTextFiled.text stringByAppendingFormat:@"%@",addressTextFiled.text];
    if (alertView==nil) {
        alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate=self;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [HttpHelper userSet:phone andNickName:username andPas:password andProvId:_selectProvId andCityId:_selectCityId andAdd:address   withModel:myDelegate.model success:^(HttpModel *model){
            NSLog(@"%@",model.message);
            dispatch_async(dispatch_get_main_queue(), ^{

            if ([model.status isEqual:[NSNumber numberWithInt:1]]) {
                [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    NSNotification *notification =[NSNotification notificationWithName:@"autologin" object:self userInfo:@{@"tel":phone,@"pas":password}];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }];
            }else{
                [alertView setMessage:model.message];
                [alertView show];
                
            }
            });
        }failure:^(NSError *error){
            if (error.userInfo!=nil) {
                NSLog(@"%@",error.userInfo);
            }
        }];
    });
}
-(void)disMiss:(UITapGestureRecognizer *)recognizer{
    // NSLog(@"点点点");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end