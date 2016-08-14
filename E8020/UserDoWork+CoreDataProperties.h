//
//  UserDoWork+CoreDataProperties.h
//  E8020
//
//  Created by Yiwen Fu on 16/1/15.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserDoWork.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDoWork (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *active_flag;
@property (nullable, nonatomic, retain) NSDate *appove_date;
@property (nullable, nonatomic, retain) NSString *appove_user;
@property (nullable, nonatomic, retain) NSDate *begin_date;
@property (nullable, nonatomic, retain) NSDate *create_date;
@property (nullable, nonatomic, retain) NSDate *deny_date;
@property (nullable, nonatomic, retain) NSString *deny_user;
@property (nullable, nonatomic, retain) NSString *do_id;
@property (nullable, nonatomic, retain) NSDate *end_date;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *work_id;
@property (nullable, nonatomic, retain) NSNumber *work_time;
@property (nullable, nonatomic, retain) NSNumber *work_value;
@property (nullable, nonatomic, retain) NSString *do_memo;
@property (nullable, nonatomic, retain) NSString *display_name;

@end

NS_ASSUME_NONNULL_END
