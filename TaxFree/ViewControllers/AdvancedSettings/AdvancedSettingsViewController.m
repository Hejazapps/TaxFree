//
//  AdvancedSettingsViewController.m
//  TaxFree
//
//  Created by Smile on 2023/06/27.
//  Copyright © 2023 Smile. All rights reserved.
//

#import "AdvancedSettingsViewController.h"

@interface AdvancedSettingsViewController ()
{
    BOOL isFeeSettingShop;
    NSInteger duration;
}
@end

@implementation AdvancedSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self interfaceConfig];
    // Do any additional setup after loading the view.
}

- (void) interfaceConfig {
    
    _txtCustomerFee.superview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtShopFee.superview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtGtfFee.superview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _btnSave.layer.cornerRadius = _btnSave.frame.size.height/2;
    _btnSave.clipsToBounds = YES;
    _btnSave.hidden = YES;
        
    NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
    if (feeSettingInfo) {
        isFeeSettingShop = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
        _btnUseFee.selected = isFeeSettingShop;
        if (isFeeSettingShop) {
            NSMutableDictionary *feeInfo = feeSettingInfo[@"fee_info"][0];
            if ([feeInfo[@"fee_type"] isEqualToString:@"1"]) {
                _txtGtfFee.text = [NSNumber numberWithFloat:[feeInfo[@"gtf_fee"] floatValue]].stringValue;
                _txtShopFee.text = @"0";
                _txtCustomerFee.text = [NSNumber numberWithFloat:1.0f - [feeInfo[@"gtf_fee"] floatValue]].stringValue;
            }
            else if ([feeInfo[@"fee_type"] isEqualToString:@"2"]) {
                _txtShopFee.text = [NSNumber numberWithFloat:[feeInfo[@"merchant_fee"] floatValue]].stringValue;
                _txtGtfFee.text = [NSNumber numberWithFloat:[feeInfo[@"gtf_fee"] floatValue]].stringValue;
                _txtCustomerFee.text = [NSNumber numberWithFloat:1.0f - [feeInfo[@"merchant_fee"] floatValue] - [feeInfo[@"gtf_fee"] floatValue]].stringValue;
            }
            else if ([feeInfo[@"fee_type"] isEqualToString:@"3"]) {
                _txtShopFee.text = [NSNumber numberWithFloat:[feeInfo[@"merchant_fee"] floatValue]].stringValue;
                _txtGtfFee.text = @"0";
                _txtCustomerFee.text = [NSNumber numberWithFloat:1.0f - [feeInfo[@"merchant_fee"] floatValue]].stringValue;
            }
        }
    }
    _viewFeeInfo.hidden = !_btnUseFee.isSelected;
}

- (IBAction)btnUseFeeClick:(id)sender {
//    if (isFeeSettingShop) {
//        _btnUseFee.selected = !_btnUseFee.isSelected;
//        _viewFeeInfo.hidden = !_btnUseFee.isSelected;
//    }
//    else {
//        [self.view makeToast:@"수수료 기능 사용 매장이 아닙니다."];
//    }
}

- (IBAction)BackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)SaveClick:(id)sender {
    
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
