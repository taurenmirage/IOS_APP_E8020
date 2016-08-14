//
//  AddWorkTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 15/11/1.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "Work.h"
#import "UserJoinEngagement.h"


@interface AddWorkTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}


@property (strong, nonatomic) IBOutlet UITextField *workTitle;
@property (strong, nonatomic) IBOutlet UITextField *workDescription;

@property (strong, nonatomic) IBOutlet UITextField *expTime;
@property (strong, nonatomic) IBOutlet UITextField *expValue;
@property (strong, nonatomic) IBOutlet UIButton *endDate;

@property (strong, nonatomic) IBOutlet UIButton *userName;


@property (nonatomic,strong) NSDictionary *record;

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *engagement_id;

@property (strong, nonatomic) NSArray *pickerData;
@property (nonatomic,strong) NSMutableArray *userNameListForPicker;

@property (nonatomic,strong) NSString *assignUserID;
@property (nonatomic,strong) NSString *assignUserName;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@end