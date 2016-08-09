//
//  HttpHelper.h
//  CKProject
//
//  Created by furui on 15/12/24.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpModel.h"
//
////cs
//static NSString * const HTTPHEADER =@"http://211.149.198.8:9090//api/";
//static NSString * const HTTPHOST =@"http://211.149.198.8:9090/";
//zs
static NSString * const HTTPHEADER =@"http://211.149.190.90//api/";
static NSString * const HTTPHOST =@"http://211.149.190.90/";
///http://211.149.190.90//Public/image/upload/20160601/574e8984b9bd3.png
static NSString * const API_liebiao=@"news";;
static NSString * const API_News=@"indexnews";
static NSString * const API_LOGIN=@"login";
static NSString * const API_LOGOUT=@"logout";
static NSString * const API_REGISTER=@"register";
static NSString * const API_GET_MSG_CODE=@"telverify";
static NSString * const API_VERIFY_CODE=@"telverifycheck";
static NSString * const API_REPASSWRORD=@"repassword";
static NSString * const API_RENAME=@"reusername";
static NSString * const API_RESEX=@"resex";
static NSString * const API_READDRESS=@"readdr";
static NSString * const API_USERSET=@"userset";
static NSString * const API_MYFAVORITE=@"myfavorite";
static NSString * const API_MAINDATA=@"index";
static NSString * const API_SEARCH=@"searchs";
static NSString * const API_GET_LESSON_LIST=@"lesson";
static NSString * const API_GET_LESSON_GROUP=@"lessongroup";
static NSString * const API_GET_INST_LIST=@"inst";
static NSString * const API_GET_INTER_GROUP=@"intergroup";
static NSString * const API_GET_DELETE_PROJECT=@"myfavoritedel";
static NSString * const API_GET_MYLESSON_LIST=@"mylesson";
static NSString * const API_GET_DELETE_MYLESSON=@"mylessondel";
static NSString * const API_GET_MYINTER_LIST=@"myinter";
static NSString * const API_GET_DELETE_MYINTER=@"myinterdel";
static NSString * const API_GET_GETCOMMTES_LIST=@"mycomments";
static NSString * const API_GET_DELETE_COMMTES=@"mycommentsdel";
static NSString * const API_GET_GETINTER_FAVORITE_LIST=@"interfavorite";
static NSString * const API_GET_DELTETE_INTER_FAVORITE=@"interfavoritedel";
static NSString * const API_GET_GETSYS_MSG_LIST=@"message";
static NSString * const API_GET_DELETE_MSG=@"messagedel";
static NSString * const API_GET_LESSON_INFO=@"lessoninfo";
static NSString * const API_GET_ORDER_LESSON=@"lessonenter";
static NSString * const API_GET_COLLECTION_LESSON=@"favorite";
static NSString * const API_GET_INSET_INFO=@"instinfo";
static NSString * const API_GET_CIRCLE_AIRTICLE_TOP=@"intertop";
static NSString * const API_GET_CIRCLE_AIRTICLE_LIST=@"inter";
static NSString * const API_GET_CIRCLE_AIRTICLE_INFO=@"interinfo";


static NSString * const API_GET_XINWENCIRCLE_AIRTICLE_INFO=@"newscomments";
static NSString * const API_GET_XINWEN_AIRTICLE_INFO=@"news";
static NSString * const API_GET_CIRCLE_AIRTICLE_COMMENTS_LIST=@"intercomments";
static NSString * const API_GET_SENDINVIATION=@"interadd";
static NSString * const API_GET_SENDCOMMECTS=@"commentsadd";
static NSString * const API_GET_XINWENSENDCOMMECTS=@"newscommentsadd";
static NSString * const API_GET_ARTICLE_ZAN=@"interzan";
static NSString * const API_GET_COMMECTS_ZAN=@"commentszan";
static NSString * const API_GET_SEARCHINST_LIST=@"searchinst";
static NSString * const API_GET_LOCAL_LIST=@"local";
static NSString * const API_SET_STAR=@"instscore";
static NSString * const API_SET_USER_EDITE=@"useredit";
static NSString * const API_SEARCH_INST=@"searchinst";
static NSString *const API_GET_GRADE=@"grade";
static NSString *const API_GET_LESSON_COUNT=@"lessoncount";
static NSString *const API_GET_LESSON_SUBCLASSES=@"classes";


static NSString * const API_GET_SLIDER=@"slider";


static NSString * const API_GET_USERINFO=@"userinfo";
static NSString * const API_ACESS_LOGIN=@"accesslogin";
static NSString * const API_READ_MSG=@"messageinfo";

static NSString *const API_UPLOAD=@"uploads";
//二期
static NSString *const API_NEW_HOT_LESSON=@"newhotlesson";
static NSString *const API_NearBy_LESSON=@"nearlesson";
static NSString *const API_NEW_LESSON=@"newlesson";
static NSString *const API_HOT_LESSON=@"hotlesson";
static NSString *const API_CHARSECTION=@"charsection";
static NSString *const API_TIMELIST=@"weeklist";
static NSString *const API_NEWSCOMMENTS_ZAN=@"newscommentszan";
static NSString *const API_NEWS_ZAN=@"newszan";

@interface HttpHelper : NSObject
+(NSString *)getNowImageTime;
//二期接口
+(void)zanNews:(NSNumber*)articleId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)deleteMyLesson:(NSNumber *)projectId withWeekId:(NSNumber *)weekid withWeekNum:(NSNumber *)weeknum withBeginTime:(NSString *) begintime withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)orderLesson:(NSNumber *)projectId withWeekId:(NSNumber *)weekid withWeekNum:(NSNumber *)weeknum withBtime:(NSString *)begintime withadvancetime:(NSNumber *) advancetime withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getTimeList:(NSNumber *)lid withBeginTime:(NSNumber *)btime withAid:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)searchData:(NSNumber *)aid withData:(NSString *)sqlstring success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getCharsection:(NSNumber *)userId success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)getHotLesson:(NSNumber *) userId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)getNewHotLesson:(NSNumber *) userId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)getNewLesson:(NSNumber *) userId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)getNearByLesson:(NSNumber *) userId withlgn:(NSNumber *)lng withlat:(NSNumber *)lat withstatus:(NSNumber *)status success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)getFavoriteProjectList:(NSNumber *)pn withPageLine:(NSNumber *)pc withLng:(NSNumber *)lng withLat:(NSNumber *)lat  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getLessonInfo:(NSNumber *)projectId withLng:(NSNumber *)lng withLat:(NSNumber *)lat  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getLessonInfo:(NSNumber *)projectId withLng:(NSNumber *)lng withLat:(NSNumber *)lat success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)zanNewsComments:(NSNumber*)commentsId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
//一期接口
+(void)getMsgInfo:(NSNumber *)msgId withModel:(HttpModel *)model success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)accessLogin:(NSString *)uid withUserName:(NSString *)userName withToken:(NSString *)token withType:(NSString *)type  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getLessonSubClasses:(NSNumber *)cid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
//(void)getLessonCount:(NSNumber *)aid  andstrd :(NSString *)strd
+(void)getLessonCount:(NSNumber *)aid  andstrd :(NSString *)strd
 success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getGrade:(NSNumber *)cid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)searchInst:(NSNumber *)cid withAid:(NSNumber *)aid withStartLv:(NSNumber *)lv1 withEndLv:(NSNumber *)lv2  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;

+(void)completeUserInfo:(NSString *)username withUserSex:(NSNumber *)sexNumber withAddr:(NSString *)addres withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)setStar:(NSNumber *)lid withLv:(NSNumber *)lv withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getCity:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getSlider:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getFavoriteProjectList:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)siftOrgList:(NSNumber *)aid withTypeId:(NSNumber *)cid withCornerId:(NSNumber *)tid withLv:(NSNumber *)lvId success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)zanComments:(NSNumber*)commentsId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)zanArticle:(NSNumber*)articleId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)sendComments:(NSNumber*)articleId withContext:(NSString *)context withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)sendInvitation:(NSNumber *)circleId withAid:(NSNumber *)aid withTitle:(NSString *)title withContext:(NSString *)context withImage:(NSString *)imageUrl withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)sendInvitation:(NSNumber *)circleId withAid:(NSNumber *)aid withTitle:(NSString *)title withContext:(NSString *)context  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getArticleCommectsList:(NSNumber *)articleId withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getArticleCommectsList:(NSNumber *)articleId withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getArticleInfo:(NSNumber *)articleId  success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)getArticleInfo:(NSNumber *)articleId withModel:(HttpModel *)model success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
+(void)getArticleList:(NSNumber *)aid withCircleId:(NSNumber *)circleId withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getTopArticle:(NSNumber *)aid withCircleId:(NSNumber *)circleId success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getInsetInfo:(NSNumber *)orgId success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)collectionLesson:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)orderLesson:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getLessonInfo:(NSNumber *)projectId success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getLessonInfo:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)deleteSysMsg:(NSNumber *)interId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getSysMsgListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)deleteInterFavorite:(NSNumber *)interId withZan:(NSNumber *)zan withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getInterFavoriteListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)deleteMyCommect:(NSNumber *)interId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getCommectsListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)deleteMyInter:(NSNumber *)interId  withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getMyInterListwithPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)deleteMyLesson:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getMyLessonList:(NSNumber *)statues withPageNumber:(NSNumber *)pn withPageLine:(NSNumber *)pc withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)deleteFavoriteProject:(NSNumber *)projectId withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getInterGroup:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getInsetList:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getLessonGroup:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getLessonList:(NSNumber *)cid withPid:(NSNumber *)pid withAID:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)searchData:(NSNumber *)aid withData:(NSString *)data withDate:(NSString *)date withCid:(NSNumber *)cid withPid:(NSNumber *)pid withGid:(NSNumber *)gid withPc:(NSNumber *)pc withPn:(NSNumber *)pn success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)searchData:(NSNumber *)aid withData:(NSString *)data withDate:(NSString *)date success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getMainData:(NSNumber *)aid success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)resetAddress:(NSString *)address withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)resetSex:(NSString *)sex withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)resetName:(NSString *)username withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)resetPassowrd:(NSString *)phone andCode:(NSString *)code andPas:(NSString *)pas success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)userSet:(NSString *)phone andNickName:(NSString *)nickName andPas:(NSString *)pas andProvId:(NSNumber *)provId andCityId:(NSNumber *)cityId andAdd:(NSString *)add withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)upload:(HttpModel *)model withImageUrl:(NSString *)imageUrl withImage:(UIImage *)image success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getUserInfo:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)registerAcount:(NSString *)phone withCode:(NSString *)code withPassword:(NSString *)password success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)getMsgCode:(NSString *)phone  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)loginAcount:(NSString *)phone with:(NSString *)password success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
+(void)logoutAcount:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
//新闻详情数据
+(void)getXinwenInfo:(NSNumber *)articleId  success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
//获取新闻评论列表
+(void)getXINWENArticleInfo:(NSNumber *)articleId withModel:(HttpModel *)model success:(void (^)(HttpModel *))success failure:(void (^)(NSError *))failture;
//发布新闻评论
+(void)sendXinwenComments:(NSNumber*)articleId withContext:(NSString *)context withModel:(HttpModel *)model success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
//新闻头条
+(void)getXW:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
//http://211.149.190.90/api/news
+(void)getfenlei:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;

//
+(void)getLessonList:(NSNumber *)cid withPid:(NSNumber *)pid withAID:(NSNumber *)aid withlng:(NSNumber *)lg withlat:(NSNumber *)lat withnums:(NSNumber *)nums  success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;
//获取新闻列表
+(void)getliebiao:(id)sender success:(void (^)(HttpModel *model)) success failure:(void (^)(NSError *error)) failture;

@end
