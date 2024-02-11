//
//  OnlineSearchViewController.m
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "OnlineSearchViewController.h"

@interface OnlineSearchViewController (){
    NSString *active_button;
    
    NSMutableArray *TableArray;
    NSMutableDictionary *SelectedSlip;
    
    NSMutableArray *DateTypeList;
    NSMutableDictionary *DateType;
    
    NSMutableArray *RefundStatusList;
    NSMutableDictionary *RefundStatus;
    BOOL isStartDate;
    
    NSDate *StartDate;
    NSDate *EndDate;
    
    NSString* total_cnt;
    NSInteger page_num;
}

@end

@implementation OnlineSearchViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTableView.backgroundColor = [UIColor clearColor];
    kAppDelegate.ScreenName = @"OnlineSearch";
    // Do any additional setup after loading the view.
    [self interfacecConfig];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"OnlineSearcn 의 ViewwillAppear 부분이 실행되고 있습니다..");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(url_PosData:) name:UIApplicationWillEnterForegroundNotification object:nil];
    if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
        NSLog(@"POS 취소 거래 건을 요청하였으므로 이 건을 검색합니다. slip_no:: %@", kAppDelegate.url_gtf_slip_no);
        int milsec = 3600 * 24 * 7;
        NSDate *today = [NSDate date];
        NSDate *BeforeDay = [today dateByAddingTimeInterval:((-1)*(milsec))];
        NSLog(@"7일 이전 날짜: '%@'.", BeforeDay);
        //NSDate *afterDay = [today dateByAddingTimeInterval:milsec]; NSLog(@"7일 이 후 날짜: '%@'.", afterDay);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"yyyy-MM-dd"]; NSString *dateString = [formatter stringFromDate:BeforeDay];
        NSLog(@"7일 이전 날짜스트링: '%@'.", dateString);
        StartDate = BeforeDay;
        EndDate = today;
        _lblStartDate.text = [CommonFunc getDateStringWithFormat:BeforeDay format:@"yyyy-MM-dd"];    //최대 일주일 이전 거래 건까지 조회를 지원한다.
        _lblEndDate.text = [CommonFunc getDateStringWithFormat:EndDate format:@"yyyy-MM-dd"];
        
        _txtSlipNo.text = kAppDelegate.url_gtf_slip_no;
        [self SearchClick:self];
        [_mainTableView reloadData];
    }
}

- (void) url_PosData:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"I"]) && (!kAppDelegate.call_by_url_issued)) {
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
    
    _btnDateType.layer.cornerRadius = _btnDateType.frame.size.height/2;
    _btnDateType.clipsToBounds = YES;
    
    _btnStartDate.layer.cornerRadius = _btnStartDate.frame.size.height/2;
    _btnStartDate.clipsToBounds = YES;
    
    _btnEndDate.layer.cornerRadius = _btnEndDate.frame.size.height/2;
    _btnEndDate.clipsToBounds = YES;
    
    _btnRefundStatus.layer.cornerRadius = _btnRefundStatus.frame.size.height/2;
    _btnRefundStatus.clipsToBounds = YES;
    
    _viewSlipNo.layer.cornerRadius = _viewSlipNo.frame.size.height/2;
    _viewSlipNo.clipsToBounds = YES;
    
    _viewField.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _viewField.layer.shadowOpacity = 0.5;
    _viewField.layer.shadowRadius = 2.0;
    _viewField.layer.cornerRadius = 8;
    
    StartDate = [NSDate date];
    EndDate = [NSDate date];
    
    _lblStartDate.text = [CommonFunc getDateStringWithFormat:StartDate format:@"yyyy-MM-dd"];
    _lblEndDate.text = [CommonFunc getDateStringWithFormat:EndDate format:@"yyyy-MM-dd"];
    
    DateTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"DateType.json"][@"data"]];
    DateType = [[NSMutableDictionary alloc] init];
    DateType = DateTypeList[0];
    _lblDateType.text = DateType[LANGUAGE];
    
    RefundStatusList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"Refund_Status.json"][@"data"]];
    RefundStatus = [[NSMutableDictionary alloc] init];
    RefundStatus = RefundStatusList[0];
    _lblRefundStatus.text = RefundStatus[LANGUAGE];
    
}

- (IBAction)MenuClick:(id)sender {
    [self showLeftViewAnimated:sender];
}

- (IBAction)DateTypeClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < DateTypeList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:DateTypeList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->DateType = self->DateTypeList[i];
            self->_lblDateType.text = self->DateType[LANGUAGE];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    [view show];
    
}

- (IBAction)StartDateClick:(id)sender {
    isStartDate = YES;
    
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    chooseDataPicker.maxDate = EndDate;
    chooseDataPicker.data = StartDate;
    [chooseDataPicker show];
}

- (IBAction)EndDateClick:(id)sender {
    isStartDate = NO;
    
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    chooseDataPicker.maxDate = [NSDate date];
    chooseDataPicker.data = EndDate;
    [chooseDataPicker show];
}

#pragma mark - DatePickerViewDelegate
- (void)finishSelectDate:(NSDate *)date {
    if (date) {
        if (isStartDate) {
            if ([date timeIntervalSince1970] > [EndDate timeIntervalSince1970]) {
                return;
            }
            StartDate = date;
            _lblStartDate.text = [CommonFunc getDateStringWithFormat:StartDate format:@"yyyy-MM-dd"];
        }
        else {
            if ([date timeIntervalSince1970] < [StartDate timeIntervalSince1970]) {
                return;
            }
            EndDate = date;
            _lblEndDate.text = [CommonFunc getDateStringWithFormat:EndDate format:@"yyyy-MM-dd"];
        }
    }
}

- (IBAction)RefundStatusClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < RefundStatusList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:RefundStatusList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->RefundStatus = self->RefundStatusList[i];
            self->_lblRefundStatus.text = self->RefundStatus[LANGUAGE];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    [view show];
}



- (IBAction)SearchClick:(id)sender {
    active_button = @"Search";
//    [self setButtonImages];
    
    [TableArray removeAllObjects];
    [_mainTableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    __weak UITableView *weak_TableView = _mainTableView;
    [weak_TableView addFooterWithCallback:^{
        [weakSelf OnlineSearch];
    }];
    page_num = 1;
    [self getSearchCount];
}

- (void) getSearchCount {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"user_desk_id"] =   [CommonFunc getValuesForKey:DESK_ID];
    params[@"merchant_no"] =  [CommonFunc getValuesForKey:MERCHANT_NO];
    params[@"languageCD"] = LANGUAGE;
    params[@"companyID"] = COMPANY_ID;
    params[@"dateFrom"] = [CommonFunc getDateStringWithFormat:StartDate format:@"yyyy/MM/dd"];
    params[@"dateTo"] = [CommonFunc getDateStringWithFormat:EndDate format:@"yyyy/MM/dd"];
    if (![_txtSlipNo.text isEqualToString:@""]) {
        params[@"slip_no"] = _txtSlipNo.text;
    }
    params[@"dateCond"] = DateType[@"id"];
    params[@"refund_status_code"] = RefundStatus[@"id"];
    if ([RefundStatus[@"id"] isEqualToString:@"ALL"]) {
        params[@"refund_status_code"] = @"";
    }
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [SVProgressHUD show];
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_SERVER_SLIP_COUNT] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            [SVProgressHUD dismiss];
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    self->total_cnt = [responseObject objectForKey:@"total_cnt"];
                    if([self->total_cnt intValue] > 0){
                        [self OnlineSearch];
                    }
                    else {
                        [self.view makeToast:NO_SERACH_DATA];
                        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"])) {
                            NSString *parameter_str;
                            parameter_str = [NSString stringWithFormat:@"%@://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                                         , kAppDelegate.url_scheme_addr, @"F", kAppDelegate.url_issue_status, kAppDelegate.url_rec_no, kAppDelegate.url_gtf_slip_no];
                            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                            kAppDelegate.call_by_url_canceled = FALSE;
                            kAppDelegate.call_by_url_scheme = FALSE;
                            kAppDelegate.call_by_url_issued = FALSE;
                            kAppDelegate.url_rec_no = nil;
                            kAppDelegate.url_gtf_slip_no = nil;
                            kAppDelegate.url_issue_status = nil;
                            NSLog(@"OnlineSearch입니다....%@", parameter_str);
                            _txtSlipNo.text = @"";
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"TestCustomURL://"]];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parameter_str]];
                            });
                        }
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
        [self.view makeToast:NETWORK_FAILED];
    }
}

- (void) OnlineSearch {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"user_desk_id"] =   [CommonFunc getValuesForKey:DESK_ID];
    params[@"merchant_no"] =  [CommonFunc getValuesForKey:MERCHANT_NO];
    params[@"languageCD"] = LANGUAGE;
    params[@"companyID"] = COMPANY_ID;
    params[@"dateFrom"] = [CommonFunc getDateStringWithFormat:StartDate format:@"yyyy/MM/dd"];
    params[@"dateTo"] = [CommonFunc getDateStringWithFormat:EndDate format:@"yyyy/MM/dd"];
    if (![_txtSlipNo.text isEqualToString:@""]) {
        params[@"slip_no"] = _txtSlipNo.text;
    }
    params[@"dateCond"] = DateType[@"id"];
    params[@"refund_status_code"] = RefundStatus[@"id"];
    if ([RefundStatus[@"id"] isEqualToString:@"ALL"]) {
        params[@"refund_status_code"] = @"";
    }
    params[@"pageNum"] = [NSString stringWithFormat:@"%li", (long)page_num];
    params[@"displayNum"] = @"20";
    [SVProgressHUD show];
    [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_SERVER_SLIP] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
        [SVProgressHUD dismiss];
        [self->_mainTableView footerEndRefreshing];
        if(status == ResponseStatusOK) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"list"]];
                if (self->page_num == 1) {
                    self->SelectedSlip = nil;
                    self->TableArray = [[NSMutableArray alloc] init];
                }
                if ([array count] < 20) {
                    [self->_mainTableView removeFooter];
                }
                else {
                    self->page_num++;
                }
                
                [self->TableArray addObjectsFromArray:array];
                /////-----------------------------------------------------------------------
                if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
                    if(self->TableArray.count == 1) {
                        self->SelectedSlip = [[NSMutableDictionary alloc] initWithDictionary:self->TableArray[0]];
                        NSLog(@"SelectedSlip:: %@", self->SelectedSlip);
                        [self CancelClick:self];
                    }
                }
                /////-----------------------------------------------------------------------
                [self->_mainTableView reloadData];
                if(self->TableArray.count == 0){
                    [self.view makeToast:NO_SERACH_DATA];
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


- (IBAction)CancelClick:(id)sender {
    active_button = @"Cancel";
//    [self setButtonImages];

    NSString * alert_msg = @"";
    
    if (SelectedSlip == nil)
    {
        [self.view makeToast:SELECTCANCELSLIP];
        return;
    }
    
    if([SelectedSlip[@"REFUND_STATUS_CODE"] isEqualToString:@"04"])
    {
        [self.view makeToast:ALREADYCANCELREFUND];
        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
            NSString *parameter_str;
            //parameter_str = [NSString stringWithFormat:@"TestCustomURL://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
            parameter_str = [NSString stringWithFormat:@"%@://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                             , kAppDelegate.url_scheme_addr, @"S", kAppDelegate.url_issue_status, kAppDelegate.url_rec_no, kAppDelegate.url_gtf_slip_no];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            kAppDelegate.call_by_url_canceled = YES;
            //다시 호출했던 앱으로 제어가 돌아가도록 한다...................
            kAppDelegate.call_by_url_scheme = FALSE;
            kAppDelegate.call_by_url_issued = FALSE;
            kAppDelegate.url_rec_no = nil;
            kAppDelegate.url_gtf_slip_no = nil;
            NSLog(@"OnlineSearch입니다....%@", parameter_str);
            _txtSlipNo.text = @"";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"TestCustomURL://"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parameter_str]];

            });
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"TestCustomURL://"]];
        }
        return;
    }
    
    if (![SelectedSlip[@"REFUND_WAY_CODE"] isEqualToString:@"01"])
    {
        if (SelectedSlip[@"PROGRESS_STATUS_CODE"])
        {
            alert_msg = [NSString stringWithFormat:@"%@\n", REMMITYETSEND];
        }
        else if ([SelectedSlip[@"PROGRESS_STATUS_CODE"] isEqualToString:@"99"])
        {
            alert_msg = [NSString stringWithFormat:@"%@\n", REMMITSENDCOM];
        }
        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
            NSString *parameter_str;
            //parameter_str = [NSString stringWithFormat:@"TestCustomURL://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
            parameter_str = [NSString stringWithFormat:@"%@://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                             , kAppDelegate.url_scheme_addr, @"S", kAppDelegate.url_issue_status, kAppDelegate.url_rec_no, kAppDelegate.url_gtf_slip_no];
            NSLog(@"UploadSlipList입니다....222%@", parameter_str);
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            kAppDelegate.call_by_url_canceled = TRUE;
            //다시 호출했던 앱으로 제어가 돌아가도록 한다...................
            kAppDelegate.call_by_url_scheme = FALSE;
            kAppDelegate.url_gtf_slip_no = nil;
            kAppDelegate.url_rec_no = nil;
            kAppDelegate.call_by_url_canceled = TRUE;
            kAppDelegate.call_by_url_issued = FALSE;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"TestCustomURL://"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parameter_str]];
            });
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"TestCustomURL://"]];
        }
    }
    
    if (SelectedSlip[@"TOTAL_SLIPSEQ"])
    {
        alert_msg = [NSString stringWithFormat:@"%@%@\n%@", alert_msg, TOTAL_SLIP_ISSUED, CANCELREQUEST];

        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:alert_msg preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertView dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIAlertController *alertView2 = [UIAlertController alertControllerWithTitle:nil message:TOTALSLIPALLCANCEL preferredStyle:UIAlertControllerStyleAlert];
            
            [alertView2 addAction:[UIAlertAction actionWithTitle:ALERT_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertView2 dismissViewControllerAnimated:YES completion:nil];                
                [self Cancel:self->SelectedSlip[@"SLIP_NO"] TotalSlipNo:self->SelectedSlip[@"TOTAL_SLIPSEQ"]];
            }]];
            
            [alertView2 addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self CancelAll:self->SelectedSlip[@"SLIP_NO"] TotalSlipNo:self->SelectedSlip[@"TOTAL_SLIPSEQ"]];
            }]];
            [self presentViewController:alertView2 animated:YES completion:nil];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else
    {
        alert_msg = [NSString stringWithFormat:@"[%@] %@", SelectedSlip[@"SLIP_NO"], CANCELREQUEST];

        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:alert_msg preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertView dismissViewControllerAnimated:YES completion:nil];
            
            
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self Cancel:self->SelectedSlip[@"SLIP_NO"] TotalSlipNo:self->SelectedSlip[@"TOTAL_SLIPSEQ"]];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void) Cancel:(NSString *)SlipNo TotalSlipNo:(NSString *)TotalSlipNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userID"] =   kAppDelegate.LoginID;
    params[@"slip_no"] = SlipNo;
    params[@"totalSlipSeq"] = @"";
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [SVProgressHUD show];
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_CANCEL] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            [SVProgressHUD dismiss];
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* resultStatus = [responseObject objectForKey:@"result"];
                    if([resultStatus isEqualToString:@"S"]){
                        [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"03" conditionField:SLIP_NO conditionValue:SlipNo];
                        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
                            NSString *parameter_str;
                            //parameter_str = [NSString stringWithFormat:@"TestCustomURL://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                            parameter_str = [NSString stringWithFormat:@"%@://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                                             , kAppDelegate.url_scheme_addr, @"S", kAppDelegate.url_issue_status, kAppDelegate.url_rec_no, kAppDelegate.url_gtf_slip_no];
                            kAppDelegate.call_by_url_scheme = FALSE;
                            kAppDelegate.url_rec_no = nil;
                            kAppDelegate.url_gtf_slip_no = nil;
                            kAppDelegate.call_by_url_canceled = TRUE;
                            kAppDelegate.call_by_url_issued = FALSE;
                            NSLog(@"UploadSlipList입니다....3333%@", parameter_str);
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"TestCustomURL://"]];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parameter_str]];
                            });
                        }
                        [self.view makeToast:REFUNDCANCELCOM];
                        self->page_num = 1;
                        [self OnlineSearch];
                    }
                    else {
                        [self.view makeToast:REFUNDCANCELFAIL];
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
        [self.view makeToast:NETWORK_FAILED];
    }
}

- (void) CancelAll:(NSString *)SlipNo TotalSlipNo:(NSString *)TotalSlipNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userID"] =   kAppDelegate.LoginID;
    params[@"slip_no"] = SlipNo;
    params[@"totalSlipSeq"] = TotalSlipNo;
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [SVProgressHUD show];
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_CANCEL_ALL] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            [SVProgressHUD dismiss];
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* resultStatus = [responseObject objectForKey:@"result"];
                    if([resultStatus isEqualToString:@"S"]){
                        [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"03" conditionField:SLIP_NO conditionValue:SlipNo];
                        [self.view makeToast:REFUNDCANCELCOM];
                        self->page_num = 1;
                        [self OnlineSearch];
                    }
                    else {
                        [self.view makeToast:REFUNDCANCELFAIL];
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
        [self.view makeToast:NETWORK_FAILED];
    }
}

- (void) setButtonImages {
    if ([active_button isEqualToString:@"Search"]) {
        [_btnSearch setImage:[UIImage imageNamed:@"search_btn_active.png"] forState:UIControlStateNormal];
        [_btnCancel setImage:[UIImage imageNamed:@"cancel_online_btn.png"] forState:UIControlStateNormal];
    }
    else {
        [_btnSearch setImage:[UIImage imageNamed:@"search_btn.png"] forState:UIControlStateNormal];
        [_btnCancel setImage:[UIImage imageNamed:@"cancel_online_active.png"] forState:UIControlStateNormal];
    }
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
    OnlineSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.row%2 == 0) {
        cell.colorView.backgroundColor = LightOrangeColor;
    }
    else {
        cell.colorView.backgroundColor = [UIColor whiteColor];
    }
    
    NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
    cell.lblNo.text = [NSString stringWithFormat:@"%li", [total_cnt integerValue] - indexPath.row];
    cell.lblSlipNo.text = ItemInfo[@"SLIP_NO"];
    cell.lblRctNo.text = ItemInfo[@"REC_NO"];
    cell.lblSaleDate.text = ItemInfo[@"SALEDT"];
    cell.lblShopName.text = ItemInfo[@"MERCHANT_JPNM"];
    
    cell.lblExcommBuy.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"TOTAL_EXCOMM_SALE_AMT"]]];    
    cell.lblExcommTax.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"TOTAL_EXCOMM_TAX_AMT"]]];
    cell.lblExcommRefund.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"TOTAL_EXCOMM_REFUND_AMT"]]];
    cell.lblCommBuy.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"TOTAL_COMM_SALE_AMT"]]];
    cell.lblCommTax.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"TOTAL_COMM_TAX_AMT"]]];
    cell.lblCommRefund.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"TOTAL_COMM_REFUND_AMT"]]];
    
    cell.lblExcommBuy.text = [cell.lblExcommBuy.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.lblExcommTax.text = [cell.lblExcommTax.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.lblExcommRefund.text = [cell.lblExcommRefund.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.lblCommBuy.text = [cell.lblCommBuy.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.lblCommTax.text = [cell.lblCommTax.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.lblCommRefund.text = [cell.lblCommRefund.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cell.lblRefundState.text = [NSString stringWithFormat:@"%@", ItemInfo[@"REFUND_STATUS_CODE_DESC"]];
    
    if ([ItemInfo[@"SEND_FLAG"] isEqualToString:@"0"]) {
        cell.lblSendFlag.text = @"送信前";
    }
    else if ([ItemInfo[@"SEND_FLAG"] isEqualToString:@"1"]) {
        cell.lblSendFlag.text = @"送信開始";
    }
    else if ([ItemInfo[@"SEND_FLAG"] isEqualToString:@"2"]) {
        cell.lblSendFlag.text = @"送信完了";
    }
    else if ([ItemInfo[@"SEND_FLAG"] isEqualToString:@"3"]) {
        cell.lblSendFlag.text = @"送信失敗";
    }
    else {
        cell.lblSendFlag.text = ItemInfo[@"SEND_FLAG"];
    }
    
    cell.btnCheck.tag = indexPath.row;
    [cell.btnCheck addTarget:self action:@selector(cellCheckClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"ic_uncheck.png"] forState:UIControlStateNormal];
    if (SelectedSlip) {
        if ([SelectedSlip[@"SLIP_NO"] isEqualToString:ItemInfo[@"SLIP_NO"]]) {
            [cell.btnCheck setBackgroundImage:[UIImage imageNamed:@"ic_check.png"] forState:UIControlStateNormal];
        }
    }

    
//    GRD_SLIP[11, i].Value = tempObj["REFUND_STATUS_CODE_DESC"].ToString();
//    GRD_SLIP[12, i].Value = tempObj["TOTAL_SLIPSEQ"].ToString();
//    GRD_SLIP[13, i].Value = tempObj["WORKERID"].ToString();
//    GRD_SLIP[14, i].Value = Int64.Parse(tempObj["RETRY_CNT"].ToString());
//    GRD_SLIP[15, i].Value = tempObj["REFUND_STATUS_CODE"].ToString();
//    GRD_SLIP[16, i].Value = tempObj["REFUND_WAY_CODE"].ToString();
//    GRD_SLIP[17, i].Value = tempObj["PROGRESS_STATUS_CODE"].ToString();
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
    
    SearchDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchDetail"];
    controller.SlipNo = ItemInfo[@"SLIP_NO"];
    controller.isOnline = @"1";
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) cellCheckClick:(id) sender {
    UIButton *button = (UIButton *)sender;
    
    if (SelectedSlip) {
        if ([SelectedSlip[@"SLIP_NO"] isEqualToString:TableArray[button.tag][@"SLIP_NO"]]) {
            SelectedSlip = nil;
        }
        else {
            SelectedSlip = [[NSMutableDictionary alloc] initWithDictionary:TableArray[button.tag]];
        }
    }
    else {
        SelectedSlip = [[NSMutableDictionary alloc] initWithDictionary:TableArray[button.tag]];
    }
    [_mainTableView reloadData];
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
