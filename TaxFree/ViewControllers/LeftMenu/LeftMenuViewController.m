//
//  LeftMenuViewController.m
//  TaxFree
//
//  Created by Smile on 26/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController () 

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lblVersion.text = [NSString stringWithFormat:@"ver %@", [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CheckOnlineStatus) name:@"LGSideMenuWillShowLeftViewNotification" object:nil];
    
    _onlinePointer.layer.cornerRadius = _onlinePointer.frame.size.height / 2.0;
    
    [self SetPointer];
    // Do any additional setup after loading the view.
}

- (void) CheckOnlineStatus {
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
    }
    else {
        kAppDelegate.isOnline = nil;
    }
    [self SetPointer];
}

- (void) SetPointer {
    if (kAppDelegate.isOnline) {
        _onlinePointer.backgroundColor = [UIColor greenColor];
    }
    else {
        _onlinePointer.backgroundColor = [UIColor lightGrayColor];
    }
    
    _lblUsername.text = [NSString stringWithFormat:@"Welcome %@", kAppDelegate.LoginID];
}


- (IBAction)LogoutClick:(id)sender {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"メッセージ" message:@"アプリケーションを終了してもよろしいですか？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"ログアウト" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [CommonFunc saveUserDefaults:LOGIN_SUCCESS value:nil];
        [CommonFunc saveUserDefaults:FEE_SETTING_INFO value:nil];
        MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
        UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
        [navigationController popToRootViewControllerAnimated:NO];
        [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"ログアウトせずに終了" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //[CommonFunc saveUserDefaults:LOGIN_SUCCESS value:nil];
        [[UIApplication sharedApplication] performSelector:@selector(suspend)];
        [NSThread sleepForTimeInterval:2.0];
        exit(0);
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)IssueClick:(id)sender {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    if (![kAppDelegate.ScreenName isEqualToString:@"Issue"]) {
        IssueViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Issue"];
        [navigationController pushViewController:controller animated:NO];
    }
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)SearchClick:(id)sender {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    if (![kAppDelegate.ScreenName isEqualToString:@"Search"]) {
        SearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
        [navigationController pushViewController:controller animated:NO];
    }
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)OnlineSearchClick:(id)sender {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    if (![kAppDelegate.ScreenName isEqualToString:@"OnlineSearch"]) {
        OnlineSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineSearch"];
        [navigationController pushViewController:controller animated:NO];
    }
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)PurchaseLimitClick:(id)sender {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    if (![kAppDelegate.ScreenName isEqualToString:@"PurchaseLimit"]) {
        PurchaseLimitViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PurchaseLimit"];
        [navigationController pushViewController:controller animated:NO];
    }
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

- (IBAction)ConfigClick:(id)sender {
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    if (![kAppDelegate.ScreenName isEqualToString:@"Config"]) {
        ConfigViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Config"];
        [navigationController pushViewController:controller animated:NO];
    }
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
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
