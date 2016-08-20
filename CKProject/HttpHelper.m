//
//  HttpHelper.m
//  CKProject
//
//  Created by furui on 15/12/24.
//  Copyright © 2015年 furui. All rights reserved.
//


#import "HttpHelper.h"


@implementation HttpHelper
+(void)getTimeList:(NSNumber *)iid withBeginTime:(NSNumber *)btime withAid:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"id",@"value":iid},
                             @{@"name":@"btime",@"value":btime},
                             @{@"name":@"aid",@"value":aid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_TIMELIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getCharsection:(NSNumber *)aid success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture{
    NSArray *parameters = @[ @{@"name":@"aid",@"value":aid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_CHARSECTION] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//nearby
+(void)getNearByLesson:(NSNumber *) userId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": userId},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": status}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_NearBy_LESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//首页最新课程获取
+(void)getNewLesson:(NSNumber *) userId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": userId},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": status}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_NEW_LESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}

//首页热门课程获取
+(void)getNewHotLesson:(NSNumber *) aid withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": status}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_NEW_HOT_LESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//首页推荐课程获取
+(void)getHotLesson:(NSNumber *) userId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": userId},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": status}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_HOT_LESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)verifyTel:(NSString *)tel withCode:(NSString *)code success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture
{
    NSArray *parameters = @[@{ @"name": @"tel", @"value": tel},
                            @{ @"name": @"verify", @"value": code}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_VERIFY_CODE] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getMsgInfo:(NSNumber *)msgId withModel:(HttpModel *)model success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture
{
    NSArray *parameters = @[@{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid},
                            @{@"name":@"id",@"value":msgId}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_READ_MSG] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)accessLogin:(NSString *)uid withUserName:(NSString *)userName withToken:(NSString *)token withType:(NSString *)type withTel:(NSString *)tel withPassword:(NSString *)password success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"userid",@"value":uid},
                             @{@"name":@"username",@"value":userName},
                             @{@"name":@"accesstoken",@"value":token},
                             @{@"name":@"accesstype",@"value":type},
                              @{@"name":@"tel",@"value":tel},
                              @{@"name":@"password",@"value":password}
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_ACESS_LOGIN] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
    
}
+(void)accessLogin:(NSString *)uid withUserName:(NSString *)userName withToken:(NSString *)token withType:(NSString *)type  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"userid",@"value":uid},
                             @{@"name":@"username",@"value":userName},
                             @{@"name":@"accesstoken",@"value":token},
                             @{@"name":@"accesstype",@"value":type}
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_ACESS_LOGIN] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
    
}

+(void)getLessonSubClasses:(NSNumber *)cid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"cid",@"value":cid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_SUBCLASSES] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}

+(void)getLessonCount:(NSNumber *)aid  andstrd :(NSString *)strd   success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"aid",@"value":aid}
                             ,
                             @{@"name":@"date",@"value":strd}
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_COUNT] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)getGrade:(NSNumber *)cid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_GRADE] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)searchInst:(NSNumber *)cid withAid:(NSNumber *)aid withStartLv:(NSNumber *)lv1 withEndLv:(NSNumber *)lv2  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"aid",@"value":aid},
                             @{@"name":@"cid",@"value":cid},
                             @{@"name":@"lv",@"value":lv1},
                             @{@"name":@"lvm",@"value":lv2}
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH_INST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
    
}
+(void)searchProject:(NSString *)searchs withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc  withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"searchs",@"value":searchs},
                             @{ @"name": @"lng", @"value": lng},
                             @{ @"name": @"lat", @"value": lat},
                             @{ @"name": @"status", @"value": status},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc}
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
    
}
+(void)searchCoupon:(NSString *)searchs success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"searchs",@"value":searchs}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_COUPON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
    
}

+(void)searchInst:(NSString *)searchs success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{@"name":@"searchs",@"value":searchs}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH_INST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
    
}

+(void)completeUserInfo:(NSString *)username withUserSex:(NSNumber *)sexNumber withAddr:(NSString *)addres withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"username",@"value":username},
                             @{@"name":@"sex",@"value":sexNumber},
                             @{@"name":@"addr",@"value":addres}];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SET_USER_EDITE] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)setStar:(NSNumber *)lid withLv:(NSNumber *)lv withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":lid},
                            @{@"name":@"lv",@"value":lv},
                            @{@"name":@"zan",@"value":[NSNumber numberWithInt:1]},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SET_STAR] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)showCoupon:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SHOW_COUPON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}

+(void)getCity:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":aid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LOCAL_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}

+(void)getSlider:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    [self postParems:nil withUrl:[HTTPHEADER stringByAppendingString:API_GET_SLIDER] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//新闻头条
+(void)getXW:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    [self postParems:nil withUrl:[HTTPHEADER stringByAppendingString:API_News] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}




+(void)siftOrgList:(NSNumber *)aid withTypeId:(NSNumber *)cid withCornerId:(NSNumber *)tid withLv:(NSNumber *)lvId success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    if (tid==nil || [tid isEqual:[NSNull null]]) {
        tid=[NSNumber numberWithInt:0];
    }
    if (lvId==nil || [lvId isEqual:[NSNull null]]) {
        lvId=[NSNumber numberWithInt:0];
    }
    NSArray *parameters = @[@{@"name":@"aid",@"value":aid},
                            @{@"name":@"cid",@"value":cid},
                            @{@"name":@"tid",@"value":tid},
                            @{@"name":@"lv",@"value":lvId},
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_SEARCHINST_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)zanNewsComments:(NSNumber*)commentsId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":commentsId},
                            @{@"name":@"zan",@"value":zan},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_NEWSCOMMENTS_ZAN] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)zanComments:(NSNumber*)commentsId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":commentsId},
                            @{@"name":@"zan",@"value":zan},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_COMMECTS_ZAN] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)zanNews:(NSNumber*)articleId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":articleId},
                            @{@"name":@"zan",@"value":zan},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_NEWS_ZAN] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)zanArticle:(NSNumber*)articleId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":articleId},
                            @{@"name":@"zan",@"value":zan},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_ARTICLE_ZAN] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)sendComments:(NSNumber*)articleId withContext:(NSString *)context withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":articleId},
                            @{@"name":@"content",@"value":context},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_SENDCOMMECTS] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//发送新闻评论

+(void)sendXinwenComments:(NSNumber*)articleId withContext:(NSString *)context withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":articleId},
                            @{@"name":@"content",@"value":context},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_XINWENSENDCOMMECTS] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}












//－－－－－－－－－－－－－


+(void)sendInvitation:(NSNumber *)circleId withAid:(NSNumber *)aid withTitle:(NSString *)title withContext:(NSString *)context  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    
    NSArray *parameters = @[@{@"name":@"id",@"value":circleId},
                            @{@"name":@"aid",@"value":aid},
                            @{@"name":@"title",@"value":title},
                            @{@"name":@"content",@"value":context},
                            @{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_SENDINVIATION] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}

+(void)sendInvitation:(NSNumber *)circleId withAid:(NSNumber *)aid withTitle:(NSString *)title withContext:(NSString *)context withImage:(NSString *)imageUrl withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    UIImage *imageuplod=[UIImage imageWithContentsOfFile:[imageUrl stringByAppendingString:@".png"]];
    
    NSDictionary *parameters=[NSDictionary  dictionaryWithObjectsAndKeys:model.tel,@"tel",
                              model.token,@"token",model.uid,@"uid",imageuplod,@"pic",circleId,@"id",
                              aid,@"aid",title,@"title",context,@"content",nil];
    [self upload:[HTTPHEADER stringByAppendingString:API_GET_SENDINVIATION] widthParams:parameters success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}

+(void)getArticleCommectsList:(NSNumber *)articleId withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid},
                            @{@"name":@"id",@"value":articleId},
                            @{@"name":@"pn",@"value":pn},
                            @{@"name":@"pc",@"value":pc}
                            
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_XINWENCIRCLE_AIRTICLE_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getArticleCommectsList:(NSNumber *)articleId withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":articleId},
                            @{@"name":@"pn",@"value":pn},
                            @{@"name":@"pc",@"value":pc}
                            
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_XINWENCIRCLE_AIRTICLE_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getArticleInfo:(NSNumber *)articleId  success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture
{
    NSArray *parameters = @[@{@"name":@"id",@"value":articleId}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_CIRCLE_AIRTICLE_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//shuju
+(void)getXinwenInfo:(NSNumber *)articleId  success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture
{
    NSArray *parameters = @[@{@"name":@"id",@"value":articleId}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_XINWEN_AIRTICLE_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getCouponList:(NSString *)searchs  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_COUPON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getCouponListSerch:(NSString *)searchs  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"searchs", @"value": searchs}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_COUPON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}

+(void)getXinwenInfo:(NSNumber *)articleId  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid},
                            @{@"name":@"id",@"value":articleId},
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_XINWEN_AIRTICLE_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}


//新闻列表页
+(void)getNewsList:(NSNumber *)lam andPn:(NSNumber *)pn andPc:(NSNumber *)pc success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture
{

    NSArray *parameters = @[@{ @"name": @"pn", @"value": pn},
                            @{ @"name": @"pc", @"value": pc},
                            @{ @"name": @"lam", @"value": lam}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_liebiao] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];


}
+(void)getArticleInfo:(NSNumber *)articleId withModel:(HttpModel *)model success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture
{
    NSArray *parameters = @[@{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid},
                            @{@"name":@"id",@"value":articleId}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_CIRCLE_AIRTICLE_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//获取新闻评论列表
+(void)getXINWENArticleInfo:(NSNumber *)articleId withModel:(HttpModel *)model success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture
{
    NSArray *parameters = @[@{ @"name": @"id", @"value": articleId}
                           
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_CIRCLE_AIRTICLE_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}










//－－－－－－－－－－－－
+(void)getArticleList:(NSNumber *)aid withCircleId:(NSNumber *)circleId withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"aid",@"value":aid},
                            @{@"name":@"id",@"value":circleId},
                            @{@"name":@"pn",@"value":pn},
                            @{@"name":@"pc",@"value":pc}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_CIRCLE_AIRTICLE_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)getTopArticle:(NSNumber *)aid withCircleId:(NSNumber *)circleId success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"aid",@"value":aid},
                            @{@"name":@"id",@"value":circleId}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_CIRCLE_AIRTICLE_TOP] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getInsetInfo:(NSNumber *)orgId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":orgId},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": status}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_INSET_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)collectionLesson:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":projectId},
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_COLLECTION_LESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)orderLesson:(NSNumber *)projectId withWeekId:(NSNumber *)weekid withWeekNum:(NSNumber *)weeknum withBtime:(NSString *)begintime withadvancetime:(NSNumber *)advancetime withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":projectId},
                              @{@"name":@"weekid",@"value":weekid},
                              @{@"name":@"weeknum",@"value":weeknum},
                              @{@"name":@"begintime",@"value":begintime},
                              @{@"name":@"advancetime",@"value":advancetime},
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_ORDER_LESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)orderLesson:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":projectId},
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_ORDER_LESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getLessonInfo:(NSNumber *)projectId withModel:(HttpModel *)model  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid},
                            @{@"name":@"id",@"value":projectId}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getLessonInfo:(NSNumber *)projectId withLng:(NSNumber *)lng withLat:(NSNumber *)lat  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"tel", @"value": model.tel},
                            @{ @"name": @"token", @"value": model.token},
                            @{ @"name": @"uid", @"value": model.uid},
                            @{@"name":@"id",@"value":projectId},
                            @{@"name":@"lng",@"value":lng},
                            @{@"name":@"lat",@"value":lat}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getLessonInfo:(NSNumber *)projectId withLng:(NSNumber *)lng withLat:(NSNumber *)lat success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":projectId},
                              @{@"name":@"lng",@"value":lng},
                              @{@"name":@"lat",@"value":lat}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getLessonInfo:(NSNumber *)projectId success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{@"name":@"id",@"value":projectId}                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_INFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)openCity:(id )sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_OPEN_CITY] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)deleteSysMsg:(NSNumber *)interId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":interId},
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_DELETE_MSG] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getSysMsgListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc},
                             @{@"name":@"aid",@"value":[NSNumber numberWithInt:500100]}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_GETSYS_MSG_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)deleteInterFavorite:(NSNumber *)interId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":interId},
                             @{@"name":@"zan",@"value":zan}
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_DELTETE_INTER_FAVORITE] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getInterFavoriteListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_GETINTER_FAVORITE_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)deleteMyCommect:(NSNumber *)interId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":interId},
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_DELETE_COMMTES] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getCommectsListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_GETCOMMTES_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)deleteMyInter:(NSNumber *)interId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{ @"name": @"id", @"value":interId}
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_DELETE_MYINTER] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getMyInterListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_MYINTER_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)deleteMyLesson:(NSNumber *)projectId withWeekId:(NSNumber *)weekid withWeekNum:(NSNumber *)weeknum withBeginTime:(NSString *) begintime  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":projectId},
                             @{@"name":@"weekid",@"value":weekid},
                             @{@"name":@"weeknum",@"value":weeknum},
                             @{@"name":@"begintime",@"value":begintime},
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_DELETE_MYLESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];

}
+(void)deleteMyLesson:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":projectId},
                             ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_DELETE_MYLESSON] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getMyLessonList:(NSNumber *)statues withLng:(NSNumber *)lng withLat:(NSNumber *)lat  withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"status",@"value":statues},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc},
                             @{@"name":@"lng",@"value":lng},
                             @{@"name":@"lat",@"value":lat}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_MYLESSON_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getFavoriteProjectList:(NSNumber *)pn withPageLine:(NSNumber *)pc withLng:(NSNumber *)lng withLat:(NSNumber *)lat  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc},
                             @{@"name":@"lng",@"value":lng},
                             @{@"name":@"lat",@"value":lat}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_MYFAVORITE] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getFavoriteProjectList:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"pn",@"value":pn},
                             @{@"name":@"pc",@"value":pc}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_MYFAVORITE] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)deleteFavoriteProject:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"id",@"value":projectId}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_DELETE_PROJECT] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getInterGroup:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_INTER_GROUP] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getInsetList:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_INST_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getLessonGroup:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    [self postParems:nil withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_GROUP] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getLessonList:(NSNumber *)cid withPid:(NSNumber *)pid withAID:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"cid", @"value": cid},
                            @{ @"name": @"pid", @"value": pid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
//paixu
+(void)getLessonList:(NSNumber *)cid withPid:(NSNumber *)pid withAID:(NSNumber *)aid withlng:(NSNumber *)lg withlat:(NSNumber *)lat withnums:(NSNumber *)nums  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"cid", @"value": cid},
                            @{ @"name": @"pid", @"value": pid},
                            @{ @"name": @"lng", @"value": lg},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": nums},];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)getLessonList:(NSNumber *)cid withPid:(NSNumber *)pid withAID:(NSNumber *)aid withlng:(NSNumber *)lg withlat:(NSNumber *)lat withnums:(NSNumber *)nums withPn:(NSNumber *)pn withPageLine:(NSNumber *)pc success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"cid", @"value": cid},
                            @{ @"name": @"pid", @"value": pid},
                            @{ @"name": @"lng", @"value": lg},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": nums},
                            @{@"name":@"pn",@"value":pn},
                            @{@"name":@"pc",@"value":pc}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_LESSON_LIST] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}



//热门模块的搜索结果
+(void)searchData:(NSNumber *)aid withData:(NSString *)sqlstring withlgn:(NSNumber *)lng withlat:(NSNumber *)lat success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"sqlstring", @"value": sqlstring},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat}
                            ];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)searchData:(NSMutableArray *)parameter withPc:(NSNumber *)pc withPn:(NSNumber *)pn withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSMutableArray *array=[parameter mutableCopy];
    NSArray *parameters = @[@{ @"name": @"pn", @"value": pn},
                            @{ @"name": @"pc", @"value": pc},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": status}];
    [array addObjectsFromArray:parameters];
    parameters =[array copy];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)searchData:(NSNumber *)aid  withCid:(NSNumber *)cid withPid:(NSNumber *)pid withGid:(NSNumber *)gid withPc:(NSNumber *)pc withPn:(NSNumber *)pn withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"cid", @"value": cid},
                            @{ @"name": @"pid", @"value": pid},
                            @{ @"name": @"gid", @"value": gid},
                            @{ @"name": @"pn", @"value": pn},
                            @{ @"name": @"pc", @"value": pc},
                            @{ @"name": @"lng", @"value": lng},
                            @{ @"name": @"lat", @"value": lat},
                            @{ @"name": @"status", @"value": status},];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)searchData:(NSNumber *)aid withData:(NSString *)data withDate:(NSString *)date withCid:(NSNumber *)cid withPid:(NSNumber *)pid withGid:(NSNumber *)gid withPc:(NSNumber *)pc withPn:(NSNumber *)pn success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"datas", @"value": date},
                            @{ @"name": @"cid", @"value": cid},
                            @{ @"name": @"pid", @"value": pid},
                            @{ @"name": @"gid", @"value": gid},
                            @{ @"name": @"pn", @"value": pn},
                            @{ @"name": @"pc", @"value": pc}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//查询数据




+(void)searchData:(NSNumber *)aid withData:(NSString *)data withDate:(NSString *)date success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid},
                            @{ @"name": @"searchs", @"value": data},
                            @{ @"name": @"date", @"value": date}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_SEARCH] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getMainData:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[@{ @"name": @"aid", @"value": aid}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_MAINDATA] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}

//+(void)getMyFavorite:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
//    NSArray *parameters = @[@{ @"name": @"token", @"value": model.token},
//                            @{ @"name": @"uid", @"value": model.uid},
//                            @{@"name":@"tel",@"value":model.tel}];
//    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_READDRESS] success:^(HttpModel *model){
//        success(model);
//    }failure:^(NSError *error){
//        failture(error);
//    }];
//}
+(void)resetAddress:(NSString *)address withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"addr",@"value":address}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_READDRESS] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)resetName:(NSString *)username withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"username",@"value":username}];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_RENAME] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)resetSex:(NSString *)sex withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSNumber *sexNumber;
    if ([sex isEqualToString:@"男"]) {
        sexNumber=[NSNumber numberWithInt:1];
    }else{
        sexNumber=[NSNumber numberWithInt:2];
        
    }
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{@"name":@"sex",@"value":sexNumber}];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_RESEX] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)resetPassowrd:(NSString *)phone andCode:(NSString *)code andPas:(NSString *)pas success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": phone},
                             @{ @"name": @"verify", @"value": code},
                             @{ @"name": @"repassword", @"value": pas}];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_REPASSWRORD] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)userSet:(NSString *)phone andNickName:(NSString *)nickName andPas:(NSString *)pas andProvId:(NSNumber *)provId andCityId:(NSNumber *)cityId andAdd:(NSString *)add withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid},
                             @{ @"name": @"username", @"value": nickName},
                             @{ @"name": @"provid", @"value": provId},
                             @{ @"name": @"cityid", @"value": cityId},
                             @{@"name":@"addr",@"value":add}];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_USERSET] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)getUserInfo:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid}];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_USERINFO] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)registerAcount:(NSString *)phone withCode:(NSString *)code withPassword:(NSString *)password success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": phone},
                             @{ @"name": @"verify", @"value": code},
                             @{ @"name": @"password", @"value": password}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_REGISTER] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
    
}
+(void)getMsgCode:(NSString *)phone  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": phone}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_GET_MSG_CODE] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}


+(void)loginAcount:(NSString *)phone with:(NSString *)password success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": phone},
                             @{ @"name": @"password", @"value": password}];
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_LOGIN] success:^(HttpModel *model){
       // NSLog(@"11111222222221");
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
//xinwen
+(void)getfenlei:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture
{
    NSArray *parameters = @[ ];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_LOGOUT] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];





}


+(void)logoutAcount:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    NSArray *parameters = @[ @{ @"name": @"tel", @"value": model.tel},
                             @{ @"name": @"token", @"value": model.token},
                             @{ @"name": @"uid", @"value": model.uid}];
    
    [self postParems:parameters withUrl:[HTTPHEADER stringByAppendingString:API_LOGOUT] success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}
+(void)upload:(HttpModel *)model withImageUrl:(NSString *)imageUrl withImage:(UIImage *)image success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    UIImage *imageuplod=[UIImage imageWithContentsOfFile:[imageUrl stringByAppendingString:@".png"]];
    
    NSDictionary *parameters=[NSDictionary  dictionaryWithObjectsAndKeys:model.tel,@"tel",
                              model.token,@"token",model.uid,@"uid",imageuplod,@"pic",nil];
    [self upload:[HTTPHEADER stringByAppendingString:API_UPLOAD] widthParams:parameters success:^(HttpModel *model){
        success(model);
    }failure:^(NSError *error){
        failture(error);
    }];
}









+(id)upload:(NSString *)url widthParams:(NSDictionary *)params success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image=[params objectForKey:@"pic"];
    //得到图片的data
    NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"img\"; filename=\"boris.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = nil;
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] ==200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&error];
        
        HttpModel *model=[[HttpModel alloc]init];
        [model setTel:[resultJSON objectForKey:@"tel"]];
        [model setToken:[resultJSON objectForKey:@"token"]];
        [model setUid:[resultJSON objectForKey:@"uid"]];
        [model setStatus:[resultJSON objectForKey:@"status"]];
        [model setMessage:[resultJSON objectForKey:@"message"]];
        [model setResult:[resultJSON objectForKey:@"result"]];
        
        NSLog(@"message====%@",[resultJSON objectForKey:@"message"]);
        success(model);
    }else{
        NSLog(@"urlResponese statusCode %ld",(long)[urlResponese statusCode]);
        if([urlResponese statusCode]==500){
            error=[[NSError alloc]initWithDomain:@"网络连接异常" code:500 userInfo:nil];
            failture(error);
        }
        if (error.userInfo) {
            NSLog(
                  @"Error:%@",error.userInfo);
            failture(error);
        }
    }
    
    return nil;
}
+(void)uploadImage:(NSArray *)parameters {
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[HTTPHOST stringByAppendingString:@"/api/uploads"] ]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    NSString *boundary = @"AaB03x";
    NSString *twoHyphens=@"--";
    NSString *end=@"\r\n";
    // NSString *content=@"image/png";
    
    //  [request setValue:@"*/*" forHTTPHeaderField:@"accept"];
    //  [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connnection"];
    //  [request setValue:@"utf-8" forHTTPHeaderField:@"Charset"];
    [request setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"content-type"];
    [request setHTTPMethod:@"POST"];
    
    NSMutableString *body=[[NSMutableString alloc]init];
    [body appendString:end];
    [body appendString:twoHyphens];
    [body appendString:boundary];
    [body appendString:end];
    for (int i=0; i<[parameters count]; i++) {
        NSDictionary *param=[parameters objectAtIndex:i];
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"", param[@"name"]];
        [body appendString:end];
        [body appendString:end];
        [body appendFormat:@"%@", param[@"value"]];
        [body appendString:end];
        [body appendString:twoHyphens];
        [body appendString:boundary];
        [body appendString:end];
    }
    [body appendString:@"Content-Disposition: form-data; name=\"file\"; filename=\"icon.png\"\r\n\r\n"];
    [body appendFormat:@"Content-Type: image/png\r\n\r\n"];
    
    UIImage *image=[UIImage imageNamed:@"icon.png"];
    //得到图片的data
    NSData* imagData = UIImagePNGRepresentation(image);
    
    NSMutableData *myRequestData=[NSMutableData data];
    
    
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //将image的data加入
    [myRequestData appendData:imagData];
    
    //
    [myRequestData appendData:[@"\r\n--AaB03x--" dataUsingEncoding:NSUTF8StringEncoding]];
    // [myRequestData appendData:[twoHyphens dataUsingEncoding:NSUTF8StringEncoding]];
    // [myRequestData appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    // [myRequestData appendData:[twoHyphens dataUsingEncoding:NSUTF8StringEncoding]];
    // [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:myRequestData];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = nil;
  //  NSLog(@"=====%@",[request allHTTPHeaderFields]);
  //  NSLog(@"======%@",body);
    //设置Content-Length
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] ==200&&[urlResponese statusCode]<300){
    //    NSLog(@"返回结果=====%@",result);
        NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&error];
        if (error) {
            //failture(error);
        }
        HttpModel *model=[[HttpModel alloc]init];
        [model setTel:[resultJSON objectForKey:@"tel"]];
        [model setToken:[resultJSON objectForKey:@"token"]];
        [model setUid:[resultJSON objectForKey:@"Uid"]];
        [model setStatus:[resultJSON objectForKey:@"status"]];
        [model setMessage:[resultJSON objectForKey:@"message"]];
        [model setResult:[resultJSON objectForKey:@"result"]];
        
     //   NSLog(@"message====%@",[resultJSON objectForKey:@"message"]);
        // success(model);
    }else{
      //  NSLog(@"%ld",(long)[urlResponese statusCode]);
        //            if (error.user) {
        //                NSLog(
        //                      @"Error:%@",error);
        //              //  failture(error);
        //            }
    }
    
}

+(void)postParems:(NSArray *)parameters withUrl:(NSString *)url success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture
{
  //  NSLog(@"请求地址:%@",url);
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    NSMutableString *body=[[NSMutableString alloc]init];
    
    for (int i=0; i<[parameters count]; i++) {
        NSDictionary *param=[parameters objectAtIndex:i];
        if (i==0) {
            [body appendFormat:@"%@=", param[@"name"]];
            
        }else{
            [body appendFormat:@"&%@=", param[@"name"]];
            
        }
        [body appendFormat:@"%@", param[@"value"]];
    }
    NSLog(@"url===:%@",url);
    NSLog(@"body===:%@",body);
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=@"*/*";
    // 设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置HTTPHeader参数
    
    [request setHTTPMethod:@"POST"];
    
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];//请求头
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = nil;
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        if (resultData!=nil) {
            NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:resultData options:kNilOptions error:&error];
            if (error) {
                failture(error);
            }
            HttpModel *model=[[HttpModel alloc]init];
            [model setTel:[resultJSON objectForKey:@"tel"]];
            [model setToken:[resultJSON objectForKey:@"token"]];
            [model setUid:[resultJSON objectForKey:@"uid"]];
            [model setStatus:[resultJSON objectForKey:@"status"]];
            [model setMessage:[resultJSON objectForKey:@"message"]];
            [model setResult:[resultJSON objectForKey:@"result"]];
            [model setAid:[resultJSON objectForKey:@"aid"]];
            if([resultJSON objectForKey:@"CUSTOMER_SERVICE_TEL"]){
                [model setCustom_tel:[resultJSON objectForKey:@"CUSTOMER_SERVICE_TEL"]];
            }
            success(model);
        }
        
    }else{
        NSLog(@"%ld",(long)[urlResponese statusCode]);
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            failture(error);
        }
    }
}

//获取当前时间戳
+(NSString *)getNowImageTime{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
@end