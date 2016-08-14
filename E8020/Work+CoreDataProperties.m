//
//  Work+CoreDataProperties.m
//  E8020
//
//  Created by Yiwen Fu on 15/10/17.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Work+CoreDataProperties.h"

@implementation Work (CoreDataProperties)

@dynamic active_flag;
@dynamic appove_date;
@dynamic appove_user;
@dynamic assign_user;
@dynamic begin_date;
@dynamic complete_date;
@dynamic complete_flag;
@dynamic complete_user;
@dynamic deny_date;
@dynamic deny_user;
@dynamic end_date;
@dynamic engagement_id;
@dynamic exp_work_time;
@dynamic exp_work_value;
@dynamic work_description;
@dynamic work_id;
@dynamic work_title;
@dynamic work_type;

+ (NSString *)defaultSortAttribute {
    return @"work_id";
}

@end
