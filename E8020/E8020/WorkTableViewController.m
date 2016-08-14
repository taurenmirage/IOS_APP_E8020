//
//  WorkTableViewController.m
//  E8020
//
//  Created by Yiwen Fu on 15/10/25.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import "WorkTableViewController.h"
#import "ConstURL.h"

@interface WorkTableViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation WorkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //除去多余行数
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self readNSUserDefaults];
    
    //Sign Out
    if ([self.user_id isEqualToString:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
        [self fetchEngagementListFromCoreData];
        
        [self getCurrentEngagementAndSetEngagementList];
        
        dispatch_async(dispatch_queue_create("fetch-engagementList", 0), ^{
            
           [self fetchWorkList];
            
        });
        
        
    }
    
}

-(void)getCurrentEngagementAndSetEngagementList{
    self.pickerData= self.engagementListForPicker;
    
    if ([self.pickerData count]>0)
    {
        if ([self.currentEngagementTitle isEqualToString:@""]) {
            
            NSRange range = [[_pickerData objectAtIndex:0] rangeOfString:@"|"];
            
            self.engagement_id = [[_pickerData objectAtIndex:0] substringFromIndex:range.location+1];
            self.currentEngagementTitle = [[[_pickerData objectAtIndex:0] substringToIndex:range.location] stringByAppendingString:@" ▾"];
            [self.engagemtTitle setTitle:self.currentEngagementTitle forState:UIControlStateNormal];
            [self fetchEngagementListFromCoreData];
            [self saveToUserDefault];
            
        }
        else
        {
            [self.engagemtTitle setTitle:self.currentEngagementTitle forState:UIControlStateNormal];
            
            
        }
        
    }
    else
    {
        self.currentEngagementTitle = @"";
    }
    
}


-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString = [userDefaultes stringForKey:@"currentEngagementID"];
    self.engagement_id = myString;
    
    myString = [userDefaultes stringForKey:@"userID"];
    self.user_id = myString;
    
    myString = [userDefaultes stringForKey:@"currentEngagementTitle"];
    self.currentEngagementTitle = myString;
    
}

- (void) saveToUserDefault{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.engagement_id forKey:@"currentEngagementID"];
    [userDefaults setObject:self.currentEngagementTitle  forKey:@"currentEngagementTitle"];
    
    [userDefaults synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}


- (void)fetchWorkList{
    
    self.workList = nil;
    
    dispatch_async(dispatch_queue_create("fetch-worklist", 0), ^{
        NSString *tempURL;
        NSString *engagementID;
        
        engagementID = @"1";
        
        tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/engagementwork/"];
        tempURL = [tempURL stringByAppendingString:engagementID];
        
        
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
            //NSLog(@"FetchResult = %@",propertyListResults);
            self.workList = (NSArray *)propertyListResults;
            
            NSLog(@"workList = %@",self.workList);
            
            [self saveWorkDataToCoreData];
            
        }
        
        
    });
}

- (void) saveWorkDataToCoreData {
    
    
    dispatch_async(dispatch_queue_create("insert-worklist", 0), ^{
        
        NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
        
        
        
        
        for (NSDictionary *record in self.workList)
        {
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            Work *work = [Work insertWithContext:context withValue:[record valueForKeyPath:@"work_id"] forAttribute:@"work_id"];
            
            work.work_title = [record valueForKeyPath:@"work_title"];
            work.work_description = [record valueForKeyPath:@"work_description"];
            work.work_type = [record valueForKeyPath:@"work_type"];
            work.engagement_id = [record valueForKeyPath:@"engagement_id"];
            work.assign_user = [record valueForKeyPath:@"assign_user"];
            work.active_flag = [record valueForKeyPath:@"active_flag"];
            work.complete_flag = [record valueForKeyPath:@"complete_flag"];
            work.exp_work_time = [f numberFromString:[record valueForKeyPath:@"exp_work_time"]];
            work.exp_work_value = [f numberFromString:[record valueForKeyPath:@"exp_work_value"]];
            work.begin_date = [dateFormatter dateFromString:[record valueForKeyPath:@"begin_date"]];
            work.end_date = [dateFormatter dateFromString:[record valueForKeyPath:@"end_date"]];
            
            
            [context commitUpdate];
            
        }
    });
    
}

- (void) fetchEngagementListFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[Engagement entity] context:mainContext];
    
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:mainContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    
    
    NSString *tempForPicker;
    
    self.engagementListForPicker = [NSMutableArray arrayWithCapacity:[_fetchResultController.fetchedObjects count]];
    
    for (NSInteger i =0 ; i < [_fetchResultController.fetchedObjects count]; i++) {
        Engagement *record = [_fetchResultController.fetchedObjects objectAtIndex:i];
        
        tempForPicker = record.engagement_title;
        tempForPicker = [tempForPicker stringByAppendingString:@"|"];
        tempForPicker = [tempForPicker stringByAppendingString:[record valueForKeyPath:@"engagement_id"]];
        
        [self.engagementListForPicker addObject:tempForPicker];
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
    NSString *tempEngagementTitle;
    
    NSRange range = [[_pickerData objectAtIndex:row] rangeOfString:@"|"];
    
    //int location = range.location;
    
    //int leight = range.length;
    
    NSString *tempEngagementID;
    
    
    tempEngagementID = [[_pickerData objectAtIndex:row] substringFromIndex:range.location+1];
    // 使用一个UIAlertView来显示用户选中的列表项
    self.engagement_id = tempEngagementID;
    self.currentEngagementTitle = [[[_pickerData objectAtIndex:row] substringToIndex:range.location] stringByAppendingString:@" ▾"];
    
    tempEngagementTitle = [[_pickerData objectAtIndex:row] substringToIndex:range.location];
    
    return tempEngagementTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    NSString *tempEngagementID;
    
    NSRange range = [[_pickerData objectAtIndex:row] rangeOfString:@"|"];
    
    tempEngagementID = [[_pickerData objectAtIndex:row] substringFromIndex:range.location+1];
    // 使用一个UIAlertView来显示用户选中的列表项
    self.engagement_id = tempEngagementID;
    self.currentEngagementTitle = [[[_pickerData objectAtIndex:row] substringToIndex:range.location] stringByAppendingString:@" ▾"];
    
    
}


- (IBAction)engagementSelect:(UIButton *)sender {
    
    
    UIPickerView *pickerView;
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    pickerView.delegate=self;
    pickerView.showsSelectionIndicator=YES;
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:NSLocalizedString ( @"msg003" , nil ) preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    [alertController.view addSubview:pickerView];
    
    
    
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        
        
        
        [self.engagemtTitle setTitle:self.currentEngagementTitle forState:UIControlStateNormal];
        
        [self saveToUserDefault];
        
        
        // NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        
        
        // NSLog(@"%@",dateString);
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:ok];
    
    [alertController addAction:cancel];
    
    if ([self.engagementListForPicker count] != 0) {
        [self presentViewController:alertController animated:YES completion:nil];
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
