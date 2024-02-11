//
//  IssueViewController.m
//  TaxFree
//
//  Created by Smile on 30/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "IssueViewController.h"
#import <JWT/JWT.h>

@interface IssueViewController () {
    BOOL isEdit;
    NSString *dateType;
    UIView *darkBackground;
    NSMutableDictionary *ShopInfo;
    
    NSMutableArray *TableArray;
    NSMutableArray *AllCategoryList;
    NSMutableArray *MainCatList;
    NSMutableArray *MidCatList;
    NSMutableArray *ItemTypeList;
    
    NSMutableDictionary *MainCategory;
    NSMutableDictionary *MidCategory;
    NSMutableDictionary *ItemType;
    
    
    NSMutableArray *RefundTypeList;
    NSMutableDictionary *RefundType;
    
    NSMutableArray *SexList;
    NSMutableDictionary *Sex;
    
    NSMutableArray *ResidenceStateList;
    NSMutableDictionary *ResidenceState;
    
    NSMutableArray *PassportTypeList;
    NSMutableDictionary *PassportType;
    
    NSMutableArray *CountryList;
    
    NSMutableArray *buyHistoryList;
    
    NSDate *selectedDate;
    
    NSString *p_input_type;
    NSMutableDictionary *passportInfo;
    NSMutableArray *tempTableArray;
    
    NSMutableDictionary *configInfo;
    
    Epos2FilterOption *filteroption_;
    
    Epos2Printer *printer_;
    int printerSeries_;
    int lang_;
    
    NSMutableArray *Rct_SlipNoList;
    
    NSMutableArray *printSlipList;
    
    int nSlipTotalTaxAmt;
    int nSlipTotalBuyAmt;
    int nSlipTotalRefundAmt;
    int nSlipTotalFeeAmt;
    
    int nSlipTotalGoodsNoTaxBuyAmt;
    int nSlipTotalConsumsNoTaxBuyAmt;
    
    int total_merchant_fee_amt;
    int total_gtf_fee_amt;
    
    
    NSMutableDictionary *MapDocid;
    NSMutableDictionary *MapRetailer;
    NSMutableDictionary *MapGoods;
    NSMutableDictionary *MapTourist;
    
    NSInteger LanguageNo;
    UIImage *signImage;
    NSString *signinfo;
    NSInteger current_page;
    
    BOOL isPassport;
    BOOL input_TableArray_anyway;
    BOOL url_parsing_fail;
    
    NSString *IncompletedNo;
}

@end

@implementation IssueViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        filteroption_  = [[Epos2FilterOption alloc] init];
        [filteroption_ setDeviceType:EPOS2_TYPE_PRINTER];
        printer_ = nil;
        printerSeries_ = EPOS2_TM_M30;
        lang_ = EPOS2_MODEL_ANK;
        input_TableArray_anyway = NO;
        url_parsing_fail = NO;
        _btnSignCancel.layer.borderWidth = 2;
        _btnSignCancel.layer.borderColor = UIColor.redColor.CGColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _ItemTableView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanging:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PassportScanSuccess:) name:@"PassportScanSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(additionalInfoChanged:) name:@"AdditionalInfoChanged" object:nil];
    
    
    kAppDelegate.ScreenName = @"ISSUE";
    
    [CommonFunc saveArrayToLocal:nil key:TOTAL_ITEM_LIST];
    
    [self interfaceConfig];
    [self showShopInfo];
    [self getConfigInfo];
    
    _memoTextView.delegate = self;
    
    
    self.signatureViewController = [[UBSignatureDrawingViewController alloc] initWithImage:nil];
    self.signatureViewController.delegate = self;
    [self addChildViewController:self.signatureViewController];
    self.signatureViewController.view.frame = CGRectMake(0, 0, _signatureView.frame.size.width, _signatureView.frame.size.height);
    [_signatureView addSubview:self.signatureViewController.view];
    
    _signatureView.layer.borderColor = [UIColor blackColor].CGColor;
    _signatureView.layer.borderWidth = 1;
    
    if (![CommonFunc getValuesForKey:GUIDE_SHOWN]) {
        [CommonFunc saveUserDefaults:GUIDE_SHOWN value:@"Y"];
        _viewGuide.hidden = NO;
    }
    
    if ([CommonFunc getValuesForKey:LIMIT_SETTING_INFO]) {
        _mainScrollView.scrollEnabled = NO;
    }
    else {
        _mainScrollView.scrollEnabled = YES;
    }
    p_input_type = @"3";
    _memoTextView.text = @"メモテキスト";
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if (textView == _memoTextView) {
        
        if([textView.text  isEqual: @"メモテキスト"]) {
            _memoTextView.text = @"";
        }
        _memoTextView.textColor = [UIColor colorWithRed:76.0/255.0f green:111.0/255.0f blue:135.0/255.0f alpha:1.0];
    }
     
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        
        _memoTextView.text =  @"メモテキスト";
        _memoTextView.textColor = UIColor.lightGrayColor;
    }
}

- (void) textFieldDidChanging:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (textField == _txtPassportName) {
        if (_txtPassportName.text.length > 0) {
            NSString *lastCharactor = [_txtPassportName.text substringFromIndex:(_txtPassportName.text.length - 1)];
            if (![lastCharactor isEqualToString:@" "]) {
                if (![CommonFunc validateName:lastCharactor]) {
                    _txtPassportName.text = [_txtPassportName.text stringByReplacingOccurrencesOfString:lastCharactor withString:@""];
                }
            }
            _txtPassportName.text = [_txtPassportName.text uppercaseString];
        }
    }
    if (textField == _txtPassportNumber) {
        if (_txtPassportNumber.text.length > 0) {
            NSString *lastCharactor = [_txtPassportNumber.text substringFromIndex:(_txtPassportNumber.text.length - 1)];
            if (![CommonFunc validateNumber:lastCharactor]) {
                _txtPassportNumber.text = [_txtPassportNumber.text stringByReplacingOccurrencesOfString:lastCharactor withString:@""];
            }
            if (_txtPassportNumber.text.length > 15) {
                _txtPassportNumber.text = [_txtPassportNumber.text substringToIndex:15];
            }
            _txtPassportNumber.text = [_txtPassportNumber.text uppercaseString];
        }
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PrintNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - <UBSignatureDrawingViewControllerDelegate>
- (void)signatureDrawingViewController:(UBSignatureDrawingViewController *)signatureDrawingViewController isEmptyDidChange:(BOOL)isEmpty
{
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *ServerEnv = @"";
    NSString *TEST_URL = @"http://jp2admin.gtfetrs.com/service/jtc/";
    if ([API_URL isEqualToString:TEST_URL] == YES) {
        ServerEnv    = @"取引登録 .........TEST Version";
        _lblTitle.text = ServerEnv;
    }
    NSLog(@"ViewWillAppear 가 호출되고 있습니다....");  //만약 유지하고 싶다면 ViewDidAppear에 이 부분을 넣도록 한다.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateSlip:) name:@"PrintNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saledata_Matching:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    TableArray          = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:TOTAL_ITEM_LIST]];
    /*----------------------------------------------------------------------------------------------------------
    NSLog(@"TableArray의 값을 한번 찍어보자:: %@", TableArray);
    for(int i = 0; i < TableArray.count; i++) {
        NSMutableDictionary *temp_dict = [[NSMutableDictionary alloc] init];
        temp_dict = TableArray[i];
        NSLog(@"[%d]-------------------", i);
        NSLog(@"%@", temp_dict);
    }
    ------------------------------------------------------------------------------------------------------------*/
    [self FilterTableArray];
    [_ItemTableView reloadData];
}

- (void) get_PosData {
    NSLog(@"IssueViewChecking_____Param_string=%@", kAppDelegate.url_goods_param_str);
    NSArray *TempArray = [kAppDelegate.url_goods_param_str componentsSeparatedByString:@"?"];
    @try {
        [self FilterTableArray];
        for(int i = 0; i < kAppDelegate.url_goods_cnt; i++) {
            //NSLog(@"i=%d\t%@", i, [TempArray objectAtIndex:(i+2)]);
            NSMutableDictionary *Match_dic = [[NSMutableDictionary alloc] init];
            NSMutableDictionary *Temp_dic = [[NSMutableDictionary alloc] initWithDictionary:[self parseQueryString:[TempArray objectAtIndex:(i+2)]]];
            [Match_dic setObject:[Temp_dic objectForKey:@"Sale_amount"] forKey:@"BUY_AMT"];
            [Match_dic setObject:@"その他" forKey:@"ITEM_NAME"];
            [Match_dic setObject:[NSString stringWithFormat:@"%d", (i+1)] forKey:@"ITEM_NO"]; //물품 시퀀스 수
            if([[Temp_dic objectForKey:@"Goods_item_code"] isEqualToString:@"D"]) {
                [Temp_dic setObject:@"C" forKey:@"Goods_item_code"];
                [Temp_dic setObject:@"C0168" forKey:@"Goods_division"];
            }
            if([[Temp_dic objectForKey:@"Goods_item_code"] isEqualToString:@"E"]) {
                [Match_dic setObject:@"A0001" forKey:@"ITEM_TYPE"];
                [Match_dic setObject:@"一般品" forKey:@"ITEM_TYPE_TEXT"];
            } else {
                [Match_dic setObject:@"A0002" forKey:@"ITEM_TYPE"];
                [Match_dic setObject:@"消耗品" forKey:@"ITEM_TYPE_TEXT"];
            }
            [Match_dic setObject:[Temp_dic objectForKey:@"Goods_cnt"] forKey:@"QTY"];
            [Match_dic setObject:kAppDelegate.url_rec_no forKey:@"RCT_NO"];
            int tax = [[Temp_dic objectForKey:@"Tax_amount"] intValue];
            if(tax == 0) {
                int buy_amount = [[Temp_dic objectForKey:@"Sale_amout"] intValue];
                float tax_formula = [[Temp_dic objectForKey:@"Tax_rate"] intValue] * 0.01 ;
                if([[Temp_dic objectForKey:@"Tax_type_code"] isEqualToString:@"01"]) {  //내세임
                    tax = buy_amount - [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount / (tax_formula + 1))];
                    NSLog(@"[내세] 계산한 TAX:: %d", tax);
                } else {                                                                //외세임
                    tax = [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount * tax_formula)];
                    NSLog(@"[외세] 계산한 TAX:: %d", tax);
                }
            }
            ////////////////////////////////////
            int merchant_fee = 0;
            int gtf_fee = 0;
            int refund = 0;
            BOOL isFeeYN = NO;
            NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
            if (feeSettingInfo) {
                isFeeYN = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
            }
            if (isFeeYN) {
                NSMutableDictionary *feeInfo = feeSettingInfo[@"fee_info"][0];
                if ([feeInfo[@"fee_type"] isEqualToString:@"0"]) {
                    refund = tax;
                }
                else if ([feeInfo[@"fee_type"] isEqualToString:@"1"]) {
                    refund = [self getFixAmt:@"04" oldValue:(1 - [feeInfo[@"gtf_fee"] floatValue]) * tax];
                    gtf_fee = tax - refund;
                }
                else if ([feeInfo[@"fee_type"] isEqualToString:@"2"]) {
                    refund = [self getFixAmt:@"04" oldValue:(1 - [feeInfo[@"merchant_fee"] floatValue] - [feeInfo[@"gtf_fee"] floatValue]) * tax];
                    merchant_fee = [self getFixAmt:@"04" oldValue:[feeInfo[@"merchant_fee"] floatValue] * tax];
                    gtf_fee = tax - refund - merchant_fee;
                }
                else if ([feeInfo[@"fee_type"] isEqualToString:@"3"]) {
                    refund = [self getFixAmt:@"04" oldValue:(1 - [feeInfo[@"merchant_fee"] floatValue]) * tax];
                    merchant_fee = tax - refund;
                }
            }
            else {
                float fee_rate = [ShopInfo[@"FEE_RATE"] floatValue];
                refund = tax - [self getFixAmt:ShopInfo[@"FEE_POINT_PROC_CODE"] oldValue:(tax * fee_rate)];
            }
            
            NSLog(@"REFUND_AMT:: %i", refund);
            NSLog(@"MERCHANT_FEE_AMT:: %i", merchant_fee);
            NSLog(@"GTF_FEE_AMT:: %i", gtf_fee);
            /////////////////////////////////
            [Match_dic setObject:[NSString stringWithFormat:@"%i", tax - refund] forKey:@"FEE_AMT"];
            [Match_dic setObject:[NSString stringWithFormat:@"%d", refund]  forKey:@"REFUND_AMT"];
            [Match_dic setObject:[NSString stringWithFormat:@"%d", merchant_fee]  forKey:@"MERCHANT_FEE_AMT"];
            [Match_dic setObject:[NSString stringWithFormat:@"%d", gtf_fee]  forKey:@"GTF_FEE_AMT"];
            
            [Match_dic setObject:ShopInfo[@"MERCHANT_JPNM"] forKey:@"SHOP_NAME"];
            [Match_dic setObject:ShopInfo[@"MERCHANT_NO"] forKey:@"SHOP_NO"];
            [Match_dic setObject:[Temp_dic objectForKey:@"Tax_amount"] forKey:@"TAX_AMT"];
            double TaxValue = ([[Temp_dic objectForKey:@"Tax_rate"] doubleValue] / 100);
            [Match_dic setObject:[NSString stringWithFormat:@"%.6lf", TaxValue] forKey:@"TAX_FORMULA"];
            if((TaxValue*100) == 8) {
                [Match_dic setObject:@"01" forKey:@"TAX_TYPE"];                 // 8%
                [Match_dic setObject:@"1" forKey:@"TAX_TYPE_CODE"];
            } else {
                [Match_dic setObject:@"02" forKey:@"TAX_TYPE"];
                [Match_dic setObject:@"2" forKey:@"TAX_TYPE_CODE"];
            }
            if([[Temp_dic objectForKey:@"Tax_type_code"] isEqualToString:@"01"]) {  //내세임
                [Match_dic setObject:@"内税" forKey:@"TAX_TYPE_TEXT"];
            }   else {                                                              //외세임
                [Match_dic setObject:@"外税" forKey:@"TAX_TYPE_TEXT"];
            }
            if([[Temp_dic objectForKey:@"Goods_unit_price"] length] == 0) {
                NSLog(@"단가 정보가 0으로 들어와서 판매가격을 넣습니다..");
                [Match_dic setObject:[Temp_dic objectForKey:@"Sale_amount"] forKey:@"UNIT_AMT"];
            }
            else [Match_dic setObject:[Temp_dic objectForKey:@"Goods_unit_price"] forKey:@"UNIT_AMT"];
            [Match_dic setObject:kAppDelegate.LoginID forKey:@"USERID"];
            [Match_dic setObject:[Temp_dic objectForKey:@"Goods_division"] forKey:@"MID_CAT"];
            
            [self url_interfaceConfig: Match_dic];
            [self getMainCatList];
            [self getMidCatList];
            [self setItemKind:Match_dic];
            NSLog(@"MidCategory:: %@", MidCategory);
            NSLog(@"MidCatList:: %@", MidCatList);
            if(MidCategory.count == 0) {
                url_parsing_fail = YES;
                NSLog(@"Goods_division_code Error!");
                [self.view makeToast:@"エラー Goods_divisionに誤りがあります。入力内容を再度ご確認ください。"];
//                UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"エラー" message:@"エラー Goods_divisionに誤りがあります。入力内容を再度ご確認ください。" preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    [alert dismissViewControllerAnimated:YES completion:nil];
//                }];
//                [alert addAction:ok];
//                [self presentViewController:alert animated:YES completion:nil];
            }
            [Match_dic setObject:[MidCategory objectForKey:@"CATEGORY_NAME"] forKey:@"MID_CAT_TEXT"];
            [Match_dic setObject:[MidCategory objectForKey:@"P_CODE"] forKey:@"MAIN_CAT"];
            [self getMainCatList];
            [self setItemKind:Match_dic];
            [Match_dic setObject:[MainCategory objectForKey:@"CATEGORY_NAME"] forKey:@"MAIN_CAT_TEXT"];
                    NSLog(@"MainCategory:: %@", MainCategory);
                    NSLog(@"MainCatList:: %@", MainCatList);
            NSLog(@"BUY_AMT=%@"         , [Match_dic objectForKey:@"BUY_AMT"]);
            NSLog(@"ITEM_NAME=%@"       , [Match_dic objectForKey:@"ITEM_NAME"]);
            NSLog(@"ITEM_NO=%@"         , [Match_dic objectForKey:@"ITEM_NO"]);
            NSLog(@"ITEM_TYPE=%@"       , [Match_dic objectForKey:@"ITEM_TYPE"]);
            NSLog(@"ITEM_TYPE_TEXT=%@"  , [Match_dic objectForKey:@"ITEM_TYPE_TEXT"]);
            NSLog(@"QTY=%@"             , [Match_dic objectForKey:@"QTY"]);
            NSLog(@"RCT_NO=%@"          , [Match_dic objectForKey:@"RCT_NO"]);
            NSLog(@"FEE_AMT=%@"         , [Match_dic objectForKey:@"FEE_AMT"]);
            NSLog(@"REFUND_AMT=%@"      , [Match_dic objectForKey:@"REFUND_AMT"]);
            NSLog(@"SHOP_NAME=%@"       , [Match_dic objectForKey:@"SHOP_NAME"]);
            NSLog(@"SHOP_NO=%@"         , [Match_dic objectForKey:@"SHOP_NO"]);
            NSLog(@"TAX_AMT=%@"         , [Match_dic objectForKey:@"TAX_AMT"]);
            NSLog(@"TAX_FORMULA=%@"     , [Match_dic objectForKey:@"TAX_FORMULA"]);
            NSLog(@"TAX_TYPE=%@"        , [Match_dic objectForKey:@"TAX_TYPE"]);
            NSLog(@"TAX_TYPE_CODE=%@"   , [Match_dic objectForKey:@"TAX_TYPE_CODE"]);
            NSLog(@"TAX_TYPE_TEXT=%@"   , [Match_dic objectForKey:@"TAX_TYPE_TEXT"]);
            NSLog(@"UNIT_AMT=%@"        , [Match_dic objectForKey:@"UNIT_AMT"]);
            NSLog(@"USERID=%@"          , [Match_dic objectForKey:@"USERID"]);
            NSLog(@"MAIN_CAT=%@"        , [Match_dic objectForKey:@"MAIN_CAT"]);
            NSLog(@"MAIN_CAT_TEXT=%@"   , [Match_dic objectForKey:@"MAIN_CAT_TEXT"]);
            NSLog(@"MID_CAT=%@"         , [Match_dic objectForKey:@"MID_CAT"]);
            NSLog(@"MID_CAT_TEXT=%@"    , [Match_dic objectForKey:@"MID_CAT_TEXT"]);
            [TableArray addObject:Match_dic];
        }
        [CommonFunc saveArrayToLocal:TableArray key:TOTAL_ITEM_LIST];
    }
    @catch(NSException *exception) {
         url_parsing_fail = YES;
     }
    [_ItemTableView reloadData];
}
- (int) getFixAmt:(NSString *)strType oldValue: (float)oldValue
{
    int nAmt = 0;
    
    NSString *oldString = [NSString stringWithFormat:@"%.1f", oldValue];
    if      ([strType isEqualToString:@"03"])       nAmt = (int)lround  ([oldString floatValue]);
    else if ([strType isEqualToString:@"04"])       nAmt = (int)ceil    ([oldString floatValue]);
    else                                            nAmt = (int)floor   ([oldString floatValue]);
    
    return nAmt;
}
- (void) url_interfaceConfig : (NSMutableDictionary *)Match_dic {
    
    NSMutableArray *merchantList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:MERCHANT_TABLE_KIND]];
    NSLog(@"merchantList:: %@", merchantList);
    if (merchantList.count > 0) {
        ShopInfo = [[NSMutableDictionary alloc] initWithDictionary:merchantList[0]];
    }
    
    if ([ShopInfo[@"SALEGOODS_USEYN"] isEqualToString:@"M"]) {
        //isMidCat = YES;
        // _dropMainCat.hidden = YES;
    }
    else {
        //_dropMidCat.hidden = YES;
    }
    AllCategoryList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:CATEGORY_TABLE_KIND]];
    NSLog(@"AllCategoryList:: %@", AllCategoryList);
    MainCategory = [[NSMutableDictionary alloc] init];
    MidCategory = [[NSMutableDictionary alloc] init];
    ItemTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"ItemType.json"][@"data"]];
    ItemType = [[NSMutableDictionary alloc] init];
    //이 부분은 원래 TableView Delegate부분에 있었는데 어디에다가 넣어야할지 생각해보기
    NSLog(@"Match_dic / item_type value:: %@", [Match_dic objectForKey:@"ITEM_TYPE"]);
    if ([[Match_dic objectForKey:@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
        ItemType = ItemTypeList[0];
    }
    else {
        ItemType = ItemTypeList[1];
    }
    NSLog(@"ItemType:: %@", ItemType);
}

- (void) setItemKind:(NSMutableDictionary *)ItemInfo {
    NSLog(@"ItemInfo가 실행되고 있습니다....");
    if (ItemInfo) {
        for (int i = 0; i < MainCatList.count; i++) {
            if ([MainCatList[i][@"CATEGORY_CODE"] isEqualToString:ItemInfo[@"MAIN_CAT"]]) {
                MainCategory = [[NSMutableDictionary alloc] initWithDictionary:MainCatList[i]];
            }
        }
        for (int i = 0; i < MidCatList.count; i++) {
            if ([MidCatList[i][@"CATEGORY_CODE"] isEqualToString:ItemInfo[@"MID_CAT"]]) {
                MidCategory = [[NSMutableDictionary alloc] initWithDictionary:MidCatList[i]];
            }
        }
    }
    else {
        MainCategory = MainCatList[0];
        MidCategory = MidCatList[0];
    }
}

- (void) getMainCatList {
    NSLog(@"getMainCatList가 실행되고 있습니다....");
    MainCatList = [[NSMutableArray alloc] init];
    NSString *groupCodes = ShopInfo[@"GOODS_GROUP_CODE"];
    NSArray *array = [[NSArray alloc] initWithArray:[groupCodes componentsSeparatedByString:@","]];
    NSLog(@"ItemType:: %@",ItemType[@"id"] );
    for (int i = 0; i < AllCategoryList.count; i++) {
        for (int j = 0; j < array.count; j++) {
            if ([AllCategoryList[i][@"P_CODE"] isEqualToString:ItemType[@"id"]] && [array[j] isEqualToString:AllCategoryList[i][@"CATEGORY_CODE"]]) {
                [MainCatList addObject:AllCategoryList[i]];
            }
        }
    }
    NSLog(@"MainCatList:: %@", MainCatList);
}

- (void) getMidCatList {
    NSLog(@"getMidCatList가 실행되고 있습니다....");
    MidCatList = [[NSMutableArray alloc] init];
    NSString *divisions = ShopInfo[@"GODDS_DIVISION"];
    NSArray *array = [[NSArray alloc] initWithArray:[divisions componentsSeparatedByString:@","]];
    
    for (int i = 0; i < AllCategoryList.count; i++) {
        for (int j = 0; j < array.count; j++) {
            for (int k = 0; k < MainCatList.count; k++) {
                if ([AllCategoryList[i][@"P_CODE"] isEqualToString:MainCatList[k][@"CATEGORY_CODE"]] && [array[j] isEqualToString:AllCategoryList[i][@"CATEGORY_CODE"]]) {
                    [MidCatList addObject:AllCategoryList[i]];
                }
            }
        }
    }
}

- (NSDictionary*) parseQueryString:(NSString *)_query
{
    NSMutableDictionary* pDic = [NSMutableDictionary dictionary];
    NSString *Error_Key = @"";
    url_parsing_fail = NO;
    @try {
        NSArray* pairs = [_query componentsSeparatedByString:@"&"];
        for (NSString* sObj in pairs) {
            NSArray* elements = [sObj componentsSeparatedByString:@"="];
            Error_Key = [elements objectAtIndex:0];
            NSString* key =     [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
            NSString* value =   [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
            //값을 파싱하며 공백이나 null 로 들어온 값이 있는지 체크한다...
            if(![key isEqualToString:@"Goods_name"]) value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
            if(![key isEqualToString:@"Goods_unit_price"]) {
                if([value length] == 0) {
                    url_parsing_fail = YES;
                    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Parsing エラー" message:[NSString stringWithFormat:@"'%@'エラーが発生しました。未入力項目はないかご確認ください。", key] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                        [alert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            if(![value isEqualToString:@"Goods_name"])    [pDic setObject:value forKey:key];
            //if(![key isEqualToString:@"Goods_name"])    [pDic setObject:value forKey:key];
            
        }
    }
    @catch(NSException *exception) {
        url_parsing_fail = YES;
        NSLog(@"Error getting parameter name '%@' or next to '%@'", Error_Key, Error_Key);
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Parsing エラー" message:[NSString stringWithFormat:@"エラーが発生しました。パラメータの項目 '%@' もしくは '%@' の次の項目情報を呼び出せません。", Error_Key, Error_Key] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSLog(@"pDic의 값을 한번 확인해봅시다!! :: %@" , pDic);
    return pDic;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"ViewDidAppear이 호출되었습니다");

    if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"V"]) && (!kAppDelegate.call_by_url_canceled)) {
        //메세지 창을 띄워서 물어보고 YES를 선택했을 때만 제어를 옮기도록 한다... 혹은 무조건 확인만 누르게 하거나....
        MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
        UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
        if (![kAppDelegate.ScreenName isEqualToString:@"OnlineSearch"]) {
            OnlineSearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlineSearch"];
            [navigationController pushViewController:controller animated:NO];
        }
        [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
    else {
        int result = [Epos2Discovery start:filteroption_ delegate:self];
        
        if (EPOS2_SUCCESS != result) {
            //        [ShowMsg showErrorEpos:result method:@"start"];
        }
        if((kAppDelegate.call_by_url_scheme) && (!kAppDelegate.call_by_url_issued)) {
            //값이 이미 TableView에 입력되었는지 체크한다.
            //입력값이 다를 때 메세지 창 하나 더 띄워서 의사를 물어보도록 하면 될 것 같다.
            if([kAppDelegate.url_issue_status isEqualToString:@"I"]) {      //발행 데이터라면
                if(TableArray.count == 0)     [self get_PosData];
                else if(input_TableArray_anyway) {
                    TableArray = [[NSMutableArray alloc] init];
                    [self get_PosData];
                    input_TableArray_anyway = NO;
                }
                if(url_parsing_fail) {
                    NSString *parameter_str;
                    //parameter_str = [NSString stringWithFormat:@"TestCustomURL://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                    parameter_str = [NSString stringWithFormat:@"%@://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                                     , kAppDelegate.url_scheme_addr, @"F", kAppDelegate.url_issue_status, kAppDelegate.url_rec_no, kAppDelegate.url_gtf_slip_no];
                    //kAppDelegate.call_by_url_issued = TRUE;
                    kAppDelegate.call_by_url_issued = FALSE;
                    //다시 호출했던 앱으로 제어가 돌아가도록 한다...................
                    kAppDelegate.call_by_url_scheme = FALSE;
                    kAppDelegate.url_rec_no = nil;
                    NSLog(@"IssueViewController입니다.... %@", parameter_str);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"TestCustomURL://"]];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parameter_str] options:@{} completionHandler:nil];
                    });
                }
            }
        }
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

- (void) EpsonPrint {
    if ([self runPrintReceiptSequence]) {
        for (int i = 0; i < printSlipList.count; i++) {
            [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"02" conditionField:SLIP_NO conditionValue:printSlipList[i][@"SLIP"][SLIP_NO]];
            [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:REFUNDDT newValue:[CommonFunc getStringFromDate:[NSDate date]] conditionField:SLIP_NO conditionValue:printSlipList[i][@"SLIP"][SLIP_NO]];
            [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:PRINT_CNT newValue:@"1" conditionField:SLIP_NO conditionValue:printSlipList[i][@"SLIP"][SLIP_NO]];
        }
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:SLIP_CONFIRM preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertView dismissViewControllerAnimated:YES completion:nil];
            //현금
            if ([self->RefundType[@"id"] isEqualToString:@"01"]) {
                [self.view makeToast:[NSString stringWithFormat:@"%@ : %i", REFUND_CASH, self->nSlipTotalRefundAmt]];
            }
            //카드
            else if ([self->RefundType[@"id"] isEqualToString:@"04"]) {
                [self.view makeToast:[NSString stringWithFormat:@"%@ : %i", REFUND_CARD, self->nSlipTotalRefundAmt]];
            }
            //QQ
            else if ([self->RefundType[@"id"] isEqualToString:@"06"]) {
                [self.view makeToast:[NSString stringWithFormat:@"%@ : %i", REFUND_QQ, self->nSlipTotalRefundAmt]];
            }
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
}

- (BOOL)runPrintReceiptSequence
{
    if (![self initializeObject]) {
        return NO;
    }
    
    for (int i = 0; i < printSlipList.count; i++) {
        NSMutableDictionary *tmpDocs = [[NSMutableDictionary alloc] initWithDictionary:printSlipList[i][@"DOCS"]];
        
        NSString *tmpDocid = tmpDocs[@"DOCID"];
        tmpDocid = [tmpDocid stringByReplacingOccurrencesOfString:@"[REPUBLISH]" withString:@"0"];
        NSString *tmpRetailer = tmpDocs[@"RETAILER"];
        NSString *tmpGoods = tmpDocs[@"GOODS"];
        tmpGoods = [tmpGoods stringByReplacingOccurrencesOfString:@"[COMSUMS_TOTAL]" withString:[NSString stringWithFormat:@"%i", nSlipTotalConsumsNoTaxBuyAmt]];//치환. 세금제외 금액으로.
        
        tmpGoods = [tmpGoods stringByReplacingOccurrencesOfString:@"[GOODS_TOTAL]" withString:[NSString stringWithFormat:@"%i", nSlipTotalGoodsNoTaxBuyAmt]];//치환. 세금제외 금액으로.
        tmpDocs[@"GOODS"] = tmpGoods;
        NSString *tmpTourist = tmpDocs[@"TOURIST"];
        
        MapDocid = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseDocid:tmpDocid]];
        MapRetailer = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseRetailer:tmpRetailer]];
        MapGoods = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseGoods:tmpGoods]];
        MapTourist = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseTourist:tmpTourist]];
        
        NSMutableArray *PublishTypeList = MapDocid[@"PublishType"];
        for (NSString *Type in PublishTypeList) {
            if (![self eventPrintDoc:Type isGoods:@"1"]) {
                [self finalizeObject];
                return NO;
            }
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

- (void)updateButtonState:(BOOL)state
{
    _btnRefund.enabled = state;
    _btnClear.enabled = state;
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

-(BOOL)connectPrinter
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

- (void) FilterTableArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < TableArray.count; i++) {
//        if ([TableArray[i][@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
//            [tempArray addObject:TableArray[i]];
//        }
//    }
//    for (int i = 0; i < TableArray.count; i++) {
//        if (![TableArray[i][@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
//            [tempArray addObject:TableArray[i]];
//        }
//    }
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ITEM_NO" ascending:YES comparator:^(id obj1, id obj2) {
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
        if ([sortedArray[i][@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
            [tempArray addObject:sortedArray[i]];
        }
    }
    
    for (int i = 0; i < sortedArray.count; i++) {
        if (![sortedArray[i][@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
            [tempArray addObject:sortedArray[i]];
        }
    }
    TableArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    int real_pay_amt = 0;
    int total_buy_amt = 0;
    int total_tax_amt = 0;
    int total_fee_amt = 0;
    int total_refund_amt = 0;
    total_merchant_fee_amt = 0;
    total_gtf_fee_amt = 0;
    for (int i = 0; i < TableArray.count; i++) {
        real_pay_amt += [TableArray[i][@"BUY_AMT"] intValue] + [TableArray[i][@"FEE_AMT"] intValue];
        if ([TableArray[i][@"TAX_TYPE"] isEqualToString:@"02"]) {
            real_pay_amt -= [TableArray[i][@"TAX_AMT"] intValue];
        }
        total_buy_amt += [TableArray[i][@"BUY_AMT"] intValue];
        total_tax_amt += [TableArray[i][@"TAX_AMT"] intValue];
        total_fee_amt += [TableArray[i][@"FEE_AMT"] intValue];
        total_refund_amt += [TableArray[i][@"REFUND_AMT"] intValue];
        total_merchant_fee_amt += [TableArray[i][@"MERCHANT_FEE_AMT"] intValue];
        total_gtf_fee_amt += [TableArray[i][@"GTF_FEE_AMT"] intValue];
    }
    _lblRealPayAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", real_pay_amt]];
    
    _lblRFBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", total_buy_amt]];
    _lblRFTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", total_tax_amt]];
    _lblRFFeeAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", total_fee_amt]];
    _lblRFRefundAmt.text = [NSString stringWithFormat:@"-%@", [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", total_refund_amt]]];
    _lblRFPayAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%i", real_pay_amt]];
}

- (IBAction)PassportChangeClick:(id)sender {
    isPassport = !isPassport;
    [self PassportChanged];
    
    if (isPassport) {
        isEdit = NO;
        [self ChangeEditableIssue];
        ResidenceState = ResidenceStateList[0];
        [self.view makeToast:@"上陸許可書モードからパスポート番号モードに変更します。 在留資格の確認をお願いいたします。"];
    }
    else {
        isEdit = YES;
        [self ChangeEditableIssue];
        [_txtPassportNumber becomeFirstResponder];
        ResidenceState = ResidenceStateList[1];
    }
    self.viewAddInfo.hidden = YES;
    kAppDelegate.AdditionalInfo = nil;
    _txtResidenceState.text = ResidenceState[LANGUAGE];
}

- (void) PassportChanged {
    if (isPassport) {
        _lblPassportNumber.text = @"旅券番号";
        isEdit = NO;
    }
    else {
        _lblPassportNumber.text = @"上陸許可番号";
        isEdit = YES;
    }
    
    _btnCamera.hidden = !isPassport;
    _btnQRScan.hidden = !isPassport;
    _btnEdit.hidden = !isPassport;
    _txtPassportNumber.text = @"";
    
    [self ChangeEditableIssue];
}

- (void) interfaceConfig {
    
    isPassport = YES;
    [self PassportChanged];
    
    _btnLeft.layer.cornerRadius = 10;
    _btnLeft.clipsToBounds = YES;
    
    _btnRight.layer.cornerRadius = 10;
    _btnRight.clipsToBounds = YES;
    
    _btnLeft2.layer.cornerRadius = 10;
    _btnLeft2.clipsToBounds = YES;
    
    _btnRight2.layer.cornerRadius = 10;
    _btnRight2.clipsToBounds = YES;
    
    [self PageConfig];
    
    selectedDate = [NSDate date];
    _lblRefundDate.text = [CommonFunc getDateStringWithFormat:selectedDate format:@"yyyy-MM-dd"];
    
    _viewCardNumber.layer.cornerRadius = _viewCardNumber.frame.size.height/2;
    _txtCardNumber.delegate = self;
    
    _viewField.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _viewField.layer.shadowOpacity = 0.5;
    _viewField.layer.shadowRadius = 2.0;
    _viewField.layer.cornerRadius = 8;
    
    _mainScrollView.delegate = self;
    
    _txtPassportName.delegate = self;
    _txtPassportNumber.delegate = self;
    _txtNationality.delegate = self;
    
    
    _dropIconNationality.frame = CGRectMake(_btnNationality.frame.size.width - 10, 20, 10, 10);
    [_btnNationality addSubview:_dropIconNationality];
    
    _dropIconSex.frame = CGRectMake(_btnSex.frame.size.width - 10, 20, 10, 10);
    [_btnSex addSubview:_dropIconSex];
    
    
    _btnRefundDate.layer.cornerRadius = _btnRefundDate.frame.size.height/2;
    _btnRefundDate.clipsToBounds = YES;
    
    _btnRefundType.layer.cornerRadius = _btnRefundType.frame.size.height/2;
    _btnRefundType.clipsToBounds = YES;
    
    _backReceiptNo.layer.cornerRadius = _backReceiptNo.frame.size.height / 2;
    _backReceiptNo.clipsToBounds = YES;
    
    _ItemTableView.dataSource = self;
    _ItemTableView.delegate = self;
    _ItemTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    
    darkBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    darkBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _viewMessage.layer.cornerRadius = 12;
    _btnOk.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnOk.clipsToBounds = YES;
    
    _btnCancel.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnCancel.layer.borderColor = _btnOk.backgroundColor.CGColor;
    _btnCancel.layer.borderWidth = 1;
    _btnCancel.clipsToBounds = YES;
    
    _viewSignPad.layer.cornerRadius = 12;
    
    _btnSignRefund.layer.cornerRadius = _btnSignRefund.frame.size.height / 2.0;
    _btnSignRefund.clipsToBounds = YES;
    
    _btnSignCancel.layer.cornerRadius = _btnSignCancel.frame.size.height / 2.0;
    _btnSignCancel.layer.borderColor = _btnSignRefund.backgroundColor.CGColor;
    _btnSignCancel.layer.borderWidth = 1;
    _btnSignCancel.clipsToBounds = YES;
    
    RefundTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"RefundType.json"][@"data"]];
    SexList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"Sex.json"][@"data"]];
    ResidenceStateList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"ResidenceState.json"][@"data"]];
    PassportTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"PassportType.json"][@"data"]];
    
    NSMutableArray *allCodeList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:CODE_TABLE_KIND]];
    NSArray *beforeCountryCode = @[@"CHN", @"KOR", @"TWN", @"THA", @"SGP", @"USA", @"JPN", @"PHL", @"MYS", @"NPL", @"DEU", @"ISL", @"VNM", @"MNG"];
    
    CountryList = [[NSMutableArray alloc] init];
    for (int i = 0; i < allCodeList.count; i++) {
        if ([allCodeList[i][@"CODEDIV"] isEqualToString:@"COUNTRY_CODE"]) {
            [CountryList addObject:allCodeList[i]];
        }
    }
    
    NSMutableArray *beforeList = [[NSMutableArray alloc] init];
    for (int j = 0; j < beforeCountryCode.count; j++) {
        for (int i = 0; i < CountryList.count; i++) {
            if ([CountryList[i][@"COMCODE"] isEqualToString:beforeCountryCode[j]]) {
                [beforeList insertObject:CountryList[i] atIndex:0];
                [CountryList removeObjectAtIndex:i];
            }
        }
    }
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"COMCODE" ascending:YES];
    NSMutableArray * sortedArray = [NSMutableArray arrayWithArray:[CountryList sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
    CountryList = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    for (int i = 0; i < beforeList.count; i++) {
        [CountryList insertObject:beforeList[i] atIndex:0];
    }
    
    
    RefundType = [[NSMutableDictionary alloc] init];
    Sex = [[NSMutableDictionary alloc] init];
    ResidenceState = [[NSMutableDictionary alloc] init];
    PassportType = [[NSMutableDictionary alloc] init];
    
    RefundType= RefundTypeList[0];
    Sex= SexList[0];
    ResidenceState= ResidenceStateList[0];
    PassportType= PassportTypeList[0];
    
    _lblRefundType.text = RefundType[LANGUAGE];
    _txtSex.text = Sex[LANGUAGE];
    _txtResidenceState.text = ResidenceState[LANGUAGE];
    _txtPassportType.text = PassportType[LANGUAGE];
    
    //    _txtDateLanding.text = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyy.MM.dd"];
    _txtDateLanding.text = @"";
    
    NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
    BOOL isFeeYN = NO;
    if (feeSettingInfo) {
        isFeeYN = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
    }
    _viewRealPayAmt.hidden = !isFeeYN;
}


- (void) showShopInfo {
    NSMutableArray *merchantList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:MERCHANT_TABLE_KIND]];
    if (merchantList.count > 0) {
        ShopInfo = [[NSMutableDictionary alloc] initWithDictionary:merchantList[0]];
        _txtShopName.text = ShopInfo[@"MERCHANT_JPNM"];
        _txtShopType.text = ShopInfo[@"BIZ_INDUSTRY_CODE"];
        _txtShopType2.text = ShopInfo[@"INDUSTRY_CODE"];
        _txtShopManager.text = ShopInfo[@"SALE_MANAGER_CODE"];
        _txtShopAddress.text = [NSString stringWithFormat:@"%@ %@", ShopInfo[@"JP_ADDR1"], ShopInfo[@"JP_ADDR2"]];
        _txtPhoneNo.text = ShopInfo[@"TEL_NO"];
        _txtTaxOffice.text = ShopInfo[@"TAXOFFICE_NAME"];
    }
}

- (void) getConfigInfo {
    if ([CommonFunc getValuesForKey:CONFIG_INFO]) {
        configInfo = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getValuesForKey:CONFIG_INFO]];
    }
    else {
        configInfo = [[NSMutableDictionary alloc] init];
        configInfo[@"terminal_id"] = [[DatabaseManager sharedInstance] readData:TERMINAL_TABLE_KIND][0][@"TML_NO"];
        configInfo[@"passport_scanner"] = @"端末のカメラ";
        configInfo[@"printer"] = @"80mm";
        configInfo[@"receipt_add"] = @"YES";
        configInfo[@"signpad_use"] = @"YES";
        configInfo[@"print_choice"] = @"03";
        configInfo[@"password"] = @"123456789";
        [CommonFunc saveUserDefaults:CONFIG_INFO value:configInfo];
    }
}

- (IBAction)RefundDateClick:(id)sender {
    
    //    calendarKind = @"Refund";
    //    NSDate *date = [CommonFunc getDateFromString:_lblRefundDate.text format:@"yyyy-MM-dd"];
    //    [self OpenCalendar:date];
}

- (IBAction)RefundTypeClick:(id)sender {
    //    [self.view endEditing:YES];
    //    NSMutableArray *arr = [[NSMutableArray alloc] init];
    //    for (int i = 0; i < RefundTypeList.count; i++) {
    //        YCMenuAction *action = [YCMenuAction actionWithTitle:RefundTypeList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
    //            self->RefundType = self->RefundTypeList[i];
    //            self->_lblRefundType.text = action.title;
    //            [self RefundTypeChanged];
    //        }];
    //        [arr addObject:action];
    //    }
    //    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    //    [view show];
}

- (void) RefundTypeChanged {
    _txtCardNumber.text = @"";
    if ([RefundType[@"id"] isEqualToString:@"01"]) {
        _viewCardNumber.hidden = YES;
    }
    else {
        _viewCardNumber.hidden = NO;
        [_txtCardNumber becomeFirstResponder];
    }
}

- (IBAction)PassportQRScanClick:(id)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.qrCodeNavigationTitle = @"QRコードスキャン";
    //    __weak typeof(self) weakSelf = self;
    [qrCode QRCodeScanningWithViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self validatePassportQRCode:strValue];
        });
    } failure:^(NSString *message) {
        NSLog(@"Scan error = %@ ", message);
    }];
}

- (void)validatePassportQRCode:(NSString *)qrString {
    NSError *decodeError = nil;
    NSDictionary *result = [JWT decodeMessage:qrString withSecret:@"" withError:&decodeError withForcedAlgorithmByName:@"ES256" skipVerification:YES];
    if (result == nil) {
        NSLog(@"QR 디코드 오류 %@", decodeError.localizedDescription);
        return;
    }
    
    p_input_type = @"2";
    NSLog(@"QR 여권 자료 : %@", result);
    
    BOOL validName = NO;
    BOOL validNational = NO;
    BOOL validExpiry = NO;
    BOOL validDOB = NO;
    BOOL validLanding = NO;
    
    _txtPassportName.text = result[@"payload"][@"name"];
    if(_txtPassportName.text.length >= 6) {
        validName = YES;
    }
    _txtPassportNumber.text = result[@"payload"][@"passportNo"];

    NSString *nationality_code = result[@"payload"][@"nation"];
    
    for (int i = 0; i < CountryList.count; i++) {
        if ([nationality_code isEqualToString:CountryList[i][@"COMCODE"]]) {
            _txtNationality.placeholder = CountryList[i][@"ATTRIB02"];
            _txtNationality.text = nationality_code;
            validNational = YES;
        }
    }
    NSDate *dobDate = [CommonFunc getDateFromString:result[@"payload"][@"birth"] format:@"yyyyMMdd"];
    if (dobDate) {
        if ([dobDate timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970]) {
            validDOB = YES;
            _txtDOB.text = [CommonFunc getDateStringWithFormat:dobDate format:@"yyyy.MM.dd"];
        }
    }

    NSDate *expiryDate = [CommonFunc getDateFromString:result[@"payload"][@"expirationDate"] format:@"yyyyMMdd"];
    if (expiryDate) {
        if ([expiryDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
            validExpiry = YES;
            _txtExpiry.text = [CommonFunc getDateStringWithFormat:expiryDate format:@"yyyy.MM.dd"];
        }
    }
    
    NSString *residence_type = result[@"payload"][@"status"];
    if (residence_type) {
        for (int i = 0; i < ResidenceStateList.count; i++) {
            if ([residence_type isEqualToString:@"11"]) {
                if ([self->ResidenceStateList[i][@"id"] isEqualToString:@"01"]) {
                    self->ResidenceState = self->ResidenceStateList[i];
                    self->_txtResidenceState.text = self->ResidenceState[LANGUAGE];
                }
            }
            else if ([residence_type isEqualToString:@"14"]) {
                if ([self->ResidenceStateList[i][@"id"] isEqualToString:@"19"]) {
                    self->ResidenceState = self->ResidenceStateList[i];
                    self->_txtResidenceState.text = self->ResidenceState[LANGUAGE];
                }
            }
            else if ([residence_type isEqualToString:@"17"]) {
                if ([self->ResidenceStateList[i][@"id"] isEqualToString:@"02"]) {
                    self->ResidenceState = self->ResidenceStateList[i];
                    self->_txtResidenceState.text = self->ResidenceState[LANGUAGE];
                }
            }
        }
    }
    isPassport = YES;
    PassportType = PassportTypeList[0];
    _txtPassportType.text = PassportType[LANGUAGE];
    NSString *docType = result[@"payload"][@"docType"];
    if (docType) {
        if ([docType isEqualToString:@"7"]) {
            isPassport = YES;
            PassportType = PassportTypeList[0];
            _txtPassportType.text = PassportType[LANGUAGE];
        }
    }
    if (isPassport) {
        _lblPassportNumber.text = @"旅券番号";
    }
    else {
        _lblPassportNumber.text = @"上陸許可番号";
    }
    _btnCamera.hidden = !isPassport;
    _btnQRScan.hidden = !isPassport;
    _btnEdit.hidden = !isPassport;
    
    
    NSDate *landingDate = [CommonFunc getDateFromString:result[@"payload"][@"landDate"] format:@"yyyyMMdd"];
    if (landingDate) {
        if ([ResidenceState[@"id"] isEqualToString:@"30"]) {
            validLanding = YES;
            _txtDateLanding.text = [CommonFunc getDateStringWithFormat:landingDate format:@"yyyy.MM.dd"];
        }
        else if ([self ValidateLandingDate:landingDate]) {
            validLanding = YES;
            _txtDateLanding.text = [CommonFunc getDateStringWithFormat:landingDate format:@"yyyy.MM.dd"];
        }
    }
    
    if (!validName || !validNational || !validDOB || !validExpiry || !validLanding) {
        NSString *message = @"";
        if(!validName) {
            message = @"購入者氏名";
        }
        if (!validNational) {
            _txtNationality.text = @"";
            _txtNationality.placeholder = @"";
            
            if ([message isEqualToString:@""]) {
                message = @"国籍";
            }
            else {
                message = [NSString stringWithFormat:@"%@,国籍", message];
            }
        }
        if (!validDOB) {
            _txtDOB.text = @"";
            if ([message isEqualToString:@""]) {
                message = @"生年月日";
            }
            else {
                message = [NSString stringWithFormat:@"%@,生年月日", message];
            }
        }
        if (!validExpiry) {
            _txtExpiry.text = @"";
            if ([message isEqualToString:@""]) {
                message = @"有効期限";
            }
            else {
                message = [NSString stringWithFormat:@"%@,有効期限", message];
            }
        }
        if (!validLanding) {
            _txtDateLanding.text = @"";
            if ([message isEqualToString:@""]) {
                message = @"上陸年月日";
            }
            else {
                message = [NSString stringWithFormat:@"%@,上陸年月日", message];
            }
        }
        
        message = [NSString stringWithFormat:@"%@が正しくありません。", message];
        
        UIAlertController * alert =   [UIAlertController alertControllerWithTitle:ERROR_PASSPORT_INFO message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            self->isEdit = YES;
            [self ChangeEditableIssue];
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if (validNational) {
        [self checkJapanSelected];
    }
}

- (IBAction)CameraClick:(id)sender {
    isEdit = NO;
    isPassport = YES;
    [self PassportChanged];
    [self ChangeEditableIssue];
    [self OpenScanCamera];
}

- (void) OpenScanCamera {
    RTRViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RTR"];
    [self presentViewController:vc animated:NO completion:nil];
}

- (int) CharToInt:(NSString *)Charactor {
    if ([Charactor isEqualToString:@"A"]) return 10;
    if ([Charactor isEqualToString:@"B"]) return 11;
    if ([Charactor isEqualToString:@"C"]) return 12;
    if ([Charactor isEqualToString:@"D"]) return 13;
    if ([Charactor isEqualToString:@"E"]) return 14;
    if ([Charactor isEqualToString:@"F"]) return 15;
    if ([Charactor isEqualToString:@"G"]) return 16;
    if ([Charactor isEqualToString:@"H"]) return 17;
    if ([Charactor isEqualToString:@"I"]) return 18;
    if ([Charactor isEqualToString:@"J"]) return 19;
    if ([Charactor isEqualToString:@"K"]) return 20;
    if ([Charactor isEqualToString:@"L"]) return 21;
    if ([Charactor isEqualToString:@"M"]) return 22;
    if ([Charactor isEqualToString:@"N"]) return 23;
    if ([Charactor isEqualToString:@"O"]) return 24;
    if ([Charactor isEqualToString:@"P"]) return 25;
    if ([Charactor isEqualToString:@"Q"]) return 26;
    if ([Charactor isEqualToString:@"R"]) return 27;
    if ([Charactor isEqualToString:@"S"]) return 28;
    if ([Charactor isEqualToString:@"T"]) return 29;
    if ([Charactor isEqualToString:@"U"]) return 30;
    if ([Charactor isEqualToString:@"V"]) return 31;
    if ([Charactor isEqualToString:@"W"]) return 32;
    if ([Charactor isEqualToString:@"X"]) return 33;
    if ([Charactor isEqualToString:@"Y"]) return 34;
    if ([Charactor isEqualToString:@"Z"]) return 35;
    
    return [Charactor intValue];
}

- (BOOL) checkCRC:(NSString *)pass_number nCRC:(int) nCRC
{
    BOOL result = YES;
    NSMutableArray *strData = [[NSMutableArray alloc] init];
    for (int i = 0; i < pass_number.length; i++) {
        unichar character = [pass_number characterAtIndex:i];
        [strData addObject:[NSString stringWithCharacters:&character length:1]];
    }
    
    int nSum = 0;
    
    for (int i = 0; i < strData.count; i++)
    {
        int tmp = [self CharToInt:strData[i]];
        
        if (i % 3 == 0) {
            nSum += tmp * 7;
        }
        else if (i % 3 == 1) {
            nSum += tmp * 3;
        }
        else {
            nSum += tmp;
        }
    }
    if (nSum % 10 != nCRC)
    {
        result = NO;
    }
    
    return result;
}

- (void) saledata_Matching:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self->TableArray = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:TOTAL_ITEM_LIST]];
        NSLog(@"saledata_Matching 부분이 실행되고 있습니다..");
        // 메세지 창 띄워서 동의한 경우에 POSTAS 데이터를 가지고 온다
        /*
         UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"called by URLScheme!!" message:@"Do you want to call POSTAS sale datas?" preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
         [alert dismissViewControllerAnimated:YES completion:nil];ㄴ
         [self viewDidAppear:YES];
         }];
         input_TableArray_anyway = YES;
         [alert addAction:ok];
         [self presentViewController:alert animated:YES completion:nil];
         */
        if((kAppDelegate.call_by_url_scheme) && ([kAppDelegate.url_issue_status isEqualToString:@"I"]) && (!kAppDelegate.call_by_url_issued)) {
            self->input_TableArray_anyway = YES;
            //메세지 창을 띄워서 물어보고 YES를 선택했을 때만 제어를 옮기도록 한다... 혹은 무조건 확인만 누르게 하거나....
            if(self->current_page == 2) { [self btnLeftClick:self]; self->current_page = 1;}
            if(self->current_page == 1) { [self btnLeftClick:self]; self->current_page = 0;}
            [self PageConfig];
            [self Screen_Clear];
            
        }
        [self viewDidAppear:YES];
        [self FilterTableArray];
        [self->_ItemTableView reloadData];
    });
}

- (void) PassportScanSuccess:(NSNotification *)notification {
    // use fast getValue method
    p_input_type = @"1";
    
    int nCRC = 0;
    BOOL CheckSum_Result = false;
    BOOL validPassportNo = NO;
    BOOL validNational = NO;
    BOOL validExpiry = NO;
    BOOL validSex = NO;
    BOOL validDOB = NO;
    BOOL validName = NO;
    
    NSString *CheckSum_msg = @"";
    NSString *sex = @"";
    NSString *dob = @"";
    NSString *expiry = @"";
    NSString *MRZ_text = @"";
    NSString *firstName = @"";
    NSString *lastName = @"";
    NSString *pass_number = @"";
    NSString *nationality_code = @"";
    
    NSArray<RTRDataField*>* dataFields = notification.object;
    for (RTRDataField *field in dataFields) {
        if ([field.name isEqualToString:@"MRZ_LINE2"])        {   nCRC = [[field.text substringWithRange:NSMakeRange(9, 1)] intValue];    }
        if ([field.name isEqualToString:@"MRZ_LINE2"])          {   MRZ_text        = field.text;   }
        if ([field.name isEqualToString:@"FirstName_MRZ"])      {   firstName       = field.text;   }
        if ([field.name isEqualToString:@"LastName_MRZ"])       {   lastName        = field.text;   }
        if ([field.name isEqualToString:@"Number_MRZ"])         {   pass_number     = field.text;   }
        if ([field.name isEqualToString:@"Nationality_MRZ"])    {   nationality_code= field.text;   }
        if ([field.name isEqualToString:@"Sex_MRZ"])            {   sex             = field.text;   }
        if ([field.name isEqualToString:@"DateOfBirth_MRZ"])    {   dob             = field.text;   }
        if ([field.name isEqualToString:@"DateOfExpiry_MRZ"])   {   expiry          = field.text;   }
    }
    _txtPassportName.text = [NSString stringWithFormat:@"%@ %@", lastName, firstName];
     //여권정보 확인하는 부분 --------------------------------------- 아래에서 함께 체크하기 때문에 주석처리 하였다.
    
    if ([self checkCRC:pass_number nCRC:nCRC]) {
        validPassportNo = YES;
        _txtPassportNumber.text = [pass_number stringByReplacingOccurrencesOfString:@" " withString:@""];
        //_txtPassportNumber.text = pass_number;
    }//-----------------------------------------------------------
    
    nationality_code = [nationality_code stringByReplacingOccurrencesOfString:@"0" withString:@"O"];
    
    for (int i = 0; i < CountryList.count; i++) {
        if ([nationality_code isEqualToString:CountryList[i][@"COMCODE"]]) {
            _txtNationality.placeholder = CountryList[i][@"ATTRIB02"];
            _txtNationality.text = nationality_code;
            validNational = YES;
        }
    }

    for (NSMutableDictionary *tempSex in SexList) {
        if ([sex isEqualToString:tempSex[@"id"]]) {
            validSex = YES;
            Sex = tempSex;
            _txtSex.text = Sex[LANGUAGE];
        }
    }
    dob = [dob stringByReplacingOccurrencesOfString:@" " withString:@""];
    dob = [dob stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([CommonFunc getDateFromString:dob format:@"dd/MM/yyyy"]) {
        _txtDOB.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:dob format:@"dd/MM/yyyy"] format:@"yyyy.MM.dd"];
    }
    else if ([CommonFunc getDateFromString:dob format:@"yyyy/MM/dd"]) {
        _txtDOB.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:dob format:@"yyyy/MM/dd"] format:@"yyyy.MM.dd"];
    }
    else {
        if (dob.length > 10) {
            _txtDOB.text = [dob substringToIndex:10];
        }
        else {
            _txtDOB.text = dob;
        }
    }
    NSDate *dobDate = [CommonFunc getDateFromString:_txtDOB.text format:@"yyyy.MM.dd"];
    if (dobDate) {
        if ([dobDate timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970]) {
            validDOB = YES;
        }
    }
    
    
    expiry = [expiry stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([CommonFunc getDateFromString:expiry format:@"dd/MM/yyyy"]) {
        _txtExpiry.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:expiry format:@"dd/MM/yyyy"] format:@"yyyy.MM.dd"];
    }
    else if ([CommonFunc getDateFromString:expiry format:@"yyyy/MM/dd"]) {
        _txtExpiry.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:expiry format:@"yyyy/MM/dd"] format:@"yyyy.MM.dd"];
    }
    else {
        if (expiry.length > 10) {
            _txtExpiry.text = [expiry substringToIndex:10];
        }
        else {
            _txtExpiry.text = expiry;
        }
    }
    NSDate *expiryDate = [CommonFunc getDateFromString:_txtExpiry.text format:@"yyyy.MM.dd"];
    if (expiryDate) {
        if ([expiryDate timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
            validExpiry = YES;
        }
    }
    
    if(MRZ_text.length >= 44) {
        
        CheckSum_Result = [self checkMRZ:MRZ_text];
        //여권정보 전체의 CheckSum을 확인한다.
        //if(!CheckSum_Result) CheckSum_msg = @"스캔한 여권의 글자가 정확하지 않습니다! 반드시 여권과 입력된 정보를 대조해서 확인 후 진행해 주십시오.";
        if(!CheckSum_Result) CheckSum_msg = @"パスポート情報が正しくスキャンされていません。パスポートの内容が正しくスキャンされたかご確認ください。";
        NSString *strVal_PassportNo = [MRZ_text substringWithRange:NSMakeRange(0, 10)];
        NSString *strVal_Birth      = [MRZ_text substringWithRange:NSMakeRange(13, 7)];
        NSString *strVal_Expiry     = [MRZ_text substringWithRange:NSMakeRange(21, 7)];
        
        CheckSum_Result = [self checkMRZ_val:strVal_PassportNo];
        if(!CheckSum_Result)    {
            validPassportNo = NO;
            CheckSum_msg = [NSString stringWithFormat:@"パスポート番号 エラー, %@", CheckSum_msg];
        }
        CheckSum_Result = [self checkMRZ_val:strVal_Birth];
        if(!CheckSum_Result)   {
            validDOB        = NO;
            CheckSum_msg = [NSString stringWithFormat:@"生年月日 エラー, %@", CheckSum_msg];
        }
        CheckSum_Result = [self checkMRZ_val:strVal_Expiry];
        if(!CheckSum_Result)    {
            validExpiry     = NO;
            CheckSum_msg = [NSString stringWithFormat:@"有効期限 エラー, %@", CheckSum_msg];
        }
    }
    else CheckSum_Result = false;   //스캔 된 글자 수 부족
    //여권번호 글자 수 체크
    //이름 글자 수 체크 -- 00채우기 수정작업(7자리까지)
    //수량체크(여기서는 아니지만 확인하기)
    
    //if(_txtPassportName.text.length < 6) CheckSum_msg = @"여권에 기재된 성명의 길이가 너무 짧습니다. 잘못 입력된 것인지 다시 한번 확인 후 진행해 주십시오.";
    if(_txtPassportName.text.length < 6) CheckSum_msg = @"購入者氏名が通常より短いです。スキャンされたお名前が正しいか一度ご確認ください。";
    else validName = YES;
    
    if(!validName || !CheckSum_Result) {
        //CheckSum_msg를 Alert창으로 내보내기!
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"エラー" message:CheckSum_msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if (!validPassportNo || !validNational || !validSex || !validDOB || !validExpiry) {
        
        NSString *message = @"";
        if (!validPassportNo) {
            message = @"パスポート番号";
        }
        if (!validNational) {
            _txtNationality.text = @"";
            _txtNationality.placeholder = @"";
            
            if ([message isEqualToString:@""]) {
                message = @"国籍";
            }
            else {
                message = [NSString stringWithFormat:@"%@,国籍", message];
            }
        }
        if (!validSex) {
            _txtSex.text = @"";
            if ([message isEqualToString:@""]) {
                message = @"性別";
            }
            else {
                message = [NSString stringWithFormat:@"%@,性別", message];
            }
        }
        if (!validDOB) {
            _txtDOB.text = @"";
            if ([message isEqualToString:@""]) {
                message = @"生年月日";
            }
            else {
                message = [NSString stringWithFormat:@"%@,生年月日", message];
            }
        }
        if (!validExpiry) {
            _txtExpiry.text = @"";
            if ([message isEqualToString:@""]) {
                message = @"有効期限";
            }
            else {
                message = [NSString stringWithFormat:@"%@,有効期限", message];
            }
        }
        
        message = [NSString stringWithFormat:@"%@が正しくありません。", message];
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:ERROR_PASSPORT_INFO message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:PASSPORT_HANDWRITE style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->isEdit = YES;
            [self ChangeEditableIssue];
            [alertView dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:PASSPORT_SCANNER style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->isEdit = NO;
            [self ChangeEditableIssue];
            [self OpenScanCamera];
            [alertView dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
    if (validNational) {
        [self checkJapanSelected];
    }
}

- (BOOL) checkMRZ_val:(NSString*) MRZ_str {
    
    int tmp = 0;
    int nSum = 0;
    BOOL result = true;
    NSInteger intVal[] = {7,3,1};
    
    for(int i = 0; i < MRZ_str.length; i++) {
        NSString *tmp_str = [MRZ_str substringWithRange:NSMakeRange(i, 1)];
        tmp = [self checkChar:tmp_str];
        if(i != (MRZ_str.length-1)) nSum += (intVal[i % 3] * tmp);
        else {
            int ValidCheck = nSum % 10;
            if(ValidCheck != tmp) result = false;
        }
    }
    return result;
}

- (BOOL) checkMRZ:(NSString*) MRZ_str {
    int tmp = 0;
    int nSum = 0;
    BOOL result = true;
    
    NSInteger intVal[]  = {7,3,1};
    NSInteger intVal2[] = {3,1,7};
    NSInteger intVal3[] = {1,7,3};
    
    NSString *strVal        =[MRZ_str substringWithRange:NSMakeRange(0, 10)];
    NSString *strVal2_sub1  =[MRZ_str substringWithRange:NSMakeRange(13, 7)];
    NSString *strVal2_sub2  =[MRZ_str substringWithRange:NSMakeRange(21, 3)];
    NSString *strVal2       =[strVal2_sub1 stringByAppendingString:strVal2_sub2];
    NSString *strVal3       =[MRZ_str substringWithRange:NSMakeRange(24, 10)];
    NSString *strVal4       =[MRZ_str substringWithRange:NSMakeRange(34, 9)];
    NSInteger checkDigit    =[[MRZ_str substringWithRange:NSMakeRange(43, 1)] integerValue];
    
    for(int i = 0; i < strVal.length; i++) {
        NSString *tmp_str = [strVal substringWithRange:NSMakeRange(i, 1)];
        tmp = [self checkChar:tmp_str];
        nSum += (intVal[i % 3] * tmp);
    }
    for(int i = 0; i < strVal2.length; i++) {
        NSString *tmp_str = [strVal2 substringWithRange:NSMakeRange(i, 1)];
        tmp = [self checkChar:tmp_str];
        nSum += (intVal2[i % 3] * tmp);
    }
    for(int i = 0; i < strVal3.length; i++) {
        NSString *tmp_str = [strVal3 substringWithRange:NSMakeRange(i, 1)];
        tmp = [self checkChar:tmp_str];
        nSum += (intVal3[i % 3] * tmp);
    }
    for(int i = 0; i < strVal4.length; i++) {
        NSString *tmp_str = [strVal4 substringWithRange:NSMakeRange(i, 1)];
        tmp = [self checkChar:tmp_str];
        nSum += (intVal[i % 3] * tmp);
    }
    if (nSum % 10 != checkDigit)  {  result = false; }
                
    return result;
}

- (int) checkChar:(NSString*) my_char {
    
    int result = -1;
    
    if([my_char isEqualToString:@"A"]) result = 10;
    else if([my_char isEqualToString:@"B"]) result = 11;
    else if([my_char isEqualToString:@"C"]) result = 12;
    else if([my_char isEqualToString:@"D"]) result = 13;
    else if([my_char isEqualToString:@"E"]) result = 14;
    else if([my_char isEqualToString:@"F"]) result = 15;
    else if([my_char isEqualToString:@"G"]) result = 16;
    else if([my_char isEqualToString:@"H"]) result = 17;
    else if([my_char isEqualToString:@"I"]) result = 18;
    else if([my_char isEqualToString:@"J"]) result = 19;
    else if([my_char isEqualToString:@"K"]) result = 20;
    else if([my_char isEqualToString:@"L"]) result = 21;
    else if([my_char isEqualToString:@"M"]) result = 22;
    else if([my_char isEqualToString:@"N"]) result = 23;
    else if([my_char isEqualToString:@"O"]) result = 24;
    else if([my_char isEqualToString:@"P"]) result = 25;
    else if([my_char isEqualToString:@"Q"]) result = 26;
    else if([my_char isEqualToString:@"R"]) result = 27;
    else if([my_char isEqualToString:@"S"]) result = 28;
    else if([my_char isEqualToString:@"T"]) result = 29;
    else if([my_char isEqualToString:@"U"]) result = 30;
    else if([my_char isEqualToString:@"V"]) result = 31;
    else if([my_char isEqualToString:@"W"]) result = 32;
    else if([my_char isEqualToString:@"X"]) result = 33;
    else if([my_char isEqualToString:@"Y"]) result = 34;
    else if([my_char isEqualToString:@"Z"]) result = 35;
    else if([my_char isEqualToString:@"<"]) result = 0;
    if(result < 0) result = [my_char intValue];
    return result;
}


- (IBAction)EditClick:(id)sender {
    if (isEdit) {
        isEdit = NO;
    }
    else {
        isEdit = YES;
        p_input_type = @"3";
    }
    [self ChangeEditableIssue];
}

- (void) ChangeEditableIssue {
    if (isEdit) {
        _txtPassportName.userInteractionEnabled = YES;
        _txtPassportNumber.userInteractionEnabled = YES;
        
        _btnNationality.hidden = NO;
        _btnSex.hidden = NO;
        _iconCalendarDOB.hidden = NO;
        _iconCalendarExpiry.hidden = NO;
        
        [_txtPassportName becomeFirstResponder];
    }
    else {
        _txtPassportName.userInteractionEnabled = NO;
        _txtPassportNumber.userInteractionEnabled = NO;
        
        _btnNationality.hidden = YES;
        _btnSex.hidden = YES;
        _iconCalendarDOB.hidden = YES;
        _iconCalendarExpiry.hidden = YES;
        
        [self ClearLineColor];
        [self.view endEditing:YES];
    }
}

- (void) ClearLineColor {
    _linePassportName.backgroundColor = [UIColor lightGrayColor];
    _linePassportNumber.backgroundColor = [UIColor lightGrayColor];
    _lineNationality.backgroundColor = [UIColor lightGrayColor];
    _lineSex.backgroundColor = [UIColor lightGrayColor];
    _lineDOB.backgroundColor = [UIColor lightGrayColor];
    _lineExpiry.backgroundColor = [UIColor lightGrayColor];
    _lineResidenceState.backgroundColor = [UIColor lightGrayColor];
    _linePassportType.backgroundColor = [UIColor lightGrayColor];
    _lineDateLanding.backgroundColor = [UIColor lightGrayColor];
}


- (IBAction)DOBClick:(id)sender {
    if (!isEdit) {
        return;
    }
    [self ClearLineColor];
    _lineDOB.backgroundColor = BlueColor;
    
    dateType = @"DOB";
    
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    chooseDataPicker.maxDate = [NSDate date];
    
    if ([CommonFunc getDateFromString:_txtDOB.text format:@"yyyy.MM.dd"]) {
        chooseDataPicker.data = [CommonFunc getDateFromString:_txtDOB.text format:@"yyyy.MM.dd"];
    }
    else {
        chooseDataPicker.data = [NSDate date];
    }
    [chooseDataPicker show];
}

- (IBAction)ExpiryClick:(id)sender {
    if (!isEdit) {
        return;
    }
    [self ClearLineColor];
    _lineExpiry.backgroundColor = BlueColor;
    
    dateType = @"Expiry";
    
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    
    if ([CommonFunc getDateFromString:_txtExpiry.text format:@"yyyy.MM.dd"]) {
        chooseDataPicker.data = [CommonFunc getDateFromString:_txtExpiry.text format:@"yyyy.MM.dd"];
    }
    else {
        chooseDataPicker.data = [NSDate date];
    }
    chooseDataPicker.isExpiry = YES;
    [chooseDataPicker show];
}

- (IBAction)DateLandingClick:(id)sender {
    [self ClearLineColor];
    _lineDateLanding.backgroundColor = BlueColor;
    
    dateType = @"DateLanding";
    
    ChooseDatePickerView *chooseDataPicker = [[ChooseDatePickerView alloc] initWithFrame:self.view.bounds];
    chooseDataPicker.delegate = self;
    
    chooseDataPicker.maxDate = [NSDate date];
    
    if ([CommonFunc getDateFromString:_txtDateLanding.text format:@"yyyy.MM.dd"]) {
        chooseDataPicker.data = [CommonFunc getDateFromString:_txtDateLanding.text format:@"yyyy.MM.dd"];
    }
    
    [chooseDataPicker show];
}

#pragma mark - DatePickerViewDelegate

- (void)finishSelectDate:(NSDate *)date {
    if (date) {
        NSString *strDate = [CommonFunc getDateStringWithFormat:date format:@"yyyy.MM.dd"];
        
        if ([dateType isEqualToString:@"DOB"]) {
            _txtDOB.text = strDate;
        }
        else if ([dateType isEqualToString:@"Expiry"]) {
            _txtExpiry.text = strDate;
        }
        else if ([dateType isEqualToString:@"DateLanding"]) {
            // ============ 재류자격 米軍関係者(SOFA)인 경우 입국일로부터 6개월 체크를 하지 않습니다.===================//
            if (ResidenceState != nil) {
                if ([ResidenceState[@"id"] isEqualToString:@"30"]) {
                    _txtDateLanding.text = strDate;
                    return;
                }
            }
            // ========================================================================================//
            if ([self ValidateLandingDate:date]) {
                _txtDateLanding.text = strDate;
            }
            else {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"上陸年月日を確認してください。" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertView addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self DateLandingClick:nil];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }
    }
}

- (BOOL) ValidateLandingDate:(NSDate *)landingDate {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.month = 6;
    
    NSDate *compareDay = [calendar dateByAddingComponents:addComponents toDate:landingDate options:0];
    
    if ([today timeIntervalSince1970] > [compareDay timeIntervalSince1970]) {
        return NO;
    }
    
    return YES;
}


- (IBAction)NationalityClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < CountryList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:[NSString stringWithFormat:@"%@ (%@)", CountryList[i][@"ATTRIB02"], CountryList[i][@"COMCODE"]] image:nil handler:^(YCMenuAction *action) {
            self->_txtNationality.text = self->CountryList[i][@"COMCODE"];
            self->_txtNationality.placeholder = self->CountryList[i][@"ATTRIB02"];
            
            [self checkJapanSelected];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:300 relyonView:sender];
    view.menuCellHeight = 40;
    [view show];
    
    [self ClearLineColor];
    _lineNationality.backgroundColor = BlueColor;
}

- (void) checkJapanSelected {
    if (isPassport && [_txtNationality.text isEqualToString:@"JPN"]) {
        if (![self->ResidenceState[@"id"] isEqualToString:@"29"]) {
            AddInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddInfo"];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

- (IBAction)SexClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < SexList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:SexList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->Sex = self->SexList[i];
            self->_txtSex.text = action.title;
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    [view show];
    
    [self ClearLineColor];
    _lineSex.backgroundColor = BlueColor;
}

- (IBAction)ResideceStateClick:(id)sender {
    if (!isPassport) {
        return;
    }
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < ResidenceStateList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:ResidenceStateList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self.viewAddInfo.hidden = YES;
            kAppDelegate.AdditionalInfo = nil;
            if ([self->ResidenceStateList[i][@"id"] isEqualToString:@"29"]) {
                AddInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddInfo"];
                [self presentViewController:controller animated:YES completion:nil];
            }
            else {
                self->ResidenceState = self->ResidenceStateList[i];
                self->_txtResidenceState.text = action.title;
                NSLog(@"ResudenceState::%@ txtResidenceState_text::%@ ******************************************************************"
                      , self->ResidenceStateList[i], action.title);
            }
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:240 relyonView:sender];
    [view show];
    
    [self ClearLineColor];
    _lineResidenceState.backgroundColor = BlueColor;
}

- (IBAction)btnEditAddInfoClick:(id)sender {
    AddInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddInfo"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) additionalInfoChanged:(NSNotification *)notification {
    for (int i = 0; i < ResidenceStateList.count; i++) {
        if ([ResidenceStateList[i][@"id"] isEqualToString:@"29"]) {
            ResidenceState = ResidenceStateList[i];
        }
    }
    _txtResidenceState.text = ResidenceState[LANGUAGE];
    _viewAddInfo.hidden = NO;
    _btnResidenceOption1.selected = [kAppDelegate.AdditionalInfo[@"type"] isEqualToString:@"0"];
    _btnResidenceOption2.selected = !_btnResidenceOption1.isSelected;
}

- (IBAction)PassportTypeClick:(id)sender {
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < PassportTypeList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:PassportTypeList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->PassportType = self->PassportTypeList[i];
            self->_txtPassportType.text = action.title;
            if (i == 0) {
                self->isPassport = YES;
                self->ResidenceState = self->ResidenceStateList[0];
                self->_txtResidenceState.text = self->ResidenceState[LANGUAGE];
            }
            else {
                self->isPassport = NO;
                self->ResidenceState = self->ResidenceStateList[1];
                self->_txtResidenceState.text = self->ResidenceState[LANGUAGE];
            }
            self.viewAddInfo.hidden = YES;
            kAppDelegate.AdditionalInfo = nil;
            NSLog(@"ResudenceState::%@ txtResidenceState_text::%@ ******************************************************************"
                  , self->ResidenceState, self->_txtResidenceState.text);
            [self PassportChanged];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:200 relyonView:sender];
    [view show];
    
    [self ClearLineColor];
    _linePassportType.backgroundColor = BlueColor;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtPassportName) {
        [self ClearLineColor];
        _linePassportName.backgroundColor = BlueColor;
    }
    else if (textField == _txtPassportNumber) {
        [self ClearLineColor];
        _linePassportNumber.backgroundColor = BlueColor;
    }
    else if (textField == _txtNationality) {
        [self ClearLineColor];
        _lineNationality.backgroundColor = BlueColor;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *filter = @"####-####-####-#######";
    
    if(!filter) return YES; // No filter provided, allow anything
    if (!(textField == _txtCardNumber)) {
        return YES;
    }
    if (![RefundType[@"id"] isEqualToString:@"04"]) {
        return YES;
    }
    
    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(range.length == 1 && // Only do for single deletes
       string.length < range.length &&
       [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
    {
        // Something was deleted.  Delete past the previous number
        NSInteger location = changedString.length-1;
        if(location > 0)
        {
            for(; location > 0; location--)
            {
                if(isdigit([changedString characterAtIndex:location]))
                {
                    break;
                }
            }
            changedString = [changedString substringToIndex:location];
        }
    }
    
    textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);
    
    return NO;
}

NSString *filteredPhoneStringFromStringWithFilter(NSString *string, NSString *filter)
{
    NSUInteger onOriginal = 0, onFilter = 0, onOutput = 0;
    char outputString[([filter length])];
    BOOL done = NO;
    
    while(onFilter < [filter length] && !done)
    {
        char filterChar = [filter characterAtIndex:onFilter];
        char originalChar = onOriginal >= string.length ? '\0' : [string characterAtIndex:onOriginal];
        switch (filterChar) {
            case '#':
                if(originalChar=='\0')
                {
                    // We have no more input numbers for the filter.  We're done.
                    done = YES;
                    break;
                }
                if(isdigit(originalChar))
                {
                    outputString[onOutput] = originalChar;
                    onOriginal++;
                    onFilter++;
                    onOutput++;
                }
                else
                {
                    onOriginal++;
                }
                break;
            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput++;
                onFilter++;
                if(originalChar == filterChar)
                    onOriginal++;
                break;
        }
    }
    outputString[onOutput] = '\0'; // Cap the output string
    return [NSString stringWithUTF8String:outputString];
}

- (IBAction)btnConfirmRefundFeeClick:(id)sender {
    [self hideRefundFee];
    [self doRefund];
}

- (void) showRefundFee {
    [self.view insertSubview:darkBackground belowSubview:_viewRefundFee];
    [UIView transitionWithView:_viewRefundFee
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewRefundFee.hidden = NO;
    }
                    completion:NULL];
}

- (void) hideRefundFee {
    [UIView transitionWithView:_viewRefundFee
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewRefundFee.hidden = YES;
    }
                    completion:^(BOOL finished) {
        [self->darkBackground removeFromSuperview];
    }];
}

- (IBAction)btnConfirmLimitNotificationClick:(id)sender {
    [self hideLimitNotification];
}

- (void) showLimitNotification {
    _lblLNPassportNo.text = _txtPassportNumber.text;
    [self.view insertSubview:darkBackground belowSubview:_viewLimitNotification];
    [UIView transitionWithView:_viewLimitNotification
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewLimitNotification.hidden = NO;
    }
                    completion:NULL];
}

- (void) hideLimitNotification {
    [UIView transitionWithView:_viewLimitNotification
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewLimitNotification.hidden = YES;
    }
                    completion:^(BOOL finished) {
        [self->darkBackground removeFromSuperview];
    }];
}

- (IBAction)RefundClick:(id)sender {
    if (IncompletedNo != nil) {
        for (NSDictionary *item in TableArray) {
            if ([item[@"RCT_NO"] isEqualToString:IncompletedNo]) {
                [self.view makeToast:ERROR_MSG_SCAN_OTHERQR duration:5 position:CSToastPositionBottom];
                return;
            }
        }
        IncompletedNo = nil;
    }
    if([configInfo[@"receipt_add"] isEqualToString:@"YES"]) {
        if (![self validationCheck:YES bItem:YES]) {
            return;
        }
    }
    else {
        if (![self validationCheck:YES bItem:NO]) {
            return;
        }
    }
    
    NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
    BOOL isFeeYN = NO;
    if (feeSettingInfo) {
        isFeeYN = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
    }
    if (isFeeYN) {
        [self showRefundFee];
    }
    else {
        [self doRefund];
    }
}

- (void) doRefund {
    passportInfo = [[NSMutableDictionary alloc] init];   //로컬 DB Insert 용 전표 정보
    passportInfo[@"BUYER_NAME"] = _txtPassportName.text;
    passportInfo[@"MEMO_TEXT"] = _memoTextView.text;
    if (isPassport) {
        passportInfo[@"PASSPORT_SERIAL_NO"] = _txtPassportNumber.text;
        passportInfo[@"PERMIT_NO"] = @"";
    }
    else {
        passportInfo[@"PERMIT_NO"] = _txtPassportNumber.text;
        passportInfo[@"PASSPORT_SERIAL_NO"] = @"";
    }
    
    passportInfo[@"NATIONALITY_CODE"] = _txtNationality.text;
    passportInfo[@"NATIONALITY_NAME"] = _txtNationality.placeholder;
    
    passportInfo[@"GENDER_CODE"] = Sex[@"id"];
    passportInfo[@"BUYER_BIRTH"] = [_txtDOB.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    passportInfo[@"PASS_EXPIRYDT"] = [_txtExpiry.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    passportInfo[@"INPUT_WAY_CODE"] = @"02";
    passportInfo[@"RESIDENCE_NO"] = [CommonFunc stringPaddingLeft:ResidenceState[@"id"] newLength:8];
    passportInfo[@"RESIDENCE"] = ResidenceState[LANGUAGE];
    passportInfo[@"ENTRYDT"] = [_txtDateLanding.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    passportInfo[@"PASSPORT_TYPE"] = [CommonFunc stringPaddingLeft:PassportType[@"id"] newLength:2];
    passportInfo[@"PASSPORT_TYPE_NAME"] = PassportType[LANGUAGE];
    
    passportInfo[@"REFUND_NOTE"] = [ResidenceState[@"id"] isEqualToString:@"30"] ? @"米軍関係者" : @"";
    passportInfo[@"TYPE"] = @"";
    passportInfo[@"A_ISSUE_DATE"] = @"";
    passportInfo[@"JP_ADDR1"] = @"";
    passportInfo[@"JP_ADDR2"] = @"";
    passportInfo[@"AGENCY"] = @"";
    passportInfo[@"A_ISSUE_NO"] = @"";
    
    if ([ResidenceState[@"id"] isEqualToString:@"29"]) {
        passportInfo[@"TYPE"] = kAppDelegate.AdditionalInfo[@"type"];
        passportInfo[@"A_ISSUE_DATE"] = [kAppDelegate.AdditionalInfo[@"issue_date"] stringByReplacingOccurrencesOfString:@"." withString:@""];
        passportInfo[@"JP_ADDR1"] = kAppDelegate.AdditionalInfo[@"address"];
        passportInfo[@"JP_ADDR2"] = kAppDelegate.AdditionalInfo[@"address_no"];
        if ([passportInfo[@"TYPE"] isEqualToString:@"0"]) {
            passportInfo[@"AGENCY"] = kAppDelegate.AdditionalInfo[@"issue_name"];
            passportInfo[@"A_ISSUE_NO"] = kAppDelegate.AdditionalInfo[@"issue_no"];
        }
    }
    
    tempTableArray = [[NSMutableArray alloc] initWithArray:TableArray];
    for(int i = 0; i < tempTableArray.count; i++) {
        NSMutableDictionary *temp_dict = [[NSMutableDictionary alloc] init];
        temp_dict = TableArray[i];
        NSLog(@"[%d]-------------------발행직전에 넘어가는 값 리스트 찍어보기!!", i);
        NSLog(@"%@", temp_dict);
    }
    
    if([configInfo[@"signpad_use"] isEqualToString:@"YES"])
        {
        NSString *title = @"Tax Free Rules / 免税规则 / 면세 규칙";
        NSString *message = @"● 当該消耗品を、購入した日から３０日以内に輸出されるものとして購入し、日本で処分しないことを誓約します。\n● 当該一般品を、日本から最終的には輸出されるものとして購入し、日本で処分しないことを誓約します。\n\n● I certify that the goods listed as 'consumable commodities'on this card were purchased by me for export from Japan within 30days from the purchase date and will not be disposed of within Japan. \n● I certify that the goods listed as 'commodities except consumable' on this card were purchased by me for ultimate export from Japan and will not be disposed of within Japan.\n\n● 从购买日起30天内搬出为前提购买的消耗品，誓约日方将不给予处分。 \n● 购买的一般商品最终从日本搬出，誓约日方不会给予处分。\n\n● 해당 소모품을 구입한 날로부터 30일 이내에 수출하는 것으로 구입해 일본에서 처분하지 않는 것을 서약합니다. \n● 해당 일반 물품을 일본에서 최종적으로는 수출하는 것으로 구입해 일본에서 처분하지 않기로 서약합니다.\n● I agree my personal information for the tax exemption process is to be stored on the cloud server overseas. \n● 我同意将免税处理所需的个人信息存储在海外服务器上。\n●면세처리에 필요한 개인정보가 해외서버에 저장되는 것에 동의합니다.";
        
        NSString *accept = @"Agree/同意/동의";
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:accept style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self showSignPad];
        }]];
        
        [self presentViewController:alertView animated:YES completion:nil];
        return;
        }
    
    if (![ShopInfo[@"NATIONALITY_MAPPING_USEYN"] isEqualToString:@"Y"] && ![configInfo[@"print_choice"] isEqualToString:@"03"]) {  //
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:PRINTSLIPLANG_FORM message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_CN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->LanguageNo = 2;
            [self SaveAndPrint];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_EN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->LanguageNo = 1;
            [self SaveAndPrint];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_KO style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self->LanguageNo = 3;
            [self SaveAndPrint];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertView dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else {
        [self SaveAndPrint];
    }
}

- (IBAction)ClearClick:(id)sender {
    IncompletedNo = nil;
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"初期化" message:@"初期化しますか？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self Screen_Clear];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
    if(kAppDelegate.call_by_url_issued) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"発行されました" message:@"この取引は完了しました" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertView dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
       [kAppDelegate StartAutoRefresh];
       [alertView dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)btnSignRefundClick:(id)sender {
    if (!self.signatureViewController.isEmpty) {
        signImage = self.signatureViewController.fullSignatureImage;
        NSString *signData = [CommonFunc imageToNSString:[CommonFunc signImageResize:signImage size:CGSizeMake(140, 70)]];
        NSInteger strLength = signData.length;
        if (strLength > 4000) {
            signImage = nil;
            [self.signatureViewController reset];
            [self.view makeToast:@"電子署名を再入力してください。"];
            return;
        }
        
        [self hideSignPad];
        
        if (![ShopInfo[@"NATIONALITY_MAPPING_USEYN"] isEqualToString:@"Y"] && ![configInfo[@"print_choice"] isEqualToString:@"03"]) {  //
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:PRINTSLIPLANG_FORM message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_CN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self->LanguageNo = 2;
                [self SaveAndPrint];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_EN style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self->LanguageNo = 1;
                [self SaveAndPrint];
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:COMBO_ITEM_KO style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self->LanguageNo = 3;
                [self SaveAndPrint];
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
        else {
            [self SaveAndPrint];
        }
    }
    else {
        [self.view makeToast:@"電子署名を確認してください"];
    }
}

- (IBAction)btnSignCancelClick:(id)sender {
    [self hideSignPad];
}

- (void) showSignPad {
    [self.signatureViewController reset];
    [self.view insertSubview:darkBackground belowSubview:_viewSignPad];
    [UIView transitionWithView:_viewSignPad
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewSignPad.hidden = NO;
    }
                    completion:NULL];
}

- (void) hideSignPad {
    [UIView transitionWithView:_viewSignPad
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewSignPad.hidden = YES;
    }
                    completion:^(BOOL finished) {
        [self->darkBackground removeFromSuperview];
    }];
    
}


- (IBAction)MenuClick:(id)sender {
    [self showLeftViewAnimated:sender];
}


- (IBAction)AddClick:(id)sender {
    [self.view endEditing:YES];
    if(![configInfo[@"receipt_add"] isEqualToString:@"YES"]) {
        return;
    }
    
    if (_txtReceiptNo.text.length > 0) {
        [kAppDelegate getFeeInfo];
        AddItemViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddItem"];
        controller.RctNo = _txtReceiptNo.text;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [self showMessage];
    }
}

- (void) showMessage {
    [self.view insertSubview:darkBackground belowSubview:_viewMessage];
    [UIView transitionWithView:_viewMessage
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewMessage.hidden = NO;
    }
                    completion:NULL];
}

- (void) hideMessage {
    [UIView transitionWithView:_viewMessage
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
        self->_viewMessage.hidden = YES;
    }
                    completion:^(BOOL finished) {
        [self->darkBackground removeFromSuperview];
        
    }];
    
}

- (IBAction)btnOkClick:(id)sender {
    [self hideMessage];
    
    [kAppDelegate getFeeInfo];
    
    AddItemViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddItem"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ja"];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSString *strHour = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)hour] newLength:2];
    NSString *strMin = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)minute] newLength:2];
    NSString *strSec = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)second] newLength:2];
    
    _txtReceiptNo.text = [NSString stringWithFormat:@"G%@%@%@%@%@", ShopInfo[@"MERCHANT_NO"], [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"], strHour, strMin, strSec];
    controller.RctNo = _txtReceiptNo.text;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnCancelClick:(id)sender {
    [self hideMessage];
}

- (IBAction)QRClick:(id)sender {
    ZRQRCodeViewController *qrCode = [[ZRQRCodeViewController alloc] initWithScanType:ZRQRCodeScanTypeReturn];
    qrCode.qrCodeNavigationTitle = @"QRコードスキャン";
//    __weak typeof(self) weakSelf = self;
    [qrCode QRCodeScanningWithViewController:self completion:^(NSString *strValue) {
        NSLog(@"strValue = %@ ", strValue);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self validateQRCode:strValue];
        });
    } failure:^(NSString *message) {
        NSLog(@"Scan error = %@ ", message);
    }];
}


- (void)validateQRCode:(NSString *)qrString {
    NSArray *dataList = [[qrString stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@","];
    if (dataList.count < 12) {
        return;
    }
    NSMutableDictionary *data = [NSMutableDictionary new];
    data[@"RCT_NO"] = dataList[0];
    
    if (IncompletedNo != nil) {
        BOOL isExist = NO;
        for (NSDictionary *item in TableArray) {
            if ([item[@"RCT_NO"] isEqualToString:IncompletedNo]) {
                isExist = YES;
            }
        }
        if (!isExist) {
            IncompletedNo = nil;
        }
    }
    
    if (IncompletedNo != nil) {
        if (![data[@"RCT_NO"] isEqualToString:IncompletedNo]) {
            [self.view makeToast:ERROR_MSG_SCAN_OTHERQR2 duration:5 position:CSToastPositionBottom];
            return;
        }
    }
    if ([data[@"RCT_NO"] length] == 0) {
        [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"レシート番号"]];
        return;
    }
    else if ([data[@"RCT_NO"] length] != 4) {
        [self.view makeToast:ERROR_MSG_WRONG_NUMBER];
        return;
    }
    data[@"KindCnt"] = dataList[1];
    if ([data[@"KindCnt"] length] == 0) {
        [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"免税物品の種類数"]];
        return;
    }
    else if ([data[@"KindCnt"] length] != 2) {
        [self.view makeToast:ERROR_MSG_WRONG_NUMBER];
        return;
    }
    data[@"ProductCnt"] = dataList[2];
    if ([data[@"ProductCnt"] length] == 0) {
        [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"全体数量"]];
        return;
    }
    else if ([data[@"ProductCnt"] length] != 3) {
        [self.view makeToast:ERROR_MSG_WRONG_NUMBER];
        return;
    }
    
    if ([data[@"KindCnt"] intValue] > 10) {
        if (dataList.count/9 < 10) {
            if ([data[@"KindCnt"] intValue]%10 != dataList.count/9) {
                [self.view makeToast:ERROR_MSG_PRODUCT_KIND];
                return;
            }
        }
    }
    else if ([data[@"KindCnt"] intValue] != dataList.count/9) {
        [self.view makeToast:ERROR_MSG_PRODUCT_KIND];
        return;
    }
    
    NSMutableArray *productList = [NSMutableArray new];
    int totalQty = 0;
    for (int i = 0; i < dataList.count/9; i++) {
        NSMutableDictionary *product = [NSMutableDictionary new];
        product[@"type"] = dataList[9 * i + 3];
        
        if ([product[@"type"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"商品区分"]];
            return;
        }
        else if (!([product[@"type"] isEqualToString:@"C"] || [product[@"type"] isEqualToString:@"E"])) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"商品区分"]];
            return;
        }
        product[@"taxType"] = dataList[9 * i + 4];
        if ([product[@"taxType"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"税区分"]];
            return;
        }
        else if ([product[@"taxType"] length] != 2) {
            [self.view makeToast:ERROR_MSG_WRONG_NUMBER];
            return;
        }
        product[@"taxFormula"] = dataList[9 * i + 5];
        if ([product[@"taxFormula"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"税率"]];
            return;
        }
        else if ([product[@"taxFormula"] length] != 2) {
            [self.view makeToast:ERROR_MSG_WRONG_NUMBER];
            return;
        }
        product[@"name"] = dataList[9 * i + 6];
        if ([product[@"name"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"部門名称 (中分類)"]];
            return;
        }
        product[@"qty"] = dataList[9 * i + 7];
        if ([product[@"qty"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"数量"]];
            return;
        }
        else if ([product[@"qty"] length] != 3) {
            [self.view makeToast:ERROR_MSG_WRONG_NUMBER];
            return;
        }
        totalQty += [product[@"qty"] intValue];
        product[@"taxAmt"] = dataList[9 * i + 8];
        if ([product[@"taxAmt"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"免税学"]];
            return;
        }
        product[@"totalAddTax"] = dataList[9 * i + 9];
        product[@"totalNoTax"] = dataList[9 * i + 10];
        if ([product[@"taxType"] isEqualToString:@"01"] && [product[@"totalNoTax"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"単価 (外税)"]];
            return;
        }
        if ([product[@"taxType"] isEqualToString:@"02"] && [product[@"totalAddTax"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"単価 (内税)"]];
            return;
        }
        
        product[@"seq"] = dataList[9 * i + 11];
        NSString *rmNewLine = dataList[9 * i + 11];
        NSString *Sequence = [rmNewLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        product[@"seq"] = Sequence;
        if ([product[@"seq"] length] == 0) {
            [self.view makeToast:[ERROR_MSG_INVALID_FIELD stringByReplacingOccurrencesOfString:REPLACEMENT withString:@"シーケンス番号"]];
            return;
        }
        if ([product[@"seq"] intValue]%10 != (i + 1)%10) {
            [self.view makeToast:ERROR_MSG_SEQ_NO];
            return;
        }
        [productList addObject:product];
    }
    data[@"list"] = productList;
    if ([data[@"KindCnt"] intValue] <= 10) {
        if ([data[@"ProductCnt"] intValue] != totalQty) {
            [self.view makeToast:ERROR_MSG_PRODUCT_COUNT];
            return;
        }
        IncompletedNo = nil;
    }
    else {
//        int oldCount = 0;
//        for (NSDictionary *item in TableArray) {
//            if ([item[@"RCT_NO"] isEqualToString:data[@"RCT_NO"]]) {
//                oldCount++;
//            }
//        }
//        if (oldCount + productList.count == [data[@"KindCnt"] intValue]) {
//            IncompletedNo = nil;
//        }
//        else if (oldCount + productList.count > [data[@"KindCnt"] intValue]) {
//            [self.view makeToast:ERROR_MSG_PRODUCT_COUNT];
//            return;
//        }
//        else {
//            IncompletedNo = data[@"RCT_NO"];
//        }
    }
    NSLog(@"QR info ===================\n %@", data);
    [self inputValuesFromQRCode:data];
}

- (void) inputValuesFromQRCode:(NSMutableDictionary *)data {
    NSMutableArray *newList = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data[@"list"] count]; i++) {
        NSMutableDictionary *ItemInfo = [[NSMutableDictionary alloc] init];
        ItemInfo[@"SHOP_NAME"] = ShopInfo[@"MERCHANT_JPNM"];
        ItemInfo[@"RCT_NO"] = data[@"RCT_NO"];
        ItemTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"ItemType.json"][@"data"]];
        ItemType = [[NSMutableDictionary alloc] init];
        if ([data[@"list"][i][@"type"] isEqualToString:@"E"])   ItemType = ItemTypeList[0];
        else                                                    ItemType = ItemTypeList[1];
        ItemInfo[@"ITEM_TYPE"] = ItemType[@"id"];
        ItemInfo[@"ITEM_TYPE_TEXT"] = ItemType[LANGUAGE];
        ItemInfo[@"ITEM_NO"] = data[@"list"][i][@"seq"];
        ItemInfo[@"QTY"] = [NSString stringWithFormat:@"%i", [data[@"list"][i][@"qty"] intValue]];
        
        
        AllCategoryList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:CATEGORY_TABLE_KIND]];
        MainCatList = [NSMutableArray new];
        [self getMainCatList];
//        for (int j = 0; j < AllCategoryList.count; j++) {
//            if ([AllCategoryList[j][@"P_CODE"] isEqualToString:ItemType[@"id"]]) {
//                [MainCatList addObject:AllCategoryList[j]];
//            }
//        }
        
        MidCatList = [NSMutableArray new];
        [self getMidCatList];
//        for (int j = 0; j < AllCategoryList.count; j++) {
//            for (int k = 0; k < MainCatList.count; k++) {
//                if ([AllCategoryList[j][@"P_CODE"] isEqualToString:MainCatList[k][@"CATEGORY_CODE"]]) {
//                    [MidCatList addObject:AllCategoryList[j]];
//                }
//            }
//        }

        MainCategory = [[NSMutableDictionary alloc] init];
        MidCategory = [[NSMutableDictionary alloc] init];
        
        for (int j = 0; j < MidCatList.count; j++) {
            if ([[MidCatList[j][@"CATEGORY_NAME"] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:data[@"list"][i][@"name"]]) {
                MidCategory = MidCatList[j];
                break;
            }
            else if ([[MidCatList[j][@"CATEGORY_NAME"] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"その他"]) {
                MidCategory = MidCatList[j];
            }
        }
        if (MidCategory.count == 0) {
            MidCategory[@"CATEGORY_CODE"] = [ItemInfo[@"ITEM_TYPE"] isEqualToString:@"A0001"] ? @"C0167" : @"C0168";
            MidCategory[@"CATEGORY_NAME"] = @"その他";
        }
        ItemInfo[@"MID_CAT"] = MidCategory[@"CATEGORY_CODE"];
        ItemInfo[@"MID_CAT_TEXT"] = MidCategory[@"CATEGORY_NAME"];
        
        for (int k = 0; k < MainCatList.count; k++) {
            if ([MainCatList[k][@"CATEGORY_CODE"] isEqualToString:MidCategory[@"P_CODE"]]) {
                MainCategory = MainCatList[k];
            }
        }
        if (MainCategory.count == 0) {
            MainCategory[@"CATEGORY_CODE"] = [ItemInfo[@"ITEM_TYPE"] isEqualToString:@"A0001"] ? @"B0040" : @"B0041";
            MainCategory[@"CATEGORY_NAME"] = @"その他";
        }
        ItemInfo[@"MAIN_CAT"] = MainCategory[@"CATEGORY_CODE"];
        ItemInfo[@"MAIN_CAT_TEXT"] = MainCategory[@"CATEGORY_NAME"];

        ItemInfo[@"ITEM_NAME"] = @"その他";

        ItemInfo[@"TAX_AMT"] = data[@"list"][i][@"taxAmt"];

        int tax = [ItemInfo[@"TAX_AMT"] intValue];
                
        ItemInfo[@"TAX_TYPE"] = data[@"list"][i][@"taxType"];
        NSMutableArray *TaxTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"TaxType.json"][@"data"]];
        if ([ItemInfo[@"TAX_TYPE"] isEqualToString:@"01"]) {    //외세
            ItemInfo[@"TAX_TYPE_TEXT"] = TaxTypeList[0][LANGUAGE];
        }
        else {  // 내세
            ItemInfo[@"TAX_TYPE_TEXT"] = TaxTypeList[1][LANGUAGE];
        }
        ItemInfo[@"BUY_AMT"] = [ItemInfo[@"TAX_TYPE"] isEqualToString:@"01"] ? data[@"list"][i][@"totalNoTax"] : data[@"list"][i][@"totalAddTax"];
        ItemInfo[@"UNIT_AMT"] = ItemInfo[@"BUY_AMT"];
        
        ////////////////////////////////////
        int merchant_fee = 0;
        int gtf_fee = 0;
        int refund = 0;
        BOOL isFeeYN = NO;
        NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
        if (feeSettingInfo) {
            isFeeYN = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
        }
        if (isFeeYN) {
            NSMutableDictionary *feeInfo = feeSettingInfo[@"fee_info"][0];
            if ([feeInfo[@"fee_type"] isEqualToString:@"0"]) {
                refund = tax;
            }
            else if ([feeInfo[@"fee_type"] isEqualToString:@"1"]) {
                refund = [self getFixAmt:@"04" oldValue:(1 - [feeInfo[@"gtf_fee"] floatValue]) * tax];
                gtf_fee = tax - refund;
            }
            else if ([feeInfo[@"fee_type"] isEqualToString:@"2"]) {
                refund = [self getFixAmt:@"04" oldValue:(1 - [feeInfo[@"merchant_fee"] floatValue] - [feeInfo[@"gtf_fee"] floatValue]) * tax];
                merchant_fee = [self getFixAmt:@"04" oldValue:[feeInfo[@"merchant_fee"] floatValue] * tax];
                gtf_fee = tax - refund - merchant_fee;
            }
            else if ([feeInfo[@"fee_type"] isEqualToString:@"3"]) {
                refund = [self getFixAmt:@"04" oldValue:(1 - [feeInfo[@"merchant_fee"] floatValue]) * tax];
                merchant_fee = tax - refund;
            }
        }
        else {
            float fee_rate = [ShopInfo[@"FEE_RATE"] floatValue];
            refund = tax - [self getFixAmt:ShopInfo[@"FEE_POINT_PROC_CODE"] oldValue:(tax * fee_rate)];
        }
        
        NSLog(@"REFUND_AMT:: %i", refund);
        NSLog(@"MERCHANT_FEE_AMT:: %i", merchant_fee);
        NSLog(@"GTF_FEE_AMT:: %i", gtf_fee);
        /////////////////////////////////

        ItemInfo[@"REFUND_AMT"] = [NSString stringWithFormat:@"%i", refund];
        ItemInfo[@"MERCHANT_FEE_AMT"] = [NSString stringWithFormat:@"%i", merchant_fee];
        ItemInfo[@"GTF_FEE_AMT"] = [NSString stringWithFormat:@"%i", gtf_fee];
        ItemInfo[@"FEE_AMT"] = [NSString stringWithFormat:@"%i", tax - refund];
        
        ItemInfo[@"TAX_FORMULA"] = [NSString stringWithFormat:@"%f", [data[@"list"][i][@"taxFormula"] floatValue]/100.0f];
        ItemInfo[@"TAX_TYPE_CODE"] = [ItemInfo[@"TAX_FORMULA"] isEqualToString:@"0.08"] ? @"1" : @"2";

        ItemInfo[@"SHOP_NO"] = ShopInfo[@"MERCHANT_NO"];
        ItemInfo[@"USERID"] = kAppDelegate.LoginID;
        
        for (NSDictionary *item in TableArray) {
            if ([item[@"RCT_NO"] isEqualToString:ItemInfo[@"RCT_NO"]] && [item[@"ITEM_NO"] isEqualToString:ItemInfo[@"ITEM_NO"]]) {
                [self.view makeToast:ERROR_MSG_ALREADY_ADDED];
                return;
            }
        }
        [newList addObject:ItemInfo];
    }
    int oldCount = 0;
    for (NSDictionary *item in TableArray) {
        if ([item[@"RCT_NO"] isEqualToString:data[@"RCT_NO"]]) {
            oldCount++;
        }
    }
    if (oldCount + newList.count == [data[@"KindCnt"] intValue]) {
        IncompletedNo = nil;
    }
    else if (oldCount + newList.count > [data[@"KindCnt"] intValue]) {
        [self.view makeToast:ERROR_MSG_PRODUCT_COUNT];
        return;
    }
    else {
        IncompletedNo = data[@"RCT_NO"];
    }
    [TableArray addObjectsFromArray:newList];
    [self FilterTableArray];
    [CommonFunc saveArrayToLocal:TableArray key:TOTAL_ITEM_LIST];
    
    [_ItemTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == _BuyHistoryTableView) {
        return buyHistoryList.count;
    }
    return TableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    if (tableView == _BuyHistoryTableView) {
        BuyHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        NSMutableDictionary *historyItem = buyHistoryList[indexPath.row];
        cell.lblDate.text = [CommonFunc getDateStringWithFormat:[CommonFunc getDateFromString:historyItem[@"date"] format:@"yyyyMMdd"] format:@"yyyy.MM.dd"];
        cell.lblShopName.text = historyItem[@"merchant_name"];
        cell.lblAmt.text = [CommonFunc getCommaString:[historyItem[@"buy_amt"] stringValue]];
        
        return cell;
    }
    
    IssueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(cellDeleteClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
    if ([ItemInfo[@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
        cell.lblKind.text = @"一般品";
        cell.lblKind.textColor = OrangeColor;
        cell.colorView.backgroundColor = LightOrangeColor;
    }
    else {
        cell.lblKind.text = @"消耗品";
        cell.lblKind.textColor = BlueColor;
        cell.colorView.backgroundColor = LightBlueColor;
    }
    cell.lblRctNo.text = ItemInfo[@"RCT_NO"];
    cell.lblItemNo.text = ItemInfo[@"ITEM_NO"];
    cell.lblShopName.text = ItemInfo[@"SHOP_NAME"];
    cell.lblItemType.text = ItemInfo[@"ITEM_TYPE_TEXT"];
    cell.lblItemName.text = ItemInfo[@"ITEM_NAME"];
    cell.lblMainCat.text = ItemInfo[@"MAIN_CAT_TEXT"];
    cell.lblMidCat.text = ItemInfo[@"MID_CAT_TEXT"];
    cell.lblQty.text = [CommonFunc getCommaString:ItemInfo[@"QTY"]];
    cell.lblUnitAmt.text = [CommonFunc getCommaString:ItemInfo[@"UNIT_AMT"]];
    cell.lblTaxAmt.text = [CommonFunc getCommaString:ItemInfo[@"TAX_AMT"]];
    cell.lblBuyAmt.text = [CommonFunc getCommaString:ItemInfo[@"BUY_AMT"]];
    cell.lblRefundAmt.text = [CommonFunc getCommaString:ItemInfo[@"REFUND_AMT"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _BuyHistoryTableView) {
        return;
    }
    NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
    _txtReceiptNo.text = ItemInfo[@"RCT_NO"];
    
    AddItemViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddItem"];
    controller.RctNo = _txtReceiptNo.text;
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        float scrollViewWidth = scrollView.frame.size.width;
        if (scrollView.contentOffset.x < scrollViewWidth/2) {
            current_page = 0;
        }
        else if ( scrollViewWidth/2 < scrollView.contentOffset.x && scrollView.contentOffset.x < scrollViewWidth * 1.5) {
            current_page = 1;
        }
        else {
            current_page = 2;
        }
        [self PageConfig];
    }
}

- (void) PageConfig {
    NSString *ServerEnv = @"";
    NSString *TEST_URL = @"http://jp2admin.gtfetrs.com/service/jtc/";
    if (current_page == 0) {
        _lblTitle.text = @"取引登録";
        _btnLeft.hidden = YES;
        _btnRight.hidden = NO;
        _btnLeft2.hidden = YES;
        _btnRight2.hidden = YES;
        if ([API_URL isEqualToString:TEST_URL] == YES) {
            ServerEnv    = @"取引登録.........TEST Version";
            _lblTitle.text = ServerEnv;
        }
    }
    else if (current_page == 1) {
        _lblTitle.text = @"物品登録";
        _btnLeft.hidden = NO;
        _btnRight.hidden = YES;
        _btnLeft2.hidden = YES;
        _btnRight2.hidden = NO;
        if ([API_URL isEqualToString:TEST_URL] == YES) {
            ServerEnv    = @"物品登録.........TEST Version";
            _lblTitle.text = ServerEnv;
        }
    }
    else if (current_page == 2) {
        _lblTitle.text = @"店舗情報";
        _btnLeft.hidden = YES;
        _btnRight.hidden = YES;
        _btnLeft2.hidden = NO;
        _btnRight2.hidden = YES;
    }
}


- (IBAction)btnLeftClick:(id)sender {
    if (current_page == 1) {
        [_mainScrollView scrollRectToVisible:CGRectMake(0, 0, 100, 100) animated:YES];
    }
    else if (current_page == 2) {
        [_mainScrollView scrollRectToVisible:CGRectMake(_mainScrollView.frame.size.width, 0, 100, 100) animated:YES];
    }
}

- (IBAction)btnRightClick:(id)sender {
    if (current_page == 0) {
        if ([CommonFunc getValuesForKey:LIMIT_SETTING_INFO]) {
//            if (_mainScrollView.isScrollEnabled) {
//                [_mainScrollView scrollRectToVisible:CGRectMake(_mainScrollView.frame.size.width*2-100, 0, 100, 100) animated:YES];
//            }
//            else {
                if ([self validationCheck:YES bItem:NO]) {
                    [self checkLimitCustomer];
//                }
            }
        }
        else {
            [_mainScrollView scrollRectToVisible:CGRectMake(_mainScrollView.frame.size.width*2-100, 0, 100, 100) animated:YES];
        }
    }
    else if (current_page == 1) {
        [_mainScrollView scrollRectToVisible:CGRectMake(_mainScrollView.frame.size.width*3-100, 0, 100, 100) animated:YES];
    }
}

- (void)checkLimitCustomer {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userId"] = kAppDelegate.LoginID;
    params[@"merchant_no"] = [CommonFunc getValuesForKey:MERCHANT_NO];
    params[@"passport_no"] = _txtPassportNumber.text;
    params[@"nationality"] = _txtNationality.text;
    params[@"name"] = _txtPassportName.text;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    NSString *duration = [CommonFunc getValuesForKey:LIMIT_SETTING_INFO][@"duration"];
    if ([duration isEqualToString:@"1"]) {addComponents.day = -7;}
    if ([duration isEqualToString:@"2"]) {addComponents.month = -1;}
    if ([duration isEqualToString:@"3"]) {addComponents.month = -3;}
    if ([duration isEqualToString:@"4"]) {addComponents.month = -6;}
    if ([duration isEqualToString:@"5"]) {addComponents.year = -1;}
    if ([duration isEqualToString:@"6"]) {addComponents.year = -2;}
    if ([duration isEqualToString:@"7"]) {addComponents.year = -3;}
    NSDate *startDate = [calendar dateByAddingComponents:addComponents toDate:[NSDate date] options:0];
    params[@"startDate"] = [CommonFunc getDateStringWithFormat:startDate format:@"yyyyMMdd"];
    params[@"endDate"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
    params[@"buyAmt"] = [CommonFunc getValuesForKey:LIMIT_SETTING_INFO][@"limit"];
    params[@"buyOption"] = @"0";
    params[@"MerchantAll"] = [CommonFunc getValuesForKey:LIMIT_SETTING_INFO][@"MerchantAll"];
    params[@"MerchantManagerID"] = [CommonFunc getValuesForKey:LIMIT_SETTING_INFO][@"MerchantManagerID"];
    
    [SVProgressHUD showWithStatus:@"客様の情報を確認しています..."];
    [ConnectionMethods setTimeoutInterval:5.0f];
    [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_INFO_MSG_CHECK] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
        [SVProgressHUD dismiss];
        [ConnectionMethods setTimeoutInterval:30.0f];
//        self->_mainScrollView.scrollEnabled = YES;
        [self->_mainScrollView scrollRectToVisible:CGRectMake(self->_mainScrollView.frame.size.width*2-100, 0, 100, 100) animated:YES];
        if(status == ResponseStatusOK) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString* resultStatus = [responseObject objectForKey:@"result"];
                if([resultStatus isEqualToString:@"S"]){
                    if ([responseObject[@"msg_yn"] isEqualToString:@"Y"]) {
                        self->_lblLNBuySumAmt.text = [CommonFunc getCommaString:responseObject[@"totalBuyAmt"]];
                        self->buyHistoryList = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"buyList"]];
                        [self->_BuyHistoryTableView reloadData];
                        [self showLimitNotification];
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

- (IBAction)btnCloseGuideClick:(id)sender {
    _viewGuide.hidden = YES;
}


- (void) cellDeleteClick:(id) sender {
    UIButton *button = (UIButton *)sender;
    [TableArray removeObjectAtIndex:button.tag];
    [CommonFunc saveArrayToLocal:TableArray key:TOTAL_ITEM_LIST];
    [_ItemTableView reloadData];
}


////    Print    //////
- (void) PrintA4:(UIImage *)printImage {
    
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationLandscape;
    printInfo.jobName =@"Report";
    pc.printInfo = printInfo;
    
    NSData *imageData = UIImageJPEGRepresentation(printImage, 0.032f);
    pc.printingItem = imageData;
    //    pc.printingItem = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://test.com/Print_for_Client_Name.pdf"]];
    // You can use here image or any data type to print.
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error) {
            NSLog(@"Print failed - domain: %@ error code %ld", error.domain,
                  (long)error.code);
        }
    };
    [pc presentFromRect:CGRectMake(0, 0, 300, 300) inView:self.view animated:YES completionHandler:completionHandler];
}

- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    
}

- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    
}

- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController {
    
}

- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController {
    
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

- (BOOL) validationCheck:(BOOL) bPassPort bItem:(BOOL)bItem
{
    //데이터 미입력
    if (bPassPort){
        if ([_txtPassportName.text isEqualToString:@""] || [_txtPassportNumber.text isEqualToString:@""] || [_txtNationality.text isEqualToString:@""] || [_txtSex.text isEqualToString:@""] || [_txtDOB.text isEqualToString:@""] || [_txtExpiry.text isEqualToString:@""] || [_txtDateLanding.text isEqualToString:@""]) {
            [self.view makeToast:ERROR_PASSPORT];
            return NO;
        }
    }
    if(bItem) {
        if(TableArray.count == 0) {
            [self.view makeToast:NO_ITEM];
            return NO;
        }
    }
    return YES;
}


- (void) SaveAndPrint {
    
    NSString *tourist = @"";
    //    NSString * strSlipNo = @"";//전표번호
    NSString * strUnikey = [NSString stringWithFormat:@"%@%@", [CommonFunc stringPaddingLeft:configInfo[@"terminal_id"] newLength:5], [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%lld", [CommonFunc getSeq:UNIQ_KEY] % 1000] newLength:3]];//unikey
    NSString * totalSeq = @""; //totalseq
    signinfo = @"";
    
    NSString * SetPassportNo = @"";
    if(_txtPassportNumber.text.length < 7) {
        NSLog(@"여권번호의 길이가 너무 짧습니다!");
        for(int i = 0; i < (7 - _txtPassportNumber.text.length); i++) {
            if(i == (6 - _txtPassportNumber.text.length)) {
                SetPassportNo = [@"0" stringByAppendingString:SetPassportNo];
                SetPassportNo = [SetPassportNo stringByAppendingString:_txtPassportNumber.text];
            }
            else SetPassportNo = [@"0" stringByAppendingString:SetPassportNo];
        }
        NSLog(@"Changed Passport_No:: %@", SetPassportNo);
    }
    
    NSMutableDictionary *PassInfo = [[NSMutableDictionary alloc] init];
    PassInfo[@"RefundDate"] = _lblRefundDate.text;
    PassInfo[@"Nationality"] = _txtNationality.text;
    PassInfo[@"PassportNumber"] = _txtPassportNumber.text;
    PassInfo[@"CardNumber"] = _txtCardNumber.text;
    PassInfo[@"PassportName"] = _txtPassportName.text;
    PassInfo[@"NationalityName"] = _txtNationality.placeholder;
    PassInfo[@"DOB"] = _txtDOB.text;
    PassInfo[@"ResidenceState"] = _txtResidenceState.text;
    PassInfo[@"DateLanding"] = _txtDateLanding.text;
   
    
    
    
    [CommonFunc saveUserDefaults:PASSPORT_INFO value:PassInfo];
    
    tourist = PassportType[LANGUAGE];
    tourist = [tourist stringByAppendingString:@"|"];
    tourist = [tourist stringByAppendingString:[CommonFunc getValuesForKey:PASSPORT_INFO][@"PassportNumber"]];
    tourist = [tourist stringByAppendingString:@"|"];
    tourist = [tourist stringByAppendingString:[CommonFunc getValuesForKey:PASSPORT_INFO][@"PassportName"]];
    tourist = [tourist stringByAppendingString:@"|"];
    tourist = [tourist stringByAppendingString:[CommonFunc getValuesForKey:PASSPORT_INFO][@"NationalityName"]];
    tourist = [tourist stringByAppendingString:@"|"];
    tourist = [tourist stringByAppendingString:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"DOB"] stringByReplacingOccurrencesOfString:@"." withString:@""]];
    tourist = [tourist stringByAppendingString:@"|"];
    tourist = [tourist stringByAppendingString:[CommonFunc getValuesForKey:PASSPORT_INFO][@"ResidenceState"]];
    tourist = [tourist stringByAppendingString:@"|"];
    tourist = [tourist stringByAppendingString:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"DateLanding"] stringByReplacingOccurrencesOfString:@"." withString:@""]];
    tourist = [tourist stringByAppendingString:@"|"];
    
    if([configInfo[@"receipt_add"] isEqualToString:@"YES"]) {
        //소비세 50만 제한 체크 위해 변수 추가
        NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:[CommonFunc SearchSlips:[CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"] strEndDate:[CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"] strSendFlag:nil strSlipStatus:nil strSlipNo:nil]];
        
        for (int i = 0; i < arrTemp.count; i++) {
            if (([arrTemp[i][@"date"] intValue] < [[CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"] intValue]) ) {
                [arrTemp removeObjectAtIndex:i];
                i--;
            }
        }
        
        NSMutableDictionary *shop_consum_amt = [[NSMutableDictionary alloc] init];
        
        if (arrTemp.count > 0) {
            for (int i = 0; i < arrTemp.count; i++) {
                NSMutableDictionary *tempObj = arrTemp[i];
                if (tempObj[@"CONSUMS_BUY_AMT"]) {
                    NSString *BuyerNo = @"";
                    if (isPassport) {
                        BuyerNo = tempObj[@"PASSPORT_SERIAL_NO"];
                    }
                    else {
                        BuyerNo = tempObj[@"PERMIT_NO"];
                    }
                    if ([shop_consum_amt.allKeys containsObject:[NSString stringWithFormat:@"%@%@%@", tempObj[@"MERCHANTNO"], BuyerNo, tempObj[@"NATIONALITY_CODE"]]]) {
                        int current_amt = [shop_consum_amt[[NSString stringWithFormat:@"%@%@%@", tempObj[@"MERCHANTNO"], BuyerNo, tempObj[@"NATIONALITY_CODE"]]] intValue];
                        
                        shop_consum_amt[[NSString stringWithFormat:@"%@%@%@", tempObj[@"MERCHANTNO"], BuyerNo, tempObj[@"NATIONALITY_CODE"]]]
                        = [NSString stringWithFormat:@"%d", current_amt + [tempObj[@"CONSUMS_BUY_AMT"] intValue]];
                    }
                    else {
                        shop_consum_amt[[NSString stringWithFormat:@"%@%@%@", tempObj[@"MERCHANTNO"], BuyerNo, tempObj[@"NATIONALITY_CODE"]]] = tempObj[@"CONSUMS_BUY_AMT"];
                    }
                }
            }
        }
        
        
        //전표 전체 금액
        nSlipTotalTaxAmt = 0;
        nSlipTotalBuyAmt = 0;
        nSlipTotalRefundAmt = 0;
        nSlipTotalFeeAmt = 0;
        
        
        int nSlipTotalGoodsBuyAmt = 0;
        int nSlipTotalConsumsBuyAmt = 0;
        
        nSlipTotalGoodsNoTaxBuyAmt = 0;
        nSlipTotalConsumsNoTaxBuyAmt = 0;
        
        NSMutableArray *arrSlips = [[NSMutableArray alloc] init];
        
        NSMutableArray * arr_RCT = [[NSMutableArray alloc] init];      //shop + 영수증별 전표 출력을 위해
        
        for (int i = 0; i < tempTableArray.count; i++) {
            if (![arr_RCT containsObject:tempTableArray[i][@"RCT_NO"]]) {
                [arr_RCT addObject:tempTableArray[i][@"RCT_NO"]];
            }
        }
        
        Rct_SlipNoList = [[NSMutableArray alloc] init];
        
        //매장+영수증별 전표 출력
        for (int j = 0; j < arr_RCT.count; j++) {
            NSString *strSlipNo = [self createSlipNo];
            NSLog(@"strSlipNo 값입니다... :: %@ ", strSlipNo);
            kAppDelegate.url_gtf_slip_no = [NSMutableString stringWithString:strSlipNo];

            NSMutableDictionary *Rct_SlipNo = [[NSMutableDictionary alloc] init];
            Rct_SlipNo[@"RCT_NO"] = arr_RCT[j];
            Rct_SlipNo[@"SLIP_NO"] = strSlipNo;
            [Rct_SlipNoList addObject:Rct_SlipNo];
            
            NSString *strTAX_PROC_TIME_CODE = ShopInfo[@"TAX_PROC_TIME_CODE"];
            NSString *strTAX_POINT_PROC_CODE = ShopInfo[@"TAX_POINT_PROC_CODE"];
            
            //매장정보 체크
            
            NSString *retailer = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|", ShopInfo[@"TAXOFFICE_NAME"], ShopInfo[@"TAX_ADDR1"], ShopInfo[@"TAX_ADDR2"], ShopInfo[@"MERCHANT_JPNM"], ShopInfo[@"JP_ADDR1"], ShopInfo[@"JP_ADDR2"]];
            if (ShopInfo[@"OPT_CORP_JPNM"]) {
                retailer = [NSString stringWithFormat:@"%@%@", retailer, ShopInfo[@"OPT_CORP_JPNM"]];
            }
            //전표 내용
            NSString *docid = @"";
            
            NSString *strSlipLang = @"EN";
            if ([ShopInfo[@"NATIONALITY_MAPPING_USEYN"] isEqualToString:@"Y"]) {
                if ([[CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"] isEqualToString:@"CHN"] || [[CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"] isEqualToString:@"TWN"]) {
                    strSlipLang = @"CN";
                    LanguageNo = 2;
                }
                else if ([[CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"] isEqualToString:@"KOR"]) {
                    strSlipLang = @"KR";
                    LanguageNo = 3;
                }
                else {
                    LanguageNo = 1;
                }
            }
            
            docid = strSlipLang;                         //출력언어
            
            
            if ([configInfo[@"print_choice"] isEqualToString:@"01"]){
                //출력전표 갯수
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:@"2"];
                //출력
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:@"01/02"];
            }
            else if ([configInfo[@"print_choice"] isEqualToString:@"02"]){
                //출력전표 갯수
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:@"1"];
                //출력
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:@"01"];
            }
            
            else if ([configInfo[@"print_choice"] isEqualToString:@"03"]){
                //출력전표 갯수
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:@"2"];
                //출력
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:@"01/02"];
            }
            
            //출력유형
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"[REPUBLISH]"];
            
            //전표번호(Slip No)
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:strSlipNo];
            
            //합산전표 출력여부
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"N"];
            
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:RefundType[@"id"]];
            
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:RefundType[LANGUAGE]];
            
            
            if ([RefundType[@"id"] isEqualToString:@"01"])//환급방법
            {
                docid = [docid stringByAppendingString:@"|"];
            }
            else
            {
                if ([RefundType[@"id"] isEqualToString:@"04"])//카드환급
                {
                    docid = [docid stringByAppendingString:@"|"];
                    docid = [docid stringByAppendingString:@"****-****-****"];
                    docid = [docid stringByAppendingString:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] substringFromIndex:14]];
                }
                else if ([RefundType[@"id"] isEqualToString:@"06"])//QQ 번호 마스킹
                {
                    docid = [docid stringByAppendingString:@"|"];
                    for (int k = 0; k < [[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] length] - 4; k++) {
                        docid = [docid stringByAppendingString:@"*"];
                    }
                    docid = [docid stringByAppendingString:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] substringFromIndex:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] length] - 4]];
                }
                else {
                    docid = [docid stringByAppendingString:@"|"];
                    docid = [docid stringByAppendingString:[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"]];
                }
            }
            
            //전표단축번호
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:strUnikey];
            
            
            //물품부 체크
            
            //매장별로 물품 묶어서 팔면 되겠네
            //1.일반/소비품 둘다 있는지 확인
            //2. 매장별로 일반물품 목록 저장
            //3. 일반물품 sum 데이터 추출
            //4. 매장별로 소비품 목록 저장
            //5. 소비품 sum 데이터 추출
            
            NSString *goods = @"";
            //판매일
            goods = [[CommonFunc getValuesForKey:PASSPORT_INFO][@"RefundDate"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSMutableArray *arrGoods = [[NSMutableArray alloc] init];
            NSMutableArray *arrConsums = [[NSMutableArray alloc] init];
            
            NSMutableArray *arrTotalGoodsList = [[NSMutableArray alloc] init];     //로컬 DB Insert 용 전표 물품 정보
            
            
            int nGoods_Sum_Tax = 0;
            int nGoods_Sum_Buy_InTax = 0;
            int nGoods_Sum_Buy_NoTax = 0;
            int nGoods_Sum_Buy = 0;
            int nGoods_Sum_Refund = 0;
            
            int nConsums_Sum_Tax = 0;
            int nConsums_Sum_Buy_InTax = 0;
            int nConsums_Sum_Buy_NoTax = 0;
            int nConsums_Sum_Buy = 0;
            int nConsums_Sum_Refund = 0;
            
            
            
            BOOL bInTax = NO;
            BOOL bOutTax = NO;
            //전표 물품 데이터 등록
            for (int i = 0; i < tempTableArray.count; i++)
            {
                if ([arr_RCT[j] isEqualToString:tempTableArray[i][@"RCT_NO"]])//현재 대상 매장 + 영수증번호면 처리
                {
                    NSMutableDictionary *tempObj = [[NSMutableDictionary alloc] initWithDictionary:tempTableArray[i]]; //출력용
                    tempObj[@"SLIP_NO"] = strSlipNo;
                    tempObj[@"REG_DTM"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
                    
                    if ([tempObj[@"ITEM_TYPE"] isEqualToString:@"A0001"])//일반물품
                    {
                        [arrGoods addObject:tempObj];
                    }
                    else    //소비물품
                    {
                        [arrConsums addObject:tempObj];
                    }
                    [arrTotalGoodsList addObject:tempObj];
                }
            }
            
            if (arrGoods.count > 0 && arrConsums.count > 0)
            {
                //물품 판매 갯수(일반/소비)
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:@"2"];
                
            }
            else if (arrGoods.count > 0 || arrConsums.count > 0)
            {
                //물품 판매 갯수(일반/소비)
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:@"1"];
            }
            else
            {
                [self.view makeToast:ERROR_ISSUE];
                return;
            }
            
            //소비
            if (arrConsums.count > 0)
            {
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:@"01"];           //물품종류(일반/소비)
                
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)arrConsums.count]]; //물품갯수
                
                for (int i = 0; i < arrConsums.count; i++)
                {
                    NSMutableDictionary *tempObj = [[NSMutableDictionary alloc] initWithDictionary:arrConsums[i]];
                    
                    int nQty = [tempObj[@"QTY"] intValue];
                    int nBuy = [tempObj[@"BUY_AMT"] intValue];
                    int nTax = [tempObj[@"TAX_AMT"] intValue];
                    
                    int nUnit = (nBuy - nTax) / nQty;
                    
                    goods = [goods stringByAppendingString:@"|"];
                    goods = [goods stringByAppendingString:tempObj[@"MAIN_CAT_TEXT"]];
                    
                    //물품 총액 & 총판매액
                    if ([tempObj[@"TAX_TYPE"] isEqualToString:@"02"])             //내세
                    {
                        bInTax = YES;
                        if ([tempObj[@"UNIT_AMT"] intValue] == [tempObj[@"BUY_AMT"] intValue])
                        {
                            goods = [goods stringByAppendingString:@"|"];
                            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", [tempObj[@"UNIT_AMT"] intValue] - nTax]]; //물품단가
                        }
                        else
                        {
                            //물품단가
                            goods = [goods stringByAppendingString:@"|"];
                            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nUnit]];
                        }
                        
                        //물품갯수
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"QTY"]];
                        
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", [tempObj[@"BUY_AMT"] intValue] - [tempObj[@"TAX_AMT"] intValue]]];
                        
                        
                        nConsums_Sum_Buy_NoTax += [tempObj[@"BUY_AMT"] intValue] - [tempObj[@"TAX_AMT"] intValue];
                        nConsums_Sum_Buy_InTax += [tempObj[@"BUY_AMT"] intValue];
                    }
                    else                                                            //외세
                    {
                        bOutTax = YES;
                        //물품단가
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"UNIT_AMT"]];
                        
                        
                        //물품갯수
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"QTY"]];
                        
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"BUY_AMT"]];
                        
                        
                        nConsums_Sum_Buy_NoTax += [tempObj[@"BUY_AMT"] intValue];
                    }
                    
                    nConsums_Sum_Buy += [tempObj[@"BUY_AMT"] intValue];     //총판매액
                    nConsums_Sum_Tax += [tempObj[@"TAX_AMT"] intValue];     //총세금
                    nConsums_Sum_Refund += [tempObj[@"REFUND_AMT"] intValue];//총환급액
                }
                
                //총판매액
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nConsums_Sum_Buy_NoTax]];
                
                //총세금
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nConsums_Sum_Tax]];
                
                //총환급액
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nConsums_Sum_Refund]];
                
                //AllStoresTotalAmt
                goods = [goods stringByAppendingString:@"|[COMSUMS_TOTAL]"];
            }
            
            //매장별 소비품 금액 확인
            if ([shop_consum_amt.allKeys containsObject:[NSString stringWithFormat:@"%@%@%@", [CommonFunc getValuesForKey:MERCHANT_NO], [CommonFunc getValuesForKey:PASSPORT_INFO][@"PassportNumber"], [CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"]]])
            {
                int current_amt = [shop_consum_amt[[NSString stringWithFormat:@"%@%@%@", [CommonFunc getValuesForKey:MERCHANT_NO], [CommonFunc getValuesForKey:PASSPORT_INFO][@"PassportNumber"], [CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"]]] intValue];
                
                shop_consum_amt[[NSString stringWithFormat:@"%@%@%@", [CommonFunc getValuesForKey:MERCHANT_NO], [CommonFunc getValuesForKey:PASSPORT_INFO][@"PassportNumber"], [CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"]]]
                = [NSString stringWithFormat:@"%d", current_amt + nConsums_Sum_Buy_NoTax];
            }
            else
            {
                shop_consum_amt[[NSString stringWithFormat:@"%@%@%@", [CommonFunc getValuesForKey:MERCHANT_NO], [CommonFunc getValuesForKey:PASSPORT_INFO][@"PassportNumber"], [CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"]]]
                = [NSString stringWithFormat:@"%d", nConsums_Sum_Buy_NoTax];
            }
            
            //일반
            if (arrGoods.count > 0)
            {
                //물품종류(일반/소비)
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:@"02"];
                
                //물품갯수
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%lu", arrGoods.count]];
                
                
                for (int i = 0; i < arrGoods.count; i++)
                {
                    NSMutableDictionary *tempObj = [[NSMutableDictionary alloc] initWithDictionary:arrGoods[i]];
                    
                    int nQty = [tempObj[@"QTY"] intValue];
                    int nBuy = [tempObj[@"BUY_AMT"] intValue];
                    int nTax = [tempObj[@"TAX_AMT"] intValue];
                    int nUnit = (nBuy - nTax) / nQty;
                    
                    //물품명
                    goods = [goods stringByAppendingString:@"|"];
                    goods = [goods stringByAppendingString:tempObj[@"MAIN_CAT_TEXT"]];
                    
                    if ([tempObj[@"TAX_TYPE"] isEqualToString:@"02"])             //내세
                    {
                        bInTax = YES;
                        if ([tempObj[@"UNIT_AMT"] intValue] == [tempObj[@"BUY_AMT"] intValue])
                        {
                            goods = [goods stringByAppendingString:@"|"];
                            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", [tempObj[@"UNIT_AMT"] intValue] - nTax]]; //물품단가
                        }
                        else
                        {
                            //물품단가
                            goods = [goods stringByAppendingString:@"|"];
                            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nUnit]];
                        }
                        
                        //물품갯수
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"QTY"]];
                        
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", [tempObj[@"BUY_AMT"] intValue] - [tempObj[@"TAX_AMT"] intValue]]];
                        
                        
                        nGoods_Sum_Buy_NoTax += [tempObj[@"BUY_AMT"] intValue] - [tempObj[@"TAX_AMT"] intValue];
                        nGoods_Sum_Buy_InTax += [tempObj[@"BUY_AMT"] intValue];
                    }
                    else                                                            //외세
                    {
                        bOutTax = YES;
                        //물품단가
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"UNIT_AMT"]];
                        
                        
                        //물품갯수
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"QTY"]];
                        
                        goods = [goods stringByAppendingString:@"|"];
                        goods = [goods stringByAppendingString:tempObj[@"BUY_AMT"]];
                        
                        
                        nGoods_Sum_Buy_NoTax += [tempObj[@"BUY_AMT"] intValue];
                    }
                    
                    nGoods_Sum_Buy += [tempObj[@"BUY_AMT"] intValue];     //총판매액
                    nGoods_Sum_Tax += [tempObj[@"TAX_AMT"] intValue];     //총세금
                    nGoods_Sum_Refund += [tempObj[@"REFUND_AMT"] intValue];//총환급액
                }
                
                //총판매액
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nGoods_Sum_Buy_NoTax]];
                
                //총세금
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nGoods_Sum_Tax]];
                
                //총환급액
                goods = [goods stringByAppendingString:@"|"];
                goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nGoods_Sum_Refund]];
                
                //AllStoresTotalAmt
                goods = [goods stringByAppendingString:@"|[GOODS_TOTAL]"];
            }
            
            //(일반+소비)총세금
            goods = [goods stringByAppendingString:@"|"];
            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nGoods_Sum_Tax + nConsums_Sum_Tax]];
            
            //(일반+소비)총판매액
            goods = [goods stringByAppendingString:@"|"];
            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nGoods_Sum_Buy + nConsums_Sum_Buy]];
            
            //(일반+소비)수수료
            goods = [goods stringByAppendingString:@"|"];
            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nGoods_Sum_Tax + nConsums_Sum_Tax- nGoods_Sum_Refund - nConsums_Sum_Refund]];
            
            //(일반+소비)총환급액
            goods = [goods stringByAppendingString:@"|"];
            goods = [goods stringByAppendingString:[NSString stringWithFormat:@"%d", nGoods_Sum_Refund + nConsums_Sum_Refund]];
            
            nSlipTotalGoodsBuyAmt += nGoods_Sum_Buy;
            nSlipTotalConsumsBuyAmt += nConsums_Sum_Buy;
            
            nSlipTotalGoodsNoTaxBuyAmt += nGoods_Sum_Buy_NoTax;
            nSlipTotalConsumsNoTaxBuyAmt += nConsums_Sum_Buy_NoTax;
            
            nSlipTotalTaxAmt += nGoods_Sum_Tax + nConsums_Sum_Tax;
            nSlipTotalBuyAmt += nGoods_Sum_Buy + nConsums_Sum_Buy;
            nSlipTotalRefundAmt += nGoods_Sum_Refund + nConsums_Sum_Refund;
            nSlipTotalFeeAmt += nGoods_Sum_Tax + nConsums_Sum_Tax - nGoods_Sum_Refund - nConsums_Sum_Refund;
            
            NSMutableDictionary *jsonSlip = [[NSMutableDictionary alloc] initWithDictionary:passportInfo];
            jsonSlip[@"SLIP_NO"] = strSlipNo;
            jsonSlip[@"MERCHANT_NO"] = [CommonFunc getValuesForKey:MERCHANT_NO];
            jsonSlip[@"SHOP_NAME"] = ShopInfo[@"MERCHANT_JPNM"];
            jsonSlip[@"OUT_DIV_CODE"] = @"00";
            jsonSlip[@"REFUND_WAY_CODE"] = RefundType[@"id"];
            jsonSlip[@"REFUND_WAY_CODE_NAME"] = RefundType[LANGUAGE];
            jsonSlip[@"SLIP_STATUS_CODE"] = @"01";               //최초 등록시에는 01
            jsonSlip[@"TML_ID"] = configInfo[@"terminal_id"];
            jsonSlip[@"REFUND_CARDNO"] = [[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] stringByReplacingOccurrencesOfString:@"-" withString:@""];   // test
            jsonSlip[@"REFUND_CARD_CODE"] = @"";
            jsonSlip[@"TOTAL_SLIPSEQ"] = totalSeq;
            
            if (bInTax && bOutTax)
                strTAX_PROC_TIME_CODE = @"03";
            else if (bOutTax)
                strTAX_PROC_TIME_CODE = @"01";
            else if (bInTax)
                strTAX_PROC_TIME_CODE = @"02";
            
            jsonSlip[@"TAX_PROC_TIME_CODE"] = strTAX_PROC_TIME_CODE;
            jsonSlip[@"TAX_POINT_PROC_CODE"] = strTAX_POINT_PROC_CODE;
            jsonSlip[@"GOODS_BUY_AMT"] = [NSString stringWithFormat:@"%d", nGoods_Sum_Buy_NoTax];
            jsonSlip[@"GOODS_TAX_AMT"] = [NSString stringWithFormat:@"%d", nGoods_Sum_Tax];
            jsonSlip[@"GOODS_REFUND_AMT"] = [NSString stringWithFormat:@"%d", nGoods_Sum_Refund];
            jsonSlip[@"CONSUMS_BUY_AMT"] = [NSString stringWithFormat:@"%d", nConsums_Sum_Buy_NoTax];
            jsonSlip[@"CONSUMS_TAX_AMT"] = [NSString stringWithFormat:@"%d", nConsums_Sum_Tax];
            jsonSlip[@"CONSUMS_REFUND_AMT"] = [NSString stringWithFormat:@"%d", nConsums_Sum_Refund];
            jsonSlip[@"TOTAL_EXCOMM_IN_TAX_SALE_AMT"] = [NSString stringWithFormat:@"%d", nGoods_Sum_Buy_InTax];
            jsonSlip[@"TOTAL_COMM_IN_TAX_SALE_AMT"] = [NSString stringWithFormat:@"%d", nConsums_Sum_Buy_InTax];
            
            jsonSlip[@"UNIKEY"] = strUnikey;
            jsonSlip[@"SALEDT"] = [CommonFunc getStringFromDate:[NSDate date]];
            jsonSlip[@"REFUNDDT"] = @"";
            jsonSlip[@"USERID"] = kAppDelegate.LoginID;
            jsonSlip[@"MERCHANTNO"] = [CommonFunc getValuesForKey:MERCHANT_NO];
            jsonSlip[@"DESKID"] = [CommonFunc getValuesForKey:DESK_ID];
            jsonSlip[@"COMPANYID"] = COMPANY_ID;
            jsonSlip[@"SEND_FLAG"] = @"N";
            jsonSlip[@"PRINT_CNT"] = @"0";
            jsonSlip[@"REG_DTM"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];   //등록일
            
            jsonSlip[@"S_M_FEE"] = @"0";
            jsonSlip[@"S_G_FEE"] = @"0";
            jsonSlip[@"MERCHANT_FEE"] = [NSString stringWithFormat:@"%i", total_merchant_fee_amt];
            jsonSlip[@"GTF_FEE"] = [NSString stringWithFormat:@"%i", total_gtf_fee_amt];
            NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
            BOOL isFeeYN = NO;
            if (feeSettingInfo) {
                isFeeYN = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
            }
            if (isFeeYN) {
                NSMutableDictionary *feeInfo = feeSettingInfo[@"fee_info"][0];
                jsonSlip[@"S_M_FEE"] = [NSNumber numberWithFloat:[feeInfo[@"merchant_fee"] floatValue]].stringValue;
                jsonSlip[@"S_G_FEE"] = [NSNumber numberWithFloat:[feeInfo[@"gtf_fee"] floatValue]].stringValue;
            }
            jsonSlip[@"P_INPUT_TYPE"] = p_input_type;
            
            // sign data
            
            if ([configInfo[@"signpad_use"] isEqualToString:@"YES"]) {
                signinfo = [CommonFunc imageToNSString:[CommonFunc signImageResize:signImage size:CGSizeMake(140, 70)]];
            }
            else {
                signinfo = @"";
            }
            
            //전표 출력데이터 등록
            NSMutableDictionary *slipDocs = [[NSMutableDictionary alloc] init];
            slipDocs[@"SLIP_NO"] = strSlipNo;
            slipDocs[@"DOCID"] = docid;
            slipDocs[@"RETAILER"] = retailer;
            slipDocs[@"GOODS"] = goods;
            slipDocs[@"TOURIST"] = tourist;
            slipDocs[@"PREVIEW"] = ShopInfo[@"PREVIEW_USEYN"];
            slipDocs[@"SIGN"] = signinfo;
            
            
            //통합 등록
            NSMutableDictionary * TotalInfo = [[NSMutableDictionary alloc] init];
            TotalInfo[@"SLIP"] = jsonSlip;
            TotalInfo[@"ITEMS"] = arrTotalGoodsList;
            TotalInfo[@"DOCS"] = slipDocs;
            
            [arrSlips addObject:TotalInfo];
        }
        
        //거래일 소비물품 금액 제한 체크
        for (int i = 0; i < [shop_consum_amt.allKeys count]; i++) {
            NSArray *allKeyList = shop_consum_amt.allKeys;
            if ([shop_consum_amt[allKeyList[i]] intValue] > 500000) {
                [self.view makeToast:[NSString stringWithFormat:@"%@:%@", ShopInfo[@"MERCHANT_JPNM"], ERROR_CONSUMS_MAX_AMT]];
                return;
            }
        }
        
        //금액 체크
        if (nSlipTotalGoodsBuyAmt == 0 && nSlipTotalConsumsBuyAmt == 0) {
            [self.view makeToast:ERROR_GOODS_AMT];
            return;
        }
        
        if (nSlipTotalGoodsNoTaxBuyAmt > 0 && nSlipTotalGoodsNoTaxBuyAmt < 5000) {
            [self.view makeToast:ERROR_GOODS_AMT];
            return;
        }
        if (nSlipTotalConsumsNoTaxBuyAmt > 0 && nSlipTotalConsumsNoTaxBuyAmt < 5000) {
            [self.view makeToast:ERROR_COMSUMS_AMT];
            return;
        }
        
        
        if ([configInfo[@"printer"] isEqualToString:@"A4"]) {
            NSMutableArray *PrintList = [[NSMutableArray alloc] init];
            for (int i = 0; i < arrSlips.count; i++) {
                NSMutableDictionary *tmpDocs = [[NSMutableDictionary alloc] initWithDictionary:arrSlips[i][@"DOCS"]];
                
                NSString *tmpDocid = tmpDocs[@"DOCID"];
                tmpDocid = [tmpDocid stringByReplacingOccurrencesOfString:@"[REPUBLISH]" withString:@"0"];
                NSString *tmpRetailer = tmpDocs[@"RETAILER"];
                NSString *tmpGoods = tmpDocs[@"GOODS"];
                tmpGoods = [tmpGoods stringByReplacingOccurrencesOfString:@"[COMSUMS_TOTAL]" withString:[NSString stringWithFormat:@"%i", nSlipTotalConsumsNoTaxBuyAmt]];//치환. 세금제외 금액으로.
                
                tmpGoods = [tmpGoods stringByReplacingOccurrencesOfString:@"[GOODS_TOTAL]" withString:[NSString stringWithFormat:@"%i", nSlipTotalGoodsNoTaxBuyAmt]];//치환. 세금제외 금액으로.
                tmpDocs[@"GOODS"] = tmpGoods;
                NSString *tmpTourist = tmpDocs[@"TOURIST"];
                
                [CommonFunc InsertSlip:arrSlips[i][@"SLIP"] arrItems:arrSlips[i][@"ITEMS"] jsonSlipDocs:tmpDocs];
                BOOL isExistSlip = [CommonFunc isExistSlip:arrSlips[i][@"SLIP"][@"SLIP_NO"]];
                if (!isExistSlip) {
                    [self.view makeToast:ERROR_DB_FAILED];
                    return;
                }
                
                if ([configInfo[@"signpad_use"] isEqualToString:@"YES"] && ![signinfo isEqualToString:@""]) {
                    NSMutableDictionary *tmpSign = [[NSMutableDictionary alloc] init];
                    tmpSign[@"SLIP_NO"] = arrSlips[i][@"SLIP"][@"SLIP_NO"];
                    tmpSign[@"SLIP_SIGN_DATA"] = signinfo;
                    tmpSign[@"SEND_YN"] = @"N";
                    tmpSign[@"REG_DTM"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
                    
                    [CommonFunc InsertSlipSign:tmpSign];
                }
                
                MapDocid = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseDocid:tmpDocid]];
                MapRetailer = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseRetailer:tmpRetailer]];
                MapGoods = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseGoods:tmpGoods]];
                MapTourist = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseTourist:tmpTourist]];
                
                [PrintList addObject:[self CreatePrintJson]];
            }
            
            NSMutableDictionary *resultJson = [[NSMutableDictionary alloc] init];
            resultJson[@"data_list"] = PrintList;
            
            ///**  Air Print  **///
            if (![configInfo[@"print_choice"] isEqualToString:@"03"]){
                [CommonFunc saveArrayToLocal:PrintList key:PRINT_LIST];
                [PrintView loadXIB:self];
            }
            else {
                for (int i = 0; i < arrSlips.count; i++) {
                    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"02" conditionField:SLIP_NO conditionValue:arrSlips[i][@"SLIP"][SLIP_NO]];
                    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:REFUNDDT newValue:[CommonFunc getStringFromDate:[NSDate date]] conditionField:SLIP_NO conditionValue:arrSlips[i][@"SLIP"][SLIP_NO]];
                    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:PRINT_CNT newValue:@"0" conditionField:SLIP_NO conditionValue:arrSlips[i][@"SLIP"][SLIP_NO]];
                }
            }
            //            [self Screen_Clear];
            //////////////////////////////////////////////////////////////////////
        }
        else {
            for (int i = 0; i < arrSlips.count; i++) {
                [CommonFunc InsertSlip:arrSlips[i][@"SLIP"] arrItems:arrSlips[i][@"ITEMS"] jsonSlipDocs:arrSlips[i][@"DOCS"]];
                
                BOOL isExistSlip = [CommonFunc isExistSlip:arrSlips[i][@"SLIP"][@"SLIP_NO"]];
                if (!isExistSlip) {
                    [self.view makeToast:ERROR_DB_FAILED];
                    return;
                }
                if ([configInfo[@"signpad_use"] isEqualToString:@"YES"] && ![signinfo isEqualToString:@""]) {
                    NSMutableDictionary *tmpSign = [[NSMutableDictionary alloc] init];
                    tmpSign[@"SLIP_NO"] = arrSlips[i][@"SLIP"][@"SLIP_NO"];
                    tmpSign[@"SLIP_SIGN_DATA"] = signinfo;
                    tmpSign[@"SEND_YN"] = @"N";
                    tmpSign[@"REG_DTM"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
                    
                    [CommonFunc InsertSlipSign:tmpSign];
                }
            }
            
            if (![configInfo[@"print_choice"] isEqualToString:@"03"]){
                printSlipList = [[NSMutableArray alloc] initWithArray:arrSlips];
                [self EpsonPrint];
            }
            else {
                for (int i = 0; i < arrSlips.count; i++) {
                    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"02" conditionField:SLIP_NO conditionValue:arrSlips[i][@"SLIP"][SLIP_NO]];
                    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:REFUNDDT newValue:[CommonFunc getStringFromDate:[NSDate date]] conditionField:SLIP_NO conditionValue:arrSlips[i][@"SLIP"][SLIP_NO]];
                    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:PRINT_CNT newValue:@"0" conditionField:SLIP_NO conditionValue:arrSlips[i][@"SLIP"][SLIP_NO]];
                }
                //                [self Screen_Clear];
            }
        }
    }
    else {
        // 영수증 첨부 개발
        NSMutableArray *arrSlips = [[NSMutableArray alloc] init];
        NSString *strSlipNo = [self createSlipNo];
        NSLog(@"strSlipNo 값입니다... :: %@ ", strSlipNo);
        kAppDelegate.url_gtf_slip_no = [NSMutableString stringWithString:strSlipNo];
        NSLog(@"//////////////////////////////////////////");
        //매장정보 체크
        NSString *retailer = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|", ShopInfo[@"TAXOFFICE_NAME"], ShopInfo[@"TAX_ADDR1"], ShopInfo[@"TAX_ADDR2"], ShopInfo[@"MERCHANT_JPNM"], ShopInfo[@"JP_ADDR1"], ShopInfo[@"JP_ADDR2"]];
        if (ShopInfo[@"OPT_CORP_JPNM"]) {
            retailer = [NSString stringWithFormat:@"%@%@", retailer, ShopInfo[@"OPT_CORP_JPNM"]];
        }
        
        
        //전표 내용
        NSString *docid = @"";
        
        NSString *strSlipLang = @"JP";
        if ([ShopInfo[@"NATIONALITY_MAPPING_USEYN"] isEqualToString:@"Y"]) {
            if ([[CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"] isEqualToString:@"CHN"] || [[CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"] isEqualToString:@"TWN"]) {
                strSlipLang = @"CN";
                LanguageNo = 2;
            }
            else if ([[CommonFunc getValuesForKey:PASSPORT_INFO][@"Nationality"] isEqualToString:@"KOR"]) {
                strSlipLang = @"KR";
                LanguageNo = 3;
            }
            else {
                LanguageNo = 1;
            }
        }
        
        docid = strSlipLang;                         //출력언어
        
        
        if ([configInfo[@"print_choice"] isEqualToString:@"01"]){
            //출력전표 갯수
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"2"];
            //출력
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"01/02"];
        }
        else if ([configInfo[@"print_choice"] isEqualToString:@"02"]){
            //출력전표 갯수
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"1"];
            //출력
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"01"];
        }
        else if ([configInfo[@"print_choice"] isEqualToString:@"03"]){
            //출력전표 갯수
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"2"];
            //출력
            docid = [docid stringByAppendingString:@"|"];
            docid = [docid stringByAppendingString:@"01/02"];
        }
        
        //출력유형
        docid = [docid stringByAppendingString:@"|"];
        docid = [docid stringByAppendingString:@"[REPUBLISH]"];
        
        //전표번호(Slip No)
        docid = [docid stringByAppendingString:@"|"];
        docid = [docid stringByAppendingString:strSlipNo];
        
        //합산전표 출력여부
        docid = [docid stringByAppendingString:@"|"];
        docid = [docid stringByAppendingString:@"N"];
        
        docid = [docid stringByAppendingString:@"|"];
        docid = [docid stringByAppendingString:RefundType[@"id"]];
        
        docid = [docid stringByAppendingString:@"|"];
        docid = [docid stringByAppendingString:RefundType[LANGUAGE]];
        
        
        if ([RefundType[@"id"] isEqualToString:@"01"])//환급방법
        {
            docid = [docid stringByAppendingString:@"|"];
        }
        else {
            if ([RefundType[@"id"] isEqualToString:@"04"])//카드환급
            {
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:@"****-****-****"];
                docid = [docid stringByAppendingString:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] substringFromIndex:14]];
            }
            else if ([RefundType[@"id"] isEqualToString:@"06"])//QQ 번호 마스킹
            {
                docid = [docid stringByAppendingString:@"|"];
                for (int k = 0; k < [[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] length] - 4; k++) {
                    docid = [docid stringByAppendingString:@"*"];
                }
                docid = [docid stringByAppendingString:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] substringFromIndex:[[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] length] - 4]];
            }
            else {
                docid = [docid stringByAppendingString:@"|"];
                docid = [docid stringByAppendingString:[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"]];
            }
        }
        
        //전표단축번호
        docid = [docid stringByAppendingString:@"|"];
        docid = [docid stringByAppendingString:strUnikey];
        
        NSMutableDictionary *jsonSlip = [[NSMutableDictionary alloc] initWithDictionary:passportInfo];
        jsonSlip[@"SLIP_NO"] = strSlipNo;
        jsonSlip[@"MERCHANT_NO"] = [CommonFunc getValuesForKey:MERCHANT_NO];
        jsonSlip[@"SHOP_NAME"] = ShopInfo[@"MERCHANT_JPNM"];
        jsonSlip[@"OUT_DIV_CODE"] = @"00";
        jsonSlip[@"REFUND_WAY_CODE"] = RefundType[@"id"];
        jsonSlip[@"REFUND_WAY_CODE_NAME"] = RefundType[LANGUAGE];
        jsonSlip[@"SLIP_STATUS_CODE"] = @"01";               //최초 등록시에는 01
        jsonSlip[@"TML_ID"] = configInfo[@"terminal_id"];
        jsonSlip[@"REFUND_CARDNO"] = [[CommonFunc getValuesForKey:PASSPORT_INFO][@"CardNumber"] stringByReplacingOccurrencesOfString:@"-" withString:@""];   // test
        jsonSlip[@"REFUND_CARD_CODE"] = @"";
        jsonSlip[@"TOTAL_SLIPSEQ"] = totalSeq;
        
        jsonSlip[@"TAX_PROC_TIME_CODE"] = ShopInfo[@"TAX_PROC_TIME_CODE"];
        jsonSlip[@"TAX_POINT_PROC_CODE"] = ShopInfo[@"TAX_POINT_PROC_CODE"];
        jsonSlip[@"GOODS_BUY_AMT"] = @"0";
        jsonSlip[@"GOODS_TAX_AMT"] = @"0";
        jsonSlip[@"GOODS_REFUND_AMT"] = @"0";
        jsonSlip[@"CONSUMS_BUY_AMT"] = @"0";
        jsonSlip[@"CONSUMS_TAX_AMT"] = @"0";
        jsonSlip[@"CONSUMS_REFUND_AMT"] = @"0";
        jsonSlip[@"TOTAL_EXCOMM_IN_TAX_SALE_AMT"] = @"0";
        jsonSlip[@"TOTAL_COMM_IN_TAX_SALE_AMT"] = @"0";
        
        jsonSlip[@"UNIKEY"] = strUnikey;
        jsonSlip[@"SALEDT"] = [CommonFunc getStringFromDate:[NSDate date]];
        jsonSlip[@"REFUNDDT"] = @"";
        jsonSlip[@"USERID"] = kAppDelegate.LoginID;
        jsonSlip[@"MERCHANTNO"] = [CommonFunc getValuesForKey:MERCHANT_NO];
        jsonSlip[@"DESKID"] = [CommonFunc getValuesForKey:DESK_ID];
        jsonSlip[@"COMPANYID"] = COMPANY_ID;
        jsonSlip[@"SEND_FLAG"] = @"N";
        jsonSlip[@"PRINT_CNT"] = @"0";
        jsonSlip[@"REG_DTM"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];   //등록일
        
        jsonSlip[@"S_M_FEE"] = @"0";
        jsonSlip[@"S_G_FEE"] = @"0";
        jsonSlip[@"MERCHANT_FEE"] = [NSString stringWithFormat:@"%i", total_merchant_fee_amt];
        jsonSlip[@"GTF_FEE"] = [NSString stringWithFormat:@"%i", total_gtf_fee_amt];
        NSMutableDictionary *feeSettingInfo = [CommonFunc getValuesForKey:FEE_SETTING_INFO];
        BOOL isFeeYN = NO;
        if (feeSettingInfo) {
            isFeeYN = [feeSettingInfo[@"fee_yn"] isEqualToString:@"Y"];
        }
        if (isFeeYN) {
            NSMutableDictionary *feeInfo = feeSettingInfo[@"fee_info"][0];
            jsonSlip[@"S_M_FEE"] = [NSNumber numberWithFloat:[feeInfo[@"merchant_fee"] floatValue]].stringValue;
            jsonSlip[@"S_G_FEE"] = [NSNumber numberWithFloat:[feeInfo[@"gtf_fee"] floatValue]].stringValue;
        }
        jsonSlip[@"P_INPUT_TYPE"] = p_input_type;
        // sign data
        
        if ([configInfo[@"signpad_use"] isEqualToString:@"YES"])
        {
            signinfo = [CommonFunc imageToNSString:[CommonFunc signImageResize:signImage size:CGSizeMake(140, 70)]];
        }
        else {
            signinfo = @"";
        }
        
        //전표 출력데이터 등록
        NSMutableDictionary *slipDocs = [[NSMutableDictionary alloc] init];
        slipDocs[@"SLIP_NO"] = strSlipNo;
        slipDocs[@"DOCID"] = docid;
        slipDocs[@"RETAILER"] = retailer;
        slipDocs[@"TOURIST"] = tourist;
        slipDocs[@"PREVIEW"] = ShopInfo[@"PREVIEW_USEYN"];
        slipDocs[@"SIGN"] = signinfo;
        
        
        //통합 등록
        NSMutableDictionary * TotalInfo = [[NSMutableDictionary alloc] init];
        TotalInfo[@"SLIP"] = jsonSlip;
        TotalInfo[@"DOCS"] = slipDocs;
        
        [arrSlips addObject:TotalInfo];
        
        NSMutableDictionary *tmpDocs = [[NSMutableDictionary alloc] initWithDictionary:arrSlips[0][@"DOCS"]];
        
        NSString *tmpDocid = tmpDocs[@"DOCID"];
        tmpDocid = [tmpDocid stringByReplacingOccurrencesOfString:@"[REPUBLISH]" withString:@"0"];
        NSString *tmpRetailer = tmpDocs[@"RETAILER"];
        NSString *tmpTourist = tmpDocs[@"TOURIST"];
        
        [CommonFunc InsertSlip:arrSlips[0][@"SLIP"] jsonSlipDocs:tmpDocs];
        BOOL isExistSlip = [CommonFunc isExistSlip:arrSlips[0][@"SLIP"][@"SLIP_NO"]];
        if (!isExistSlip) {
            [self.view makeToast:ERROR_DB_FAILED];
            return;
        }
        if ([configInfo[@"signpad_use"] isEqualToString:@"YES"] && ![signinfo isEqualToString:@""]) {
            NSMutableDictionary *tmpSign = [[NSMutableDictionary alloc] init];
            tmpSign[@"SLIP_NO"] = arrSlips[0][@"SLIP"][@"SLIP_NO"];
            tmpSign[@"SLIP_SIGN_DATA"] = signinfo;
            tmpSign[@"SEND_YN"] = @"N";
            tmpSign[@"REG_DTM"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
            [CommonFunc InsertSlipSign:tmpSign];
        }
        
        MapDocid = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseDocid:tmpDocid]];
        MapRetailer = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseRetailer:tmpRetailer]];
        MapTourist = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getParseTourist:tmpTourist]];
        
        if (![configInfo[@"print_choice"] isEqualToString:@"03"]){
            if ([self runPrintNoReceiptSequence]) {
                [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"02" conditionField:SLIP_NO conditionValue:arrSlips[0][@"SLIP"][SLIP_NO]];
                [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:REFUNDDT newValue:[CommonFunc getStringFromDate:[NSDate date]] conditionField:SLIP_NO conditionValue:arrSlips[0][@"SLIP"][SLIP_NO]];
                [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:PRINT_CNT newValue:@"1" conditionField:SLIP_NO conditionValue:arrSlips[0][@"SLIP"][SLIP_NO]];
                
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
        }
        else {
            [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"02" conditionField:SLIP_NO conditionValue:arrSlips[0][@"SLIP"][SLIP_NO]];
            [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:REFUNDDT newValue:[CommonFunc getStringFromDate:[NSDate date]] conditionField:SLIP_NO conditionValue:arrSlips[0][@"SLIP"][SLIP_NO]];
            [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:PRINT_CNT newValue:@"0" conditionField:SLIP_NO conditionValue:arrSlips[0][@"SLIP"][SLIP_NO]];
        }
        //        [self Screen_Clear];
    }
    if((kAppDelegate.call_by_url_scheme) && (!kAppDelegate.call_by_url_issued)) {
        kAppDelegate.call_by_url_issued = TRUE;
         [self Screen_Clear];
         [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }else {
        [self Screen_Clear];
        NSString *message = @"購入記録情報が正常登録されました。";
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"記録情報 登録" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertView dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (NSString *) createSlipNo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ja"];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:[NSDate date]];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSString *strHour = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)hour] newLength:2];
    NSString *strMin = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)minute] newLength:2];
    NSString *strSec = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)second] newLength:2];
    
    
    NSString *strSlipNo = [NSString stringWithFormat:@"2%@%@%@%@%@%@", [CommonFunc stringPaddingLeft:configInfo[@"terminal_id"] newLength:5], [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyMMdd"], strHour, strMin, strSec, [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%lld", [CommonFunc getSeq:SLIP_NUMBER] % 100] newLength:2]];
    NSLog(@"SlipNo 생성 %@", strSlipNo);
    return strSlipNo;
}


- (void) Screen_Clear {
    isEdit = NO;
    
    p_input_type = @"3";
    [self ChangeEditableIssue];
    
    isPassport = YES;
    [self PassportChanged];
    
    selectedDate = [NSDate date];
    _lblRefundDate.text = [CommonFunc getDateStringWithFormat:selectedDate format:@"yyyy-MM-dd"];
    //    _txtDateLanding.text = [CommonFunc getDateStringWithFormat:selectedDate format:@"yyyy.MM.dd"];
    _txtDateLanding.text = @"";
    
    RefundType = RefundTypeList[0];
    _lblRefundType.text = RefundType[LANGUAGE];
    [self RefundTypeChanged];
    
    _txtReceiptNo.text = @"";
    _txtPassportName.text = @"";
    _txtPassportNumber.text = @"";
    _txtNationality.text = @"";
    _txtNationality.placeholder = @"";
    
    
    Sex = SexList[0];
    _txtSex.text = Sex[LANGUAGE];
    
    _txtDOB.text = @"";
    _txtExpiry.text = @"";
    
    ResidenceState = ResidenceStateList[0];
    _txtResidenceState.text = ResidenceState[LANGUAGE];
    
    self.viewAddInfo.hidden = YES;
    kAppDelegate.AdditionalInfo = nil;
    
    PassportType = PassportTypeList[0];
    _txtPassportType.text = PassportType[LANGUAGE];
    
    [TableArray removeAllObjects];
    [_ItemTableView reloadData];
    [CommonFunc saveArrayToLocal:nil key:TOTAL_ITEM_LIST];
    [self FilterTableArray];
    NSLog(@"클리어 부분이 실행되고 있습니다...");
    if(kAppDelegate.call_by_url_issued) NSLog(@"call_by_url_issued값이 true입니다...");
    if((kAppDelegate.call_by_url_issued) && (kAppDelegate.call_by_url_scheme)){
        [self.view makeToast:@"取引内容が登録されました。間もなくPOSアプリに戻ります。"];
        //_queue = dispatch_queue_create("myTimer", nil);
        //_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        //dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //    [alertView dismissViewControllerAnimated:YES completion:nil];
        //    });
    }
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
    
    UIImage *barcodeImage = [TCCodeGenerator Code128BarcodeWithString:MapDocid[@"SlipNo"] width:_imageBarCode.frame.size.width color:[UIColor blackColor] inputQuietSpace:kTCCode128BarcodeInputQuietSpaceMin];
    _imageBarCode.image = barcodeImage;
    
    _lblBarCode.text = MapDocid[@"SlipNo"];
    _lblReceiptNo.text = [NSString stringWithFormat:@"%@/%@ : %@", StringSlipNo[0], StringSlipNo[LanguageNo], MapDocid[@"SlipNo"]];
    
    _viewBarCode.frame = CGRectMake(0, _lblSlipTypeDetail.frame.origin.y + _lblSlipTypeDetail.frame.size.height + 10, _viewBarCode.frame.size.width, _viewBarCode.frame.size.height);
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
    
    NSString *RctNo = @"";
    for (int i = 0; i < Rct_SlipNoList.count; i++) {
        if ([Rct_SlipNoList[i][@"SLIP_NO"] isEqualToString:PrintJson[@"SlipNo"]]) {
            RctNo = Rct_SlipNoList[i][@"RCT_NO"];
        }
    }
    
    int goods_total = 0;
    int consum_total = 0;
    
    for (int i = 0; i < TableArray.count; i++) {
        NSMutableDictionary *ItemInfo = TableArray[i];
        if ([ItemInfo[@"RCT_NO"] isEqualToString:RctNo]) {
            if ([ItemInfo[@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
                NSMutableDictionary *Goods = [[NSMutableDictionary alloc] init];
                Goods[@"name"] = [NSString stringWithFormat:@"%@ - %@ - %@", ItemInfo[@"MAIN_CAT_TEXT"], ItemInfo[@"MID_CAT_TEXT"], ItemInfo[@"ITEM_NAME"]];
                Goods[@"unit"] = [CommonFunc getCommaString:ItemInfo[@"UNIT_AMT"]];
                Goods[@"qty"] = [CommonFunc getCommaString:ItemInfo[@"QTY"]];
                Goods[@"price"] = [CommonFunc getCommaString:ItemInfo[@"BUY_AMT"]];
                [GoodsList addObject:Goods];
                
                goods_total += [ItemInfo[@"BUY_AMT"] intValue];
            }
            else {
                NSMutableDictionary *Consum = [[NSMutableDictionary alloc] init];
                Consum[@"name"] = [NSString stringWithFormat:@"%@ - %@ - %@", ItemInfo[@"MAIN_CAT_TEXT"], ItemInfo[@"MID_CAT_TEXT"], ItemInfo[@"ITEM_NAME"]];
                Consum[@"unit"] = [CommonFunc getCommaString:ItemInfo[@"UNIT_AMT"]];
                Consum[@"qty"] = [CommonFunc getCommaString:ItemInfo[@"QTY"]];
                Consum[@"price"] = [CommonFunc getCommaString:ItemInfo[@"BUY_AMT"]];
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
        PrintJson[@"Sign_Image"] = signinfo;
    }
    else {
        PrintJson[@"Sign_Image"] = @"";
    }
    return PrintJson;
}

- (void) UpdateSlip:(NSNotification *) notification {
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SLIP_STATUS_CODE newValue:@"02" conditionField:SLIP_NO conditionValue:notification.userInfo[@"SlipNo"]];
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:REFUNDDT newValue:[CommonFunc getStringFromDate:[NSDate date]] conditionField:SLIP_NO conditionValue:notification.userInfo[@"SlipNo"]];
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:PRINT_CNT newValue:@"1" conditionField:SLIP_NO conditionValue:notification.userInfo[@"SlipNo"]];
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:SLIP_CONFIRM preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}



@end
