//
//  UserTableViewCell.h
//  E8020
//
//  Created by Yiwen Fu on 15/11/7.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UISwitch *select;

@property (strong, nonatomic) NSString *user_id;

@end
