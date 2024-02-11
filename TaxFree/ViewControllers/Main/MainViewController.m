//
//  MainViewController.m
//  TaxFree
//
//  Created by Smile on 26/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "MainViewController.h"
#import "CommonFunc.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    self.rootViewController = navigationController;

    self.leftViewWidth = kYNPAGE_IS_IPHONE_X ? 194 : 150;
    // Do any additional setup after loading the view.
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
