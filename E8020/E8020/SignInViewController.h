//
//  SignInViewController.h
//  E8020
//
//  Created by Yiwen Fu on 16/1/3.
//  Copyright © 2016年 Yiwen Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface SignInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *signOrCreate;
@property (strong, nonatomic) IBOutlet UIButton *createOrSign;

@property  BOOL usercheck;

@property (strong, nonatomic) NSString *user_id;

@property (strong, nonatomic) NSString *mode;

@property (strong, nonatomic) NSArray *userList;

@property (strong, nonatomic) NSArray *userRecord;

@property (strong, nonatomic) NSString *tempPassword;

@property (strong, nonatomic) NSString *displayName;


@end
