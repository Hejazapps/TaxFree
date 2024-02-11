//
//  PurchaseLimitViewController.h
//  TaxFree
//
//  Created by Smile on 2023/07/23.
//  Copyright © 2023 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseLimitViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewContent;

@property (strong, nonatomic) IBOutlet UIView *viewLimitContent;
@property (strong, nonatomic) IBOutlet UIButton *btnUseLimitNotification;


@property (strong, nonatomic) IBOutlet UILabel *lblDuration;

@property (strong, nonatomic) IBOutlet UITextField *txtLimitAmount;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@property (strong, nonatomic) IBOutlet UIView *viewPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@property (strong, nonatomic) IBOutlet UIButton *MerchantAllBtn;
@property (strong, nonatomic) IBOutlet UILabel *lblDMerchantID;
@property (strong, nonatomic) IBOutlet UITextField *txtMerchantID;
@end

NS_ASSUME_NONNULL_END
