//
//  SignInViewController.m
//  E8020
//
//  Created by Yiwen Fu on 16/1/3.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import "SignInViewController.h"
#import "ConstURL.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setVisible:NO];
    
     //self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"e8020back6"] ];
    
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self setSignIn];
    
    [self readNSUserDefaults];
    
    
    // Do any additional setup after loading the view.
}

- (IBAction)signOrCreate:(UIButton *)sender {
    if ([self.userName.text isEqualToString:@""])
    {
        [self.userName becomeFirstResponder];
    }
    else if ([self.password.text isEqualToString:@""])
    {
        [self.password becomeFirstResponder];
    }
    else
    {
        
        if ([self checkRegex] == NO) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"failed" , nil ) message:NSLocalizedString ( @"msg008" , nil ) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [self.userName becomeFirstResponder];
        }
        else
        {
            if ([self.mode isEqualToString:@"1"]) {
                //create user
                [self checkUserName];
                
                if (self.usercheck){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"failed" , nil ) message:NSLocalizedString ( @"msg001" , nil ) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
                    
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    [self SaveNewUserToServer];
                    
                    [self saveToUserDefault];
                    [self performSegueWithIdentifier:@"showMain" sender:nil];
                }
            }
            else
            {
                //sign in
                [self checkUserName];
                
                if (self.usercheck){
                    
                    if ([self checkPassword]) {
                        [self saveToUserDefault];
                        [self performSegueWithIdentifier:@"showMain" sender:nil];
                    }
                    
                    
                }
            }
        }
        
  
    }
}

- (IBAction)createOrSign:(UIButton *)sender {
    if ([self.signOrCreate.titleLabel.text isEqualToString:NSLocalizedString ( @"signin" , nil ) ]) {
        [self setCreate];
        
    }
    else
    {
        [self setSignIn];
        
    }
}


-(void)setVisible:(BOOL)visible
{
    self.logo.hidden = visible;
    self.signOrCreate.hidden = visible;
    self.createOrSign.hidden = visible;
    self.userName.hidden = visible;
    self.password.hidden = visible;
}

-(void)setCreate{
    [self.signOrCreate setTitle:NSLocalizedString ( @"createaccount" , nil ) forState:UIControlStateNormal];
    [self.createOrSign setTitle:NSLocalizedString ( @"signin" , nil )  forState:UIControlStateNormal];
    self.mode = @"1";
    
}

-(void)setSignIn{
    [self.signOrCreate setTitle:NSLocalizedString ( @"signin" , nil )  forState:UIControlStateNormal];
    [self.createOrSign setTitle:NSLocalizedString ( @"createaccount" , nil )  forState:UIControlStateNormal];
    self.mode = @"0";
    
    [self.signOrCreate.layer setMasksToBounds:YES];
    [self.signOrCreate.layer setCornerRadius:8.0]; //设置矩圆角半径
    [self.signOrCreate.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255/255, 255/255, 255/255, 1 });
    [self.signOrCreate.layer setBorderColor:colorref];//边框颜色
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self readNSUserDefaults];
    if (self.user_id == nil)
    {
        [self setVisible:NO];
    }
    else if ([self.user_id isEqualToString:@""])
    {
        [self setVisible:NO];
    }
    else
    {
        [self setVisible:YES];
        
        [self performSegueWithIdentifier:@"showMain" sender:nil];
        
    }
}


-(void)readNSUserDefaults{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *myString;
    
    myString = [userDefaultes stringForKey:@"userID"];
    self.user_id = myString;
    
}

- (void) saveToUserDefault{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名和密码存储到UserDefault
    [userDefaults setObject:@"" forKey:@"currentEngagementID"];
    [userDefaults setObject:self.user_id forKey:@"userID"];
    [userDefaults setObject:[self.userName.text lowercaseString] forKey:@"userName"];
    [userDefaults setObject:self.displayName forKey:@"displayName"];
    [userDefaults setObject:[self md5:(self.password.text)] forKey:@"password"];
    [userDefaults setObject:@"" forKey:@"currentEngagementTitle"];
    [userDefaults synchronize];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)checkRegex  {
    
    NSString * regex = @"^[A-Za-z0-9]{1,15}$";
    //正则表达式
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //Cocoa框架中的NSPredicate用于查询，原理和用法都类似于SQL中的where，作用相当于数据库的过滤取
    BOOL isMatch = [pred evaluateWithObject:self.userName.text];
    //判读userNameField的值是否吻
    return isMatch;
}

- (void)checkUserName
{
    self.userList = nil;
    
    
    NSString *tempURL;
    NSString *userName;
    
    userName = [self.userName.text lowercaseString];
    
    //userName = @"user2";
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/usernamecheck/?username="];
    tempURL = [tempURL stringByAppendingString:userName];
    
    
    
    NSURL *url= [NSURL URLWithString:tempURL];
    NSError *error = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse:nil error:&error];
    
    
    
    //NSData *jsonResult = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    NSLog(@"Error: %@", error);
    
    if (error.code == -1009) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"error" , nil ) message:NSLocalizedString ( @"connecterror" , nil ) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        NSDictionary *propertyListResults =[NSJSONSerialization JSONObjectWithData:response options:0 error:NULL ];
        //NSLog(@"FetchResult = %@",propertyListResults);
        self.userList = (NSArray *)propertyListResults;
        
        
        NSLog(@"userList = %@",self.userList);
        
        
        
        if (self.userList != nil) {
            self.userRecord = [self.userList objectAtIndex:0];
            
            self.user_id =(NSString *)[self.userRecord valueForKeyPath:@"user_id"];
            
            self.tempPassword =  (NSString *)[self.userRecord valueForKeyPath:@"password"];
            
            self.displayName =  (NSString *)[self.userRecord valueForKeyPath:@"display_name"];
            
            self.usercheck = YES;
            
            
        }
        else
        {
            
            if ([self.mode isEqualToString:@"0"]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"failed" , nil ) message:NSLocalizedString ( @"msg002" , nil ) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
                
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            self.usercheck = NO;
        }
        
             
    }
}

- (BOOL)checkPassword{
    
    NSString *tempPassword;
    NSString *enterPassword;
    
    
    enterPassword =[self md5:self.password.text];
    
    if ([self.tempPassword isEqualToString:enterPassword]){
        return true;
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString ( @"failed" , nil ) message:NSLocalizedString ( @"msg002" , nil ) preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString ( @"ok" , nil ) style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:okAction];
        
        return false;
    }
    
    
}

- (void)SaveNewUserToServer{
    
    NSString *tempURL;
    
    tempURL = [serverURL stringByAppendingString:@"/e8020/index.php/api/user"];
    
    NSURL *url= [NSURL URLWithString:tempURL];
    
    NSMutableURLRequest *request =  [[NSMutableURLRequest alloc] init] ;
    [request setURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    //NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    
    NSString *tempUserName;
    NSString *tempPassword;
    
    
    
    tempUserName = [self.userName.text lowercaseString];
    tempPassword = [self md5:self.password.text];
    
    
    
    
    [postBody appendData:[[NSString stringWithFormat:@"user_name=%@&password=%@&display_name=%@",tempUserName,tempPassword,tempUserName] dataUsingEncoding:NSUTF8StringEncoding]];
    
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
        self.userRecord = (NSArray *)propertyListResults;
        
        if (self.userRecord != nil) {
            self.user_id = [self.userRecord valueForKeyPath:@"user_id"];
            self.displayName = [self.userRecord valueForKeyPath:@"display_name"];
        }
        
  
        NSLog(@"newUser = %@",self.userRecord);
        
        NSLog(@"Success");
        
    }
    
 
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
