//
//  LoginViewController.m
//  TaxFree
//
//  Created by Smile on 24/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    NSMutableDictionary *userInfo;
}
@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanging:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _txtUsername.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:_txtUsername.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _txtPassword.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:_txtPassword.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _btnSignIn.layer.cornerRadius = _btnSignIn.frame.size.height/2;
    _btnSignIn.clipsToBounds = YES;
    
    if ([CommonFunc getValuesForKey:LOGIN_SUCCESS]) {
        //-----------------------------------------------------------------------------------------------------------------------------------------
        //외부 앱으로부터 호출되어 앱이 실행되고 발행 취소요청인 경우, 바로 Onlien Search메뉴로 이동하도록 한다
        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
            MainViewController      *mainViewController     = (MainViewController *)self                    .sideMenuController;
            UINavigationController  *navigationController   = (UINavigationController *)mainViewController  .rootViewController;

            if (![kAppDelegate.ScreenName isEqualToString:@"OnlineSearch"]) {
                OnlineSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineSearch"];
                [navigationController pushViewController:controller animated:NO];
            }
            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
        //-----------------------------------------------------------------------------------------------------------------------------------------
        else {
            IssueViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Issue"];
            [self.navigationController pushViewController:controller animated:NO];
        }
    }
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *TEST_URL = @"http://jp2admin.gtfetrs.com/service/jtc/";
    if ([API_URL isEqualToString:TEST_URL]) {
        _TestVersion.text = @"TEST Version";
    }
    NSMutableArray *userList = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:USER_LIST]];
    
    if (userList.count > 0) {
        _txtUsername.text = [userList lastObject][@"userId"];
        _txtPassword.text = [userList lastObject][@"passWord"];
    }
}

- (void) textFieldDidChanging:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    
    if (textField == _txtUsername) {
        _txtUsername.text = [_txtUsername.text uppercaseString];
    }
}

- (IBAction)SignInClick:(id)sender {
    [self.view endEditing:YES];

    if (_txtUsername.text.length == 0) {
        [self.view makeToast:EMPTY_ID];
        return;
    }
    if (_txtPassword.text.length == 0) {
        [self.view makeToast:EMPTY_PASSWORD];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userId"] = _txtUsername.text;      // @"TESTID01";  @"KRTEST01"
    params[@"passWord"] = _txtPassword.text;
    
    params[@"userId"] =  @"TESTID01";      // @"TESTID01";  @"KRTEST01"
    params[@"passWord"] = @"gtf12345";

    // @"gtf12345";  @"gtfsg12345"
   params[@"languageCD"] = LANGUAGE;
   params[@"companyID"] = COMPANY_ID;
   params[@"device_id"] = [CommonFunc getValuesForKey:PHONE_UUID];
   params[@"openDate"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [SVProgressHUD show];
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_LOGIN] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* loginStatus = [responseObject objectForKey:@"login"];
                    if([loginStatus isEqualToString:@"S"]){
                        
                        NSString* new_version = [responseObject objectForKey:@"ios_version"];
                        new_version = [new_version stringByReplacingOccurrencesOfString:@"." withString:@""];
                        NSString *app_version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
                        app_version = [app_version stringByReplacingOccurrencesOfString:@"." withString:@""];
                        if (new_version.intValue <= app_version.intValue) {
                            self->userInfo = [[NSMutableDictionary alloc] initWithDictionary:[responseObject objectForKey:@"userInfo"]];
                            if ([[DatabaseManager sharedInstance] readData:USERINFO_TABLE_KIND].count > 0) {
                                //[[DatabaseManager sharedInstance] updateData:USERINFO_TABLE_KIND data:self->userInfo];
                                [[DatabaseManager sharedInstance] updateData:USERINFO_TABLE_KIND data:self->userInfo conditionValue:1];
                            }
                            else {
                                [[DatabaseManager sharedInstance] insertData:USERINFO_TABLE_KIND data:@[self->userInfo]];
                            }
                            kAppDelegate.LoginID = self->userInfo[@"userId"];
                            
                            
                            //위탁형
                            if (self->userInfo[@"deskId"]) {
                                [CommonFunc saveUserDefaults:DESK_ID value:self->userInfo[@"deskId"]];
                            }
                            //일반형
                            else {
                                if (self->userInfo[@"merchantNo"]) {
                                    [CommonFunc saveUserDefaults:MERCHANT_NO value:self->userInfo[@"merchantNo"]];
                                }
                                [CommonFunc saveUserDefaults:DESK_ID value:@""];
                            }
                            
                            [self getInfo:@"merchant"];
                        }
                        else {
                            [SVProgressHUD dismiss];
                            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"最新バージョンが確認されました" message:nil preferredStyle:UIAlertControllerStyleAlert];
                            [alertView addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                [alertView dismissViewControllerAnimated:YES completion:nil];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id1451260493?ls=1&mt=8"]];
                            }]];
                            [self presentViewController:alertView animated:YES completion:nil];
                        }
                    }
                    else {
                        [SVProgressHUD dismiss];
                        [self.view makeToast:ERROR_LOGIN];
                    }
                }
                else {
                    [SVProgressHUD dismiss];
                    [self.view makeToast:ERROR_LOGIN];
                }
            }
            else {
                [SVProgressHUD dismiss];
                [self.view makeToast:NETWORK_ERROR];
            }
        }];
    }
    else {
        kAppDelegate.isOnline = nil;
        [self.view makeToast:NETWORK_FAILED];
    }
}

- (void) getInfo:(NSString *)code_type {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userId"] = userInfo[@"userId"];
    params[@"merchantNo"] = userInfo[@"merchantNo"];
    params[@"deskId"] = [CommonFunc getValuesForKey:DESK_ID];
    params[@"code_type"] = code_type;
    params[@"languageCD"] = LANGUAGE;
    params[@"companyID"] = COMPANY_ID;
    params[@"openDate"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_INFO] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* resultStatus = [responseObject objectForKey:@"result"];
                    if([resultStatus isEqualToString:@"S"]){
                        if ([code_type isEqualToString:@"merchant"]) {
                            [[DatabaseManager sharedInstance] deleteData:MERCHANT_TABLE_KIND];
                            [[DatabaseManager sharedInstance] deleteData:TERMINAL_TABLE_KIND];
                            
                            [[DatabaseManager sharedInstance] insertData:MERCHANT_TABLE_KIND data:[responseObject objectForKey:@"merchantList"]];
                            [[DatabaseManager sharedInstance] insertData:TERMINAL_TABLE_KIND data:[responseObject objectForKey:@"term_list"]];
                            
                            [self getInfo:@"code"];
                        }
                        else if ([code_type isEqualToString:@"code"]) {
                            NSMutableArray *codeList = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"codeList"]];
                            [[DatabaseManager sharedInstance] deleteData:CODE_TABLE_KIND];
                            [[DatabaseManager sharedInstance] insertDataBulk:CODE_TABLE_KIND data:codeList];
                            
                            [self getInfo:@"item"];
                        }
                        else if ([code_type isEqualToString:@"item"]) {
                            [[DatabaseManager sharedInstance] deleteData:CATEGORY_TABLE_KIND];
                            [[DatabaseManager sharedInstance] insertData:CATEGORY_TABLE_KIND data:[responseObject objectForKey:@"itemList"]];
                            [self getFeeInfo];
                            
                            
                        }
                    }
                    else {
                        [SVProgressHUD dismiss];
                        [self.view makeToast:ERROR_LOGIN];
                    }
                }
                else {
                    [SVProgressHUD dismiss];
                    [self.view makeToast:RESPONSE_ERROR];
                }
            }
            else {
                [SVProgressHUD dismiss];
                [self.view makeToast:NETWORK_ERROR];
            }
        }];
    }
    else {
        kAppDelegate.isOnline = nil;
    }
}

- (void) getFeeInfo {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userId"] = kAppDelegate.LoginID;
    params[@"merchant_no"] =  [CommonFunc getValuesForKey:MERCHANT_NO];
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_MERCHANT_FEE] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            [SVProgressHUD dismiss];
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* resultStatus = [responseObject objectForKey:@"result"];
                    if([resultStatus isEqualToString:@"S"]){
                        [CommonFunc saveUserDefaults:FEE_SETTING_INFO value:responseObject];
                        [self SaveUserList];
                        [CommonFunc saveUserDefaults:LOGIN_SUCCESS value:@"1"];
\
                        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
                            MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
                            UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
                            //----------------------------------------------------------------------------------------------------------------
                            kAppDelegate.LoginID = [[DatabaseManager sharedInstance] readData:USERINFO_TABLE_KIND][0][@"userId"];
                            if (![kAppDelegate.ScreenName isEqualToString:@"OnlineSearch"]) {
                                OnlineSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineSearch"];
                                [navigationController pushViewController:controller animated:NO];
                            }
                            [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
                        }   else {
                            IssueViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Issue"];
                            [self.navigationController pushViewController:controller animated:NO];
                        }
                    }
                    else {
                        [self.view makeToast:ERROR_LOGIN];
                    }
                }
                else {
                    [self.view makeToast:RESPONSE_ERROR];
                }
            }
            else {
                [self.view makeToast:NETWORK_ERROR];
            }
        }];
    }
    else {
        kAppDelegate.isOnline = nil;
    }
}


- (void) SaveUserList {
    NSMutableArray *userList = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:USER_LIST]];
    
    NSMutableDictionary *new_user = [[NSMutableDictionary alloc] init];
    new_user[@"userId"] =    _txtUsername.text;
    new_user[@"passWord"] =  _txtPassword.text; 
    
    for (int i = 0; i < userList.count; i++) {
        if ([userList[i][@"userId"] isEqualToString:new_user[@"userId"]]) {
            [userList removeObjectAtIndex:i];
            break;
        }
    }
    [userList addObject:new_user];
    [CommonFunc saveArrayToLocal:userList key:USER_LIST];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtUsername) {
        _lineUsername.backgroundColor = BlueColor;
    }
    else if (textField == _txtPassword) {
        _linePassword.backgroundColor = BlueColor;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _txtUsername) {
        _lineUsername.backgroundColor = [UIColor blackColor];
        
        _txtPassword.text = @"";
        NSMutableArray *userList = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:USER_LIST]];
        for (int i = 0; i < userList.count; i++) {
            if ([userList[i][@"userId"] isEqualToString:_txtUsername.text]) {
                _txtPassword.text = userList[i][@"passWord"];
            }
        }
    }
    else if (textField == _txtPassword) {
        _linePassword.backgroundColor = [UIColor blackColor];
    }
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
