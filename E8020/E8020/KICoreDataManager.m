//
//  KICoreDataManager.m
//  Kitalker
//
//  Created by Kitalker on 14-3-28.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import "KICoreDataManager.h"

@interface KICoreDataManager ()
@property (nonatomic, strong) NSString  *modelName;
@property (nonatomic, strong) NSString  *dbSavePath;
@property (nonatomic, strong) NSURL     *dbSaveURL;

@property (nonatomic, strong) NSManagedObjectModel          *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext        *mainManagedObjectContext;
@end

@implementation KICoreDataManager

static KICoreDataManager *KI_CORE_DATA_MANAGER;

+ (KICoreDataManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KI_CORE_DATA_MANAGER = [[KICoreDataManager alloc] init];
    });
    return KI_CORE_DATA_MANAGER;
}

- (void)dealloc {
    [self clean];
}

- (id)init {
    if (KI_CORE_DATA_MANAGER == nil) {
        if (self = [super init]) {
            KI_CORE_DATA_MANAGER = self;
            _modelName = @"Model";
        }
    }
    return KI_CORE_DATA_MANAGER;
}

- (void)setupWithModelName:(NSString *)modelName
                dbSavePath:(NSString *)dbSavePath {
    [self disconnect];
    _modelName = modelName;
    _dbSavePath = dbSavePath;
}

- (NSString *)dbSavePath {
    if (_dbSavePath == nil) {
        NSString *fileName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        _dbSavePath = [[NSString alloc] initWithFormat:@"%@/Documents/%@.sqlite", NSHomeDirectory(), fileName];
    }
    return _dbSavePath;
}

- (NSURL *)dbSaveURL {
    if (_dbSaveURL == nil) {
        _dbSaveURL = [NSURL fileURLWithPath:[self dbSavePath]];
    }
    return _dbSaveURL;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        _managedObjectModel = [self createManagedObjectModel:_modelName];
    }
    return _managedObjectModel;
}

- (NSManagedObjectModel *)managedObjectModelForStoreMetadata:(NSDictionary *)sourceMetadata {
    return [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]
                                       forStoreMetadata:sourceMetadata];
}

- (NSManagedObjectModel *)createManagedObjectModel:(NSString *)name {
    NSManagedObjectModel *managedObjectModel = nil;
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"];
    if (!modelPath) {
        modelPath = [[NSBundle mainBundle] pathForResource:name ofType:@"mom"];
    }
    
    NSURL *modelURL = nil;
    
    if (modelPath) {
        modelURL = [NSURL fileURLWithPath:modelPath];
    }
    
    if (modelURL) {
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    } else {
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return managedObjectModel;
}

- (NSString *)storeType {
    return NSSQLiteStoreType;
}

- (NSDictionary *)sourceMetadata:(NSError **)error {
    return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self storeType]
                                                                      URL:[self dbSaveURL]
                                                                    error:error];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:NO], NSInferMappingModelAutomaticallyOption, nil];
        NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:[self storeType]
                                                                                       configuration:nil
                                                                                                 URL:[self dbSaveURL]
                                                                                             options:options
                                                                                               error:&error];
        if (persistentStore) {
#if DEBUG
            NSLog(@"连接数据库成功：%@", [self dbSavePath]);
#endif
        } else {
#if DEBUG
            NSLog(@"连接数据库出错：%d - %@", [error code], [error userInfo]);
#endif
            if (error.code == 134130 || error.code == 134140) {
                //Can't find model for source store
                [self backupDataBase];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager removeItemAtURL:[self dbSaveURL] error:nil]) {
                    persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:[self storeType]
                                                                                configuration:nil
                                                                                          URL:[self dbSaveURL]
                                                                                      options:options
                                                                                        error:&error];
                }
            }
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainManagedObjectContext {
//    NSAssert([NSThread isMainThread], @"[KICoreDataManager mainManagedObjectContext] main thread only");
    if (_mainManagedObjectContext == nil) {
        if ([NSManagedObjectContext instancesRespondToSelector:@selector(initWithConcurrencyType:)]) {
            _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        } else {
            _mainManagedObjectContext = [[NSManagedObjectContext alloc] init];
        }
        [_mainManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(managedObjectContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)createManagedObjectContext {
    NSManagedObjectContext *managedObjectContext = nil;
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    return managedObjectContext;
}

- (void)managedObjectContextDidSave:(NSNotification *)noti {
    NSManagedObjectContext *sender = (NSManagedObjectContext *)noti.object;
    if (sender != _mainManagedObjectContext
        && sender.persistentStoreCoordinator == _mainManagedObjectContext.persistentStoreCoordinator) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainManagedObjectContext mergeChangesFromContextDidSaveNotification:noti];
        });
    }
}

- (BOOL)commitUpdate {
    if (_mainManagedObjectContext == nil) {
        return NO;
    }
    return [self.mainManagedObjectContext commitUpdate];
}

- (void)clean {
    _modelName = nil;
    _dbSavePath = nil;
    _dbSaveURL = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _mainManagedObjectContext = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)backupDataBase {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyMMddhhmmSSsss"];
    return [self backupDataBaseWithName:[NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]]];
}

- (BOOL)backupDataBaseWithName:(NSString *)dbName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *sourceURL = [self dbSaveURL];
    NSString *desPath = [NSString stringWithFormat:@"%@-%@", sourceURL.relativePath, dbName];
#if DEBUG
    NSLog(@"备份数据库至：%@", desPath);
#endif
    NSURL *desURL = [NSURL fileURLWithPath:desPath];
    return [fileManager copyItemAtURL:sourceURL toURL:desURL error:nil];
}

- (BOOL)removeDataBase {
    if (_mainManagedObjectContext != nil) {
        [_mainManagedObjectContext commitUpdate];
    }
    [self backupDataBase];
    [self disconnect];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtURL:[self dbSaveURL] error:nil];
}

- (void)disconnect {
    [self commitUpdate];
    [self clean];
}

/*高级功能*/

//是否需要进行数据库迁移
- (BOOL)isMigrationNeeded {
    NSError *error = nil;
    
    NSDictionary *sourceMetadata = [self sourceMetadata:&error];
    BOOL isMigrationNeeded = NO;
    
    if (sourceMetadata != nil) {
        NSManagedObjectModel *destinationModel = [self managedObjectModel];
        isMigrationNeeded = ![destinationModel isConfiguration:nil
                                   compatibleWithStoreMetadata:sourceMetadata];
    }
#if DEBUG
    NSLog(@"isMigrationNeeded: %d", isMigrationNeeded);
#endif
    return isMigrationNeeded;
}

@end
