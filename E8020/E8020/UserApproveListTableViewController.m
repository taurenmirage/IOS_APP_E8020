//
//  UserApproveListTableViewController.m
//  E8020
//
//  Created by Yiwen Fu on 16/1/12.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import "UserApproveListTableViewController.h"
#import "ConstURL.h"

#import "UserApproveTableViewCell.h"

@interface UserApproveListTableViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation UserApproveListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchJoinListFromCoreData];
    
    //除去多余行数
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchJoinListFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[UserJoinEngagement entity] context:mainContext];
    
    
    if ([self.engagementID isEqualToString:@""])
    {
        NSLog(@"No Engagement ID");
    }
    else
    {
        [fetchRequest fetchObjectWithValue:self.engagementID forAttributes:@"engagement_id" error:nil];
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:mainContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    }
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

     return [_fetchResultController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserApproveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Join" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UserJoinEngagement *record = [_fetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    cell.userName.text = record.display_name;
    cell.join_id = record.join_id;
    
    cell.joinFlag.tag = [record.join_id integerValue];
    
    if ([record.join_type isEqualToString:@"1"]) {
        cell.joinFlag.on = YES;
    }
    else{
        cell.joinFlag.on = NO;
    }
    
    return cell;
}


- (IBAction)joinChange:(UISwitch *)sender {
    
   
    
    
    self.selectJoinID = [NSString stringWithFormat: @"%ld", (long)sender.tag];
    if (sender.isOn) {
        [self UpdateToServer:@"1"];
    }
    else
    {
        [self UpdateToServer:@"2"];
    }
    
    NSLog( @"The switch is %@", sender.on ? @"ON" : @"OFF" );
}

- (void)UpdateToServer:(NSString *)activeFlag{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/userjoinengagement/"];
    tempURL = [tempURL stringByAppendingString:self.selectJoinID];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"PUT"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"join_type=%@&join_value=%@",activeFlag,_workValue] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSError *error = [[NSError alloc] init];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    if (error.code == -1009) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"error" , nil ) message:NSLocalizedString ( @"connecterror" , nil ) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        NSDictionary *propertyListResults =[NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL ];
        //NSLog(@"FetchResult = %@",propertyListResults);
       
        
        NSLog(@"Success");
        
        [self saveDataToCoreData:activeFlag];
        
    }
    
    
}


- (void) saveDataToCoreData:(NSString *)activeFlag{
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    UserJoinEngagement *join = [UserJoinEngagement insertWithContext:context withValue:self.selectJoinID forAttribute:@"join_id"];
    

    join.join_type = activeFlag;
  
    [context commitUpdate];
    
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:  forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
