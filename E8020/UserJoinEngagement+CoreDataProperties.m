//
//  UserJoinEngagement+CoreDataProperties.m
//  E8020
//
//  Created by Yiwen Fu on 15/11/8.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserJoinEngagement+CoreDataProperties.h"

@implementation UserJoinEngagement (CoreDataProperties)

@dynamic create_date;
@dynamic engagement_id;
@dynamic join_id;
@dynamic join_type;
@dynamic join_value;
@dynamic leader_flag;
@dynamic sum_time;
@dynamic sum_value;
@dynamic user_id;
@dynamic e_sum_value;
@dynamic e_sum_time;
@dynamic display_name;

+ (NSString *)defaultSortAttribute {
    return @"join_id";
}

@end
