//
//  AddEngagementTableViewController.m
//  E8020
//
//  Created by Yiwen Fu on 15/11/18.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import "AddEngagementTableViewController.h"
#import "AddEngagementNavigationViewController.h"
#import "UserApproveListTableViewController.h"

#import "ConstURL.h"

@interface AddEngagementTableViewController ()<NSFetchedResultsControllerDelegate>


@end

@implementation AddEngagementTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"e8020back6"]];
    
    [self readNSUserDefaults];
    
    AddEngagementNavigationViewController *rvc = (AddEngagementNavigationViewController * )self.parentViewController;
    
    
    self.editType = rvc.editType;
    
    if ([self.editType isEqualToString:@"1"]) {
        self.engagement_id = rvc.engagementID;
        [self fetchEngagementListFromCoreData];
        
        [self fetchUserListFromCoreData];
        
        self.title = NSLocalizedString ( @"edit" , nil );
        
         self.pickerData = self.userNameListForPicker;
    }
    else{
        self.title = NSLocalizedString ( @"new" , nil );
    }
    
    
    //除去多余行数
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) fetchEngagementListFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[Engagement entity] context:mainContext];
    
    if ([self.engagement_id isEqualToString:@""])
    {
        NSLog(@"No Engagement ID");
    }
    else
    {
        [fetchRequest fetchObjectWithValue:self.engagement_id forAttributes:@"engagement_id" error:nil];
        _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:mainContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    }
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    
    Engagement  *record = [_fetchResultController.fetchedObjects objectAtIndex:0];
    
    
    self.engagementTitle.text = record.engagement_title;
    self.engagementDescription.text = record.engagement_description;
    self.uniqueID.text = record.unique_id;
    
    //self.workValue.text = r
    
    self.leaderUser = record.leader_user;
    
    if ([self.leaderUser isEqualToString:self.user_id])
    {
        self.engagementTitle.enabled = YES;
        self.engagementDescription.enabled = YES;
        self.workValue.enabled = YES;
        self.workValue.text = [record.average_value stringValue];
        
        
        if ([record.complete_flag isEqualToString:@"1"]) {
            self.completeFlag.on = YES;
        }
        else
        {
            self.completeFlag.on = NO;
        }
        
        if ([record.active_flag isEqualToString:@"1"])
        {
            self.activeFlag.on = YES;
        }
        else
        {
            self.activeFlag.on = NO;
        }
        
    }
    
    else
    {
        self.engagementTitle.enabled = NO;
        self.engagementDescription.enabled = NO;
        self.workValue.enabled = NO;
    }
    

}

-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"currentEngagementID"];
    self.engagement_id = myString;
    
    myString = [userDefaultes stringForKey:@"userID"];
    self.user_id = myString;
    
    myString = [userDefaultes stringForKey:@"currentEngagementTitle"];
    
    myString = [userDefaultes stringForKey:@"displayName"];
    self.displayName = myString;
    //self.currentEngagementTitle = myString;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.editType isEqualToString:@"1"]) {
        return 6;
    }
    
    return 4;
}


- (IBAction)save:(UIBarButtonItem *)sender {
    if ([self.engagementTitle.text isEqualToString:@""]) {
        [self.engagementTitle becomeFirstResponder];
    }
    else if ([self.workValue.text isEqualToString:@""]) {
        [self.workValue becomeFirstResponder];
    }
    
    else{
        if ([self.editType isEqualToString:@"0"]) {
            [self SaveToServer];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self UpdateToServer];
        }
        
    }
    
}

- (void)saveNewToCoreData {
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        
      
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.engagement_id = [self.record valueForKeyPath:@"engagement_id"];
    
    Engagement *engagement = [Engagement insertWithContext:context withValue:[self.record valueForKeyPath:@"engagement_id"] forAttribute:@"engagement_id"];
        
        
    engagement.engagement_title = [self.record valueForKeyPath:@"engagement_title"];
    engagement.engagement_description = [self.record valueForKeyPath:@"engagement_description"];
    //engagement.company_id = [self.record valueForKeyPath:@"company_id"];
    engagement.engagement_type = [self.record valueForKeyPath:@"engagement_type"];
    engagement.leader_user = [self.record valueForKeyPath:@"learder_user"];
    engagement.active_flag = [self.record valueForKeyPath:@"active_flag"];
    engagement.complete_flag = [self.record valueForKeyPath:@"complete_flag"];
    engagement.unique_id = [self.record valueForKeyPath:@"unique_id"];
    engagement.sum_time =[f numberFromString:[self.record valueForKeyPath:@"sum_time"]];
    engagement.sum_value =[f numberFromString:[self.record valueForKeyPath:@"sum_value"]];
    engagement.average_value = [f numberFromString:[self.record valueForKeyPath:@"avarge_value"]];
    
        //engagement.current_user_time = [f numberFromString:[self.record valueForKeyPath:@"user_time"]];
        //engagement.current_user_value = [f numberFromString:[self.record valueForKeyPath:@"user_value"]];
        
    [context commitUpdate];
  

}

- (void)saveUpdateToCoreData {
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    Engagement *engagement = [Engagement insertWithContext:context withValue:self.engagement_id forAttribute:@"engagement_id"];
    
    
    engagement.engagement_title = self.engagementTitle.text;
    engagement.engagement_description = self.engagementDescription.text;
    
    //engagement.leader_user = [self.record valueForKeyPath:@"leader_user"];
    //engagement.active_flag = [self.record valueForKeyPath:@"active_flag"];
    //engagement.complete_flag = [self.record valueForKeyPath:@"complete_flag"];

    engagement.average_value = [f numberFromString:self.workValue.text];
    
    
    [context commitUpdate];
    
    
}

- (void)saveNewJoinToCoreData {
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];

    UserJoinEngagement *join = [UserJoinEngagement insertWithContext:context withValue:[self.record valueForKeyPath:@"join_id"] forAttribute:@"join_id"];
    
    join.user_id = [self.record valueForKeyPath:@"user_id"];
    join.engagement_id = [self.record valueForKeyPath:@"engagement_id"];
    join.leader_flag = [self.record valueForKeyPath:@"leader_flag"];
    join.join_value = [f numberFromString:[self.record valueForKeyPath:@"join_value"]];
    join.display_name = self.displayName;
 
    [context commitUpdate];
    
    
}

- (void)SaveToServer{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/engagement"];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    
    NSString *tempTitle;
    NSString *tempDescription;
    NSString *tempUniqueID;
    NSString *complete_flag;
    NSString *active_flag;
    NSString *tempAverageValue;
    
    
    
    tempTitle = self.engagementTitle.text;
    tempDescription = self.engagementDescription.text;
    tempUniqueID = [self ret32bitString];
    tempAverageValue = self.workValue.text;
    
    
    if (self.completeFlag.isOn)
    {
        complete_flag = @"1";
    }
    else
    {
        complete_flag = @"0";
    }
    
    if (self.activeFlag.isOn)
    {
        active_flag = @"1";
    }
    else
    {
        active_flag = @"0";
    }
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"engagement_title=%@&engagement_description=%@&unique_id=%@&learder_user=%@&complete_flag=%@&active_flag=%@&average_value=%@&create_user=%@",tempTitle,tempDescription,tempUniqueID,_user_id,complete_flag,active_flag,tempAverageValue,_user_id] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        
        NSLog(@"newEngagement = %@",self.record);
        
        NSLog(@"Success");
        
        
        [self saveNewToCoreData];
        
        [self SaveJoinToServer];
        
    }
}

- (void)UpdateToServer{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/engagement/"];
    
    tempURL = [tempURL stringByAppendingString:self.engagement_id];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"PUT"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    
    NSString *tempTitle;
    NSString *tempDescription;
    
    NSString *complete_flag;
    NSString *active_flag;
    NSString *tempAverageValue;
    NSString *tempLeaderUserID;
    
    
    
    tempAverageValue = self.workValue.text;
    tempTitle = self.engagementTitle.text;
    tempDescription = self.engagementDescription.text;
    
    
    if (self.completeFlag.isOn)
    {
        complete_flag = @"1";
    }
    else
    {
        complete_flag = @"0";
    }
    
    if (self.activeFlag.isOn)
    {
        active_flag = @"1";
    }
    else
    {
        active_flag = @"0";
    }
    
    
    
    if (self.assignUserID != nil)
    {
        tempLeaderUserID = self.assignUserID;
    }
    else
    {
        tempLeaderUserID = self.leaderUser;
    }
    
    
    [postBody appendData:[[NSString stringWithFormat:@"engagement_title=%@&engagement_description=%@&learder_user=%@&complete_flag=%@&active_flag=%@&average_value=%@&update_user=%@",tempTitle,tempDescription,tempLeaderUserID,complete_flag,active_flag,tempAverageValue,_user_id] dataUsingEncoding:NSUTF8StringEncoding]];

    
    
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
        
        [self saveUpdateToCoreData];
    }


}


- (void)SaveJoinToServer{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/userjoinengagement"];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    


    NSString *tempAverageValue;
    
    

    tempAverageValue = self.workValue.text;
    

    
    
    [postBody appendData:[[NSString stringWithFormat:@"engagement_id=%@&join_value=%@&leader_flag=%@&user_id=%@&join_type=%@",self.engagement_id,tempAverageValue,@"1",_user_id,@"1"] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        
        NSLog(@"newJoin = %@",self.record);
        
        NSLog(@"Success");
        
        
        [self saveNewJoinToCoreData];
        
    }
}

- (NSString *)ret32bitString
{
    
    char data[8];
    
    for (int x=0;x<8;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:8 encoding:NSUTF8StringEncoding];
    
}


- (IBAction)selectLeader:(UIButton *)sender {
    UIPickerView *pickerView;
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:NSLocalizedString ( @"msg009" , nil ) preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertController.view addSubview:pickerView];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.userName  setTitle:self.assignUserName forState:UIControlStateNormal];
        
        
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:ok];
    
    [alertController addAction:cancel];
    
    if ([self.userNameListForPicker count] != 0) {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void) fetchUserListFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[UserJoinEngagement entity] context:mainContext];
    
    if ([self.engagement_id isEqualToString:@""])
    {
        NSLog(@"No Engagement ID");
    }
    else
    {
        [fetchRequest fetchObjectWithValue:self.engagement_id forAttributes:@"engagement_id" error:nil];
        _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:mainContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    }
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    
    NSString *tempForPicker;
    
    self.userNameListForPicker = [NSMutableArray arrayWithCapacity:[_fetchResultController.fetchedObjects count]];
    
    for (NSInteger i =0 ; i < [_fetchResultController.fetchedObjects count]; i++) {
        UserJoinEngagement *record = [_fetchResultController.fetchedObjects objectAtIndex:i];
        
        if ([self.leaderUser isEqualToString:record.user_id])
        {
            self.currentLeaderUser = record.display_name;
             [self.userName  setTitle:self.currentLeaderUser forState:UIControlStateNormal];
        }
        
        
        
        
        
        tempForPicker = record.display_name;
        
        tempForPicker = [tempForPicker stringByAppendingString:@"|"];
        tempForPicker = [tempForPicker stringByAppendingString:record.user_id];
        
        [self.userNameListForPicker addObject:tempForPicker];
    }
    
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerData count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *tempUserName;
    
    NSRange range = [[_pickerData objectAtIndex:row] rangeOfString:@"|"];
    
    //int location = range.location;
    
    //int leight = range.length;
    
    NSString *tempUserID;
    
    
    tempUserID = [[_pickerData objectAtIndex:row] substringFromIndex:range.location+1];
    // 使用一个UIAlertView来显示用户选中的列表项
    self.assignUserID = tempUserID;
    self.assignUserName = [[_pickerData objectAtIndex:row] substringToIndex:range.location] ;
    
    
    tempUserName = [[_pickerData objectAtIndex:row] substringToIndex:range.location];
    
    return tempUserName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    NSString *tempUserID;
    
    NSRange range = [[_pickerData objectAtIndex:row] rangeOfString:@"|"];
    
    tempUserID = [[_pickerData objectAtIndex:row] substringFromIndex:range.location+1];
    // 使用一个UIAlertView来显示用户选中的列表项
    self.assignUserID = tempUserID;
    self.leaderUser = tempUserID;
    self.assignUserName = [[_pickerData objectAtIndex:row] substringToIndex:range.location] ;
    
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: sa forIndexPath:indexPath];
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"showTeam"]) //"goView2"是SEGUE连线的标识
    {
        UserApproveListTableViewController *rvc = segue.destinationViewController;
        rvc.workValue = self.workValue.text;
        rvc.engagementID = self.engagement_id;
        
    }
}


@end
