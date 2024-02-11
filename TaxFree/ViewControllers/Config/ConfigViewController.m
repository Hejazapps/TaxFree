//
//  ConfigViewController.m
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController() {
    UIView *darkBackground;
    NSMutableDictionary *configInfo;
    NSMutableArray *PrinterList;
    NSMutableDictionary *Printer;
    NSMutableDictionary *ShopInfo;
    NSMutableArray *PrintChoiceList;
    NSMutableDictionary *PrintChoice;
}

@end

@implementation ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *merchantList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:MERCHANT_TABLE_KIND]];
    if (merchantList.count > 0) {
        ShopInfo = [[NSMutableDictionary alloc] initWithDictionary:merchantList[0]];
    }
    
    kAppDelegate.ScreenName = @"Config";
    [self interfaceConfig];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"환경설정의 viewDidLoad가 실행되고 있습니다...");
    
    //    if (kAppDelegate.isPassOn) {
    [self showConfigInfo];
    //    }
    //    else {
    //        [self showPasswordInput];
    //    }
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancel_PosData:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) cancel_PosData:(NSNotification *)notification {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
            //메세지 창을 띄워서 물어보고 YES를 선택했을 때만 제어를 옮기도록 한다... 혹은 무조건 확인만 누르게 하거나....
            MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            kAppDelegate.ScreenName = @"OnlineSearch";
            OnlineSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineSearch"];
            [navigationController pushViewController:controller animated:NO];
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        else if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"I"]) && (!kAppDelegate.call_by_url_issued)) {
            //메세지 창을 띄워서 물어보고 YES를 선택했을 때만 제어를 옮기도록 한다... 혹은 무조건 확인만 누르게 하거나....
            MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
            kAppDelegate.ScreenName = @"Issue";
            IssueViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Issue"];
            [self.navigationController pushViewController:controller animated:NO];
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
     });
}
- (void) interfaceConfig {
    configInfo = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getValuesForKey:CONFIG_INFO]];
    
    darkBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    darkBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _viewPassword.layer.cornerRadius = 12;
    _btnOk.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnOk.clipsToBounds = YES;
    
    _btnCancel.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnCancel.layer.borderColor = _btnOk.backgroundColor.CGColor;
    _btnCancel.layer.borderWidth = 1;
    _btnCancel.clipsToBounds = YES;
    
    _viewTerminalID.layer.cornerRadius = _viewTerminalID.frame.size.height/2;
    _viewPassportScanner.layer.cornerRadius = _viewTerminalID.frame.size.height/2;
    _viewPrinter.layer.cornerRadius = _viewTerminalID.frame.size.height/2;
    _viewReceiptAdd.layer.cornerRadius = _viewTerminalID.frame.size.height/2;
    _viewSignpadUse.layer.cornerRadius = _viewTerminalID.frame.size.height/2;
    _viewPrintChoice.layer.cornerRadius = _viewTerminalID.frame.size.height/2;
    
    _btnSave.layer.cornerRadius = _btnSave.frame.size.height/2;
    _btnSave.clipsToBounds = YES;
    
    PrinterList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"Printer.json"][@"data"]];
    Printer = [[NSMutableDictionary alloc] init];
    
    PrintChoiceList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"PrintChoice.json"][@"data"]];
    PrintChoice = [[NSMutableDictionary alloc] init];
}

- (void) showConfigInfo {
    _txtTerminalID.text = configInfo[@"terminal_id"];
    _txtPassportScanner.text = configInfo[@"passport_scanner"];
    for (int i = 0; i < PrinterList.count; i++) {
        if ([configInfo[@"printer"] isEqualToString:PrinterList[i][@"id"]]) {
            Printer = PrinterList[i];
        }
    }
    _txtPrinter.text = Printer[LANGUAGE];
    
    //_txtReceiptAdd.text = configInfo[@"receipt_add"];
    _txtSignpadUse.text = configInfo[@"signpad_use"];
    
    for (int i = 0; i < PrintChoiceList.count; i++) {
        if ([configInfo[@"print_choice"] isEqualToString:PrintChoiceList[i][@"id"]]) {
            PrintChoice = PrintChoiceList[i];
        }
    }
    _txtPrintChoice.text = PrintChoice[LANGUAGE];
    
    //    if ([_txtSignpadUse.text isEqualToString:@"YES"]) {
    _dropPrintChoice.hidden = NO;
    //    }
    //    else {
    //        _dropPrintChoice.hidden = YES;
    //    }
    
}

- (IBAction)MenuClick:(id)sender {
    [self showLeftViewAnimated:sender];
}

- (IBAction)PrinterClick:(id)sender {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < PrinterList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:PrinterList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->Printer = self->PrinterList[i];
            self->_txtPrinter.text = self->Printer[LANGUAGE];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:240 relyonView:sender];
    [view show];
}

- (IBAction)TerminalIDClick:(id)sender {
    NSMutableArray *termList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:TERMINAL_TABLE_KIND]];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < termList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:termList[i][@"TML_NO"] image:nil handler:^(YCMenuAction *action) {
            self->_txtTerminalID.text = action.title;
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:120 relyonView:sender];
    [view show];
}
/*
- (IBAction)ReceiptAddClick:(id)sender {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"YES" image:nil handler:^(YCMenuAction *action) {
        self->_txtReceiptAdd.text = @"YES";
    }];
    [arr addObject:action1];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"NO" image:nil handler:^(YCMenuAction *action) {
        self->_txtReceiptAdd.text = @"NO";
    }];
    [arr addObject:action2];
    
    YCMenuView *view = [YCMenuView menuWithActions:arr width:120 relyonView:sender];
    [view show];
}
 */

- (IBAction)SignpadUseClick:(id)sender {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"YES" image:nil handler:^(YCMenuAction *action) {
        self->_txtSignpadUse.text = @"YES";
    }];
    [arr addObject:action1];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"NO" image:nil handler:^(YCMenuAction *action) {
        self->_txtSignpadUse.text = @"NO";
    }];
    [arr addObject:action2];
    
    YCMenuView *view = [YCMenuView menuWithActions:arr width:120 relyonView:sender];
    [view show];
}

- (IBAction)PrintChoiceClick:(id)sender {
    //    if ([_txtSignpadUse.text isEqualToString:@"NO"]) {
    //        return;
    //    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < PrintChoiceList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:PrintChoiceList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            if ([self->ShopInfo[@"SEND_CUSTOM_FLAG"] isEqualToString:@"N"] && (i == 2)) {
                [self.view makeToast:@"電子化未対応のため選択不可"];
            }
            else {
                self->PrintChoice = self->PrintChoiceList[i];
                self->_txtPrintChoice.text = self->PrintChoice[LANGUAGE];
            }
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:240 relyonView:sender];
    [view show];
}

- (IBAction)AdvancedSettingsClick:(id)sender {
    NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
    if (feeSettingInfo) {
        if ([feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"]) {
            _txtPassword.text = @"";
            [self showPasswordInput];
        }
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
        kAppDelegate.isPassOn = @"1";
        [self hidePasswordInput];
        AdvancedSettingsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AdvancedSettings"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [self.view makeToast:@"パスワードが間違っています。"];
    }
    
}

- (IBAction)btnCancelClick:(id)sender {
    [self hidePasswordInput];
}




- (IBAction)SaveClick:(id)sender {
    configInfo[@"terminal_id"] = _txtTerminalID.text;
    //configInfo[@"receipt_add"] = _txtReceiptAdd.text;
    configInfo[@"signpad_use"] = _txtSignpadUse.text;
    configInfo[@"print_choice"] = PrintChoice[@"id"];
    configInfo[@"printer"] = Printer[@"id"];
    [CommonFunc saveUserDefaults:CONFIG_INFO value:configInfo];
    
    [self.view makeToast:CONFIG_SAVE_SUCCESS];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
