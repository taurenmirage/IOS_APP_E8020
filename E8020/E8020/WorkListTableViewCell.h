//
//  WorkListTableViewCell.h
//  E8020
//
//  Created by Yiwen Fu on 15/10/24.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *workTitle;
@property (strong, nonatomic) IBOutlet UILabel *workDesc;
@property (strong, nonatomic) IBOutlet UILabel *EndDate;
@property (strong, nonatomic) NSString *work_id;



@end
