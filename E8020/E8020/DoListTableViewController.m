//
//  DoListTableViewController.m
//  E8020
//
//  Created by Yiwen Fu on 15/10/25.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import "DoListTableViewController.h"
#import "DoListTableViewCell.h"
#import "AddDoTableViewController.h"
#import "DoListNavigationViewController.h"
#import "DoDetailViewController.h"

#import "ConstURL.h"

@interface DoListTableViewController ()<NSFetchedResultsControllerDelegate>


@end

@implementation DoListTableViewController

- (void)setdoList:(NSArray *)doList
{
    _doList= doList;
    [self.tableView reloadData];
    
   
    //除去多余行数
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DoListNavigationViewController *rvc = (DoListNavigationViewController * )self.parentViewController;
    
    self.work_id = rvc.work_id;
    
    [self fetchDoList];
    
    [self fetchDoListFromCoreData];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self readNSUserDefaults];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"currentEngagementID"];
    self.engagement_id = myString;
    
    myString = [userDefaultes stringForKey:@"userID"];
    self.user_id = myString;
    
    myString = [userDefaultes stringForKey:@"currentEngagementTitle"];
    self.currentEngagementTitle = myString;
    
    self.currentUserName = [userDefaultes stringForKey:@"displayName"];
    
    self.selfJoinValue = [userDefaultes stringForKey:@"currentEJoinValue"];
    
    self.currentLeaderUser = [userDefaultes stringForKey:@"currentLeaderUser"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDoList{
    
    self.doList = nil;
    
    dispatch_async(dispatch_queue_create("fetch-dolist", 0), ^{
        NSString *tempURL;
        NSString *workID;
        
        workID = self.work_id;
        
        tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/userdo/"];
        tempURL = [tempURL stringByAppendingString:workID];
        
        
        NSURL *url= [NSURL URLWithString:tempURL];
        NSError *error = nil;
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error:&error];
        
        
        
        //NSData *jsonResult = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
        NSLog(@"Error: %@", error);
        
        if (error != nil) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:error.debugDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alter show];
            
            
        }
        else{
            NSDictionary *propertyListResults =[NSJSONSerialization JSONObjectWithData:response options:0 error:NULL ];
            self.doList = (NSArray *)propertyListResults;
            
            NSLog(@"doList = %@",self.doList);
            
            [self saveDataToCoreData];
            
        }
        
        
    });
}

- (void) saveDataToCoreData {
    
    
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
        
    NSArray *record;
    
    
    
    for (NSUInteger i = 0; i < [self.doList count]; i++)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        
        record = [self.doList valueForKey:[ NSString  stringWithFormat:  @"%lu" , (unsigned long)i]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        UserDoWork *doWork = [UserDoWork insertWithContext:context withValue:[record valueForKeyPath:@"do_id"] forAttribute:@"do_id"];
        
        doWork.work_id = [record valueForKeyPath:@"work_id"];
        doWork.user_id = [record valueForKeyPath:@"user_id"];
        doWork.active_flag = [record valueForKeyPath:@"active_flag"];
        doWork.do_memo =  [record valueForKeyPath:@"do_memo"];
        doWork.display_name = [record valueForKeyPath:@"display_name"];
        
        doWork.work_time = [f numberFromString:[record valueForKeyPath:@"work_time"]];
        doWork.work_value = [f numberFromString:[record valueForKeyPath:@"work_value"]];
        //doWork.begin_date = [dateFormatter dateFromString:[record valueForKeyPath:@"begin_date"]];
        //doWork.end_date = [dateFormatter dateFromString:[record valueForKeyPath:@"end_date"]];
        
        doWork.create_date = [dateFormatter dateFromString:[record valueForKeyPath:@"do_date"]];

        [context commitUpdate];
    }
}


- (IBAction)addDo:(UIBarButtonItem *)sender {

        UIAlertController *searchController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"msg010" , nil ) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    

    
    [searchController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder  = NSLocalizedString ( @"dotime" , nil );
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
    }];
    
   
         [searchController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString ( @"domemo" , nil );
        }];

        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
         
            
            if ([searchController.textFields.firstObject.text isEqualToString:@""]) {
                //[searchController.textFields.firstObject becomeFirstResponder];
            }
            else
            {
                self.work_time = searchController.textFields.firstObject.text;
                self.work_memo = searchController.textFields.lastObject.text;
                
                [self SaveToServer];
                //[self fetchCanvasByUniqueIDList];
            }
            
        }];
        
        [searchController addAction:cancelAction];
        [searchController addAction:okAction];
        
        [self presentViewController:searchController animated:YES completion:nil];

}

- (void) fetchDoListFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[UserDoWork entity] context:mainContext];
    
    [fetchRequest fetchObjectWithValue:self.work_id forAttributes:@"work_id" error:nil];
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:mainContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_fetchResultController.fetchedObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doList" forIndexPath:indexPath];
    
    UserDoWork *record = [_fetchResultController.fetchedObjects objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // Configure the cell...
    cell.createDate.text = [dateFormatter stringFromDate:record.create_date];
    cell.userName.text = record.display_name;
    cell.do_id = record.do_id;
    cell.workTime.text = [@"+" stringByAppendingString: record.work_time.description];
    

    
    
    return cell;
}

- (void)SaveToServer{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/userdowork"];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    
    NSString *tempDescription;
    NSString *tempTime;
    NSString *tempValue;
    
    
    tempDescription = self.work_memo;
    tempTime = self.work_time;
    
    double value = [self.work_time doubleValue] * [self.selfJoinValue doubleValue];
    tempValue = [NSString stringWithFormat:@"%.2f",value];
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"work_id=%@&work_time=%@&work_value=%@&user_id=%@&do_memo=%@",self.work_id,tempTime,tempValue,_user_id,tempDescription] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        self.record = propertyListResults;
        
        NSLog(@"newUserDoWork = %@",self.record);
        
        NSLog(@"Success");
        
        [self saveDoDataToCoreData];
        
    }
    
    
}

- (void)UpdateToServer:(NSString *)activeFlag{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/userdowork/"];
    tempURL = [tempURL stringByAppendingString:self.do_id];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"PUT"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
 
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"active_flag=%@&appove_user=%@",@"1",_user_id] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        self.record = propertyListResults;
        
        NSLog(@"newUserDoWork = %@",self.record);
        
        NSLog(@"Success");
        
        [self saveDoActiveFlagDataToCoreData:activeFlag];
        
    }
    
    
}

- (void) saveDoDataToCoreData {
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    UserDoWork *work = [UserDoWork insertWithContext:context withValue:[self.record valueForKeyPath:@"do_id"] forAttribute:@"do_id"];
    
    work.work_id = self.work_id;
    work.create_date = [dateFormatter dateFromString:[self.record valueForKeyPath:@"create_date"]];
    work.display_name = self.currentUserName;
    work.work_time = [f numberFromString:[self.record valueForKeyPath:@"work_time"]];
    work.work_value = [f numberFromString:[self.record valueForKeyPath:@"work_value"]];
    
    
    [context commitUpdate];
    
    
}

- (void) saveDoActiveFlagDataToCoreData:(NSString *)activeFlag {
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
    

    
    UserDoWork *dowork = [UserDoWork insertWithContext:context withValue:self.do_id forAttribute:@"do_id"];
    
    dowork.active_flag  = activeFlag;
    
    
    [context commitUpdate];
    
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    /*
     if (self.isOwner == YES) {
     return YES;
     }
     else
     {
     return  NO;
     }
     */
    
    if ([self.user_id isEqualToString:self.currentLeaderUser])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *activeFlag;
    
    //NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    
    DoListTableViewCell  *cell = (DoListTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //activeFlag = cell.activeFlag;
    
    
    
    self.do_id = cell.do_id;
    
    // 添加一个删除按钮
    
    UITableViewRowAction *denyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString ( @"deny" , nil ) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"deny");
        
        [self UpdateToServer:@"2"];
        
        
        //cell.activeFlag = @"2";
        
        [cell.workTime setTextColor:[UIColor grayColor]];
        
        [self fetchDoListFromCoreData];
        }];
        
        
        
        // 添加一个更多按钮
        
        UITableViewRowAction *acceptRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString ( @"accept" , nil ) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            NSLog(@"Accept");
            
            [self UpdateToServer:@"1"];
            
            //cell.activeFlag = @"1";
            
            [cell.workTime setTextColor:[UIColor blackColor]];
            
            [self fetchDoListFromCoreData];
            
            
        }];
        
        acceptRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        denyRowAction.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:202.0/255.0 blue:203.0/255.0 alpha:1.0];
        acceptRowAction.backgroundColor = [UIColor darkGrayColor];
        
        
        // 将设置好的按钮放到数组中返回
        
        // return @[deleteRowAction, topRowAction, moreRowAction];
        
        // return @[deleteRowAction,moreRowAction];
  
            if ([activeFlag isEqualToString:@"0"]) {
                //deny, accept
                return @[acceptRowAction,denyRowAction];
                
            }
            else if ([activeFlag isEqualToString:@"1"])
            {
                //deny
                return @[denyRowAction];
                
            }
            else {
                //accept
                return @[acceptRowAction];
                
            }
        
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    /*
    if([segue.identifier isEqualToString:@"showDetail"])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        DoListTableViewCell  *cell = (DoListTableViewCell *)[self.tableView cellForRowAtIndexPath:path];
        
       DoDetailViewController *rvc = segue.destinationViewController;
        
        rvc.do_id = cell.do_id;
        
    }
     */
}


@end
