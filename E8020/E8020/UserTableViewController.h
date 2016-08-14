//
//  UserTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 16/1/3.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "UserJoinEngagement.h"

@interface UserTableViewController : UITableViewController

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) IBOutlet UITextField *displayName;
@property (strong, nonatomic) NSArray *userRecord;

@end
