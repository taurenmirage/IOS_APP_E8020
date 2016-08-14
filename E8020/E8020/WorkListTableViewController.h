//
//  WorkListTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 15/10/21.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "Work.h"
#import "Engagement.h"

@interface WorkListTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}

@property (nonatomic,strong) NSArray *workList;
@property (strong, nonatomic) NSArray *pickerData;
@property (nonatomic,strong) NSString *showType;

@property (strong, nonatomic) IBOutlet UIButton *engagementTitle;

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *engagement_id;
@property (nonatomic, strong) NSString *currentEngagementTitle;

@property (nonatomic,strong) NSMutableArray *engagementListForPicker;


@end
