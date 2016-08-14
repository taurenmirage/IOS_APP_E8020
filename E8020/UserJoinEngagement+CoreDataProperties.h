//
//  UserJoinEngagement+CoreDataProperties.h
//  E8020
//
//  Created by Yiwen Fu on 15/11/8.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserJoinEngagement.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserJoinEngagement (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *create_date;
@property (nullable, nonatomic, retain) NSString *engagement_id;
@property (nullable, nonatomic, retain) NSString *join_id;
@property (nullable, nonatomic, retain) NSString *join_type;
@property (nullable, nonatomic, retain) NSNumber *join_value;
@property (nullable, nonatomic, retain) NSString *leader_flag;
@property (nullable, nonatomic, retain) NSNumber *sum_time;
@property (nullable, nonatomic, retain) NSNumber *sum_value;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSNumber *e_sum_value;
@property (nullable, nonatomic, retain) NSNumber *e_sum_time;
@property (nullable, nonatomic, retain) NSString *display_name;

@end

NS_ASSUME_NONNULL_END
