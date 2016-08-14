//
//  NSManagedObject+KIAdditions.h
//  Kitalker
//
//  Created by Kitalker on 14-3-28.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (KIAdditions)

+ (NSString *)entityName;

/*必须重写此方法*/
+ (NSString *)defaultSortAttribute;

+ (NSEntityDescription *)entity;

/*查询出所有的NSManagedObject*/
+ (NSArray *)objects;

+ (NSArray *)objectsWithContext:(NSManagedObjectContext *)context;

/*根据条件查询出NSManagedObject*/
+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate;

+ (NSArray *)objectsWithContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;

+ (NSArray *)objectsWithFormat:(NSString *)fmt,...;

+ (NSArray *)objectsWithContext:(NSManagedObjectContext *)context format:(NSString *)fmt,...;

+ (id)firstObject;

+ (id)firstObjectWithContext:(NSManagedObjectContext *)context;

+ (id)firstObjectWithFormat:(NSString *)fmt,...;

+ (id)firstObjectWithContext:(NSManagedObjectContext *)context format:(NSString *)fmt,...;

+ (id)lastObject;

+ (id)lastObjectWithContext:(NSManagedObjectContext *)context;

+ (id)lastObjectWithFormat:(NSString *)fmt,...;

+ (id)lastObjectWithContext:(NSManagedObjectContext *)context format:(NSString *)fmt,...;

/*新建一个NSManagedObject*/
+ (id)insertWithContext:(NSManagedObjectContext *)context;

/*新建一个NSManagedObject之前，先根据value和attribute进行查找，
 如果查找到对象，则返回该对象，如果没有查找到，则新建一个对象*/
+ (id)insertWithContext:(NSManagedObjectContext *)context
              withValue:(id)value
           forAttribute:(NSString *)attribute;

- (void)remove;

- (void)removeFromContext:(NSManagedObjectContext *)context;

@end
