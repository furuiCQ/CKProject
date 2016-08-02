//
//  ListItem.h
//  CKProject
//
//  Created by frain on 15/12/3.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainListItem : UIControl
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *joinLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *typelabel;
@property(nonatomic,strong)UILabel *typelabel1;
@property(nonatomic,strong)UILabel *typelabel2;


-(id)initFrame:(CGRect)frame withHegiht:(int)hegiht;
@end