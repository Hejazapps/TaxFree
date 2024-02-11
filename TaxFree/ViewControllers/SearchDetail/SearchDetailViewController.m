//
//  SearchDetailViewController.m
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "SearchDetailViewController.h"

@interface SearchDetailViewController ()
{
    NSMutableArray *SexList;
    NSMutableArray *RefundStatusList;
    NSMutableArray *SlipStatusList;
    NSMutableArray *RefundTypeList;
    
    NSMutableArray *TableArray;
    
    NSMutableDictionary *OnlineSlip;
    NSMutableArray* OnlineSlipList;
    NSMutableArray* OnlineGoodsList;
    
    Epos2FilterOption *filteroption_;
    Epos2Printer *printer_;
    int printerSeries_;
    int lang_;
    
    NSMutableDictionary *SlipDoc;
    
    NSMutableDictionary *MapDocid;
    NSMutableDictionary *MapRetailer;
    NSMutableDictionary *MapGoods;
    NSMutableDictionary *MapTourist;
    UIImage *signImage;
    
    NSInteger LanguageNo;
    NSMutableDictionary *configInfo;
    NSMutableDictionary *ShopInfo;
    NSString *myMemoText;
    BOOL isRepublish;
}
@end

@implementation SearchDetailViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        filteroption_  = [[Epos2FilterOption alloc] init];
        [filteroption_ setDeviceType:EPOS2_TYPE_PRINTER];
        printer_ = nil;
        printerSeries_ = EPOS2_TM_M30;
        lang_ = EPOS2_MODEL_ANK;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myMemoText = @"";
    _mainTableView.backgroundColor = [UIColor clearColor];
    [self interfaceConfig];
    
    if (_isOnline) {
        _mainScrollView.hidden = YES;
        _lblScreenTitle.text = @"取引リストに戻る";
        [self getOnlineDetailInfo];
    }
    else {
        [self getDetailInfo];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateSlip:) name:@"PrintNotification" object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PrintNotification" object:nil];
}

- (void) interfaceConfig {
    _viewTable.layer.cornerRadius = 8;
    _viewTable.layer.borderColor = [UIColor blackColor].CGColor;
    _viewTable.layer.borderWidth = 1;
    _viewTable.clipsToBounds = YES;
    
    _viewField.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _viewField.layer.shadowOpacity = 0.5;
    _viewField.layer.shadowRadius = 2.0;
    _viewField.layer.cornerRadius = 8;
    
    _mainScrollView.contentSize = CGSizeMake(100, 625);
    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    SexList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"Sex.json"][@"data"]];
    RefundStatusList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"Refund_Status.json"][@"data"]];
    SlipStatusList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"SlipStatus.json"][@"data"]];
    RefundTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"RefundType.json"][@"data"]];
    
    configInfo = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getValuesForKey:CONFIG_INFO]];
    
    NSMutableArray *merchantList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:MERCHANT_TABLE_KIND]];
    if (merchantList.count > 0) {
        ShopInfo = [[NSMutableDictionary alloc] initWithDictionary:merchantList[0]];
    }
    
    NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
    BOOL isFeeYN = NO;
    if (feeSettingInfo) {
        isFeeYN = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
    }
    _viewRealPayAmt.hidden = !isFeeYN;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    int result = [Epos2Discovery start:filteroption_ delegate:self];
    if (EPOS2_SUCCESS != result) {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    int result = EPOS2_SUCCESS;
    while (YES) {
        result = [Epos2Discovery stop];
        if (result != EPOS2_ERR_PROCESSING) {
            break;
        }
    }
}

- (void)dealloc
{
    filteroption_ = nil;
}

- (void) onDiscovery:(Epos2DeviceInfo *)deviceInfo
{
    NSString *printer_target = [deviceInfo getTarget];
    if (printer_target) {
        [CommonFunc saveUserDefaults:PRINTER_TARGET value:printer_target];
    }
}

- (void)restartDiscovery
{
    int result = EPOS2_SUCCESS;
    
    while (YES) {
        result = [Epos2Discovery stop];
        
        if (result != EPOS2_ERR_PROCESSING) {
            if (result == EPOS2_SUCCESS) {
                break;
            }
            else {
                return;
            }
        }
    }
    
    result = [Epos2Discovery start:filteroption_ delegate:self];
    if (result != EPOS2_SUCCESS) {
        
    }
}

- (BOOL)runPrintReceiptSequence
{
    if (![self initializeObject]) {
        return NO;
    }
    
    NSMutableArray *PublishTypeList = MapDocid[@"PublishType"];
    for (NSString *Type in PublishTypeList) {
        if (![self eventPrintDoc:Type isGoods:@"1"]) {
            [self finalizeObject];
            return NO;
        }
    }
    if (![self printData]) {
        [self finalizeObject];
        return NO;
    }
    return YES;
}

- (BOOL)runPrintNoReceiptSequence
{
    if (![self initializeObject]) {
        return NO;
    }
    
    NSMutableArray *PublishTypeList = MapDocid[@"PublishType"];
    for (NSString *Type in PublishTypeList) {
        if (![self eventPrintDoc:Type isGoods:@"0"]) {
            [self finalizeObject];
            return NO;
        }
    }
    if (![self printData]) {
        [self finalizeObject];
        return NO;
    }
    return YES;
}

- (void)updateButtonState:(BOOL)state {
    _btnRefund.enabled = state;
}

- (BOOL)initializeObject {
    printer_ = [[Epos2Printer alloc] initWithPrinterSeries:printerSeries_ lang:lang_];
    if (printer_ == nil) {
        //        [ShowMsg showErrorEpos:EPOS2_ERR_PARAM method:@"initiWithPrinterSeries"];
        return NO;
    }
    [printer_ setReceiveEventDelegate:self];
    return YES;
}

- (BOOL)printData
{
    int result = EPOS2_SUCCESS;
    Epos2PrinterStatusInfo *status = nil;
    
    if (printer_ == nil) {
        return NO;
    }
    
    if (![self connectPrinter]) {
        return NO;
    }
    
    status = [printer_ getStatus];
    [self dispPrinterWarnings:status];
    
    if (![self isPrintable:status]) {
        //        [ShowMsg show:[self makeErrorMessage:status]];
        [printer_ disconnect];
        return NO;
    }
    
    result = [printer_ sendData:EPOS2_PARAM_DEFAULT];
    if (result != EPOS2_SUCCESS) {
        //        [ShowMsg showErrorEpos:result method:@"sendData"];
        [printer_ disconnect];
        return NO;
    }
    
    return YES;
}

- (void)finalizeObject
{
    if (printer_ == nil) {
        return;
    }
    [printer_ clearCommandBuffer];
    [printer_ setReceiveEventDelegate:nil];
    
    printer_ = nil;
}

- (BOOL) connectPrinter
{
    int result = EPOS2_SUCCESS;
    
    if (printer_ == nil) {
        return NO;
    }
    
    if ([CommonFunc getValuesForKey:PRINTER_TARGET]) {   //  @"BT:00:01:90:B9:20:DF";
        NSString *printer_target = (NSString *)[CommonFunc getValuesForKey:PRINTER_TARGET];
        result = [printer_ connect:printer_target timeout:EPOS2_PARAM_DEFAULT];
        if (result != EPOS2_SUCCESS) {
            return NO;
        }
    }
    else {
        [self restartDiscovery];
        return NO;
    }
    
    result = [printer_ beginTransaction];
    if (result != EPOS2_SUCCESS) {
        //        [ShowMsg showErrorEpos:result method:@"beginTransaction"];
        [printer_ disconnect];
        return NO;
    }
    
    return YES;
}

- (void)disconnectPrinter
{
    int result = EPOS2_SUCCESS;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (printer_ == nil) {
        return;
    }
    
    result = [printer_ endTransaction];
    if (result != EPOS2_SUCCESS) {
        [dict setObject:[NSNumber numberWithInt:result] forKey:KEY_RESULT];
        [dict setObject:@"endTransaction" forKey:KEY_METHOD];
        [self performSelectorOnMainThread:@selector(showEposErrorFromThread:) withObject:dict waitUntilDone:NO];
    }
    
    result = [printer_ disconnect];
    if (result != EPOS2_SUCCESS) {
        [dict setObject:[NSNumber numberWithInt:result] forKey:KEY_RESULT];
        [dict setObject:@"disconnect" forKey:KEY_METHOD];
        [self performSelectorOnMainThread:@selector(showEposErrorFromThread:) withObject:dict waitUntilDone:NO];
    }
    [self finalizeObject];
}

- (void)showEposErrorFromThread:(NSDictionary *)dict
{
    int result = EPOS2_SUCCESS;
    NSString *method = @"";
    result = [[dict valueForKey:KEY_RESULT] intValue];
    method = [dict valueForKey:KEY_METHOD];
    //    [ShowMsg showErrorEpos:result method:method];
}

- (BOOL)isPrintable:(Epos2PrinterStatusInfo *)status
{
    if (status == nil) {
        return NO;
    }
    
    if (status.connection == EPOS2_FALSE) {
        return NO;
    }
    else if (status.online == EPOS2_FALSE) {
        return NO;
    }
    else {
        ;//print available
    }
    
    return YES;
}

- (void) onPtrReceive:(Epos2Printer *)printerObj code:(int)code status:(Epos2PrinterStatusInfo *)status printJobId:(NSString *)printJobId
{
    //    [ShowMsg showResult:code errMsg:[self makeErrorMessage:status]];
    
    [self dispPrinterWarnings:status];
    [self updateButtonState:YES];
    [self performSelectorInBackground:@selector(disconnectPrinter) withObject:nil];
}

- (void)dispPrinterWarnings:(Epos2PrinterStatusInfo *)status
{
    NSMutableString *warningMsg = [[NSMutableString alloc] init];
    
    if (status == nil) {
        return;
    }
    
    if (status.paper == EPOS2_PAPER_NEAR_END) {
        [warningMsg appendString:@"Roll paper is nearly end.\n"];
    }
    
    if (status.batteryLevel == EPOS2_BATTERY_LEVEL_1) {
        [warningMsg appendString:@"Battery level of printer is low.\n"];
    }
}


- (void) getDetailInfo {
    
    NSMutableArray *arrRetSlip = [[NSMutableArray alloc] initWithArray:[CommonFunc SearchSlips:nil strEndDate:nil strSendFlag:@"" strSlipStatus:@"" strSlipNo:_SlipNo]];
    
    if (arrRetSlip.count > 0) {
        NSMutableDictionary *tempObj = arrRetSlip[0];
        
        _lblBuyerName1.text = tempObj[@"BUYER_NAME"];
        myMemoText = tempObj[@"MEMO_TEXT"];
        
         
        [_mainTableView reloadData];
        
        
        
        NSString *BuyerNo = @"";
        if (![tempObj[@"PASSPORT_SERIAL_NO"] isEqualToString:@""]) {
            BuyerNo = tempObj[@"PASSPORT_SERIAL_NO"];
        }
        else {
            BuyerNo = tempObj[@"PERMIT_NO"];
        }
        _lblBuyerNo.text = BuyerNo;
        _lblNationality1.text = tempObj[@"NATIONALITY_NAME"];
        
        for (int i = 0; i < SexList.count; i++) {
            if ([SexList[i][@"id"] isEqualToString:tempObj[@"GENDER_CODE"]]) {
                _lblSex.text = SexList[i][LANGUAGE];
            }
        }
        
        _lblDOB.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:tempObj[@"BUYER_BIRTH"] format:@"yyyyMMdd"] format:@"yyyy.MM.dd"];
        _lblExpiry.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:tempObj[@"PASS_EXPIRYDT"] format:@"yyyyMMdd"] format:@"yyyy.MM.dd"];
        _lblDateLanding.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:tempObj[@"ENTRYDT"] format:@"yyyyMMdd"] format:@"yyyy.MM.dd"];
        
        _lblResidence1.text = tempObj[@"RESIDENCE"];
        _lblPassportType1.text = tempObj[@"PASSPORT_TYPE_NAME"];
        
        _lblSlipNo.text = tempObj[@"SLIP_NO"];
        
        for (int i = 0; i < SlipStatusList.count; i++) {
            if ([SlipStatusList[i][@"id"] isEqualToString:tempObj[@"SLIP_STATUS_CODE"]]) {
                _lblSlipStatus.text = SlipStatusList[i][LANGUAGE];
            }
        }
        for (int i = 0; i < RefundStatusList.count; i++) {
            if ([RefundStatusList[i][@"id"] isEqualToString:tempObj[@"SLIP_STATUS_CODE"]]) {
                _lblRefundStatus.text = RefundStatusList[i][LANGUAGE];
            }
        }
        
        _lblRefundDate.text = tempObj[@"SALEDT"];
        
        if ([tempObj[@"SLIP_STATUS_CODE"] isEqualToString:@"02"]) {
            _lblRefund.text = tempObj[@"REFUNDDT"];
            _btnEditRefund.hidden = YES;
        }
        else {
            _btnEditRefund.hidden = NO;
        }
        //        else
        //        {
        //            if (tempObj[@"REG_DTM"] != nil && ![tempObj[@"REG_DTM"] isEqualToString:[CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"]])
        //            {
        //                _btnRefund.hidden = YES;
        //            }
        //        }
        
        for (int i = 0; i < RefundTypeList.count; i++) {
            if ([RefundTypeList[i][@"id"] isEqualToString:tempObj[@"REFUND_WAY_CODE"]]) {
                _lblPayMethod.text = RefundTypeList[i][LANGUAGE];
            }
        }
        
        _lblUser.text = tempObj[@"USERID"];
        
        _lblGoodsBuyAmt.text = [CommonFunc getCommaString:tempObj[@"GOODS_BUY_AMT"]];
        _lblGoodsTaxAmt.text = [CommonFunc getCommaString:tempObj[@"GOODS_TAX_AMT"]];
        _lblGoodsFeeAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [tempObj[@"GOODS_TAX_AMT"] intValue] - [tempObj[@"GOODS_REFUND_AMT"] intValue]]];
        _lblGoodsRefundAmt.text = [CommonFunc getCommaString:tempObj[@"GOODS_REFUND_AMT"]];
        
        _lblConsumBuyAmt.text = [CommonFunc getCommaString:tempObj[@"CONSUMS_BUY_AMT"]];
        _lblConsumTaxAmt.text = [CommonFunc getCommaString:tempObj[@"CONSUMS_TAX_AMT"]];
        _lblConsumFeeAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [tempObj[@"CONSUMS_TAX_AMT"] intValue] - [tempObj[@"CONSUMS_REFUND_AMT"] intValue]]];
        _lblConsumRefundAmt.text = [CommonFunc getCommaString:tempObj[@"CONSUMS_REFUND_AMT"]];
        
        _lblTotalBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [tempObj[@"GOODS_BUY_AMT"] intValue] + [tempObj[@"CONSUMS_BUY_AMT"] intValue]]];
        _lblTotalTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [tempObj[@"GOODS_TAX_AMT"] intValue] + [tempObj[@"CONSUMS_TAX_AMT"] intValue]]];
        _lblTotalFeeAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [[_lblGoodsFeeAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] + [[_lblConsumFeeAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]]];
        _lblTotalRefundAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [tempObj[@"GOODS_REFUND_AMT"] intValue] + [tempObj[@"CONSUMS_REFUND_AMT"] intValue]]];
        
    }
    
    TableArray = [[NSMutableArray alloc] initWithArray:[CommonFunc SearchSlipDetail:_SlipNo]];
    
    [self FilterTableArray];
    [_mainTableView reloadData];
}

- (void) FilterTableArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    NSString *sortKey = @"ITEM_NO";
    NSString *itemTypeKey = @"ITEM_TYPE";
    if (_isOnline) {
        sortKey = @"SALE_SEQ";
        itemTypeKey = @"ITEM_CODE";
    }
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES comparator:^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray * sortedArray = [NSMutableArray arrayWithArray:[TableArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
    
    for (int i = 0; i < sortedArray.count; i++) {
        if ([sortedArray[i][itemTypeKey] isEqualToString:@"A0001"]) {
            [tempArray addObject:sortedArray[i]];
        }
    }
    for (int i = 0; i < sortedArray.count; i++) {
        if ([sortedArray[i][itemTypeKey] isEqualToString:@"A0002"]) {
            [tempArray addObject:sortedArray[i]];
        }
    }
    
    TableArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    int real_pay_amt = 0;
    for (int i = 0; i < TableArray.count; i++) {
        if (_isOnline) {
            real_pay_amt += [TableArray[i][@"GOODS_AMT"] intValue] + [TableArray[i][@"FEE_AMT"] intValue];
        }
        else {
            real_pay_amt += [TableArray[i][@"BUY_AMT"] intValue] + [TableArray[i][@"FEE_AMT"] intValue];
            if ([TableArray[i][@"TAX_TYPE"] isEqualToString:@"02"]) {
                real_pay_amt -= [TableArray[i][@"TAX_AMT"] intValue];
            }
        }
    }
    _lblRealPayAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", real_pay_amt]];
}


- (void) getOnlineDetailInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"languageCD"] = LANGUAGE;
    params[@"companyID"] = COMPANY_ID;
    params[@"slip_no"] = _SlipNo;
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [SVProgressHUD show];
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_SERVER_SLIP_DETAIL] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            [SVProgressHUD dismiss];
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    self->OnlineSlipList = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"list"]];
                    if(self->OnlineSlipList.count > 0){
                        [self showOnlineSlipDetail];
                        if([self->configInfo[@"receipt_add"] isEqualToString:@"YES"]) {
                            [self getSlipGoods];
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

- (void) getSlipGoods {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"languageCD"] = LANGUAGE;
    params[@"companyID"] = COMPANY_ID;
    params[@"slip_no"] = _SlipNo;
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        [SVProgressHUD show];
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_SERVER_SLIP_GOODS_DETAIL] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            [SVProgressHUD dismiss];
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    self->TableArray = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"list"]];
                    [self FilterTableArray];
                    [self->_mainTableView reloadData];
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

- (void) showOnlineSlipDetail {
    _mainScrollView.hidden = NO;
    
    OnlineSlip = OnlineSlipList[0];
    _lblBuyerName1.text = OnlineSlip[@"BUYER_NAME"];
    _showMemoLabel.text = OnlineSlip[@"MEMO_TEXT"];
    NSString *BuyerNo = @"";
    if (OnlineSlip[@"PASSPORT_SERIAL_NO"] && ([OnlineSlip[@"PASSPORT_SERIAL_NO"] length] > 0) ) {
        BuyerNo = OnlineSlip[@"PASSPORT_SERIAL_NO"];
    }
    else {
        BuyerNo = OnlineSlip[@"PERMIT_NO"];
    }
    _lblBuyerNo.text = BuyerNo;
    _lblNationality1.text = OnlineSlip[@"NATIONALITY_NAME"];
    
    for (int i = 0; i < SexList.count; i++) {
        if ([SexList[i][@"id"] isEqualToString:OnlineSlip[@"GENDER_CODE"]]) {
            _lblSex.text = SexList[i][LANGUAGE];
        }
    }
    
    _lblDOB.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:OnlineSlip[@"BUYER_BIRTH"] format:@"yyyyMMdd"] format:@"yyyy.MM.dd"];
    _lblExpiry.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:OnlineSlip[@"PASS_EXPIRYDT"] format:@"yyyyMMdd"] format:@"yyyy.MM.dd"];
    _lblDateLanding.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:OnlineSlip[@"ENTRYDT"] format:@"yyyyMMdd"] format:@"yyyy.MM.dd"];
    
    _lblResidence1.text = OnlineSlip[@"RESIDENCE_NAME"];
    _lblPassportType1.text = OnlineSlip[@"PASSPORT_TYPE"];
    
    
    _lblSlipNo.text = OnlineSlip[@"SLIP_NO"];
    _lblRctNo.text = OnlineSlip[@"TOTAL_SLIPSEQ"];
    
    _lblSlipStatus.text = OnlineSlip[@"SLIP_STATUS_CODE"];
    _lblRefundStatus.text = OnlineSlip[@"REFUND_STATUS_CODE"];
    
    _lblRefundDate.text = OnlineSlip[@"SALEDT"];
    
    
    if ([OnlineSlip[@"PUBLISH_STATUS"] isEqualToString:@"02"])
        {
        _lblRefund.text = OnlineSlip[@"PUBLISHDT"];
        }
    //    else
    //    {
    //        if (tempObj[@"PUBLISHDT"] != nil && ![tempObj[@"PUBLISHDT"] isEqualToString:[CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"]])
    //        {
    //            _btnRefund.hidden = YES;
    //        }
    
    //    }
    
    for (int i = 0; i < RefundTypeList.count; i++) {
        if ([RefundTypeList[i][@"id"] isEqualToString:OnlineSlip[@"REFUND_WAY_CODE"]]) {
            _lblPayMethod.text = RefundTypeList[i][LANGUAGE];
        }
    }
    
    _lblUser.text = OnlineSlip[@"WORKERID"];
    
    _lblConsumBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_COMM_SALE_AMT"]]];
    _lblConsumTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_COMM_TAX_AMT"]]];
    _lblConsumFeeAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_COMM_FEE_AMT"]]];
    _lblConsumRefundAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_COMM_REFUND_AMT"]]];
    
    _lblGoodsBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_EXCOMM_SALE_AMT"]]];
    _lblGoodsTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_EXCOMM_TAX_AMT"]]];
    _lblGoodsFeeAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_EXCOMM_FEE_AMT"]]];
    _lblGoodsRefundAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", OnlineSlip[@"TOTAL_EXCOMM_REFUND_AMT"]]];
    
    _lblTotalBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [[_lblGoodsBuyAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] + [[_lblConsumBuyAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]]];
    _lblTotalTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [[_lblGoodsTaxAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] + [[_lblConsumTaxAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]]];
    _lblTotalFeeAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [[_lblGoodsFeeAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] + [[_lblConsumFeeAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]]];
    _lblTotalRefundAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [[_lblGoodsRefundAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] + [[_lblConsumRefundAmt.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]]];
}

- (IBAction)EditRefundClick:(id)sender {
    if (!_isOnline) {
        [self UpdateSlip];
    }
}

- (IBAction)RefundClick:(id)sender {
    
    signImage = nil;
    _printScrollView.hidden = NO;
     

    if (_isOnline) {
        if ([OnlineSlip[@"PUBLISH_STATUS"] isEqualToString:@"04"]) {
            [self.view makeToast:ALREADYCANCELREFUND];
            return;
        }
        isRepublish = NO;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        params[@"slip_no"] = _SlipNo;
        
        if (SlipDoc) {
            [self makePrintDoc];
            return;
        }
        
        if ([CommonFunc isNetworkAvailable]) {
            kAppDelegate.isOnline = @"1";
            [SVProgressHUD show];
            [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_PRINT_SLIP_INFO] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
                [SVProgressHUD dismiss];
                if(status == ResponseStatusOK) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        NSString *resultString = [responseObject objectForKey:@"result"];
                        if ([resultString isEqualToString:@"S"]) {
                            self->SlipDoc = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
                            [self makePrintDoc];
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
    else {
        isRepublish = YES;
        NSMutableArray *AllDocs = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:SLIP_PRINT_DOCS_TABLE_KIND fieldName:USERID fieldValue:kAppDelegate.LoginID fieldName2:SLIP_NO fieldValue2:_SlipNo]];
        if (AllDocs.count > 0) {
            SlipDoc = [[NSMutableDictionary alloc] initWithDictionary:AllDocs[0]];
        }
        MapDocid = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseDocid:SlipDoc[DOCID]]];
        MapRetailer = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseRetailer:SlipDoc[RETAILER]]];
        MapGoods = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseGoods:SlipDoc[GOODS]]];
        MapTourist = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseTourist:SlipDoc[TOURIST]]];
        signImage = [CommonFunc getImageFromBase64:SlipDoc[SIGN]];
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:PRINTSLIPLANG_FORM message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_CN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->LanguageNo = 2;
            [self PrintSlip];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_EN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->LanguageNo = 1;
            [self PrintSlip];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_KO style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->LanguageNo = 3;
            [self PrintSlip];
        }]];
        
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertView dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void) makePrintDoc {
    
    NSString *strSlipLang= @"EN";
    
    NSString *retailer = @"";
    NSString *docid = @"";
    NSString *goods = @"";
    NSString *tourist = @"";
    NSString *singinfo = @"";
    
    NSMutableArray *arrComm = [[NSMutableArray alloc] init];
    NSMutableArray *arrExComm = [[NSMutableArray alloc] init];
    NSMutableDictionary *signToken;
    
    NSMutableDictionary *retailerToken = SlipDoc[@"retailerInfo"];
    NSMutableDictionary *touristToken = SlipDoc[@"touristInfo"];
    NSMutableDictionary *refundToken = SlipDoc[@"refundInfo"];
    NSMutableDictionary *saleToken = SlipDoc[@"saleInfo"];
    if (SlipDoc[@"signInfo"] != nil) {
        signToken = SlipDoc[@"signInfo"];
    }
    else {
        signToken = nil;
    }
    NSString *BuyerNo = @"";
    if (![touristToken[@"PASSPORT_SERIAL_NO"] isEqualToString:@""]) {
        BuyerNo = touristToken[@"PASSPORT_SERIAL_NO"];
    }
    else {
        BuyerNo = touristToken[@"PERMIT_NO"];
    }
    tourist = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@", touristToken[@"PASSPORT_TYPE"], BuyerNo, touristToken[@"BUYER_NAME"], touristToken[@"NATIONALITY"], touristToken[@"BUYER_BIRTH"], touristToken[@"RESIDENCE"], touristToken[@"ENTRYDT"]];
    
    retailer = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|", retailerToken[@"TAXOFFICE_NAME"], retailerToken[@"TAX_ADDR1"], retailerToken[@"TAX_ADDR2"], retailerToken[@"MERCHANT_JPNM"], retailerToken[@"JP_ADDR1"], retailerToken[@"JP_ADDR2"]];
    if (retailerToken[@"OPT_CORP_JPNM"]) {
        retailer = [NSString stringWithFormat:@"%@%@", retailer, retailerToken[@"OPT_CORP_JPNM"]];
    }
    
    
    docid = strSlipLang;                         //출력언어
    
    if ([configInfo[@"print_choice"] isEqualToString:@"01"]) {
        //출력전표 갯수
        docid = [NSString stringWithFormat:@"%@|2|01/02|", docid];
    }
    else if ([configInfo[@"print_choice"] isEqualToString:@"02"]){
        //출력전표 갯수
        docid = [NSString stringWithFormat:@"%@|1|01|", docid];
    }
    else if ([configInfo[@"print_choice"] isEqualToString:@"03"]){
        //출력전표 갯수
        docid = [NSString stringWithFormat:@"%@|2|01/02|", docid];
    }
    
    docid = [NSString stringWithFormat:@"%@[REPUBLISH]|%@|N|%@|%@|%@|%@", docid, _SlipNo, refundToken[@"REFUND_WAY_CODE"], refundToken[@"REFUND_WAY_CODE_DESC"], refundToken[@"MASK_REMIT_NO"], retailerToken[@"UNIKEY"]];
    
    if([configInfo[@"receipt_add"] isEqualToString:@"YES"]) {
        goods = [NSString stringWithFormat:@"%@|", retailerToken[@"SALEDT"]];
        
        int com_cnt = [saleToken[@"COM_COUNT"] intValue];
        int excom_cnt = [saleToken[@"EXCOM_COUNT"] intValue];
        
        if (com_cnt > 0 && excom_cnt > 0) {
            goods = [NSString stringWithFormat:@"%@2|", goods];
        }
        else if (com_cnt > 0 || excom_cnt > 0) {
            goods = [NSString stringWithFormat:@"%@1|", goods];
        }
        else {
            [self.view makeToast:ERROR_ISSUE];
            return;
        }
        
        NSMutableArray *goodsList = [[NSMutableArray alloc] initWithArray:SlipDoc[@"goodsList"]];
        for (int i = 0; i < goodsList.count; i++) {
            NSString *item_code = goodsList[i][@"GOODS_ITEMS_CODE"];
            if ([item_code isEqualToString:@"A0002"]) {
                [arrComm addObject:goodsList[i]];
            }
            else {
                [arrExComm addObject:goodsList[i]];
            }
        }
        
        if (arrComm != nil && arrComm.count > 0) {
            goods = [NSString stringWithFormat:@"%@01|%lu|", goods, (unsigned long)arrComm.count];     //물품종류(소비) 물품갯수
            for (int i = 0; i < arrComm.count; i++) {
                goods = [NSString stringWithFormat:@"%@%@|%@|%@|%@|", goods, arrComm[i][@"GOODS_NAME"], arrComm[i][@"GOODS_UNIT_PRICE"], arrComm[i][@"GOODS_QTY"], arrComm[i][@"GOODS_AMT"]];
            }
            goods = [NSString stringWithFormat:@"%@%@|%@|%@||", goods, saleToken[@"TOTAL_COMM_SALE_AMT"], saleToken[@"TOTAL_COMM_TAX_AMT"], saleToken[@"TOTAL_COMM_REFUND_AMT"]];
        }
        
        if (arrExComm != nil && arrExComm.count > 0) {
            goods = [NSString stringWithFormat:@"%@02|%lu|", goods, (unsigned long)arrExComm.count];     //물품종류(소비) 물품갯수
            for (int i = 0; i < arrExComm.count; i++) {
                goods = [NSString stringWithFormat:@"%@%@|%@|%@|%@|", goods, arrExComm[i][@"GOODS_NAME"], arrExComm[i][@"GOODS_UNIT_PRICE"], arrExComm[i][@"GOODS_QTY"], arrExComm[i][@"GOODS_AMT"]];
            }
            goods = [NSString stringWithFormat:@"%@%@|%@|%@||", goods, saleToken[@"TOTAL_EXCOMM_SALE_AMT"], saleToken[@"TOTAL_EXCOMM_TAX_AMT"], saleToken[@"TOTAL_EXCOMM_REFUND_AMT"]];
        }
        
        goods = [NSString stringWithFormat:@"%@%i|%i|%i|%i|", goods, [saleToken[@"TOTAL_EXCOMM_TAX_AMT"] intValue] + [saleToken[@"TOTAL_COMM_TAX_AMT"] intValue], [saleToken[@"TOTAL_EXCOMM_SALE_AMT"] intValue] + [saleToken[@"TOTAL_COMM_SALE_AMT"] intValue], [saleToken[@"TOTAL_EXCOMM_TAX_AMT"] intValue] + [saleToken[@"TOTAL_COMM_TAX_AMT"] intValue] - [saleToken[@"TOTAL_EXCOMM_REFUND_AMT"] intValue] - [saleToken[@"TOTAL_COMM_REFUND_AMT"] intValue], [saleToken[@"TOTAL_EXCOMM_REFUND_AMT"] intValue] + [saleToken[@"TOTAL_COMM_REFUND_AMT"] intValue]];
        
        MapGoods = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseGoods:goods]];
    }
    else {
        
    }
    
    if (signToken != nil)
        {
        singinfo = signToken[@"SIGN_DATA"];
        signImage = [CommonFunc getImageFromBase64:singinfo];
        }
    
    MapDocid = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseDocid:docid]];
    MapRetailer = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseRetailer:retailer]];
    MapTourist = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseTourist:tourist]];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:PRINTSLIPLANG_FORM message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_CN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self->LanguageNo = 2;
        [self PrintSlip];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_EN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self->LanguageNo = 1;
        [self PrintSlip];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_KO style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self->LanguageNo = 3;
        [self PrintSlip];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void) PrintSlip {
    if (MapGoods && MapGoods.count > 0) {
        if ([configInfo[@"printer"] isEqualToString:@"A4"]) {   //  Air Print
            NSMutableArray *PrintList = [[NSMutableArray alloc] init];
            [PrintList addObject:[self CreatePrintJson]];
            
//            if (![configInfo[@"print_choice"] isEqualToString:@"03"]){
                [CommonFunc saveArrayToLocal:PrintList key:PRINT_LIST];
                [PrintView loadXIB:self];
//            }
        }
        else {
//            if (![configInfo[@"print_choice"] isEqualToString:@"03"]){
                if ([self runPrintReceiptSequence]) {
                    if (!_isOnline) {
                        [self UpdateSlip];
                    }
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:SLIP_CONFIRM preferredStyle:UIAlertControllerStyleAlert];
                    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [alertView dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
                else {
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:PRINT_FAILED preferredStyle:UIAlertControllerStyleAlert];
                    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [alertView dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
//            }
        }
    }
    else {
//        if (![configInfo[@"print_choice"] isEqualToString:@"03"]){
            if ([self runPrintNoReceiptSequence]) {
                if (!_isOnline) {
                    [self UpdateSlip];
                }
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:SLIP_CONFIRM preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
            else {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:PRINT_FAILED preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
//        }
    }
}

- (void) UpdateSlip {
    NSMutableDictionary *newSlip = [[NSMutableDictionary alloc] initWithDictionary:[[DatabaseManager sharedInstance] readData:REFUNDSLIP_TABLE_KIND fieldName:USERID fieldValue:kAppDelegate.LoginID fieldName2:SLIP_NO fieldValue2:_SlipNo][0]];
    newSlip[SLIP_STATUS_CODE] = @"02";
    newSlip[REFUNDDT] = [CommonFunc getStringFromDate:[NSDate date]];
    newSlip[PRINT_CNT] = [NSString stringWithFormat:@"%i", [newSlip[PRINT_CNT] intValue] + 1];
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND data:newSlip];
    
    [self getDetailInfo];
}


- (IBAction)BackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)  tableView:(UITableView *)tableView
  viewForFooterInSection :(NSInteger)section{

  UIView *result = nil;

  if (section == 0){

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = myMemoText;
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];

    /* Move the label 10 points to the right */
    label.frame = CGRectMake(label.frame.origin.x + 10.0f,
                             10.0f, /* Go 5 points down in y axis */
                             label.frame.size.width,
                             label.frame.size.height);

    /* Give the container view 10 points more in width than our label
     because the label needs a 10 extra points left-margin */
      
    label.textColor = [UIColor colorWithRed:32/255.f green:66/255.f blue:92/255.f alpha:1.0];;
    CGRect resultFrame = CGRectMake(0.0f,
                                    0.0f,
                                    label.frame.size.width + 10.0f,
                                    label.frame.size.height);
    result = [[UIView alloc] initWithFrame:resultFrame];
    [result addSubview:label];
      
     

  }

  return result;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    SearchDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (_isOnline) {
        NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
        
        if ([ItemInfo[@"ITEM_CODE"] isEqualToString:@"A0001"]) {
            cell.colorView.backgroundColor = LightOrangeColor;
        }
        else {
            cell.colorView.backgroundColor = LightBlueColor;
        }
        
        _lblRctNo.text = ItemInfo[@"REC_NO"];
        
        cell.lblNo.text = ItemInfo[@"SALE_SEQ"];
        cell.lblItemType.text = ItemInfo[@"GOODS_ITEMS_CODE"];
        cell.lblMainCat.text = ItemInfo[@"GOODS_GROUP_CODE"];
        cell.lblMidCat.text = ItemInfo[@"GOODS_DIVISION"];
        cell.lblItemName.text = ItemInfo[@"NAME"];
        cell.lblQty.text = [CommonFunc getCommaString:ItemInfo[@"GOODS_QTY"]];
        
        if ([ItemInfo[@"TAX_PROC_TIME_CODE"] isEqualToString:@"02"])//내세
            {
            //cell.lblBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [ItemInfo[@"GOODS_AMT"] intValue] - [ItemInfo[@"TAX_AMT"] intValue]]];
                // OnLineSearch 조회에서 금액이 틀어져서 나와서 이 부분을 수정 함.
                cell.lblBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [ItemInfo[@"GOODS_AMT"] intValue]]];
                NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++????????");
                NSLog(@"GOODS_AMT:: %i", [ItemInfo[@"GOODS_AMT"] intValue]);
                NSLog(@"BUY_AMT:: %i", [ItemInfo[@"BUY_AMT"] intValue]);
                NSLog(@"TAX_AMT:: %i", [ItemInfo[@"TAX_AMT"] intValue]);
            }
        else//외세
            {
            cell.lblBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"GOODS_AMT"]]];
            }
        
        cell.lblTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"TAX_AMT"]]];
        cell.lblFee.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"FEE_AMT"]]];
        cell.lblRefundAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"REFUND_AMT"]]];
        
        cell.lblTaxFormula.text = [self getTaxFormula:ItemInfo isOnline:YES];
        if (ItemInfo[@"TAX_TYPE"]) {
            if ([ItemInfo[@"TAX_TYPE"] isEqualToString:@"1"]) {
                cell.lblTaxFormula.text = @"8%";
            }
            else if ([ItemInfo[@"TAX_TYPE"] isEqualToString:@"2"]) {
                cell.lblTaxFormula.text = @"10%";
            }
        }
        else {
            cell.lblTaxFormula.text = [self getTaxFormula:ItemInfo isOnline:YES];//[NSString stringWithFormat:@"%i%@", (int)([ShopInfo[@"TAX_FORMULA"] floatValue] * 100), @"%"];
        }
        if ([ItemInfo[@"TAX_PROC_TIME_CODE"] isEqualToString:@"02"])//내세
            {
            cell.lblTaxType.text = @"内税";
            }
        else//외세
            {
            cell.lblTaxType.text = @"外税";
            }
        
    }
    else {
        NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
        if ([ItemInfo[@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
            cell.colorView.backgroundColor = LightOrangeColor;
        }
        else {
            cell.colorView.backgroundColor = LightBlueColor;
        }
        _lblRctNo.text = ItemInfo[@"RCT_NO"];
        cell.lblNo.text = ItemInfo[@"ITEM_NO"];
        cell.lblItemType.text = ItemInfo[@"ITEM_TYPE_TEXT"];
        cell.lblMainCat.text = ItemInfo[@"MAIN_CAT_TEXT"];
        cell.lblMidCat.text = ItemInfo[@"MID_CAT_TEXT"];
        cell.lblItemName.text = ItemInfo[@"ITEM_NAME"];
        cell.lblQty.text = [CommonFunc getCommaString:ItemInfo[@"QTY"]];
        
        if ([ItemInfo[@"TAX_TYPE"] isEqualToString:@"02"])//내세
            {
            cell.lblBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", [ItemInfo[@"BUY_AMT"] intValue] - [ItemInfo[@"TAX_AMT"] intValue]]];
                NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                NSLog(@"GOODS_AMT:: %i", [ItemInfo[@"GOODS_AMT"] intValue]);
                NSLog(@"BUY_AMT:: %i", [ItemInfo[@"BUY_AMT"] intValue]);
                NSLog(@"TAX_AMT:: %i", [ItemInfo[@"TAX_AMT"] intValue]);
            }
        else//외세
            {
            cell.lblBuyAmt.text = [CommonFunc getCommaString:ItemInfo[@"BUY_AMT"]];
            }
        
        cell.lblTaxAmt.text = [CommonFunc getCommaString:ItemInfo[@"TAX_AMT"]];
        cell.lblFee.text = [CommonFunc getCommaString:ItemInfo[@"FEE_AMT"]];
        cell.lblRefundAmt.text = [CommonFunc getCommaString:ItemInfo[@"REFUND_AMT"]];
        
        //        cell.lblTaxFormula.text = [self getTaxFormula:ItemInfo isOnline:NO];
        if (ItemInfo[@"TAX_FORMULA"]) {
            cell.lblTaxFormula.text = [NSString stringWithFormat:@"%i%@", (int)([ItemInfo[@"TAX_FORMULA"] floatValue] * 100), @"%"];
        }
        else {
            cell.lblTaxFormula.text = [self getTaxFormula:ItemInfo isOnline:NO]; //[NSString stringWithFormat:@"%i%@", (int)([ShopInfo[@"TAX_FORMULA"] floatValue] * 100), @"%"];
        }
        cell.lblTaxType.text = ItemInfo[@"TAX_TYPE_TEXT"];
    }
    
    return cell;
}

- (NSString *) getTaxFormula:(NSMutableDictionary *)ItemInfo isOnline:(BOOL)isOnline {
    NSString *TaxPercent = [NSString stringWithFormat:@"%i%@", (int)([ShopInfo[@"TAX_FORMULA"] floatValue] * 100), @"%"];
    if (isOnline) {
        if ([ItemInfo[@"TAX_PROC_TIME_CODE"] isEqualToString:@"02"])//내세
            {
            float tax_formula = [ItemInfo[@"GOODS_AMT"] floatValue] / ([ItemInfo[@"GOODS_AMT"] floatValue] - [ItemInfo[@"TAX_AMT"] floatValue]) - 1;
            TaxPercent = [NSString stringWithFormat:@"%i%@", (int)roundf(tax_formula * 100), @"%"];
            
            }
        else//외세
            {
            float tax_formula = [ItemInfo[@"TAX_AMT"] floatValue] / [ItemInfo[@"GOODS_AMT"] floatValue];
            TaxPercent = [NSString stringWithFormat:@"%i%@", (int)roundf(tax_formula * 100), @"%"];
            }
    }
    else {
        if ([ItemInfo[@"TAX_TYPE"] isEqualToString:@"02"])//내세
            {
            float tax_formula = [ItemInfo[@"BUY_AMT"] floatValue]/ ([ItemInfo[@"BUY_AMT"] floatValue] - [ItemInfo[@"TAX_AMT"] floatValue]) - 1;
            TaxPercent = [NSString stringWithFormat:@"%i%@", (int)roundf(tax_formula * 100), @"%"];
            
            }
        else//외세
            {
            float tax_formula = [ItemInfo[@"TAX_AMT"] floatValue] / [ItemInfo[@"BUY_AMT"] floatValue];
            TaxPercent = [NSString stringWithFormat:@"%i%@", (int)roundf(tax_formula * 100), @"%"];
            }
    }
    return TaxPercent;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

///////////////    Print  Module   ///////////////

- (BOOL) eventPrintDoc:(NSString *)SlipType isGoods:(NSString *)isGoods {
    
    int type = [SlipType intValue];
    
    ///======================  Header  ============================///
    _lblSlipType.frame = CGRectMake(0, _lblSlipType.frame.origin.y, _viewHeader.frame.size.width, 30);
    if (type == 1) {
        _lblSlipType.text = StringSlipType01AddText01;
        _lblSlipTypeDetail.text = [NSString stringWithFormat:@"%@/\n%@", StringSlipType01[0], StringSlipType01[LanguageNo]];
    }
    else if (type == 2) {
        _lblSlipType.text = StringSlipType02AddText01;
        _lblSlipTypeDetail.text = [NSString stringWithFormat:@"%@/\n%@", StringSlipType02[0], StringSlipType02[LanguageNo]];
    }
    [_lblSlipTypeDetail sizeToFit];
    _lblSlipTypeDetail.frame = CGRectMake(0, _lblSlipTypeDetail.frame.origin.y, _viewHeader.frame.size.width, _lblSlipTypeDetail.frame.size.height);
    
    [_lblSlipType sizeToFit];
    _lblSlipType.frame = CGRectMake(0, _lblSlipType.frame.origin.y, _lblSlipType.frame.size.width + 10, 30);
    _lblSlipType.layer.borderWidth = 1;
    _lblSlipType.layer.borderColor = [UIColor blackColor].CGColor;
    _lblSlipType.textAlignment = NSTextAlignmentCenter;
    
    _lblRepublish.hidden = YES;
    if (isRepublish) {
        _lblRepublish.hidden = NO;
        _lblRepublish.text = [NSString stringWithFormat:@"[%@/%@]", StringRePublish[0], StringRePublish[LanguageNo]];
        _lblRepublish.frame = CGRectMake(0, _lblSlipTypeDetail.frame.origin.y + _lblSlipTypeDetail.frame.size.height + 10, _lblRepublish.frame.size.width, _lblRepublish.frame.size.height);
    }
    
    
    UIImage *barcodeImage = [TCCodeGenerator Code128BarcodeWithString:MapDocid[@"SlipNo"] width:_imageBarCode.frame.size.width color:[UIColor blackColor] inputQuietSpace:kTCCode128BarcodeInputQuietSpaceMin];
    _imageBarCode.image = barcodeImage;
    
    _lblBarCode.text = MapDocid[@"SlipNo"];
    _lblReceiptNo.text = [NSString stringWithFormat:@"%@/%@ : %@", StringSlipNo[0], StringSlipNo[LanguageNo], MapDocid[@"SlipNo"]];
    
    _viewBarCode.frame = CGRectMake(0, _lblSlipTypeDetail.frame.origin.y + _lblSlipTypeDetail.frame.size.height + 10, _viewBarCode.frame.size.width, _viewBarCode.frame.size.height);
    
    if (isRepublish) {
        _viewBarCode.frame = CGRectMake(0, _lblRepublish.frame.origin.y + _lblRepublish.frame.size.height + 10, _viewBarCode.frame.size.width, _viewBarCode.frame.size.height);
    }
    
    
    _viewHeader.frame = CGRectMake(0, 0, _viewHeader.frame.size.width, _viewBarCode.frame.origin.y + _viewBarCode.frame.size.height);
    
    ///======================  Retailer  =========================////
    _lblTaxOffice.text = [NSString stringWithFormat:@"%@/%@ : %@", StringRetailer01[0], StringRetailer01[LanguageNo], MapRetailer[@"TaxOffice"]];
    _lblTaxPlace.text = [NSString stringWithFormat:@"%@/%@", StringRetailer02[0], StringRetailer02[LanguageNo]];
    _lblTaxPlaceInfo.text = [NSString stringWithFormat:@"%@ %@", MapRetailer[@"TaxPlace1"], MapRetailer[@"TaxPlace2"]];
    _lblSellerName.text = [NSString stringWithFormat:@"%@/%@", StringRetailer03[0], StringRetailer03[LanguageNo]];
    _lblSellerNameInfo.text = MapRetailer[@"Seller"];
    _lblOperationName.text = StringOperationName;
    _lblOperationNameInfo.text = MapRetailer[@"OptCorpJpnm"];
    _lblSellerPlace.text = [NSString stringWithFormat:@"%@/%@", StringRetailer04[0], StringRetailer04[LanguageNo]];
    _lblSellerPlaceInfo.text = [NSString stringWithFormat:@"%@ %@", MapRetailer[@"SellerAddr1"], MapRetailer[@"SellerAddr2"]];
    
    _viewRetailer.frame = CGRectMake(0, _viewHeader.frame.origin.y + _viewHeader.frame.size.height, _viewRetailer.frame.size.width, _viewRetailer.frame.size.height);
    
    ///======================   Goods Detail  ===================//////
    _viewGoodsDetail.hidden = YES;
    if ([isGoods isEqualToString:@"1"]) {
        _viewGoodsDetail.hidden = NO;
        
        _lblPurchaseDate.text = [NSString stringWithFormat:@"%@/%@ : %@", StringGoodsDetails01[0], StringGoodsDetails01[LanguageNo], MapGoods[@"SaleDate"]];
        _lblConsumTitle.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails02[0], StringGoodsDetails02[LanguageNo]];
        _lblConsumName. text = StringGoodsDetails04[LanguageNo];
        _lblConsumUnit. text = StringGoodsDetails05[LanguageNo];
        _lblConsumQty. text = StringGoodsDetails06[LanguageNo];
        _lblConsumBuyAmount. text = StringGoodsDetails07[LanguageNo];
        
        _lblGoodsTitle.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails03[0], StringGoodsDetails03[LanguageNo]];
        _lblGoodsName. text = StringGoodsDetails04[LanguageNo];
        _lblGoodsUnit. text = StringGoodsDetails05[LanguageNo];
        _lblGoodsQty. text = StringGoodsDetails06[LanguageNo];
        _lblGoodsBuyAmount. text = StringGoodsDetails07[LanguageNo];
        
        _lblConsumTotalBuyAmount.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails09[0], StringGoodsDetails09[LanguageNo]];
        _lblGoodsTotalBuyAmount.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails09[0], StringGoodsDetails09[LanguageNo]];
        
        _lblConsumTotalTaxAmount.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails08[0], StringGoodsDetails08[LanguageNo]];
        _lblGoodsTotalTaxAmount.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails08[0], StringGoodsDetails08[LanguageNo]];
        
        _lblConsumTotalRefundAmount.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails10[0], StringGoodsDetails10[LanguageNo]];
        _lblGoodsTotalRefundAmount.text = [NSString stringWithFormat:@"%@/%@", StringGoodsDetails10[0], StringGoodsDetails10[LanguageNo]];
        
        _viewGoods.hidden = YES;
        _viewConsumables.hidden = YES;
        
        for (UIView * subview in _viewConsumList.subviews) {
            if (subview != nil)
                [subview removeFromSuperview];
        }
        for (UIView * subview in _viewGoodsList.subviews) {
            if (subview != nil)
                [subview removeFromSuperview];
        }
        
        for (int i = 0; i < [MapGoods[@"ItemTypeSeq"] intValue]; i++)
            {
            NSString *ItemMapKey = [NSString stringWithFormat:@"ItemsMap_%i", i];
            NSMutableDictionary *ItemMap = MapGoods[ItemMapKey];
            
            if ([ItemMap[@"ItemTypeCode"] isEqualToString:@"01"])       // 소모품
                {
                _viewConsumables.hidden = NO;
                for (int j = 0; j < [ItemMap[@"GoodsSeq"] intValue]; j++)
                    {
                    NSString *GoodsMapKey = [NSString stringWithFormat:@"GoodsMap_%i", j];
                    NSMutableDictionary *GoodsMap = ItemMap[GoodsMapKey];
                    
                    // 품명
                    UILabel *labelBuyerName = [[UILabel alloc] initWithFrame:CGRectMake(0, j * 30, 200, 30)];
                    labelBuyerName.font = _lblConsumNameInfo.font;
                    labelBuyerName.textAlignment = _lblConsumNameInfo.textAlignment;
                    [_viewConsumList addSubview:labelBuyerName];
                    labelBuyerName.text = GoodsMap[@"Name"];
                    
                    // 단가
                    UILabel *labelUnitPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, j * 30, 100, 30)];
                    labelUnitPrice.font = _lblConsumUnitInfo.font;
                    labelUnitPrice.textAlignment = _lblConsumUnitInfo.textAlignment;
                    [_viewConsumList addSubview:labelUnitPrice];
                    labelUnitPrice.text = [CommonFunc getCommaString:GoodsMap[@"UnitPrice"]];
                    
                    // 수량
                    UILabel *labelQty = [[UILabel alloc] initWithFrame:CGRectMake(300, j * 30, 100, 30)];
                    labelQty.font = _lblConsumNameInfo.font;
                    labelQty.textAlignment = _lblConsumQtyInfo.textAlignment;
                    [_viewConsumList addSubview:labelQty];
                    labelQty.text = [CommonFunc getCommaString:GoodsMap[@"Qty"]];
                    
                    // 판매가격
                    UILabel *labelBuyAmt = [[UILabel alloc] initWithFrame:CGRectMake(400, j * 30, 180, 30)];
                    labelBuyAmt.font = _lblConsumBuyAmountInfo.font;
                    labelBuyAmt.textAlignment = _lblConsumBuyAmountInfo.textAlignment;
                    [_viewConsumList addSubview:labelBuyAmt];
                    labelBuyAmt.text = [CommonFunc getCommaString:GoodsMap[@"Amt"]];
                    }
                
                _lblConsumTotalBuyAmountInfo.text = [CommonFunc getCommaString:ItemMap[@"SaleAmt"]];
                _lblConsumTotalTaxAmountInfo.text = [CommonFunc getCommaString:ItemMap[@"TaxAmt"]];
                _lblConsumTotalRefundAmountInfo.text = [CommonFunc getCommaString:ItemMap[@"RefundAmt"]];
                
                _viewConsumList.frame = CGRectMake(0, _viewConsumList.frame.origin.y, _viewConsumList.frame.size.width, [ItemMap[@"GoodsSeq"] intValue] * 30);
                _viewConsumTotalList.frame = CGRectMake(0, _viewConsumList.frame.origin.y + _viewConsumList.frame.size.height + 10, _viewConsumTotalList.frame.size.width, _viewConsumTotalList.frame.size.height);
                }
            else if ([ItemMap[@"ItemTypeCode"] isEqualToString:@"02"])    // 일반품목
                {
                _viewGoods.hidden = NO;
                for (int j = 0; j < [ItemMap[@"GoodsSeq"] intValue]; j++)
                    {
                    NSString *GoodsMapKey = [NSString stringWithFormat:@"GoodsMap_%i", j];
                    NSMutableDictionary *GoodsMap = ItemMap[GoodsMapKey];
                    
                    // 품명
                    UILabel *labelBuyerName = [[UILabel alloc] initWithFrame:CGRectMake(0, j * 30, 200, 30)];
                    labelBuyerName.font = _lblConsumNameInfo.font;
                    labelBuyerName.textAlignment = _lblConsumNameInfo.textAlignment;
                    [_viewGoodsList addSubview:labelBuyerName];
                    labelBuyerName.text = GoodsMap[@"Name"];
                    
                    // 단가
                    UILabel *labelUnitPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, j * 30, 100, 30)];
                    labelUnitPrice.font = _lblConsumUnitInfo.font;
                    labelUnitPrice.textAlignment = _lblConsumUnitInfo.textAlignment;
                    [_viewGoodsList addSubview:labelUnitPrice];
                    labelUnitPrice.text = [CommonFunc getCommaString:GoodsMap[@"UnitPrice"]];
                    
                    // 수량
                    UILabel *labelQty = [[UILabel alloc] initWithFrame:CGRectMake(300, j * 30, 100, 30)];
                    labelQty.font = _lblConsumNameInfo.font;
                    labelQty.textAlignment = _lblConsumQtyInfo.textAlignment;
                    [_viewGoodsList addSubview:labelQty];
                    labelQty.text = [CommonFunc getCommaString:GoodsMap[@"Qty"]];
                    
                    // 판매가격
                    UILabel *labelBuyAmt = [[UILabel alloc] initWithFrame:CGRectMake(400, j * 30, 180, 30)];
                    labelBuyAmt.font = _lblConsumBuyAmountInfo.font;
                    labelBuyAmt.textAlignment = _lblConsumBuyAmountInfo.textAlignment;
                    [_viewGoodsList addSubview:labelBuyAmt];
                    labelBuyAmt.text = [CommonFunc getCommaString:GoodsMap[@"Amt"]];
                    }
                
                _lblGoodsTotalBuyAmountInfo.text = [CommonFunc getCommaString:ItemMap[@"SaleAmt"]];
                _lblGoodsTotalTaxAmountInfo.text = [CommonFunc getCommaString:ItemMap[@"TaxAmt"]];
                _lblGoodsTotalRefundAmountInfo.text = [CommonFunc getCommaString:ItemMap[@"RefundAmt"]];
                
                _viewGoodsList.frame = CGRectMake(0, _viewGoodsList.frame.origin.y, _viewGoodsList.frame.size.width, [ItemMap[@"GoodsSeq"] intValue] * 30);
                _viewGoodsTotalList.frame = CGRectMake(0, _viewGoodsList.frame.origin.y + _viewGoodsList.frame.size.height + 10, _viewGoodsTotalList.frame.size.width, _viewGoodsTotalList.frame.size.height);
                }
            }
        
        if (_viewConsumables.isHidden && !_viewGoods.isHidden) {
            _viewGoods.frame = CGRectMake(0, _viewConsumables.frame.origin.y, _viewGoods.frame.size.width, _viewGoodsTotalList.frame.origin.y + _viewGoodsTotalList.frame.size.height);
            _viewGoodsDetail.frame = CGRectMake(0, _viewRetailer.frame.origin.y + _viewRetailer.frame.size.height, _viewGoodsDetail.frame.size.width, _viewGoods.frame.origin.y + _viewGoods.frame.size.height);
        }
        else if (!_viewConsumables.isHidden && _viewGoods.isHidden) {
            _viewConsumables.frame = CGRectMake(0, _viewConsumables.frame.origin.y, _viewConsumables.frame.size.width, _viewConsumTotalList.frame.origin.y + _viewConsumTotalList.frame.size.height);
            _viewGoodsDetail.frame = CGRectMake(0, _viewRetailer.frame.origin.y + _viewRetailer.frame.size.height, _viewGoodsDetail.frame.size.width, _viewConsumables.frame.origin.y + _viewConsumables.frame.size.height);
        }
        else if (!_viewConsumables.isHidden && !_viewGoods.isHidden) {
            _viewConsumables.frame = CGRectMake(0, _viewConsumables.frame.origin.y, _viewConsumables.frame.size.width, _viewConsumTotalList.frame.origin.y + _viewConsumTotalList.frame.size.height);
            _viewGoods.frame = CGRectMake(0, _viewConsumables.frame.origin.y + _viewConsumables.frame.size.height, _viewGoods.frame.size.width, _viewGoodsTotalList.frame.origin.y + _viewGoodsTotalList.frame.size.height);
            
            _viewGoodsDetail.frame = CGRectMake(0, _viewRetailer.frame.origin.y + _viewRetailer.frame.size.height, _viewGoodsDetail.frame.size.width, _viewGoods.frame.origin.y + _viewGoods.frame.size.height);
        }
    }
    
    
    ///==================  Refund Detail  ==================////
    _lblRefundWay.text = [NSString stringWithFormat:@"%@ : %@", StringRefundWayDesc, MapDocid[@"REFUND_WAY_CODE_DESC"]];
    if ([MapDocid[@"REFUND_WAY_CODE"] isEqualToString:@"06"])
        {
        _lblRefundWay.text = [NSString stringWithFormat:@"%@\n%@ : %@",_lblRefundWay.text, StringRefundWayQQ, MapDocid[@"MASK_REMIT_NO"]];
        }
    else if ([MapDocid[@"REFUND_WAY_CODE"] isEqualToString:@"04"])
        {
        _lblRefundWay.text = [NSString stringWithFormat:@"%@\n%@ : %@",_lblRefundWay.text, StringRefundWayUPI, MapDocid[@"MASK_REMIT_NO"]];
        }
    [_lblRefundWay sizeToFit];
    
    
    if ([isGoods isEqualToString:@"1"]) {
        _viewRefundDetail.frame = CGRectMake(0, _viewGoodsDetail.frame.origin.y + _viewGoodsDetail.frame.size.height, _viewRefundDetail.frame.size.width, _lblRefundWay.frame.origin.y + _lblRefundWay.frame.size.height + 10);
    }else {
        _viewRefundDetail.frame = CGRectMake(0, _viewRetailer.frame.origin.y + _viewRetailer.frame.size.height, _viewRefundDetail.frame.size.width, _lblRefundWay.frame.origin.y + _lblRefundWay.frame.size.height + 10);
    }
    
    
    
    ///=================   Tourist Detail  =================//////
    _lblPassportType.text = [NSString stringWithFormat:@"%@/%@ : %@", StringTouristDetails01[0], StringTouristDetails01[LanguageNo], MapTourist[@"PassportType"]];
    _lblPassportNo.text = [NSString stringWithFormat:@"%@/%@ : %@", StringTouristDetails02[0], StringTouristDetails02[LanguageNo], MapTourist[@"PassportNo"]];
    _lblBuyerName.text = [NSString stringWithFormat:@"%@/%@", StringTouristDetails03[0], StringTouristDetails03[LanguageNo]];
    _lblBuyerNameInfo.text = MapTourist[@"Name"];
    _lblNationality.text = [NSString stringWithFormat:@"%@/%@ : %@", StringTouristDetails04[0], StringTouristDetails04[LanguageNo], MapTourist[@"National"]];
    _lblBirthDay.text = [NSString stringWithFormat:@"%@/%@ : %@", StringTouristDetails05[0], StringTouristDetails05[LanguageNo], MapTourist[@"Birth"]];
    _lblResidence.text = [NSString stringWithFormat:@"%@/%@ : %@", StringTouristDetails06[0], StringTouristDetails06[LanguageNo], MapTourist[@"Residence"]];
    _lblLandingDate.text = [NSString stringWithFormat:@"%@/%@ : %@", StringTouristDetails08[0], StringTouristDetails08[LanguageNo], MapTourist[@"LandingDate"]];
    
    _viewTourist.frame = CGRectMake(0, _viewRefundDetail.frame.origin.y + _viewRefundDetail.frame.size.height, _viewTourist.frame.size.width,  _viewTourist.frame.size.height);
    
    ///====================   Unique ID  ======================//////
    if ([isGoods isEqualToString:@"1"]) {
        _viewUniqueID.hidden = YES;
        _lblReceiptAdd.hidden = YES;
        _lblUniqueID.hidden = NO;
        _lblUniqueIDTitle.text = @"Unique ID";
        if (type == 1) {
            _lblUniqueID.text = [NSString stringWithFormat:@"%@ : %@", StringRefundSerial, MapDocid[@"Unikey"]];
            _viewUniqueID.hidden = NO;
            _viewUniqueID.frame = CGRectMake(0, _viewTourist.frame.origin.y + _viewTourist.frame.size.height, _viewUniqueID.frame.size.width,  150);
        }
    }
    else {
        _viewUniqueID.hidden = NO;
        _lblReceiptAdd.hidden = NO;
        _lblUniqueID.hidden = YES;
        _lblUniqueIDTitle.text = @"RECEIPT";
        
        _viewUniqueID.frame = CGRectMake(0, _viewTourist.frame.origin.y + _viewTourist.frame.size.height, _viewUniqueID.frame.size.width,  500);
    }
    
    ///=====================  Footer  ========================////
    if ([isGoods isEqualToString:@"1"]) {
        if (type == 1) {
            _lblFooterContents.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@\n%@\n%@\n%@\n", StringSlipType01Desc01[0], StringSlipType01Desc02[0], StringSlipType01Desc03[0], StringSlipType01Desc04[0], StringSlipType01Desc01[LanguageNo], StringSlipType01Desc02[LanguageNo], StringSlipType01Desc03[LanguageNo], StringSlipType01Desc04[LanguageNo]];
            [_lblFooterContents sizeToFit];
            
            _lblFooterContents.frame = CGRectMake(0, _lblFooterContents.frame.origin.y, _viewFooter.frame.size.width, _lblFooterContents.frame.size.height);
            
            
            _viewFooter.frame = CGRectMake(0, _viewUniqueID.frame.origin.y + _viewUniqueID.frame.size.height, _viewFooter.frame.size.width, _lblFooterContents.frame.origin.y + _lblFooterContents.frame.size.height + 20);
        }
        else if (type == 2) {
            _lblFooterContents.text = [NSString stringWithFormat:@"%@\n%@\n\n%@\n%@\n", StringSlipType02Desc01[0], StringSlipType02Desc01[LanguageNo], StringSlipType02Desc02[0], StringSlipType02Desc02[LanguageNo]];
            [_lblFooterContents sizeToFit];
            
            _lblFooterContents.frame = CGRectMake(0, _lblFooterContents.frame.origin.y, _viewFooter.frame.size.width, _lblFooterContents.frame.size.height);
            _viewFooter.frame = CGRectMake(0, _viewTourist.frame.origin.y + _viewTourist.frame.size.height, _viewFooter.frame.size.width, _lblFooterContents.frame.origin.y + _lblFooterContents.frame.size.height + 20);
        }
    }
    else {
        if (type == 1) {
            _lblFooterContents.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@\n%@\n%@\n%@\n", StringSlipType01Desc01[0], StringSlipType01Desc02[0], StringSlipType01Desc03[0], StringSlipType01Desc04[0], StringSlipType01Desc01[LanguageNo], StringSlipType01Desc02[LanguageNo], StringSlipType01Desc03[LanguageNo], StringSlipType01Desc04[LanguageNo]];
            [_lblFooterContents sizeToFit];
        }
        else if (type == 2) {
            _lblFooterContents.text = [NSString stringWithFormat:@"%@\n%@\n\n%@\n%@\n", StringSlipType02Desc01[0], StringSlipType02Desc01[LanguageNo], StringSlipType02Desc02[0], StringSlipType02Desc02[LanguageNo]];
            [_lblFooterContents sizeToFit];
        }
        _lblFooterContents.frame = CGRectMake(0, _lblFooterContents.frame.origin.y, _viewFooter.frame.size.width, _lblFooterContents.frame.size.height);
        _viewFooter.frame = CGRectMake(0, _viewUniqueID.frame.origin.y + _viewUniqueID.frame.size.height, _viewFooter.frame.size.width, _lblFooterContents.frame.origin.y + _lblFooterContents.frame.size.height + 20);
    }
    
    if (type == 1) {
        _viewSignature.hidden = YES;
    }
    else if (type == 2) {
        _viewSignature.hidden = NO;
        _imageSignature.image = nil;
        if ([configInfo[@"signpad_use"] isEqualToString:@"YES"]) {
            _imageSignature.image = signImage;
        }
        _lblSignature.text = StringSlipType02Signature;
        
        _viewSignature.frame = CGRectMake(_viewSignature.frame.origin.x, _lblFooterContents.frame.origin.y + _lblFooterContents.frame.size.height + 10, _viewSignature.frame.size.width, _viewSignature.frame.size.height);
        
        _viewFooter.frame = CGRectMake(0, _viewFooter.frame.origin.y, _viewFooter.frame.size.width, _viewSignature.frame.origin.y + _viewSignature.frame.size.height + 20);
    }
    
    _printScrollView.contentSize = CGSizeMake(_printScrollView.frame.size.width, _viewFooter.frame.origin.y + _viewFooter.frame.size.height);
    
    UIImage *screenshot = [CommonFunc screenShotScrollView:_printScrollView];
    UIImage *print_image = [CommonFunc imageResize:screenshot size:CGSizeMake(540, screenshot.size.height * 540.0f / screenshot.size.width)];
    int result = EPOS2_SUCCESS;
    
    result = [printer_ addImage:print_image x:0 y:0
                          width:print_image.size.width
                         height:print_image.size.height
                          color:EPOS2_COLOR_1
                           mode:EPOS2_MODE_MONO
                       halftone:EPOS2_HALFTONE_THRESHOLD
                     brightness:EPOS2_PARAM_DEFAULT
                       compress:EPOS2_COMPRESS_AUTO];
    if (result != EPOS2_SUCCESS) {
        return NO;
    }
    result = [printer_ addCut:EPOS2_CUT_FEED];
    if (result != EPOS2_SUCCESS) {
        return NO;
    }
    return YES;
}

///==================   Air Print  ======================//

- (void) LoadHTMLPage:(NSString *)ReplaceValue {
    
    [SVProgressHUD show];
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    html = [html stringByReplacingOccurrencesOfString:@"ReplaceText" withString:ReplaceValue];
    
    [CommonFunc copyResourceFileToDocuments:@"jquery-2.0.3.min" withExt:@"js"];
    [CommonFunc copyResourceFileToDocuments:@"style" withExt:@"css"];
    
    readmePath = [CommonFunc copyResourceFileToDocuments:@"index"withExt:@"html"];
    
    NSError *error = nil;
    [html writeToFile:readmePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    readmePath = [readmePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self.view addSubview:self.webview];
    self.webview.delegate = self;
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:readmePath]]];
}

- (NSMutableDictionary *) CreatePrintJson {
    NSMutableDictionary *PrintJson = [[NSMutableDictionary alloc] init];
    PrintJson[@"SlipNo"] = MapDocid[@"SlipNo"];
    
    NSMutableDictionary *SellerInfo= [[NSMutableDictionary alloc] init];
    SellerInfo[@"TaxOffice"] = MapRetailer[@"TaxOffice"];
    SellerInfo[@"TaxPlace"] = [NSString stringWithFormat:@"%@ %@", MapRetailer[@"TaxPlace1"], MapRetailer[@"TaxPlace2"]];
    SellerInfo[@"SellerAddr"] = [NSString stringWithFormat:@"%@ %@", MapRetailer[@"SellerAddr1"], MapRetailer[@"SellerAddr2"]];
    SellerInfo[@"Seller"] = MapRetailer[@"Seller"];
    PrintJson[@"Seller_Info"] = SellerInfo;
    
    NSMutableDictionary *UserInfo= [[NSMutableDictionary alloc] init];
    UserInfo[@"PassportType"] = MapTourist[@"PassportType"];
    UserInfo[@"PassportNo"] = MapTourist[@"PassportNo"];
    UserInfo[@"National"] = MapTourist[@"National"];
    UserInfo[@"Birth"] = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:MapTourist[@"Birth"] format:@"yyyy-MM-dd"] format:@"MM 月 dd 日 yyyy 年"];
    UserInfo[@"Name"] = MapTourist[@"Name"];
    UserInfo[@"Residence"] = MapTourist[@"Residence"];
    UserInfo[@"LandingDate"] = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:MapTourist[@"LandingDate"] format:@"yyyy-MM-dd"] format:@"MM 月 dd 日 yyyy 年"];
    UserInfo[@"SaleDate"] = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:MapGoods[@"SaleDate"] format:@"yyyy-MM-dd"] format:@"MM 月 dd 日 yyyy 年"];
    PrintJson[@"User_Info"] = UserInfo;
    
    NSMutableDictionary *DescInfo= [[NSMutableDictionary alloc] init];
    DescInfo[@"1"] = StringSlipType01Desc01[LanguageNo];
    DescInfo[@"2"] = StringSlipType01Desc02[LanguageNo];
    DescInfo[@"3"] = StringSlipType01Desc03[LanguageNo];
    DescInfo[@"4"] = StringSlipType01Desc04[LanguageNo];
    PrintJson[@"Desc_Info"] = DescInfo;
    
    NSMutableDictionary *ConsumInfo= [[NSMutableDictionary alloc] init];
    NSMutableArray *ConsumList = [[NSMutableArray alloc] init];
    NSMutableDictionary *ConsumTotalInfo= [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *GoodsInfo= [[NSMutableDictionary alloc] init];
    NSMutableArray *GoodsList = [[NSMutableArray alloc] init];
    NSMutableDictionary *GoodsTotalInfo= [[NSMutableDictionary alloc] init];
    
    int goods_total = 0;
    int consum_total = 0;
    
    for (int i = 0; i < TableArray.count; i++) {
        NSMutableDictionary *ItemInfo = TableArray[i];
        if (_isOnline) {
            if ([ItemInfo[@"ITEM_CODE"] isEqualToString:@"A0001"]) {
                NSMutableDictionary *Goods = [[NSMutableDictionary alloc] init];
                Goods[@"name"] = [NSString stringWithFormat:@"%@ - %@ - %@", ItemInfo[@"GOODS_GROUP_CODE"], ItemInfo[@"GOODS_DIVISION"], ItemInfo[@"NAME"]];
                //Goods[@"unit"] = [CommonFunc getCommaString:ItemInfo[@"GOODS_UNIT_PRICE"]];
                //NSString *goods_unit_str =[NSString stringWithFormat:@"%ld", ItemInfo[@"GOODS_UNIT_PRICE"]];
                Goods[@"unit"] = [CommonFunc getCommaString:[NSString stringWithFormat:@"%@", ItemInfo[@"GOODS_UNIT_PRICE"]]];
                Goods[@"qty"] = [CommonFunc getCommaString:ItemInfo[@"GOODS_QTY"]];
                Goods[@"price"] = [CommonFunc getCommaString: [NSString stringWithFormat:@"%@", ItemInfo[@"GOODS_AMT"]]];
                [GoodsList addObject:Goods];
                
                goods_total += [ItemInfo[@"GOODS_AMT"] intValue];
            }
            else {
                NSMutableDictionary *Consum = [[NSMutableDictionary alloc] init];
                Consum[@"name"] = [NSString stringWithFormat:@"%@ - %@ - %@", ItemInfo[@"GOODS_GROUP_CODE"], ItemInfo[@"GOODS_DIVISION"], ItemInfo[@"NAME"]];
                //Consum[@"unit"] = [CommonFunc getCommaString:ItemInfo[@"GOODS_UNIT_PRICE"]];
                NSString *goods_unit_str =[NSString stringWithFormat:@"%@", ItemInfo[@"GOODS_UNIT_PRICE"]];
                Consum[@"unit"] = [CommonFunc getCommaString:goods_unit_str];
                Consum[@"qty"] = [CommonFunc getCommaString:ItemInfo[@"GOODS_QTY"]];
                Consum[@"price"] = [CommonFunc getCommaString: [NSString stringWithFormat:@"%@", ItemInfo[@"GOODS_AMT"]]];
                [ConsumList addObject:Consum];
                
                consum_total += [ItemInfo[@"GOODS_AMT"] intValue];
            }
        }
        else {
            if ([ItemInfo[@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
                NSMutableDictionary *Goods = [[NSMutableDictionary alloc] init];
                Goods[@"name"] = [NSString stringWithFormat:@"%@ - %@ - %@", ItemInfo[@"MAIN_CAT_TEXT"], ItemInfo[@"MID_CAT_TEXT"], ItemInfo[@"ITEM_NAME"]];
                if([ItemInfo[@"TAX_TYPE_TEXT"] isEqualToString:@"内税"]) {
                    int unit_amt = [ItemInfo[@"BUY_AMT"] intValue] - [ItemInfo[@"UNIT_AMT"] intValue];
                    Goods[@"unit"] = [CommonFunc getCommaString:[NSString stringWithFormat:@"%d", unit_amt]];
                } else {
                    NSString *goods_unit_str =[NSString stringWithFormat:@"%@", ItemInfo[@"UNIT_AMT"]];
                    Goods[@"unit"] = [CommonFunc getCommaString:goods_unit_str];
                }
                Goods[@"qty"] = [CommonFunc getCommaString:ItemInfo[@"QTY"]];
                Goods[@"price"] = [NSString stringWithFormat:@"%@", [CommonFunc getCommaString:ItemInfo[@"BUY_AMT"]]];
                [GoodsList addObject:Goods];
                
                goods_total += [ItemInfo[@"BUY_AMT"] intValue];
            }
            else {
                NSMutableDictionary *Consum = [[NSMutableDictionary alloc] init];
                Consum[@"name"] = [NSString stringWithFormat:@"%@ - %@ - %@", ItemInfo[@"MAIN_CAT_TEXT"], ItemInfo[@"MID_CAT_TEXT"], ItemInfo[@"ITEM_NAME"]];
                NSString *goods_unit_str =[NSString stringWithFormat:@"%@", ItemInfo[@"UNIT_AMT"]];
                Consum[@"unit"] = [CommonFunc getCommaString:goods_unit_str];
                //Consum[@"unit"] = [NSString stringWithFormat:@"%ld", [CommonFunc getCommaString:ItemInfo[@"UNIT_AMT"]
                Consum[@"qty"] = [CommonFunc getCommaString:ItemInfo[@"QTY"]];
                Consum[@"price"] = [NSString stringWithFormat:@"%@", [CommonFunc getCommaString:ItemInfo[@"BUY_AMT"]]];
                [ConsumList addObject:Consum];
                
                consum_total += [ItemInfo[@"BUY_AMT"] intValue];
            }
        }
    }
    
    GoodsTotalInfo[@"price"] = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", goods_total]];
    GoodsInfo[@"total"] = GoodsTotalInfo;
    GoodsInfo[@"list"] = GoodsList;
    PrintJson[@"Goods_Info"] = GoodsInfo;
    
    ConsumTotalInfo[@"price"] = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", consum_total]];
    ConsumInfo[@"total"] = ConsumTotalInfo;
    ConsumInfo[@"list"] = ConsumList;
    PrintJson[@"Consum_Info"] = ConsumInfo;
    
    PrintJson[@"Total_Price"] = [CommonFunc getCommaString:MapGoods[@"TotalSaleAmt"]];
    
    if ([configInfo[@"signpad_use"] isEqualToString:@"YES"])
        {
        if (_isOnline) {
            if (SlipDoc[@"signInfo"][@"SIGN_DATA"]) {
                PrintJson[@"Sign_Image"] = SlipDoc[@"signInfo"][@"SIGN_DATA"];
            }
            else {
                PrintJson[@"Sign_Image"] = @"";
            }
            
        }
        else {
            PrintJson[@"Sign_Image"] = SlipDoc[@"SIGN"];
        }
        }
    else {
        PrintJson[@"Sign_Image"] = @"";
    }
    
    
    return PrintJson;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading) return;
    [SVProgressHUD dismiss];
    [self AirPrintA4];
    [self terminateWebTask];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (webView.isLoading) return;
    [SVProgressHUD dismiss];
    [self terminateWebTask];
}

- (void)terminateWebTask
{
    [self.webview stopLoading];
    self.webview.delegate = nil;
    [self.webview removeFromSuperview];
    self.webview = nil;
}

- (void) AirPrintA4 {
    UIPrintInfo *pi = [UIPrintInfo printInfo];
    pi.outputType = UIPrintInfoOutputGeneral;
    pi.jobName = @"TaxFree Receipt";
    pi.orientation = UIPrintInfoOrientationPortrait;
    pi.duplex = UIPrintInfoDuplexLongEdge;
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.printInfo = pi;
    pic.printFormatter = self.webview.viewPrintFormatter;
    [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController *pic2, BOOL completed, NSError *error) {
        if (completed) {
            if (!self->_isOnline) {
                [self UpdateSlip];
            }
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:SLIP_CONFIRM preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        else {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:PRINT_FAILED preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }];
}

- (void) UpdateSlip:(NSNotification *) notification {
    if (_isOnline) {
        return;
    }
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"02" conditionField:SLIP_NO conditionValue:notification.userInfo[@"SlipNo"]];
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:REFUNDDT newValue:[CommonFunc getStringFromDate:[NSDate date]] conditionField:SLIP_NO conditionValue:notification.userInfo[@"SlipNo"]];
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:PRINT_CNT newValue:@"1" conditionField:SLIP_NO conditionValue:notification.userInfo[@"SlipNo"]];
    
    [self getDetailInfo];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:SLIP_CONFIRM preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
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

- (IBAction)btnEditRefund:(id)sender {
}
@end

