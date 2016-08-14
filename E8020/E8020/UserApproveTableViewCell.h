//
//  UserApproveTableViewCell.h
//  E8020
//
//  Created by Yiwen Fu on 16/1/12.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserApproveTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) NSString *join_id;
@property (strong, nonatomic) IBOutlet UISwitch *joinFlag;

@end
