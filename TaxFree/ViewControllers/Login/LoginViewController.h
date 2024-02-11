//
//  LoginViewController.h
//  TaxFree
//
//  Created by Smile on 24/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UILabel *lineUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UILabel *linePassword;
@property (strong, nonatomic) IBOutlet UILabel *TestVersion;

@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;


@end
