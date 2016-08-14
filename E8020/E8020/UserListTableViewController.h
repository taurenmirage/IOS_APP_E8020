//
//  UserListTableViewController.h
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

#import "User.h"

@interface UserListTableViewController : UITableViewController{
    NSFetchedResultsController  *_fetchResultController;
}
@property (nonatomic,strong) NSArray *userList;
@property (nonatomic,strong) NSString *work_id;


@end
