//
//  User+CoreDataProperties.h
//  E8020
//
//  Created by Yiwen Fu on 15/10/17.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *active_flag;
@property (nullable, nonatomic, retain) NSString *company_id;
@property (nullable, nonatomic, retain) NSString *display_name;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *user_name;

@end

NS_ASSUME_NONNULL_END
