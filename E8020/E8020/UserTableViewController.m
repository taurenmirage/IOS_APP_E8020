//
//  UserTableViewController.m
//  E8020
//
//  Created by Yiwen Fu on 16/1/3.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import "UserTableViewController.h"
#import "ConstURL.h"

@interface UserTableViewController ()

@end

@implementation UserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //除去多余行数
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self readNSUserDefaults];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancel:(UIBarButtonItem *)sender {
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signOut:(UIButton *)sender {
    [self saveToUserDefault];
    
    [self clear];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    self.user_id =[userDefaultes stringForKey:@"userID"];
    self.displayName.text = [userDefaultes stringForKey:@"displayName"];
    self.title = [userDefaultes stringForKey:@"userName"];
    
    
   
    //self.DisplayName.text =  [userDefaultes stringForKey:@"displayName"];
    
}

- (void) saveToUserDefault{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名和密码存储到UserDefault
    [userDefaults setObject:@"" forKey:@"currentEngagementID"];
    [userDefaults setObject:@"" forKey:@"userID"];
    [userDefaults setObject:@"" forKey:@"displayName"];
    [userDefaults setObject:@"" forKey:@"currentEngagementTitle"];
    [userDefaults synchronize];
}

- (void)clear {
    dispatch_async(dispatch_queue_create("delete-join", 0), ^{
        NSManagedObjectContext *context = [[KICoreDataManager sharedInstance] createManagedObjectContext];
        NSArray *items = [UserJoinEngagement objectsWithContext:context];
        
        for (UserJoinEngagement *r in items) {
            [r removeFromContext:context];
        }
        
        [context commitUpdate];
    });
}

- (void)UpdateUserToServer{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/user/"];
    
    tempURL = [tempURL stringByAppendingString:self.user_id];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"PUT"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    
    NSString *tempDisplayName;
    
    
    
    
    tempDisplayName = self.displayName.text;
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"display_name=%@",tempDisplayName] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        
        if (propertyListResults != nil) {
            self.userRecord = (NSArray *)propertyListResults;
        }
        //NSLog(@"FetchResult = %@",propertyListResults);
        
        
        //self.user_id = [self.userRecord valueForKeyPath:@"user_id"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //登陆成功后把用户名和密码存储到UserDefault
        
        [userDefaults setObject:self.displayName.text forKey:@"displayName"];
        [userDefaults synchronize];
        
        //NSLog(@"newUser = %@",self.userRecord);
        
        NSLog(@"Success");
        
    }
    
}


- (IBAction)save:(UIBarButtonItem *)sender {
    if ([self.displayName.text isEqualToString:@""]) {
        [self.displayName becomeFirstResponder];
    }
    else
    {
        [self UpdateUserToServer];
    }

}


/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
 */


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
