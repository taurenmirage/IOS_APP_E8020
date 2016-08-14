//
//  Work+CoreDataProperties.h
//  E8020
//
//  Created by Yiwen Fu on 15/10/17.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Work.h"

NS_ASSUME_NONNULL_BEGIN

@interface Work (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *active_flag;
@property (nullable, nonatomic, retain) NSDate *appove_date;
@property (nullable, nonatomic, retain) NSString *appove_user;
@property (nullable, nonatomic, retain) NSString *assign_user;
@property (nullable, nonatomic, retain) NSDate *begin_date;
@property (nullable, nonatomic, retain) NSDate *complete_date;
@property (nullable, nonatomic, retain) NSString *complete_flag;
@property (nullable, nonatomic, retain) NSString *complete_user;
@property (nullable, nonatomic, retain) NSDate *deny_date;
@property (nullable, nonatomic, retain) NSString *deny_user;
@property (nullable, nonatomic, retain) NSDate *end_date;
@property (nullable, nonatomic, retain) NSString *engagement_id;
@property (nullable, nonatomic, retain) NSNumber *exp_work_time;
@property (nullable, nonatomic, retain) NSNumber *exp_work_value;
@property (nullable, nonatomic, retain) NSString *work_description;
@property (nullable, nonatomic, retain) NSString *work_id;
@property (nullable, nonatomic, retain) NSString *work_title;
@property (nullable, nonatomic, retain) NSString *work_type;

@end

NS_ASSUME_NONNULL_END
