//
//  Company+CoreDataProperties.m
//  E8020
//
//  Created by Yiwen Fu on 15/10/17.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Company+CoreDataProperties.h"

@implementation Company (CoreDataProperties)

@dynamic active_flag;
@dynamic company_id;
@dynamic company_name;

+ (NSString *)defaultSortAttribute {
    return @"company_id";
}

@end
