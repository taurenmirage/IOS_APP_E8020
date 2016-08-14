//
//  DoListTableViewCell.h
//  E8020
//
//  Created by Yiwen Fu on 15/10/25.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *createDate;

@property (strong, nonatomic) IBOutlet UILabel *workTime;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) NSString *do_id;

@end
