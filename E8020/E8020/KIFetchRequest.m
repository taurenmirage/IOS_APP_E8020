//
//  KIFetchRequest.m
//  Kitalker
//
//  Created by Kitalker on 14-3-28.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import "KIFetchRequest.h"
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"

@interface KIFetchRequest ()
@property (nonatomic, strong) NSMutableDictionary       *sorts;
@property (nonatomic, assign) NSManagedObjectContext    *context;
@end

@implementation KIFetchRequest

- (id)initWithEntity:(NSEntityDescription *)entity {
    NSAssert([NSThread isMainThread], @"[KIFetchRequest initWithEntity] main thread only");
    return [self initWithEntity:entity context:[KICoreDataManager sharedInstance].mainManagedObjectContext];
}

- (id)initWithEntity:(NSEntityDescription *)entity context:(NSManagedObjectContext *)context {
    if(self = [super init]) {
        _context = context;
        [self setEntity:entity];
    }
    return self;
}

- (void)addSortDescriptor:(NSSortDescriptor *)sortDescriptor {
    if (_sorts == nil) {
        _sorts = [[NSMutableDictionary alloc] init];
    }
    [_sorts setObject:sortDescriptor forKey:sortDescriptor.key];
}

- (void)addSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending {
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    [self addSortDescriptor:sort];
    sort = nil;
}

- (void)removeSortDescriptorWithKey:(NSString *)key {
    if (_sorts != nil) {
        [_sorts removeObjectForKey:key];
    }
}

- (void)removeAllSortDescriptor {
    if (_sorts != nil) {
        [_sorts removeAllObjects];
    }
}

- (NSArray *)sortDescriptors {
    if (_sorts == nil || _sorts.count == 0) {
        Class class = NSClassFromString(self.entityName);
        if ([class methodForSelector:@selector(defaultSortAttribute)]) {
            NSString *sortKey = [class defaultSortAttribute];
            [self addSortDescriptorWithKey:sortKey ascending:YES];
        }
    }
    return [_sorts allValues];
}

- (void)setPageNumber:(NSUInteger)pageNumber {
    _pageNumber = pageNumber;
    [self setFetchOffset:_pageSize*_pageNumber];
}

- (void)setPageSize:(NSUInteger)pageSize {
    _pageSize = pageSize;
    [self setFetchLimit:_pageSize];
}

- (NSArray *)fetchObjects:(NSError **)error {
    NSArray *objects = nil;
    
    [self setFetchLimit:[self pageSize]];
    [self setFetchOffset:[self pageSize] * [self pageNumber]];
    
    @try {
        objects = [[self context] executeFetchRequest:self
                                                error:error];
        if (error != nil) {
            NSLog(@"查询过程中出错：%@", [*error description]);
        }
    }
    @catch (NSException *exception) {
        objects = nil;
    }
    @finally {
    }
   
    return objects;
}

- (NSManagedObject *)fetchObject:(NSError **)error {
    NSArray *objects = [self fetchObjects:error];
    if (objects.count > 0) {
        return [objects objectAtIndex:0];
    }
    return nil;
}

- (NSManagedObject *)fetchObjectWithValue:(id)value forAttributes:(NSString *)attributes error:(NSError **)error {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", attributes, value];
    [self setPredicate:predicate];
    return [self fetchObject:error];
}

- (NSUInteger)numberOfObjects:(NSError **)error {
    NSUInteger count = 0;
    @try {
        count = [[self context] countForFetchRequest:self error:error];
    }
    @catch (NSException *exception) {
        count = 0;
    }
    @finally {
    }
    return count;
}

- (void)dealloc {
    _sorts = nil;
}

@end
