//
//  NSManagedObject+KIAdditions.m
//  Kitalker
//
//  Created by Kitalker on 14-3-28.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import "NSManagedObject+KIAdditions.h"
#import "KICoreDataManager.h"
#import "KIFetchRequest.h"

@implementation NSManagedObject (KIAdditions)

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (NSString *)defaultSortAttribute {
    NSString *errorMsg = [NSString stringWithFormat:@"%@ 必须重写 [NSManagedObject defaultSortAttribute] 方法", [self entityName]];
    NSAssert(NO, errorMsg);
    return nil;
}

+ (NSEntityDescription *)entity {
    return [NSEntityDescription entityForName:[self entityName]
                       inManagedObjectContext:[KICoreDataManager sharedInstance].mainManagedObjectContext];
}

+ (NSArray *)objects {
    return [self objectsWithPredicate:nil];
}

+ (NSArray *)objectsWithContext:(NSManagedObjectContext *)context {
    return [self objectsWithContext:context predicate:nil];
}

+ (NSArray *)objectsWithContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate {
    KIFetchRequest *fetchRequest = nil;
    if (context == nil) {
        return nil;
    }
    
    fetchRequest = [[KIFetchRequest alloc] initWithEntity:[self entity] context:context];
    
    if (predicate != nil) {
        [fetchRequest setPredicate:predicate];
    }
    
    return [fetchRequest fetchObjects:nil];
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *context = nil;
    if ([NSThread isMainThread]) {
        context = [KICoreDataManager sharedInstance].mainManagedObjectContext;
    } else {
        context = [KICoreDataManager sharedInstance].createManagedObjectContext;
    }
    return [self objectsWithContext:context predicate:predicate];
}

+ (NSArray *)objectsWithFormat:(NSString *)fmt,... {
    va_list args;
    va_start(args, fmt);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:fmt arguments:args];
    va_end(args);
    
    return [self objectsWithPredicate:predicate];
}

+ (NSArray *)objectsWithContext:(NSManagedObjectContext *)context format:(NSString *)fmt,... {
    va_list args;
    va_start(args, fmt);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:fmt arguments:args];
    va_end(args);
    return [self objectsWithContext:context predicate:predicate];
}

+ (id)firstObject {
    return [[self objects] firstObject];
}

+ (id)firstObjectWithContext:(NSManagedObjectContext *)context {
    return [[self objectsWithContext:context] firstObject];
}

+ (id)firstObjectWithFormat:(NSString *)fmt, ... {
    va_list args;
    va_start(args, fmt);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:fmt arguments:args];
    va_end(args);
    return [[self objectsWithPredicate:predicate] firstObject];
}

+ (id)firstObjectWithContext:(NSManagedObjectContext *)context format:(NSString *)fmt,... {
    va_list args;
    va_start(args, fmt);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:fmt arguments:args];
    va_end(args);
    return [[self objectsWithContext:context predicate:predicate] firstObject];
}

+ (id)lastObject {
    return [[self objects] lastObject];
}

+ (id)lastObjectWithContext:(NSManagedObjectContext *)context {
    return [[self objectsWithContext:context] lastObject];
}

+ (id)lastObjectWithFormat:(NSString *)fmt,... {
    va_list args;
    va_start(args, fmt);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:fmt arguments:args];
    va_end(args);
    return [[self objectsWithPredicate:predicate] lastObject];
}

+ (id)lastObjectWithContext:(NSManagedObjectContext *)context format:(NSString *)fmt,... {
    va_list args;
    va_start(args, fmt);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:fmt arguments:args];
    va_end(args);
    return [[self objectsWithContext:context predicate:predicate] lastObject];
}

+ (id)insertWithContext:(NSManagedObjectContext *)context {
    NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entity]
                                       insertIntoManagedObjectContext:context];
    return object;
}

+ (id)insertWithContext:(NSManagedObjectContext *)context
              withValue:(id)value
           forAttribute:(NSString *)attribute {
    KIFetchRequest *request = [[KIFetchRequest alloc] initWithEntity:[self entity] context:context];
    [request setPageSize:1];
    
    NSManagedObject *object = [request fetchObjectWithValue:value forAttributes:attribute error:nil];
    if (object == nil) {
        object = [self insertWithContext:context];
        [object setValue:value forKey:attribute];
    }
    return object;
}

- (void)remove {
    [self.managedObjectContext deleteObject:self];
}

- (void)removeFromContext:(NSManagedObjectContext *)context {
    if (context == nil) {
        return ;
    }
    [context deleteObject:self];
}

@end
