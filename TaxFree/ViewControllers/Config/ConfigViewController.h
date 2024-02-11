//
//  ConfigViewController.h
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

@interface ConfigViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *viewTerminalID;
@property (strong, nonatomic) IBOutlet UIView *viewPassportScanner;
@property (strong, nonatomic) IBOutlet UIView *viewPrinter;
@property (strong, nonatomic) IBOutlet UIView *viewReceiptAdd;
@property (strong, nonatomic) IBOutlet UIView *viewSignpadUse;
@property (strong, nonatomic) IBOutlet UIView *viewPrintChoice;

@property (strong, nonatomic) IBOutlet UITextField *txtTerminalID;
@property (strong, nonatomic) IBOutlet UITextField *txtPassportScanner;
@property (strong, nonatomic) IBOutlet UITextField *txtPrinter;
//@property (strong, nonatomic) IBOutlet UITextField *txtReceiptAdd;
@property (strong, nonatomic) IBOutlet UITextField *txtSignpadUse;
@property (strong, nonatomic) IBOutlet UITextField *txtPrintChoice;
@property (strong, nonatomic) IBOutlet UIImageView *dropPrintChoice;


@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (strong, nonatomic) IBOutlet UIView *viewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end
