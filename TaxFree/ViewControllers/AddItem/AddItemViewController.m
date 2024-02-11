//
//  AddItemViewController.m
//  TaxFree
//
//  Created by Smile on 25/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//


#import "AddItemViewController.h"
@interface AddItemViewController () {
    UIView *darkBackground;
    NSMutableDictionary *ItemType;

    BOOL isEdit;
    BOOL isMidCat;
    
    NSMutableDictionary *ShopInfo;
    
    NSMutableArray *AllCategoryList;
    NSMutableArray *MainCatList;
    NSMutableArray *MidCatList;
    
    NSMutableArray *TaxTypeList;
    NSMutableArray *ItemTypeList;
    
    NSMutableArray *TableArray;
    
    NSMutableDictionary *MainCategory;
    NSMutableDictionary *MidCategory;
    NSMutableDictionary *TaxType;
    
    NSMutableDictionary *configInfo;
    
    NSInteger index;
    NSInteger maxNo;
    
    NSString *tax_type_code;
    float tax_formula;
    BOOL input_SaleData_anyway;
}

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ItemTableView.backgroundColor = [UIColor clearColor];
    input_SaleData_anyway = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanging:) name:UITextFieldTextDidChangeNotification object:nil];
    [self interfaceConfig];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saledata_Matching:) name:UIApplicationWillEnterForegroundNotification object:nil];
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(input_SaleData_anyway) {
        [self.navigationController popViewControllerAnimated:YES];
        input_SaleData_anyway = NO;
    }
}
- (void) saledata_Matching:(NSNotification *)notification {
    input_SaleData_anyway = YES;
    [self viewDidAppear:YES];
}

- (void) interfaceConfig {
    
    configInfo = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc getValuesForKey:CONFIG_INFO]];
    
    NSMutableArray *merchantList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:MERCHANT_TABLE_KIND]];
    if (merchantList.count > 0) {
        ShopInfo = [[NSMutableDictionary alloc] initWithDictionary:merchantList[0]];
    }
    
    if ([ShopInfo[@"SALEGOODS_USEYN"] isEqualToString:@"M"]) {
        isMidCat = YES;
        _dropMainCat.hidden = YES;
    }
    else {
        _dropMidCat.hidden = YES;
    }
    
    if ([ShopInfo[@"TAX_TYPE"] isEqualToString:@"0"]) {
        _viewPlus2.frame = CGRectMake(SCREEN_WIDTH/2 - _viewPlus2.frame.size.width, _viewPlus2.frame.origin.y, _viewPlus2.frame.size.width, _viewPlus2.frame.size.height);
        _viewPlus1.frame = CGRectMake(SCREEN_WIDTH/2, _viewPlus1.frame.origin.y, _viewPlus1.frame.size.width, _viewPlus1.frame.size.height);
    }
    else if ([ShopInfo[@"TAX_TYPE"] isEqualToString:@"1"]) {   //  8%
        _viewPlus1.hidden = YES;
    }
    else if ([ShopInfo[@"TAX_TYPE"] isEqualToString:@"2"]) {   //  10%
        _viewPlus2.hidden = YES;
    }
    
    //_btn8Percent.enabled = FALSE;
    //_btn10Percent.enabled = FALSE;
    
    _txtShopName.text = ShopInfo[@"MERCHANT_JPNM"];

    _viewTable.layer.cornerRadius = 8;
    _viewTable.layer.borderColor = [UIColor blackColor].CGColor;
    _viewTable.layer.borderWidth = 1;
    _viewTable.clipsToBounds = YES;
    
    _viewField.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewField.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _viewField.layer.shadowOpacity = 0.5;
    _viewField.layer.shadowRadius = 2.0;
    _viewField.layer.cornerRadius = 8;
    
    _backShopName.layer.cornerRadius = _backShopName.frame.size.height / 2;
    _backShopName.clipsToBounds = YES;
    
    _ItemTableView.dataSource = self;
    _ItemTableView.delegate = self;
    _ItemTableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    _btnGoods.layer.cornerRadius = _btnGoods.frame.size.height / 2.0;
    _btnGoods.clipsToBounds = YES;
    _btnConsumable.layer.cornerRadius = _btnConsumable.frame.size.height / 2.0;
    _btnConsumable.clipsToBounds = YES;
    
    darkBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    darkBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    _viewInsert.layer.cornerRadius = 12;
    _btnOk.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnOk.clipsToBounds = YES;
    
    _btnAddMore.layer.cornerRadius = _btnOk.frame.size.height / 2.0;
    _btnAddMore.layer.borderColor = _btnOk.backgroundColor.CGColor;
    _btnAddMore.layer.borderWidth = 1;
    _btnAddMore.clipsToBounds = YES;
    
    AllCategoryList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:CATEGORY_TABLE_KIND]];
    MainCategory = [[NSMutableDictionary alloc] init];
    MidCategory = [[NSMutableDictionary alloc] init];
    
    ItemTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"ItemType.json"][@"data"]];
    ItemType = [[NSMutableDictionary alloc] init];
    TaxTypeList = [[NSMutableArray alloc] initWithArray:[CommonFunc dictionaryWithContentsOfJSONString:@"TaxType.json"][@"data"]];
    TaxType = [[NSMutableDictionary alloc] init];
    
    _txtItemName.delegate = self;
    _txtQty.delegate = self;
    _txtItemAmount.delegate = self;
    _txtTaxAmount.delegate = self;
    _txtBuyAmount.delegate = self;
    
    [self getItemList];
    [self setItemKind:nil];
}

- (void) getItemList {
    TableArray = [[NSMutableArray alloc] init];
    NSMutableArray *allItems = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:TOTAL_ITEM_LIST]];
    
    for (int i = 0; i < [allItems count]; i++) {
        if ([_RctNo isEqualToString:allItems[i][@"RCT_NO"]]) {
            [TableArray addObject:allItems[i]];
            if (allItems[i][@"TAX_FORMULA"]) {
                tax_formula = [allItems[i][@"TAX_FORMULA"] floatValue];
            }
            else {
                tax_formula = [ShopInfo[@"TAX_FORMULA"] floatValue];
            }
            if (allItems[i][@"TAX_TYPE_CODE"]) {
                tax_type_code = allItems[i][@"TAX_TYPE_CODE"];
            }
            else {
                tax_type_code = @"2";
            }
        }
    }
    
    [self RadioButtonConfig];
    
    [self FilterTableArray];
    [_ItemTableView reloadData];
    [self checkNoItems];
    [self CalculateAll];
    
    ItemType = ItemTypeList[0];
    if (TableArray.count > 0) {
        if ([TableArray[0][@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
            ItemType = ItemTypeList[0];
        }
        else {
            ItemType = ItemTypeList[1];
        }
    }
}

- (NSString *) createItemNo {
    int tempMaxNo = 0;
    for (int i = 0; i < TableArray.count; i++) {
        if ([TableArray[i][@"ITEM_NO"] intValue] > tempMaxNo) {
            tempMaxNo = [TableArray[i][@"ITEM_NO"] intValue];
        }
    }
    return [NSString stringWithFormat:@"%i", tempMaxNo + 1];
}

- (void) FilterTableArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
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
}

- (void) CalculateAll {
    long goods_buy_amt = 0;
    long goods_tax_amt = 0;
    long consum_buy_amt = 0;
    long consum_tax_amt = 0;
    long total_buy_amt = 0;
    long total_tax_amt = 0;
    long total_refund_amt = 0;
        
    for (int i = 0; i < TableArray.count; i++) {
        if ([TableArray[i][@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
            goods_buy_amt = goods_buy_amt + [TableArray[i][@"BUY_AMT"] intValue];
            goods_tax_amt = goods_tax_amt + [TableArray[i][@"TAX_AMT"] intValue];
        }
        else {
            consum_buy_amt = consum_buy_amt + [TableArray[i][@"BUY_AMT"] intValue];
            consum_tax_amt = consum_tax_amt + [TableArray[i][@"TAX_AMT"] intValue];
        }
        total_refund_amt = total_refund_amt + [TableArray[i][@"REFUND_AMT"] intValue];
    }
    
    total_buy_amt = goods_buy_amt + consum_buy_amt;
    total_tax_amt = goods_tax_amt + consum_tax_amt;
    
    _lblGoodsBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%ld", goods_buy_amt]];
    _lblGoodsTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%ld", goods_tax_amt]];
    _lblConsumBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%ld", consum_buy_amt]];
    _lblConsumTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%ld", consum_tax_amt]];
    _lblTotalBuyAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%ld", total_buy_amt]];
    _lblTotalTaxAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%ld", total_tax_amt]];
    _lblTotalRefundAmt.text = [CommonFunc getCommaString:[NSString stringWithFormat:@"%ld", total_refund_amt]];
    
    if (TableArray.count > 0) {
        NSString *temp_tax_type = TableArray[0][@"TAX_TYPE_CODE"];    
        for (int i = 1; i < TableArray.count; i++) {
            if (![TableArray[i][@"TAX_TYPE_CODE"] isEqualToString:temp_tax_type]) {
                temp_tax_type = @"100";
            }
        }
        
        if ([temp_tax_type isEqualToString:@"100"]) {
            _lblTaxFormula.text = @"10%, 8%";
        }
        else if ([temp_tax_type isEqualToString:@"1"]) {
            _lblTaxFormula.text = @"8%";
        }
        else if ([temp_tax_type isEqualToString:@"2"]) {
            _lblTaxFormula.text = @"10%";
        }
    }
    
    
}

- (void) checkNoItems {
    if (TableArray.count > 0) {
        _viewNoItem.hidden = YES;
    }
    else {
        _viewNoItem.hidden = NO;
    }
}

- (IBAction)BackClick:(id)sender {
    if (TableArray.count > 0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"データを保存しますか？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:ALERT_NO style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self SaveItems];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)InitClick:(id)sender {
    [TableArray removeAllObjects];
    [_ItemTableView reloadData];
    [self checkNoItems];
    [self CalculateAll];
}

- (IBAction)SaveClick:(id)sender {
    [self SaveItems];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) SaveItems {
    NSMutableArray *allItemList = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:TOTAL_ITEM_LIST]];
    
    for (int i = 0; i < [allItemList count]; i++) {
        if ([_RctNo isEqualToString:allItemList[i][@"RCT_NO"]]) {
            [allItemList removeObjectAtIndex:i];
            i--;
        }
    }
    [allItemList addObjectsFromArray:TableArray];
    [CommonFunc saveArrayToLocal:allItemList key:TOTAL_ITEM_LIST];
}

- (IBAction)CloseClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)NewAddClick:(id)sender {
    tax_formula = 0.08;
    tax_type_code = @"1";
    [self RadioButtonConfig];
    [self showInsertView];
}

- (IBAction)NewAdd2Click:(id)sender {
    
    tax_formula = 0.1;
    tax_type_code = @"2";
    [self RadioButtonConfig];
    [self showInsertView];
}


- (IBAction)btnGoodsClick:(id)sender {
        ItemType = ItemTypeList[0];
        [self setItemKind:nil];
    
}

- (IBAction)btnConsumableClick:(id)sender {
    ItemType = ItemTypeList[1];
    [self setItemKind:nil];
}

- (void) setItemKind:(NSMutableDictionary *)ItemInfo {

    if ([ItemType[@"id"] isEqualToString:@"A0001"]) {
        _btnGoods.backgroundColor = OrangeColor;
        _btnConsumable.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        _btnGoods.backgroundColor = [UIColor lightGrayColor];
        _btnConsumable.backgroundColor = BlueColor;
    }
    
    [self getMainCatList];
    [self getMidCatList];
    
    MainCategory = [[NSMutableDictionary alloc] init];
    MidCategory = [[NSMutableDictionary alloc] init];
    
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
        if (MainCategory.count == 0) {
            MainCategory[@"CATEGORY_CODE"] = ItemInfo[@"MAIN_CAT"];
            MainCategory[@"CATEGORY_NAME"] = ItemInfo[@"MAIN_CAT_TEXT"];
        }
        if (MidCategory.count == 0) {
            MidCategory[@"CATEGORY_CODE"] = ItemInfo[@"MID_CAT"];
            MidCategory[@"CATEGORY_NAME"] = ItemInfo[@"MID_CAT_TEXT"];
        }
    }
    else {
        if(MainCatList.count > 0) MainCategory = MainCatList[0];
        if(MidCatList.count > 0) MidCategory = MidCatList[0];
        
        if ([ShopInfo[@"TAX_PROC_TIME_CODE"] isEqualToString:@"01"]) {
            TaxType = TaxTypeList[0];
        }
        else {
            TaxType = TaxTypeList[1];
        }
        _txtItemName.text = @"その他";
    }
    _txtMainCategory.text = MainCategory[@"CATEGORY_NAME"];
    _txtMidCategory.text = MidCategory[@"CATEGORY_NAME"];
    
    if (!isMidCat) {
        _txtMidCategory.text = @"その他";
    }
    //——————— 물품리스트 비었을 때, 강제로 기타 값을 넣기 위해 추가 한 부분 ——————————————————————————————————————————————————————
    if(MidCatList.count == 0) {
        [self.view makeToast:@"取り扱い品目設定エラー：GTF担当者にご連絡ください info@global-taxfree.jp"];
        MainCategory[@"CATEGORY_CODE"] = [ItemType[@"id"] isEqualToString:@"A0001"] ? @"B0040" : @"B0041";
        MidCategory[@"CATEGORY_CODE"] = [ItemType[@"id"] isEqualToString:@"A0001"] ? @"C0167" : @"C0168";
        MainCategory[@"CATEGORY_NAME"] = @"その他";
        MidCategory[@"CATEGORY_NAME"] = @"その他";
        _txtMainCategory.text = @"その他";
        _txtMidCategory.text = @"その他";
    }
    //————————————————————————————————————————————————————————————————————————————————————————————————————————————
    _txtTaxType.text = TaxType[LANGUAGE];
    
}


- (IBAction)btn10PercentClick:(id)sender {
    tax_formula = 0.1;
    tax_type_code = @"2";
    [self RadioButtonConfig];
    int buy_amount = [_txtBuyAmount.text intValue];
    int tax;
    if ([TaxType[@"id"] isEqualToString:@"02"]) {   ///  내세
            tax = buy_amount - [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount / (tax_formula + 1))];
    }   else {                              // 외세
        tax = [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount * tax_formula)];
    }
    _txtTaxAmount.text = [NSString stringWithFormat:@"%i", tax];
}

- (IBAction)btn8PercentClick:(id)sender {
    tax_formula = 0.08;
    tax_type_code = @"1";
    [self RadioButtonConfig];
    int buy_amount = [_txtBuyAmount.text intValue];
    int tax;
    if ([TaxType[@"id"] isEqualToString:@"02"]) {   ///  내세
            tax = buy_amount - [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount / (tax_formula + 1))];
    }   else {                              // 외세
        tax = [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount * tax_formula)];
    }
    _txtTaxAmount.text = [NSString stringWithFormat:@"%i", tax];
}

- (void) RadioButtonConfig {
    [_btn10Percent setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
    [_btn8Percent setImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];

    if ([tax_type_code isEqualToString:@"1"]) {
        [_btn8Percent setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];

    }
    else if ([tax_type_code isEqualToString:@"2"]) {
        [_btn10Percent setImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateNormal];

    }
}


- (void) getMainCatList {
    MainCatList = [[NSMutableArray alloc] init];
    NSString *groupCodes = ShopInfo[@"GOODS_GROUP_CODE"];
    NSArray *array = [[NSArray alloc] initWithArray:[groupCodes componentsSeparatedByString:@","]];
    for (int i = 0; i < AllCategoryList.count; i++) {
        for (int j = 0; j < array.count; j++) {
            if ([AllCategoryList[i][@"P_CODE"] isEqualToString:ItemType[@"id"]] && [array[j] isEqualToString:AllCategoryList[i][@"CATEGORY_CODE"]]) {
                [MainCatList addObject:AllCategoryList[i]];
            }
        }
    }
}

- (void) getMidCatList {
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

- (IBAction)MainCategoryClick:(id)sender {
    [self.view endEditing:YES];
    if (isMidCat) {
        return;
    }
    
    [self ClearLineColor];
    _lineMainCat.backgroundColor = BlueColor;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < MainCatList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:MainCatList[i][@"CATEGORY_NAME"] image:nil handler:^(YCMenuAction *action) {
            
            self->MainCategory = self->MainCatList[i];
            self->_txtMainCategory.text = self->MainCategory[@"CATEGORY_NAME"];
            
            self->_txtMidCategory.text = @"その他";
            self->_txtItemName.text = @"その他";
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:160 relyonView:sender];
    [view show];
}

- (IBAction)MidCategoryClick:(id)sender {
    if (!isMidCat) {
        return;
    }
    [self.view endEditing:YES];
    [self ClearLineColor];
    _lineMidCat.backgroundColor = BlueColor;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < MidCatList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:MidCatList[i][@"CATEGORY_NAME"] image:nil handler:^(YCMenuAction *action) {
            self->MidCategory = self->MidCatList[i];
            self->_txtMidCategory.text = self->MidCategory[@"CATEGORY_NAME"];
            
            for (int k = 0; k < self->MainCatList.count; k++) {
                if ([self->MainCatList[k][@"CATEGORY_CODE"] isEqualToString:self->MidCategory[@"P_CODE"]]) {
                    self->MainCategory = self->MainCatList[k];
                    self->_txtMainCategory.text = self->MainCategory[@"CATEGORY_NAME"];
                    self->_txtItemName.text = @"その他";
                }
            }
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:200 relyonView:sender];
    [view show];
}



- (IBAction)TaxTypeClick:(id)sender {
    [self ClearLineColor];
    _lineTaxType.backgroundColor = BlueColor;
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < TaxTypeList.count; i++) {
        YCMenuAction *action = [YCMenuAction actionWithTitle:TaxTypeList[i][LANGUAGE] image:nil handler:^(YCMenuAction *action) {
            self->TaxType = self->TaxTypeList[i];
            self->_txtTaxType.text = self->TaxType[LANGUAGE];
            [self CalculateTax];
        }];
        [arr addObject:action];
    }
    YCMenuView *view = [YCMenuView menuWithActions:arr width:140 relyonView:sender];
    [view show];
}

- (IBAction)btnOkClick:(id)sender {
    [self.view endEditing:YES];
    
    if ([self Validation_Check]) {
        if ([configInfo[@"printer"] isEqualToString:@"A4"]) {
            if ([self availableInputA4]) {
                [self inputValues];
                [self ClearInsertView];
                [self hideInsertView];
            }
            else {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"これ以上は入力できません。" message:nil preferredStyle:UIAlertControllerStyleAlert];                
                [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }
        else {
            [self inputValues];
            [self ClearInsertView];
            [self hideInsertView];
        }
    }
}

- (BOOL) availableInputA4 {
    int product_count = 0;

    for (int i = 0; i < TableArray.count; i++) {
        if ([TableArray[i][@"ITEM_TYPE"] isEqualToString:ItemType[@"id"]]) {
            product_count++;
        }
    }
    if (product_count < 6) {
        return YES;
    }
    
    return NO;
}

- (IBAction)btnAddMoreClick:(id)sender {
    [self.view endEditing:YES];
    
    if ([self Validation_Check]) {
        if ([configInfo[@"printer"] isEqualToString:@"A4"]) {
            if ([self availableInputA4]) {
                [self inputValues];
                [self ClearInsertView];
                
                if (TableArray.count < 12) {
                    return;
                }
                else {
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"これ以上は入力できません。" message:nil preferredStyle:UIAlertControllerStyleAlert];                
                    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [alertView dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                    [self hideInsertView];
                }
            }
            else {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"これ以上は入力できません。" message:nil preferredStyle:UIAlertControllerStyleAlert];                
                [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
            }
        }
        else {
            [self inputValues];
            [self ClearInsertView];
            
            if (TableArray.count < 50) {
                return;
            }
            else {
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:ITEM_MAX message:nil preferredStyle:UIAlertControllerStyleAlert];                
                [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [alertView dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alertView animated:YES completion:nil];
                [self hideInsertView];
            }
        }
    }
}

- (BOOL) Validation_Check {
    if ([_txtQty.text intValue]  == 0) {
        [self.view makeToast:ERROR_QTY];
        return NO;
    }
    else if ([_txtQty.text intValue]  > 9999) {
        [self.view makeToast:ERROR_QTY_LIMIT];
        return NO;
    }
    else if ([_txtItemAmount.text intValue]  == 0) {
        [self.view makeToast:ERROR_ITEM_AMT];
        return NO;
    }
    else if ([_txtTaxAmount.text intValue]  == 0) {
        [self.view makeToast:ERROR_TAX_AMT];
        return NO;
    }
    else if ([_txtBuyAmount.text intValue]  == 0) {
        [self.view makeToast:ERROR_BUY_AMT];
        return NO;
    }
    
    return YES;
}

- (void) inputValues {
    NSMutableDictionary *ItemInfo = [[NSMutableDictionary alloc] init];
    ItemInfo[@"SHOP_NAME"] = ShopInfo[@"MERCHANT_JPNM"];
    ItemInfo[@"RCT_NO"] = _RctNo;
    ItemInfo[@"ITEM_TYPE"] = ItemType[@"id"];
    ItemInfo[@"ITEM_TYPE_TEXT"] = ItemType[LANGUAGE];
    ItemInfo[@"ITEM_NO"] = _txtItemNumber.text;
    ItemInfo[@"MAIN_CAT"] = MainCategory[@"CATEGORY_CODE"];
    ItemInfo[@"MAIN_CAT_TEXT"] = _txtMainCategory.text;
    
    ItemInfo[@"MID_CAT"] = MidCategory[@"CATEGORY_CODE"];
    ItemInfo[@"MID_CAT_TEXT"] = _txtMidCategory.text;
    
    ItemInfo[@"ITEM_NAME"] = _txtItemName.text;
    ItemInfo[@"QTY"] = _txtQty.text;
    ItemInfo[@"UNIT_AMT"] = _txtItemAmount.text;
    ItemInfo[@"TAX_AMT"] = _txtTaxAmount.text;
    ItemInfo[@"BUY_AMT"] = _txtBuyAmount.text;
    
    int tax = [_txtTaxAmount.text intValue];
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
    
    
    ItemInfo[@"REFUND_AMT"] = [NSString stringWithFormat:@"%i", refund];
    ItemInfo[@"MERCHANT_FEE_AMT"] = [NSString stringWithFormat:@"%i", merchant_fee];
    ItemInfo[@"GTF_FEE_AMT"] = [NSString stringWithFormat:@"%i", gtf_fee];
    ItemInfo[@"FEE_AMT"] = [NSString stringWithFormat:@"%i", tax - refund];
    
    ItemInfo[@"TAX_TYPE"] = TaxType[@"id"];
    ItemInfo[@"TAX_FORMULA"] = [NSString stringWithFormat:@"%f", tax_formula];
    ItemInfo[@"TAX_TYPE_CODE"] = tax_type_code;
    ItemInfo[@"TAX_TYPE_TEXT"] = TaxType[LANGUAGE];
    
    ItemInfo[@"SHOP_NO"] = ShopInfo[@"MERCHANT_NO"];
    ItemInfo[@"USERID"] = kAppDelegate.LoginID;
    
    if (isEdit) {
        [TableArray replaceObjectAtIndex:index withObject:ItemInfo];
    }
    else {
        [TableArray addObject:ItemInfo];
    }
    
    isEdit = NO;
    
    [self FilterTableArray];
    [_ItemTableView reloadData];
    [self checkNoItems];
    [self CalculateAll];
}

- (IBAction)CloseInsertViewClick:(id)sender {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"削除しますか?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self->isEdit = NO;
        [self ClearInsertView];
        [self hideInsertView];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
    
    
}

- (void) ClearInsertView {
    _txtItemNumber.text = [self createItemNo];
    _txtItemName.text = @"その他";
    _txtQty.text = @"";
    _txtItemAmount.text = @"";
    _txtTaxAmount.text = @"";
    _txtBuyAmount.text = @"";
    
    [self ClearLineColor];
}

- (void) showInsertView {
    if (!isEdit) {
         _txtItemNumber.text = [self createItemNo];
    }
    
    [self.view insertSubview:darkBackground belowSubview:_viewInsert];
    [UIView transitionWithView:_viewInsert
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        self->_viewInsert.hidden = NO;
                    }
                    completion:NULL];
}


- (void) hideInsertView {
    [UIView transitionWithView:_viewInsert
                      duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom
                    animations:^{
                        self->_viewInsert.hidden = YES;
                    }
                    completion:^(BOOL finished) {
                        [self->darkBackground removeFromSuperview];
                        
                    }];
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
    AddItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    cell.btnAdd.tag = indexPath.row;
    [cell.btnAdd addTarget:self action:@selector(cellAddClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    cell.lblMainCat.text = ItemInfo[@"MAIN_CAT_TEXT"];
    cell.lblMidCat.text = ItemInfo[@"MID_CAT_TEXT"];
    cell.lblItemType.text = ItemInfo[@"ITEM_TYPE_TEXT"];
    cell.lblItemName.text = ItemInfo[@"ITEM_NAME"];
    cell.lblQty.text = [CommonFunc getCommaString:ItemInfo[@"QTY"]];
    cell.lblItemAmt.text = [CommonFunc getCommaString:ItemInfo[@"UNIT_AMT"]];
    cell.lblTaxAmt.text = [CommonFunc getCommaString:ItemInfo[@"TAX_AMT"]];
    cell.lblBuyAmt.text = [CommonFunc getCommaString:ItemInfo[@"BUY_AMT"]];
    cell.lblRefundAmt.text = [CommonFunc getCommaString:ItemInfo[@"REFUND_AMT"]];
    
    int percent = [ItemInfo[@"TAX_FORMULA"] floatValue] * 100;
    cell.lblTaxFormula.text = [NSString stringWithFormat:@"%i%@", percent, @"%"];
    cell.lblTaxType.text = ItemInfo[@"TAX_TYPE_TEXT"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.row;
    NSMutableDictionary *ItemInfo = TableArray[indexPath.row];
    
    _txtItemNumber.text = ItemInfo[@"ITEM_NO"];
    _txtMainCategory.text = ItemInfo[@"MAIN_CAT_TEXT"];
    _txtMidCategory.text = ItemInfo[@"MID_CAT_TEXT"];
    _txtItemName.text = ItemInfo[@"ITEM_NAME"];
    _txtQty.text = ItemInfo[@"QTY"];
    _txtItemAmount.text = ItemInfo[@"UNIT_AMT"];
    _txtTaxAmount.text = ItemInfo[@"TAX_AMT"];
    _txtBuyAmount.text = ItemInfo[@"BUY_AMT"];
    _txtTaxType.text = ItemInfo[@"TAX_TYPE_TEXT"];
    
    if ([ItemInfo[@"ITEM_TYPE"] isEqualToString:@"A0001"]) {
        ItemType = ItemTypeList[0];
    }
    else {
        ItemType = ItemTypeList[1];
    }
    
    if ([ItemInfo[@"TAX_TYPE"] isEqualToString:@"01"]) {
        TaxType = TaxTypeList[0];
    }
    else {
        TaxType = TaxTypeList[1];
    }
    _txtTaxType.text = TaxType[LANGUAGE];
    
    isEdit = YES;
    [self setItemKind:ItemInfo];
    [self showInsertView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) cellAddClick:(id) sender {
    if ([configInfo[@"printer"] isEqualToString:@"A4"]) {
        if (TableArray.count < 12) {
            [self showInsertView];
        }
        else {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"これ以上は入力できません。" message:nil preferredStyle:UIAlertControllerStyleAlert];                
            [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }
    else {
        if (TableArray.count < 50) {
            [self showInsertView];
        }
        else {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:ITEM_MAX message:nil preferredStyle:UIAlertControllerStyleAlert];                
            [alertView addAction:[UIAlertAction actionWithTitle:ALERT_OK style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [alertView dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        }
    }
}

- (void) cellDeleteClick:(id) sender {
    UIButton *button = (UIButton *)sender;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"削除しますか?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_NO style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertView dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:ALERT_YES style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self->TableArray removeObjectAtIndex:button.tag];
        [self->_ItemTableView reloadData];
        [self checkNoItems];
        [self CalculateAll];
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
    
    
}


- (void) textFieldDidChanging:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    
    if (textField == _txtQty || textField == _txtItemAmount) {
        [self CalculateTax];
    }
    if (textField == _txtBuyAmount) {        
        _txtItemAmount.text = _txtBuyAmount.text;

        int buy_amount = [_txtBuyAmount.text intValue];
        int tax;
        
        if ([TaxType[@"id"] isEqualToString:@"02"]) {   ///  내세
            tax = buy_amount - [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount / (tax_formula + 1))];
        }
        else {                              // 외세
            tax = [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount * tax_formula)];
        }
        _txtTaxAmount.text = [NSString stringWithFormat:@"%i", tax];
    }
}

- (void) CalculateTax {
    int qty = [_txtQty.text intValue];
    int amount = [_txtItemAmount.text intValue];
    int buy_amount = qty * amount;
    int tax;
        
    if ([TaxType[@"id"] isEqualToString:@"02"]) {   ///  내세
        tax = buy_amount - [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount / (tax_formula + 1))];
    }
    else {                              // 외세
        tax = [self getFixAmt:ShopInfo[@"TAX_POINT_PROC_CODE"] oldValue:(buy_amount * tax_formula)];
    }
    _txtBuyAmount.text = [NSString stringWithFormat:@"%i", buy_amount];
    _txtTaxAmount.text = [NSString stringWithFormat:@"%i", tax];
}

- (int) getFixAmt:(NSString *)strType oldValue: (float)oldValue
{
    NSString *oldString = [NSString stringWithFormat:@"%.1f", oldValue];
    int nAmt = 0;
    if ([strType isEqualToString:@"03"])
    {
        nAmt = (int)lround([oldString floatValue]);
    }
    else if ([strType isEqualToString:@"04"])
    {
        nAmt = (int)ceil([oldString floatValue]);
    }
    else {
        nAmt = (int)floor([oldString floatValue]);
    }
    return nAmt;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _txtItemName) {
        [self ClearLineColor];
        _lineItemName.backgroundColor = BlueColor;
    }
    else if (textField == _txtQty) {
        [self ClearLineColor];
        _lineQty.backgroundColor = BlueColor;
    }
    else if (textField == _txtItemAmount) {
        [self ClearLineColor];
        _lineItemAmount.backgroundColor = BlueColor;
    }
    else if (textField == _txtTaxAmount) {
        [self ClearLineColor];
        _lineTaxAmount.backgroundColor = BlueColor;
    }
    else if (textField == _txtBuyAmount) {
        [self ClearLineColor];
        _lineBuyAmount.backgroundColor = BlueColor;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}

- (void) ClearLineColor {
    _lineMainCat.backgroundColor = [UIColor lightGrayColor];
    _lineMidCat.backgroundColor = [UIColor lightGrayColor];
    _lineItemName.backgroundColor = [UIColor lightGrayColor];
    _lineQty.backgroundColor = [UIColor lightGrayColor];
    _lineItemAmount.backgroundColor = [UIColor lightGrayColor];
    _lineItemAmount.backgroundColor = [UIColor lightGrayColor];
    _lineTaxAmount.backgroundColor = [UIColor lightGrayColor];
    _lineBuyAmount.backgroundColor = [UIColor lightGrayColor];
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
