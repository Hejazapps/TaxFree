//
//  AdvancedSettingsViewController.h
//  TaxFree
//
//  Created by Smile on 2023/06/27.
//  Copyright © 2023 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdvancedSettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnUseFee;

@property (strong, nonatomic) IBOutlet UIView *viewFeeInfo;

@property (strong, nonatomic) IBOutlet UITextField *txtCustomerFee;
@property (strong, nonatomic) IBOutlet UITextField *txtShopFee;
@property (strong, nonatomic) IBOutlet UITextField *txtGtfFee;

@property (strong, nonatomic) IBOutlet UIButton *btnSave;

@end

NS_ASSUME_NONNULL_END
