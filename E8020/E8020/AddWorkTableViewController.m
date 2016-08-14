//
//  AddWorkTableViewController.m
//  E8020
//
//  Created by Yiwen Fu on 15/11/1.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import "AddWorkTableViewController.h"
#import "ConstURL.h"

@interface AddWorkTableViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation AddWorkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    
    //实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    [self.endDate setTitle:dateString forState:UIControlStateNormal];
    
    
    //除去多余行数
    
    [self readNSUserDefaults];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self fetchUserListFromCoreData];
    
    self.pickerData = self.userNameListForPicker;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"currentEngagementID"];
    self.engagement_id = myString;
    myString = [userDefaultes stringForKey:@"userID"];
    self.user_id = myString;
    myString = [userDefaultes stringForKey:@"displayName"];
    self.displayName = myString;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (IBAction)endDate:(UIButton *)sender {
 
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init]; datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController.view addSubview:datePicker];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        
        //实例化一个NSDateFormatter对象
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        
        //求出当天的时间字符串
        
        NSLog(@"%@",dateString);
        
        [self.endDate setTitle:dateString forState:UIControlStateNormal];
        
        
        
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:ok];
    
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];

    
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    
    
    if ([self.workTitle.text isEqualToString:@""])
    {
        [self.workTitle becomeFirstResponder];
    }
    else if ([self.workDescription.text isEqualToString:@""])
    {
        [self.workDescription becomeFirstResponder];
    }
    else if ([self.expValue.text isEqualToString:@""])
    {
        [self.expValue becomeFirstResponder];
    }
    else if ([self.expTime.text isEqualToString:@""])
    {
        [self.expTime becomeFirstResponder];
    }
    else
    {
        [self SaveToServer];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (void) saveDataToCoreData {
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    Work *work = [Work insertWithContext:context withValue:[self.record valueForKeyPath:@"work_id"] forAttribute:@"work_id"];
    
    work.engagement_id = self.engagement_id;
    work.work_title = [self.record valueForKeyPath:@"work_title"];
    work.work_description = [self.record valueForKeyPath:@"work_description"];
    work.exp_work_time = [f numberFromString:[self.record valueForKeyPath:@"exp_work_time"]];
    work.exp_work_value = [f numberFromString:[self.record valueForKeyPath:@"exp_work_value"]];
    work.begin_date = [dateFormatter dateFromString:[self.record valueForKeyPath:@"begin_date"]];
    work.end_date = [dateFormatter dateFromString:[self.record valueForKeyPath:@"end_date"]];
    
    
    
    [context commitUpdate];
    
    
}

- (void)SaveToServer{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/work"];
    
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
    NSString *tempTime;
    NSString *tempValue;
    NSString *tempEndDate;
    
    
    tempTitle = self.workTitle.text;
    tempDescription = self.workDescription.text;
    tempTime = self.expTime.text;
    tempValue = self.expValue.text;
    tempEndDate = self.endDate.titleLabel.text;
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"work_title=%@&work_description=%@&engagement_id=%@&end_date=%@&exp_work_time=%@&exp_work_value=%@&create_user=%@&assign_user=%@",tempTitle,tempDescription,self.engagement_id,tempEndDate,tempTime,tempValue,_user_id,self.assignUserID] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        
        NSLog(@"newWork = %@",self.record);
        
        NSLog(@"Success");
        
        [self saveDataToCoreData];
        
    }
    
    
    //NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Error: %@", error);
    // NSDictionary *propertyListResults =[NSJSONSerialization JSONObjectWithData:responseData  options:0 error:NULL ];
    //NSLog(@"FetchResult = %@",propertyListResults);
    
    // NSLog(@"Error: %@", error);
}


- (IBAction)userName:(UIButton *)sender {
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
    self.assignUserName = [[_pickerData objectAtIndex:row] substringToIndex:range.location] ;
    
    
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
        
        tempForPicker = record.display_name;
        tempForPicker = [tempForPicker stringByAppendingString:@"|"];
        tempForPicker = [tempForPicker stringByAppendingString:record.user_id];
        
        [self.userNameListForPicker addObject:tempForPicker];
    }
    
    
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
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
