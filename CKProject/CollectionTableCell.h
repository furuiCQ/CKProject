//
//  CollectionTableCell.h
//  CKProject
//
//  Created by furui on 15/12/10.
//  Copyright © 2015年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainListItem.h"
@interface CollectionTableCell:UITableViewCell
@property(nonatomic,strong)UIViewController *viewController;
@property int rowHeight;


@property UIImageView *logoImageView;
@property UILabel *projectName;
@property UILabel *haveSomeOneLabel;
@property UILabel *addressLabel;
@property UILabel *typelabel;
@property UILabel *typelabel1;
@property UILabel *typelabel2;
@end
