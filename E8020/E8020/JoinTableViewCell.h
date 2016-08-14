//
//  JoinTableViewCell.h
//  E8020
//
//  Created by Yiwen Fu on 15/11/8.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *sum;
@property (strong, nonatomic) IBOutlet UILabel *ratio;

@property  double sum_value;
@property  double sum_time;
@property  double e_sum_value;
@property  double e_sum_time;

@end
