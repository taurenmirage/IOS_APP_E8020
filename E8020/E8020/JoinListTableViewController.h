//
//  JoinListTableViewController.h
//  E8020
//
//  Created by Yiwen Fu on 15/11/8.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "UserJoinEngagement.h"

@interface JoinListTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}
@property (nonatomic,strong) NSArray *joinList;
@property (nonatomic,strong) NSString *engagment_id;

@property (nonatomic,strong) NSString *sumType;
@property (nonatomic) double engagementSum;

@end
