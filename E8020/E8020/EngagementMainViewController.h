//
//  EngagementMainViewController.h
//  E8020
//
//  Created by Yiwen Fu on 15/10/17.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRadialProgressView.h"
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "Engagement.h"
#import "UserJoinEngagement.h"
#import "User.h"
#import "Work.h"


@interface EngagementMainViewController : UIViewController{
    NSFetchedResultsController  *_fetchResultController;
}
@property (nonatomic,strong) NSArray *engagementList;
@property (nonatomic,strong) NSArray *userjoinengagementList;
@property (nonatomic,strong) NSArray *uniqueList;
@property (nonatomic,strong) NSArray *userList;
@property (nonatomic,strong) NSMutableArray *engagementListForPicker;
@property (nonatomic,strong) NSArray *workList;

@property (strong, nonatomic) IBOutlet UIButton *sumValue;

@property (nonatomic,strong) NSDictionary *record;


@property (strong, nonatomic) IBOutlet UIView *ringView;

@property (strong, nonatomic) IBOutlet UIButton *engagemtTitle;

@property (nonatomic) double currentSumValue;
@property (nonatomic) double currentSumTime;
@property (nonatomic) double currentValue;
@property (nonatomic) double currentTime;

@property (strong, nonatomic) NSArray *pickerData;

@property (nonatomic,strong) NSString *uniqueID;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *engagement_id;
@property (nonatomic, strong) NSString *currentEngagementTitle;

@property (nonatomic, strong) NSString *leaderUser;
@property (nonatomic, strong) NSString *sumType;

@property (nonatomic, strong) NSString *selfJoinValue;

@property (strong, nonatomic) IBOutlet UISegmentedControl *valueTimeSelect;

@end
