//
//  JoinListTableViewController.m
//  E8020
//
//  Created by Yiwen Fu on 15/11/8.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import "JoinListTableViewController.h"
#import "ConstURL.h"

#import "JoinTableViewCell.h"

@interface JoinListTableViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation JoinListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchJoinListFromCoreData];
    
    if ([self.sumType isEqualToString:@"0"])
    {
        self.title =  NSLocalizedString ( @"sumvalue" , nil );
    }
    else
    {
        self.title =  NSLocalizedString ( @"sumtime" , nil );
    }
    
    //除去多余行数
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) fetchJoinListFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[UserJoinEngagement entity] context:mainContext];
    
    [fetchRequest fetchObjectWithValue:self.engagment_id forAttributes:@"engagement_id" error:nil];
    
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:mainContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_fetchResultController.fetchedObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Join" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UserJoinEngagement *record = [_fetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    cell.userName.text = record.display_name;
    if ([self.sumType isEqualToString:@"0"]) {
        cell.sum.text = [NSString stringWithFormat:@"%0.0lf",[record.sum_value doubleValue] ];
        cell.ratio.text = [[NSString stringWithFormat:@"%0.0lf",100 * [record.sum_value doubleValue]/self.engagementSum  ] stringByAppendingString:@"%"];
    }
    else {
        cell.sum.text = [NSString stringWithFormat:@"%0.0lf",[record.sum_time doubleValue] ];
        cell.ratio.text = [[NSString stringWithFormat:@"%0.0lf",100 * [record.sum_time doubleValue]/self.engagementSum  ]stringByAppendingString:@"%"];
    }
    
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
