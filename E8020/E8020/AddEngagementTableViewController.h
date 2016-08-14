//
//  AddEngagementTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 15/11/18.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "Engagement.h"
#import "UserJoinEngagement.h"

@interface AddEngagementTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}

@property (nonatomic,strong) NSDictionary *record;

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *engagement_id;

@property (nonatomic, strong) NSString *editType;

@property (nonatomic, strong) NSString *leaderUser;

@property (strong, nonatomic) IBOutlet UITextField *engagementTitle;
@property (strong, nonatomic) IBOutlet UITextField *engagementDescription;
@property (strong, nonatomic) IBOutlet UITextField *workValue;

@property (strong, nonatomic) IBOutlet UISwitch *completeFlag;
@property (strong, nonatomic) IBOutlet UISwitch *activeFlag;

@property (strong, nonatomic) IBOutlet UILabel *uniqueID;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *save;

@property (strong, nonatomic) NSArray *pickerData;
@property (nonatomic,strong) NSMutableArray *userNameListForPicker;

@property (nonatomic,strong) NSString *assignUserID;
@property (nonatomic,strong) NSString *assignUserName;

@property (strong, nonatomic) IBOutlet UIButton *userName;

@property (strong, nonatomic) NSString *currentLeaderUser;



@end
