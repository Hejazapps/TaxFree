//
//  PurchaseLimitViewController.m
//  TaxFree
//
//  Created by Smile on 2023/07/23.
//  Copyright © 2023 Smile. All rights reserved.
//

#import "PurchaseLimitViewController.h"

@interface PurchaseLimitViewController ()
{
    NSInteger duration;
    UIView *darkBackground;
    Boolean MerchantAllFlag;
    NSString *str_MerchantID;
}
@end

@implementation PurchaseLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MerchantAllFlag = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanging:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self interfaceConfig];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    
    [self showPasswordInput];
}

- (IBAction)MenuClick:(id)sender {
    [self showLeftViewAnimated:sender];
}

- (void) interfaceConfig {
    
    _viewPassword.layer.cornerRadius = 12;
    _btnOk.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnOk.clipsToBounds = YES;
    
    _btnCancel.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnCancel.layer.borderColor = _btnOk.backgroundColor.CGColor;
    _btnCancel.layer.borderWidth = 1;
    _btnCancel.clipsToBounds = YES;
    
    darkBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    darkBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];

    _btnSave.layer.cornerRadius = _btnSave.frame.size.height/2;
    _btnSave.clipsToBounds = YES;
    str_MerchantID = @"";
    
    NSMutableDictionary *limitSettingInfo = [CommonFunc getValuesForKey:LIMIT_SETTING_INFO];
    if (limitSettingInfo) {
        _btnUseLimitNotification.selected = YES;
        duration = [limitSettingInfo[@"duration"] integerValue];
        _txtLimitAmount.text = [CommonFunc getCommaString:limitSettingInfo[@"limit"]];
        _txtLimitAmount.userInteractionEnabled = YES;
        
        MerchantAllFlag = [limitSettingInfo[@"MerchantAll"] boolValue];
        if(MerchantAllFlag) {
            _MerchantAllBtn.selected = true;
            _txtMerchantID.hidden = false;
            _lblDMerchantID.hidden = false;
            str_MerchantID = limitSettingInfo[@"MerchantManagerID"];
            _txtMerchantID.text = str_MerchantID;
        } else {
            _MerchantAllBtn.selected = false;
            _txtMerchantID.hidden = true;
            _lblDMerchantID.hidden = true;
            _txtMerchantID.text = @"";
        }
    }
    else {
        duration = 0;
        _txtLimitAmount.userInteractionEnabled = NO;
        _MerchantAllBtn.selected = false;
        _txtMerchantID.hidden = true;
        _lblDMerchantID.hidden = true;
        _txtMerchantID.text = @"";
    }
    _viewLimitContent.hidden = !_btnUseLimitNotification.isSelected;
    [self durationChanged];
}

- (void) textFieldDidChanging:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    
    if (textField == _txtLimitAmount) {
        _txtLimitAmount.text = [CommonFunc getCommaString:[_txtLimitAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]];
    }
}


- (void) showPasswordInput {
    [self.view insertSubview:darkBackground belowSubview:_viewPassword];
    [UIView transitionWithView:_viewPassword
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewPassword.hidden = NO;
    } completion:^(BOOL finished) {
        [self->_txtPassword becomeFirstResponder];
    }];
}

- (void) hidePasswordInput {
    [self.view endEditing:YES];
    [UIView transitionWithView:_viewPassword
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewPassword.hidden = YES;
    }
                    completion:^(BOOL finished) {
        [self->darkBackground removeFromSuperview];
    }];
}


- (IBAction)btnOkClick:(id)sender {
    if ([_txtPassword.text.lowercaseString isEqualToString:SETTING_PASSWORD]) {
        kAppDelegate.ScreenName = @"PurchaseLimit";
        [self hidePasswordInput];
        _viewContent.hidden = NO;
        _btnSave.hidden = NO;
    }
    else {
        [self.view makeToast:@"パスワードが間違っています。"];
    }
}

- (IBAction)btnCancelClick:(id)sender {
    [self hidePasswordInput];
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)btnUseLimitNotificationClick:(id)sender {
    _btnUseLimitNotification.selected = !_btnUseLimitNotification.isSelected;
    _txtLimitAmount.userInteractionEnabled = _btnUseLimitNotification.isSelected;
    _viewLimitContent.hidden = !_btnUseLimitNotification.isSelected;
    if(MerchantAllFlag) {
        _MerchantAllBtn.selected = true;
        _txtMerchantID.hidden = false;
        _lblDMerchantID.hidden = false;
        _txtMerchantID.text = str_MerchantID;
    } else {
        _MerchantAllBtn.selected = false;
        _txtMerchantID.hidden = true;
        _lblDMerchantID.hidden = true;
        _txtMerchantID.text = str_MerchantID;
    }
}

- (IBAction)durationClick:(UIButton *)sender {
    if (!_btnUseLimitNotification.isSelected) {
        return;
    }
    [self.view endEditing:YES];
    NSArray *durationList = @[@"1週間", @"1ヶ月", @"3ヶ月", @"6ヶ月", @"1年", @"2年", @"3年"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < durationList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:durationList[i] image:nil handler:^(YCMenuAction *action) {
            self->_lblDuration.text = action.title;
            self->duration = i + 1;
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:sender.frame.size.width relyonView:sender];
    view.menuCellHeight = 40;
    [view show];
}


- (void) durationChanged {
    NSArray *durationList = @[@"1週間", @"1ヶ月", @"3ヶ月", @"6ヶ月", @"1年", @"2年", @"3年"];
    if (duration == 0) {
        _lblDuration.text = @"期間を選択";
    }
    else {
        _lblDuration.text = durationList[duration - 1];
    }
}


- (IBAction)SaveClick:(id)sender {
    if (_btnUseLimitNotification.isSelected) {
        if (duration == 0) {
            [self.view makeToast:@"期間を設定してください。"];
            return;
        }
        if (_txtLimitAmount.text.length == 0 || [_txtLimitAmount.text longLongValue] == 0) {
            [self.view makeToast:@"金額を設定してください。"];
            return;
        }
        //매장전체 조회로 선택됐는데 매장담당ID란에 아무것도 없으면 return 메세지
        if(_MerchantAllBtn.selected) {
            if(_txtMerchantID.text.length <= 1){
                [self.view makeToast:@"담당ID 값을 입력해주시기 바랍니다!"];
                return;
            }
        }
        NSMutableDictionary *limitSettingInfo = [NSMutableDictionary new];
        limitSettingInfo[@"duration"] = [NSString stringWithFormat:@"%ld", (long)duration];
        limitSettingInfo[@"limit"] = [_txtLimitAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        limitSettingInfo[@"MerchantAll"] = [NSString stringWithFormat:@"%d", MerchantAllFlag];
        limitSettingInfo[@"MerchantManagerID"] = [NSString stringWithFormat:@"%@", _txtMerchantID.text];
        [CommonFunc saveUserDefaults:LIMIT_SETTING_INFO value:limitSettingInfo];
    }
    else {
        [CommonFunc saveUserDefaults:LIMIT_SETTING_INFO value:nil];
    }
    
    [self.view makeToast:@"環境情報が保存されました。"];
    str_MerchantID = _txtMerchantID.text;
}

- (IBAction)MerchantAllBtnClick:(id)sender {
    _MerchantAllBtn.selected = !_MerchantAllBtn.selected;
    _txtMerchantID.hidden = !_MerchantAllBtn.selected;
    _lblDMerchantID.hidden = !_MerchantAllBtn.selected;
    MerchantAllFlag = !MerchantAllFlag;
    if(MerchantAllFlag) {
        _txtMerchantID.text = str_MerchantID;
    } else _txtMerchantID.text = @"";
}


@end
