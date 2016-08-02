//
//  mCell.h
//  CKProject
//
//  Created by user on 16/7/12.
//  Copyright © 2016年 furui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titles;

@property (weak, nonatomic) IBOutlet UIImageView *im;
@property (weak, nonatomic) IBOutlet UILabel *writers;
@property (weak, nonatomic) IBOutlet UILabel *nums;
@property (weak, nonatomic) IBOutlet UILabel *times;
@end
