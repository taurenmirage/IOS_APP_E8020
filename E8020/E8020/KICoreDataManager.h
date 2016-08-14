//
//  KICoreDataManager.h
//  Kitalker
//
//  Created by Kitalker on 14-3-28.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+KIAdditions.h"
#import "NSManagedObject+KIAdditions.h"
#import "KIFetchRequest.h"

@interface KICoreDataManager : NSObject

+ (KICoreDataManager *)sharedInstance;

/*如果需要特殊配置，调用这个方法进行初始化*/
- (void)setupWithModelName:(NSString *)modelName
                dbSavePath:(NSString *)dbSavePath;

/*主线程专用*/
- (NSManagedObjectContext *)mainManagedObjectContext;

/*创建新的ManagedObjectContext, 一般用于非主线的情况下*/
- (NSManagedObjectContext *)createManagedObjectContext;

/*提交所有的更新*/
- (BOOL)commitUpdate;

- (BOOL)backupDataBase;

- (BOOL)removeDataBase;

/*断开连接*/
- (void)disconnect;

@end
