//
//  AddressViewController.m
//  TaxFree
//
//  Created by Smile on 2023/01/16.
//  Copyright © 2023 Smile. All rights reserved.
//

#import "AddressViewController.h"

@interface AddressViewController ()
{
    NSMutableArray *StateList;
    NSMutableDictionary *State;
    NSMutableArray *ResultList;
}
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StateList = [[NSMutableArray alloc] initWithArray:[CommonFunc readJapanStates]];
    ResultList = [NSMutableArray new];
    [self interfaceConfig];
    // Do any additional setup after loading the view.
}

- (void) interfaceConfig {
    _mainTableView.layer.shadowColor = [UIColor grayColor].CGColor;
    _mainTableView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _mainTableView.layer.shadowOpacity = 0.5;
    _mainTableView.layer.shadowRadius = 2.0;
    
    _txtState.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:_txtState.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _txtSearch.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:_txtSearch.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _txtState.leftViewMode = UITextFieldViewModeAlways;
    _txtSearch.leftViewMode = UITextFieldViewModeAlways;
    _txtState.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 28)];
    _txtSearch.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 28)];
    
    _viewField.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _viewField.layer.shadowOpacity = 0.5;
    _viewField.layer.shadowRadius = 2.0;
}

- (IBAction)btnStateClick:(UIButton *)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < StateList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:StateList[i][@"CODENAME"] image:nil handler:^(YCMenuAction *action) {
            self->State = self->StateList[i];
            self->_txtState.text = self->State[@"CODENAME"];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:120 relyonView:sender];
    view.maxDisplayCount = 5;
    [view show];
}
- (IBAction)btnSearchClick:(id)sender {
    if (State == nil) {
        [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"都道府県"]];
        return;
    }
    if (_txtSearch.text.length == 0) {
        [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"市区町村 • 町名"]];
        return;
    }
    ResultList = [[NSMutableArray alloc] initWithArray:[CommonFunc searchAddress:State[@"CODENAME"] keyString:_txtSearch.text]];
    [_mainTableView reloadData];
}



- (IBAction)btnCloseClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return ResultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.row%2 == 0) {
        cell.cellView.backgroundColor = LightOrangeColor;
    }
    else {
        cell.cellView.backgroundColor = [UIColor whiteColor];
    }
    NSMutableDictionary *AddressInfo = ResultList[indexPath.row];
    cell.lblAddress1.text = AddressInfo[@"KANJI_TODOFUKEN_NAME"];
    cell.lblAddress2.text = AddressInfo[@"KANJI_SIGUCHOSON_NAME"];
    cell.lblAddress3.text = AddressInfo[@"KANJI_CHOIKI_NAME"];
    cell.lblAddress4.text = AddressInfo[@"KANA_CHOIKI_NAME"];
    
    NSString *postCode = [AddressInfo[@"POST_CODE"] stringValue];
//    NSString *oldCode = [AddressInfo[@"POST_CODE_OLD"] stringValue];
//    cell.lblPostCode.text = [NSString stringWithFormat:@"%@-%@", oldCode, [postCode stringByReplacingOccurrencesOfString:oldCode withString:@""]];
    cell.lblPostCode.text = postCode;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *AddressInfo = ResultList[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddressSelected" object:nil userInfo:AddressInfo];
    [self dismissViewControllerAnimated:true completion:nil];
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
