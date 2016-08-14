//
//  EngagementMainViewController.m
//  E8020
//
//  Created by Yiwen Fu on 15/10/17.
//  Copyright © 2015年 Yiwen Fu. All rights reserved.
//

#import "EngagementMainViewController.h"
#import "ConstURL.h"

#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

#import "AddEngagementNavigationViewController.h"
#import "JoinListTableViewController.h"

@interface EngagementMainViewController ()<NSFetchedResultsControllerDelegate>

@end

@implementation EngagementMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"e8020back6"] ];
    
    self.sumType = @"0";
   

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self readNSUserDefaults];
    
    //Sign Out
    if ([self.user_id isEqualToString:@""]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        self.valueTimeSelect.selectedSegmentIndex = 0;
        self.sumType = @"0";
    
        [self fetchEngagementList];
    
        [self getCurrentEngagementAndSetEngagementList];
        
        [self fetchUserJoinEngagementList];
        
        [self fetchWorkList];
        
    
        [self saveToUserDefault];
       
    
        [self addRadialProgress];
        
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

-(void)getCurrentEngagementAndSetEngagementList{
    self.pickerData= self.engagementListForPicker;
    
    if ([self.pickerData count]>0)
    {
        if ([self.currentEngagementTitle isEqualToString:@""]) {
            
            NSRange range = [[_pickerData objectAtIndex:0] rangeOfString:@"|"];
            
            self.engagement_id = [[_pickerData objectAtIndex:0] substringFromIndex:range.location+1];
            self.currentEngagementTitle = [[[_pickerData objectAtIndex:0] substringToIndex:range.location] stringByAppendingString:@" ▾"];
            [self.engagemtTitle setTitle:self.currentEngagementTitle forState:UIControlStateNormal];
            [self fetchEngagementList];
            [self fetchEngagementListFromCoreData];
            [self saveToUserDefault];
            
        }
        else
        {
            [self.engagemtTitle setTitle:self.currentEngagementTitle forState:UIControlStateNormal];
            [self fetchEngagementListFromCoreData];
            
        }
        
    }
    else
    {
        self.currentEngagementTitle = @"";
    }
    
}

- (void) saveToUserDefault{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:self.engagement_id forKey:@"currentEngagementID"];
    [userDefaults setObject:self.currentEngagementTitle  forKey:@"currentEngagementTitle"];
    
    [userDefaults setObject:self.selfJoinValue forKey:@"currentEJoinValue"];
    
    [userDefaults setObject:self.leaderUser forKey:@"currentLeaderUser"];

    [userDefaults synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRadialProgress{
     CGRect frame = CGRectMake(0, 0, self.ringView.frame.size.width, self.ringView.frame.size.height);
    
    
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.completedColor = [UIColor colorWithRed:1/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    newTheme.incompletedColor = [UIColor colorWithRed:150/255.0 green:200/255.0 blue:255/255.0 alpha:1.0];
    newTheme.centerColor = [UIColor clearColor];
    newTheme.centerColor = [UIColor colorWithRed:210/255.0 green:230/255.0 blue:255/255.0 alpha:1.0];
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor darkGrayColor];
    newTheme.labelShadowColor = [UIColor whiteColor];
    
    
    MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
    
    NSString * labelTitle;
    
    
    
    if (self.currentSumValue == 0)
    {
        radialView.progressTotal = 1;
        labelTitle= @"0%";
    }
    else
    {
        radialView.progressTotal = self.currentSumValue;
        labelTitle= [[NSString stringWithFormat:@"%0.0lf",self.currentValue/self.currentSumValue*100] stringByAppendingString:@"%"];
    }
    
    
    radialView.theme.thickness = 50;
    
  
    
    
    radialView.progressCounter =  self.currentValue;
    //radialView.progressCounter =  670;
    
    //radialView.theme.sliceDividerHidden = NO;
    
    radialView.labelText =  labelTitle;
    
    
    NSString *title;
    
    title = [NSLocalizedString ( @"sumvalue" , nil ) stringByAppendingString:[NSString stringWithFormat:@"%0.0lf",self.currentSumValue]];
    
    [self.sumValue setTitle:title forState:UIControlStateNormal];
    
    //[self.view addSubview:radialView];
    [self.ringView addSubview:radialView];
}

- (void)addRadialProgressTime{
    
    
  CGRect frame = CGRectMake(0, 0, self.ringView.frame.size.width, self.ringView.frame.size.height);
    
    
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.completedColor = [UIColor colorWithRed:1/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    newTheme.incompletedColor = [UIColor colorWithRed:150/255.0 green:200/255.0 blue:255/255.0 alpha:1.0];
    newTheme.centerColor = [UIColor clearColor];
    newTheme.centerColor = [UIColor colorWithRed:210/255.0 green:230/255.0 blue:255/255.0 alpha:1.0];
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor darkGrayColor];
    newTheme.labelShadowColor = [UIColor whiteColor];
    
    
    MDRadialProgressView *radialView = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
    
    NSString * labelTitle;
    
    if (self.currentSumTime == 0)
    {
        radialView.progressTotal = 1;
        labelTitle = @"0%";
    }
    else
    {
        radialView.progressTotal = self.currentSumTime;
        labelTitle =  [[NSString stringWithFormat:@"%0.0lf",self.currentTime/self.currentSumTime*100] stringByAppendingString:@"%"];
    }
    
    
    radialView.theme.thickness = 50;
    
    
    
    
    radialView.progressCounter =  self.currentTime;
    //radialView.progressCounter =  100;
    
    // radialView.theme.sliceDividerHidden = NO;
    
    radialView.labelText =  labelTitle;
   
    
    NSString *title;
    
    title = [NSLocalizedString ( @"sumtime" , nil ) stringByAppendingString:[NSString stringWithFormat:@"%0.0lf",self.currentSumTime]];
    
    [self.sumValue setTitle:title forState:UIControlStateNormal];
    
    //[self.view addSubview:radialView];
    [self.ringView addSubview:radialView];
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
    MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
    // Only required in this demo to align vertically the progress views.
    //view.center = CGPointMake(view.center.x,view.center.y);
    
    return view;
}


- (void)fetchEngagementList{
    
    self.engagementList = nil;
    
    //dispatch_async(dispatch_queue_create("fetch-engagementList", 0), ^{
        NSString *tempURL;
        NSString *userID;
        
        userID = self.user_id;
    
        tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/userengagement/"];
        tempURL = [tempURL stringByAppendingString:userID];
        
        
        
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
            self.engagementList = (NSArray *)propertyListResults;
            
            NSLog(@"engagementList = %@",self.engagementList);
            
            [self saveDataToCoreData];
            
        }
        
        
    //});
}

- (void)fetchUserJoinEngagementList{
    
    self.userjoinengagementList = nil;
    
    //dispatch_async(dispatch_queue_create("fetch-userjoinengagementList", 0), ^{
        NSString *tempURL;
        NSString *engagementID;
        
        engagementID = self.engagement_id;
    
        tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/userjoinengagement/"];
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
            self.userjoinengagementList = (NSArray *)propertyListResults;
            
            NSLog(@"userjoinengagementList = %@",self.userjoinengagementList);
            
            [self saveUserJoinEngagementToCoreData];
            
        }
        
        
    //});
}

- (void)fetchByUniqueID{
    
    self.userjoinengagementList = nil;
    
    //dispatch_async(dispatch_queue_create("fetch-userjoinengagementList", 0), ^{
    NSString *tempURL;
    NSString *uniqueID;
    
    uniqueID = self.uniqueID;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/engagementcheck/?uniqueid="];
    tempURL = [tempURL stringByAppendingString:uniqueID];
    
    
    
    NSURL *url= [NSURL URLWithString:tempURL];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error:&error];
    
    
    
    //NSData *jsonResult = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    NSLog(@"Error: %@", error);
    
    if (error != nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"error" , nil ) message:NSLocalizedString ( @"connecterror" , nil ) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else{
        NSDictionary *propertyListResults =[NSJSONSerialization JSONObjectWithData:response options:0 error:NULL ];
        //NSLog(@"FetchResult = %@",propertyListResults);
        self.uniqueList = (NSArray *)propertyListResults;
        
        NSLog(@"uniqueengagementList = %@",self.uniqueList);
        
        NSArray *record;
        NSString *unique_engagementID;
        
        record = [self.uniqueList objectAtIndex:0];
        unique_engagementID = [record valueForKeyPath:@"engagement_id"];
        
        [self SaveJoinToServer:unique_engagementID];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString ( @"msg011" , nil ) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        

    }
    
    
    //});
}


- (void) saveUserJoinEngagementToCoreData {
    NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
    
    NSArray *record;
    
   
    
    for (NSUInteger i = 0; i < [self.userjoinengagementList count]; i++)
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        
        record = [self.userjoinengagementList valueForKey:[ NSString  stringWithFormat:  @"%lu" , (unsigned long)i]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        UserJoinEngagement *join = [UserJoinEngagement insertWithContext:context withValue:[record valueForKeyPath:@"join_id"] forAttribute:@"join_id"];
        
        
        join.engagement_id = [record valueForKeyPath:@"engagement_id"];
        join.user_id= [record valueForKeyPath:@"user_id"];
        join.display_name = [record valueForKeyPath:@"display_name"];
        join.sum_time =[f numberFromString:[record valueForKeyPath:@"count_sum"]];
        join.sum_value =[f numberFromString:[record valueForKeyPath:@"count_value"]];
        join.e_sum_time = [f numberFromString:[record valueForKeyPath:@"e_sum_time"]];
        join.e_sum_value = [f numberFromString:[record valueForKeyPath:@"e_sum_value"]];
        
        if ([[record valueForKeyPath:@"user_id"] isEqualToString:self.user_id]) {
            self.selfJoinValue  = [record valueForKeyPath:@"join_value"];
            self.currentTime =[[f numberFromString:[record valueForKeyPath:@"count_sum"]] doubleValue];
            self.currentValue =[[f numberFromString:[record valueForKeyPath:@"count_value"]] doubleValue];
            self.currentSumTime = [[f numberFromString:[record valueForKeyPath:@"e_sum_time"]] doubleValue];
            self.currentSumValue = [[f numberFromString:[record valueForKeyPath:@"e_sum_value"]] doubleValue];
        }
        
        join.join_value = [f numberFromString:[record valueForKeyPath:@"join_value"]];
        join.join_type = [record valueForKeyPath:@"join_type"];
        
        [context commitUpdate];
    }
    
 
}


- (void) saveDataToCoreData {

    
        NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
        
        NSArray *record;
    
         NSString *tempForPicker;
    
        self.engagementListForPicker = [NSMutableArray arrayWithCapacity:[self.engagementList count]];
        
        for (NSUInteger i = 0; i < [self.engagementList count]; i++)
        {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            
            record = [self.engagementList valueForKey:[ NSString  stringWithFormat:  @"%lu" , (unsigned long)i]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            Engagement *engagement = [Engagement insertWithContext:context withValue:[record valueForKeyPath:@"engagement_id"] forAttribute:@"engagement_id"];
            
            
            engagement.engagement_title = [record valueForKeyPath:@"engagement_title"];
            engagement.engagement_description = [record valueForKeyPath:@"engagement_description"];
            //engagement.company_id = [record valueForKeyPath:@"company_id"];
            engagement.engagement_type = [record valueForKeyPath:@"engagement_type"];
            engagement.leader_user = [record valueForKeyPath:@"learder_user"];
            engagement.active_flag = [record valueForKeyPath:@"active_flag"];
            engagement.complete_flag = [record valueForKeyPath:@"complete_flag"];
            engagement.unique_id = [record valueForKeyPath:@"unique_id"];
            //engagement.sum_time =[f numberFromString:[record valueForKeyPath:@"sum_time"]];
            //engagement.sum_value =[f numberFromString:[record valueForKeyPath:@"sum_value"]];
            //engagement.current_user_time = [f numberFromString:[record valueForKeyPath:@"user_time"]];
            //engagement.current_user_value = [f numberFromString:[record valueForKeyPath:@"user_value"]];
            engagement.average_value = [f numberFromString:[record valueForKeyPath:@"average_value"]];
            
 
            
            tempForPicker = [record valueForKeyPath:@"engagement_title"];
            tempForPicker = [tempForPicker stringByAppendingString:@"|"];
            tempForPicker = [tempForPicker stringByAppendingString:[record valueForKeyPath:@"engagement_id"]];
            
            [self.engagementListForPicker addObject:tempForPicker];
            
            [context commitUpdate];
        }
    
    [self fetchDoListFromCoreData];
    
    
    
}

- (void) fetchDoListFromCoreData{
    
    NSManagedObjectContext *mainContext = [[KICoreDataManager sharedInstance] mainManagedObjectContext];
    KIFetchRequest *fetchRequest = [[KIFetchRequest alloc] initWithEntity:[Engagement entity] context:mainContext];
    
    _fetchResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:mainContext
                                                                   sectionNameKeyPath:nil
                                                                            cacheName:nil];
    [_fetchResultController setDelegate:self];
    [_fetchResultController performFetch:nil];
    
    
    
}

- (void)fetchWorkList{
    
    self.workList = nil;
    
    dispatch_async(dispatch_queue_create("fetch-worklist", 0), ^{
        NSString *tempURL;
        NSString *engagementID;
        
        engagementID = self.engagement_id;
        
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

- (IBAction)Manage:(UIBarButtonItem *)sender {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"msg004" , nil ) message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *newAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"new" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //UITextField *login = alertController.textFields.firstObject;
        //UITextField *password = alertController.textFields.lastObject;
        [self performSegueWithIdentifier:@"showNew" sender:nil];
      
    }];

    UIAlertAction *editAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"edit" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //UITextField *login = alertController.textFields.firstObject;
        //UITextField *password = alertController.textFields.lastObject;
        [self performSegueWithIdentifier:@"showEdit" sender:nil];
        
    }];
    
    
    UIAlertAction *searchAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"search" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        UIAlertController *searchController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"search" , nil ) message:NSLocalizedString ( @"msg005" , nil ) preferredStyle:UIAlertControllerStyleAlert];
        
        [searchController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = NSLocalizedString ( @"uniqueid" , nil );
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            if ([searchController.textFields.firstObject.text isEqualToString:@""]) {
                //[searchController.textFields.firstObject becomeFirstResponder];
            }
            else
            {
                self.uniqueID = [searchController.textFields.firstObject.text uppercaseString];
                [self fetchByUniqueID];
            }
            
        }];
        
        [searchController addAction:cancelAction];
        [searchController addAction:okAction];
       
        
        [self presentViewController:searchController animated:YES completion:nil];
        
        
        
    }];

    
    [alertController addAction:cancelAction];
    if ([self.leaderUser isEqualToString:self.user_id]) {
       [alertController addAction:editAction];
    }
    
    
    [alertController addAction:newAction];
    [alertController addAction:searchAction];

    
    [self presentViewController:alertController animated:YES completion:nil];
    
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
        
        
        self.currentSumValue = 0;
        self.currentSumTime = 0;
        self.currentTime = 0;
        self.currentValue = 0;
        
        
        [self.engagemtTitle setTitle:self.currentEngagementTitle forState:UIControlStateNormal];
        
        [self fetchEngagementListFromCoreData];
        
   
            
        [self fetchUserJoinEngagementList];
            
        
        
        [self fetchWorkList];
        
        
        self.valueTimeSelect.selectedSegmentIndex = 0;
        
             
        
        [self addRadialProgress];
        
        
        [self saveToUserDefault];

        
        
        // NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        
        
        // NSLog(@"%@",dateString);
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:ok];
    
    [alertController addAction:cancel];
    
    if ([self.engagementList count] != 0) {
        [self presentViewController:alertController animated:YES completion:nil];
    }

}


- (IBAction)report:(UIButton *)sender {
    
    UIAlertController *reportController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"report" , nil ) message:NSLocalizedString ( @"msg007" , nil ) preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"canncel" , nil ) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        
    }];
    
    [reportController addAction:cancelAction];
    [reportController addAction:okAction];
    
    [self presentViewController:reportController animated:YES completion:nil];
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
    
    //self.currentSumTime = [record.sum_time doubleValue];
    //self.currentSumValue = [record.sum_value doubleValue];
    //self.currentTime = [record.current_user_time doubleValue];
    //self.currentValue =  [record.current_user_value doubleValue];
    //self.workValue.text = r
    
    self.leaderUser = record.leader_user;
    
    
    
    
}

- (IBAction)pressSegment:(UISegmentedControl *)sender {
    int selectedIndex = sender.selectedSegmentIndex;
    if (selectedIndex == 0) {
        self.sumType = @"0";
        [self addRadialProgress];
    }
    else
    {
        self.sumType = @"1";
        [self addRadialProgressTime];
    }
   
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"showNew"]) //"goView2"是SEGUE连线的标识
    {
        AddEngagementNavigationViewController *rvc = segue.destinationViewController;
        rvc.editType = @"0";
        
    }
    else if([segue.identifier isEqualToString:@"showEdit"])
    {
        AddEngagementNavigationViewController *rvc = segue.destinationViewController;
        
        rvc.editType = @"1";
        rvc.engagementID = self.engagement_id;
      
    }
    else if([segue.identifier isEqualToString:@"showValue"])
    {
        JoinListTableViewController *rvc = segue.destinationViewController;
        rvc.engagment_id = self.engagement_id;
        rvc.sumType = self.sumType;
        if ([self.sumType isEqualToString:@"0"]) {
            rvc.engagementSum = self.currentSumValue;
        }
        else
        {
            rvc.engagementSum = self.currentSumTime;
        }
        
    }

}

- (void)SaveJoinToServer:(NSString *)uniqueEngagementID{
    
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
    
    
    
    tempAverageValue = @"0";
    
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"engagement_id=%@&join_value=%@&leader_flag=%@&user_id=%@&join_type=%@",uniqueEngagementID,tempAverageValue,@"0",_user_id,@"0"] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        
        
       // [self saveNewJoinToCoreData];
        
    }
}


@end
