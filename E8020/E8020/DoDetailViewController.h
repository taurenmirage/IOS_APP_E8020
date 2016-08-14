//
//  DoDetailViewController.h
//  E8020
//
//  Created by Yiwen Fu on 16/1/30.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICoreDataManager.h"
#import "NSManagedObject+KIAdditions.h"
#import "NSManagedObjectContext+KIAdditions.h"
#import "KIFetchRequest.h"

#import "UserDoWork.h"

@interface DoDetailViewController : UIViewController{
    NSFetchedResultsController  *_fetchResultController;
}


@property (strong, nonatomic) IBOutlet UILabel *workTime;
@property (strong, nonatomic) IBOutlet UILabel *workValue;


@property (strong, nonatomic) IBOutlet UILabel *workMemo;

@property (strong, nonatomic) NSString *do_id;

@end
