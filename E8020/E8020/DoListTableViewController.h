//
//  DoListTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 15/10/25.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "UserDoWork.h"

@interface DoListTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}
@property (nonatomic,strong) NSArray *doList;
@property (nonatomic,strong) NSString *work_id;

@property (nonatomic,strong) NSString *work_time;
@property (nonatomic,strong) NSString *work_memo;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *add;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *engagement_id;
@property (nonatomic, strong) NSString *currentEngagementTitle;
@property (nonatomic, strong) NSString *currentUserName;
@property (nonatomic, strong) NSString *currentLeaderUser;

@property (nonatomic, strong) NSString *selfJoinValue;

@property (nonatomic,strong) NSDictionary *record;

@property (nonatomic,strong) NSString *do_id;

@end
