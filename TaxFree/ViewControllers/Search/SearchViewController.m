//
//  SearchViewController.m
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
{
    NSString *active_button;
    NSDate *selectedDate;
    
    NSMutableArray *RefundStatusList;
    NSMutableArray *SendList;
    
    NSMutableDictionary *RefundStatus;
    NSMutableDictionary *Send;
    
    NSMutableArray *TableArray;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTableView.backgroundColor = [UIColor clearColor];
    kAppDelegate.ScreenName = @"Search";
    // Do any additional setup after loading the view.
    [self interfacecConfig];
}

- (void) call_PosData:(NSNotification *)notification {
    
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

- (void) interfacecConfig {
    active_button = @"Search";
    
    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    
    _btnRefundDate.layer.cornerRadius = _btnRefundDate.frame.size.height/2;
    _btnRefundDate.clipsToBounds = YES;
    
    _btnRefundStatus.layer.cornerRadius = _btnRefundStatus.frame.size.height/2;
    _btnRefundStatus.clipsToBounds = YES;
    
    _btnSend.layer.cornerRadius = _btnSend.frame.size.height/2;
    _btnSend.clipsToBounds = YES;
    
    _viewSlipNo.layer.cornerRadius = _viewSlipNo.frame.size.height/2;
    _viewSlipNo.clipsToBounds = YES;
    
    _viewField.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _viewField.layer.shadowOpacity = 0.5;
    _viewField.layer.shadowRadius = 2.0;
    _viewField.layer.cornerRadius = 8;
    
    selectedDate = [NSDate date];
    _lblRefundDate.text = [CommonFunc getDateStringWithFormat:selectedDate format:@"yyyy-MM-dd"];
    
    RefundStatusList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"Refund_Status.json"][@"data"]];
    RefundStatus = [[NSMutableDictionary alloc] init];
    RefundStatus = RefundStatusList[0];
    _lblRefundStatus.text = RefundStatus[LANGUAGE];
    
    SendList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"Send.json"][@"data"]];
    Send = [[NSMutableDictionary alloc] init];
    Send = SendList[0];
    _lblSend.text = Send[LANGUAGE];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(call_PosData:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self Search];
}


- (IBAction)MenuClick:(id)sender {
    [self showLeftViewAnimated:sender];
}

- (IBAction)RefundDateClick:(id)sender {
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    chooseDataPicker.maxDate = [NSDate date];
    chooseDataPicker.data = selectedDate;
    [chooseDataPicker show];
}

#pragma mark - DatePickerViewDelegate
- (void)finishSelectDate:(NSDate *)date {
    if (date) {
        selectedDate = date;
        _lblRefundDate.text = [CommonFunc getDateStringWithFormat:selectedDate format:@"yyyy-MM-dd"];
        [self Search];
    }
}

- (IBAction)RefundStatusClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < RefundStatusList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:RefundStatusList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->RefundStatus = self->RefundStatusList[i];
            self->_lblRefundStatus.text = self->RefundStatus[LANGUAGE];
            [self Search];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    [view show];
}

- (IBAction)SendClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < SendList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:SendList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->Send = self->SendList[i];
            self->_lblSend.text = self->Send[LANGUAGE];
            [self Search];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    [view show];
}

- (IBAction)SearchClick:(id)sender {
    active_button = @"Search";
    
    [self Search];
}

- (void) Search {
    NSString *strSearchDate = [CommonFunc getDateStringWithFormat:selectedDate format:@"yyyyMMdd"];
    NSString *strSendFlag = Send[@"id"];
    NSString *strSlipStatus = RefundStatus[@"id"];
    
    TableArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[CommonFunc SearchSlips:strSearchDate strEndDate:strSearchDate strSendFlag:strSendFlag strSlipStatus:strSlipStatus strSlipNo:_txtSlipNo.text]];
    for (int i = 0; i < tempArray.count; i++) {
        [TableArray insertObject:tempArray[i] atIndex:0];
    }
    
    if (TableArray.count == 0)
    {
        [self.view makeToast:NO_SERACH_DATA];
    }
    [_mainTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return TableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.row%2 == 0) {
        cell.colorView.backgroundColor = LightOrangeColor;
    }
    else {
        cell.colorView.backgroundColor = [UIColor whiteColor];
    }
    
    NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
    
    cell.lblNo.text = [NSString stringWithFormat:@"%lu", TableArray.count - indexPath.row];
    cell.lblSlipNo.text = ItemInfo[@"SLIP_NO"];
    
    NSMutableDictionary *RCTinfo = [CommonFunc getRCTInfo:ItemInfo[@"SLIP_NO"]];
    if (RCTinfo) {
        cell.lblRctNo.text = RCTinfo[@"RCT_NO"];
    }
    for (int i = 0; i < SendList.count; i++) {
        if ([ItemInfo[@"SEND_FLAG"] isEqualToString:SendList[i][@"id"]]) {
            cell.lblSend.text = SendList[i][LANGUAGE];
        }
    }
    cell.lblSaleDate.text = ItemInfo[@"SALEDT"];
    cell.lblShopName.text = ItemInfo[@"SHOP_NAME"];
    cell.lblGoodsBuyAmt.text = [CommonFunc getCommaString:ItemInfo[@"GOODS_BUY_AMT"]];
    cell.lblGRefundAmt.text = [CommonFunc getCommaString:ItemInfo[@"GOODS_REFUND_AMT"]];
    cell.lblGTaxAmt.text = [CommonFunc getCommaString:ItemInfo[@"GOODS_TAX_AMT"]];
    cell.lblConBuyAmt.text = [CommonFunc getCommaString:ItemInfo[@"CONSUMS_BUY_AMT"]];
    cell.lblConRefundAmt.text = [CommonFunc getCommaString:ItemInfo[@"CONSUMS_REFUND_AMT"]];
    cell.lblConTaxAmt.text = [CommonFunc getCommaString:ItemInfo[@"CONSUMS_TAX_AMT"]];
    
    for (int i = 0; i < RefundStatusList.count; i++) {
        if ([ItemInfo[@"SLIP_STATUS_CODE"] isEqualToString:RefundStatusList[i][@"id"]]) {
            cell.lblRefundState.text = RefundStatusList[i][LANGUAGE];
        }
    }
    cell.lblPrintCount.text = ItemInfo[@"PRINT_CNT"];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
    
    SearchDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDetail"];
    controller.SlipNo = ItemInfo[@"SLIP_NO"];
    [self.navigationController pushViewController:controller animated:YES];
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
