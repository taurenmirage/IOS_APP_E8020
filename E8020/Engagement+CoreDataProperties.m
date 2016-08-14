//
//  Engagement+CoreDataProperties.m
//  E8020
//
//  Created by Yiwen Fu on 16/1/14.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Engagement+CoreDataProperties.h"

@implementation Engagement (CoreDataProperties)

@dynamic active_flag;
@dynamic begin_date;
@dynamic company_id;
@dynamic complete_date;
@dynamic complete_flag;
@dynamic complete_user;
@dynamic current_user_time;
@dynamic current_user_value;
@dynamic end_date;
@dynamic engagement_description;
@dynamic engagement_id;
@dynamic engagement_title;
@dynamic engagement_type;
@dynamic leader_user;
@dynamic sum_time;
@dynamic sum_value;
@dynamic unique_id;
@dynamic average_value;

+ (NSString *)defaultSortAttribute {
    return @"engagement_id";
}

@end
