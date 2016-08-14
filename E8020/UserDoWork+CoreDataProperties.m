//
//  UserDoWork+CoreDataProperties.m
//  E8020
//
//  Created by Yiwen Fu on 16/1/15.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserDoWork+CoreDataProperties.h"

@implementation UserDoWork (CoreDataProperties)

@dynamic active_flag;
@dynamic appove_date;
@dynamic appove_user;
@dynamic begin_date;
@dynamic create_date;
@dynamic deny_date;
@dynamic deny_user;
@dynamic do_id;
@dynamic end_date;
@dynamic user_id;
@dynamic work_id;
@dynamic work_time;
@dynamic work_value;
@dynamic do_memo;
@dynamic display_name;

+ (NSString *)defaultSortAttribute {
    return @"do_id";
}

@end
