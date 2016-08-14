//
//  UserApproveListTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 16/1/12.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "UserJoinEngagement.h"

@interface UserApproveListTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}
@property (nonatomic,strong) NSArray *userList;
@property (nonatomic,strong) NSString *work_id;

@property (nonatomic,strong) NSString *selectJoinID;

@property (nonatomic,strong) NSDictionary *record;

@property (nonatomic,strong) NSString *workValue;

@property (nonatomic,strong) NSString *engagementID;

@end
