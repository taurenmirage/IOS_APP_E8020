//
//  Engagement+CoreDataProperties.h
//  E8020
//
//  Created by Yiwen Fu on 16/1/14.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Engagement.h"

NS_ASSUME_NONNULL_BEGIN

@interface Engagement (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *active_flag;
@property (nullable, nonatomic, retain) NSDate *begin_date;
@property (nullable, nonatomic, retain) NSString *company_id;
@property (nullable, nonatomic, retain) NSDate *complete_date;
@property (nullable, nonatomic, retain) NSString *complete_flag;
@property (nullable, nonatomic, retain) NSString *complete_user;
@property (nullable, nonatomic, retain) NSNumber *current_user_time;
@property (nullable, nonatomic, retain) NSNumber *current_user_value;
@property (nullable, nonatomic, retain) NSDate *end_date;
@property (nullable, nonatomic, retain) NSString *engagement_description;
@property (nullable, nonatomic, retain) NSString *engagement_id;
@property (nullable, nonatomic, retain) NSString *engagement_title;
@property (nullable, nonatomic, retain) NSString *engagement_type;
@property (nullable, nonatomic, retain) NSString *leader_user;
@property (nullable, nonatomic, retain) NSNumber *sum_time;
@property (nullable, nonatomic, retain) NSNumber *sum_value;
@property (nullable, nonatomic, retain) NSString *unique_id;
@property (nullable, nonatomic, retain) NSNumber *average_value;

@end

NS_ASSUME_NONNULL_END
