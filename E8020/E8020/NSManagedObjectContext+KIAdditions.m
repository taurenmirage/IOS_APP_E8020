//
//  NSManagedObjectContext+KIAdditions.m
//  Kitalker
//
//  Created by Kitalker on 14-3-28.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import "NSManagedObjectContext+KIAdditions.h"

@implementation NSManagedObjectContext (KIAdditions)

- (BOOL)commitUpdate {
    return [self commitUpdate:nil];
}

- (BOOL)commitUpdate:(NSError **)error {
    BOOL saveStatus = NO;
    if ([self hasChanges]) {
        saveStatus = [self save:error];
    }
    return saveStatus;
}

@end
