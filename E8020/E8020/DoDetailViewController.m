//
//  DoDetailViewController.m
//  E8020
//
//  Created by Yiwen Fu on 16/1/30.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import "DoDetailViewController.h"

@interface DoDetailViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation DoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchDoFromCoreData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchDoFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[UserDoWork entity] context:mainContext];
    
    [fetchRequest fetchObjectWithValue:self.do_id forAttributes:@"do_id" error:nil];
    
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:mainContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    
    
    UserDoWork *record = [_fetchResultController.fetchedObjects objectAtIndex:0];
    
    self.workMemo.text = record.do_memo;
    self.workTime.text = [NSLocalizedString ( @"dotime" , nil ) stringByAppendingString:[record.work_time stringValue]];
    self.workValue.text = [NSLocalizedString ( @"dovalue" , nil ) stringByAppendingString:[record.work_value stringValue]];
        
 }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancel:(UIButton *)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}

@end
