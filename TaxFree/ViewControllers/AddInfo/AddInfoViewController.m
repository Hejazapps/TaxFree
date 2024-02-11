//
//  AddInfoViewController.m
//  TaxFree
//
//  Created by Smile on 2023/01/16.
//  Copyright © 2023 Smile. All rights reserved.
//

#import "AddInfoViewController.h"

@interface AddInfoViewController ()
{
    int option;
    NSDate *IssueDate;
    NSDate *IssueDate2;
}
@end

@implementation AddInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressSelected:) name:@"AddressSelected" object:nil];
    
    [self interfaceConfig];
    // Do any additional setup after loading the view.
}

- (void) interfaceConfig {
    _txtInstituteName.delegate = self;
    _txtIssueNo.delegate = self;
    _txtPostNo.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:_txtPostNo.placeholder attributes:@{NSForegroundColorAttributeName: OrangeColor}];
    _txtAddress.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:_txtAddress.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _txtAddressNo.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:_txtAddressNo.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _txtAddress.leftViewMode = UITextFieldViewModeAlways;
    _txtAddressNo.leftViewMode = UITextFieldViewModeAlways;
    _txtAddress.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 28)];
    _txtAddressNo.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 28)];
    
    _btnCancel.layer.borderColor = _btnOk.backgroundColor.CGColor;
    
    if (kAppDelegate.AdditionalInfo) {
        option = [kAppDelegate.AdditionalInfo[@"type"] isEqualToString:@"0"] ? 0 : 1;
        if (option == 0) {
            _txtInstituteName.text = kAppDelegate.AdditionalInfo[@"issue_name"];
            _txtIssueDate.text = kAppDelegate.AdditionalInfo[@"issue_date"];
            _txtIssueNo.text = kAppDelegate.AdditionalInfo[@"issue_no"];
        }
        else {
            _txtIssueDate2.text = kAppDelegate.AdditionalInfo[@"issue_date"];
        }
        _txtPostNo.text = kAppDelegate.AdditionalInfo[@"post_no"];
        _txtAddress.text = kAppDelegate.AdditionalInfo[@"address"];
        _txtAddressNo.text = kAppDelegate.AdditionalInfo[@"address_no"];
    }
    [self optionChanged];
}

- (void) ClearLineColor {
    _lineInstituteName.backgroundColor = [UIColor lightGrayColor];
    _lineIssueDate.backgroundColor = [UIColor lightGrayColor];
    _lineIssueNo.backgroundColor = [UIColor lightGrayColor];
    _lineIssueDate2.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtInstituteName) {
        [self ClearLineColor];
        _lineInstituteName.backgroundColor = BlueColor;
    }
    else if (textField == _txtIssueNo) {
        [self ClearLineColor];
        _lineIssueNo.backgroundColor = BlueColor;
    }
}

- (void) addressSelected:(NSNotification *)notification {
    NSDictionary *AddressInfo = notification.userInfo;
    _txtPostNo.text = [AddressInfo[@"POST_CODE"] stringValue];
    _txtAddress.text = [NSString stringWithFormat:@"%@%@%@", AddressInfo[@"KANJI_TODOFUKEN_NAME"], AddressInfo[@"KANJI_SIGUCHOSON_NAME"], AddressInfo[@"KANJI_CHOIKI_NAME"]];
}

- (IBAction)btnOption1Click:(id)sender {
    option = 0;
    [self optionChanged];
}

- (IBAction)btnOption2Click:(id)sender {
    option = 1;
    [self optionChanged];
}

- (void)optionChanged {
    if (option == 0) {
        _viewOption1.hidden = NO;
        _viewOption2.hidden = YES;
        _btnOption1.backgroundColor = OrangeColor;
        _btnOption2.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        _viewOption1.hidden = YES;
        _viewOption2.hidden = NO;
        _btnOption1.backgroundColor = [UIColor lightGrayColor];
        _btnOption2.backgroundColor = OrangeColor;
    }
    [self ClearLineColor];
    [self.view endEditing:YES];
}


- (IBAction)IssueDateClick:(id)sender {
    [self.view endEditing:YES];
    [self ClearLineColor];
    _lineIssueDate.backgroundColor = BlueColor;
    
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    chooseDataPicker.maxDate = [NSDate date];
    if (IssueDate) {
        chooseDataPicker.data = IssueDate;
    }
    [chooseDataPicker show];
}

- (IBAction)IssueDate2Click:(id)sender {
    [self.view endEditing:YES];
    [self ClearLineColor];
    _lineIssueDate2.backgroundColor = BlueColor;
    
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    chooseDataPicker.maxDate = [NSDate date];
    if (IssueDate2) {
        chooseDataPicker.data = IssueDate2;
    }
    [chooseDataPicker show];
}

#pragma mark - DatePickerViewDelegate
- (void)finishSelectDate:(NSDate *)date {
    if (date) {
        if (option == 0) {
            IssueDate = date;
            _txtIssueDate.text = [CommonFunc getDateStringWithFormat:IssueDate format:@"yyyy.MM.dd"];
        }
        else {
            IssueDate2 = date;
            _txtIssueDate2.text = [CommonFunc getDateStringWithFormat:IssueDate2 format:@"yyyy.MM.dd"];
        }
    }
}


- (IBAction)btnOkClick:(id)sender {
    if (option == 0) {
        if (_txtInstituteName.text.length == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"在外公館の名称"]];
            return;
        }
        if (_txtIssueDate.text.length == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"発給年月日"]];
            return;
        }
        if (_txtIssueNo.text.length == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"発給番号"]];
            return;
        }
    }
    else {
        if (_txtIssueDate2.text.length == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"発給年月日"]];
            return;
        }
    }
    if (_txtAddress.text.length == 0) {
        [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"都道府県 •市区町村•町名"]];
        return;
    }
    if (_txtAddressNo.text.length == 0) {
        [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"番地"]];
        return;
    }
    
    kAppDelegate.AdditionalInfo = [NSMutableDictionary new];
    if (option == 0) {
        kAppDelegate.AdditionalInfo[@"type"] = @"0";
        kAppDelegate.AdditionalInfo[@"issue_name"] = _txtInstituteName.text;
        kAppDelegate.AdditionalInfo[@"issue_date"] = _txtIssueDate.text;
        kAppDelegate.AdditionalInfo[@"issue_no"] = _txtIssueNo.text;
    }
    else {
        kAppDelegate.AdditionalInfo[@"type"] = @"1";
        kAppDelegate.AdditionalInfo[@"issue_date"] = _txtIssueDate2.text;
    }
    kAppDelegate.AdditionalInfo[@"post_no"] = _txtPostNo.text;
    kAppDelegate.AdditionalInfo[@"address"] = _txtAddress.text;
    kAppDelegate.AdditionalInfo[@"address_no"] = _txtAddressNo.text;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AdditionalInfoChanged" object:nil];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)btnCancelClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)btnCloseClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)btnAddressClick:(id)sender {
    AddressViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Address"];
    [self presentViewController:vc animated:true completion:nil];
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
