//
//  AddDoTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 15/11/7.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "UserDoWork.h"

@interface AddDoTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}

@property (strong, nonatomic) IBOutlet UITextField *workTime;
@property (strong, nonatomic) IBOutlet UITextField *workValue;
@property (strong, nonatomic) IBOutlet UITextField *workDescription;

@property (nonatomic,strong) NSDictionary *record;

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *engagement_id;
@property (nonatomic, strong) NSString *work_id;

@end
