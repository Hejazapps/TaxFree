//
//  PrintView.m
//  TaxFree
//
//  Created by Smile on 24/03/2019.
//  Copyright © 2019 Smile. All rights reserved.
//

#import "PrintView.h"

#define kDefaultPageHeight 1555.5
#define kDefaultPageWidth  1100.0
#define kMargin 0

#define kContentWidth  980.0
#define cell_width     196.0
#define cell_height    14.0


@implementation PrintView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)loadXIB:(id)owner
{
    return [[[NSBundle mainBundle] loadNibNamed:@"Print" owner:owner options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];   
    NSMutableArray *printingItems = [[NSMutableArray alloc] init];    
    PrintList = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:PRINT_LIST]];

    for (int i = 0; i < PrintList.count; i++) {
        PrintInfo = [[NSMutableDictionary alloc] initWithDictionary:PrintList[i]];        
        [self PageConfig];
        
//        if (_viewConvenant.frame.origin.y + _viewConvenant.frame.size.height > 1535) {
//            _viewConvenant.frame = CGRectMake(_viewConvenant.frame.origin.x, kDefaultPageHeight, _viewConvenant.frame.size.width, _viewConvenant.frame.size.height);
//            _mainScrollView.contentSize = CGSizeMake(100, kDefaultPageHeight * 2);
//        }
//        else {
            _mainScrollView.contentSize = CGSizeMake(100, kDefaultPageHeight);
//        }

        [printingItems addObject:[self pdfDataOfScrollView:_mainScrollView]];
    }
    
    [self Print:printingItems];
}

- (void) PageConfig {
    default_font = _lblConv_SlipNo.font;
    
    
    [_RecordTableView reloadData];
    [_ConvTableView reloadData];
    
    _RecordTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _RecordTableView.layer.borderWidth = 1;
    
    _ConvTableView.layer.borderColor = [UIColor blackColor].CGColor;
    _ConvTableView.layer.borderWidth = 1;
    
    _viewConv_Content.layer.borderColor = [UIColor blackColor].CGColor;
    _viewConv_Content.layer.borderWidth = 1;
    
    _lblRecord_SlipType.layer.borderColor = [UIColor blackColor].CGColor;
    _lblRecord_SlipType.layer.borderWidth = 1;
    
    _lblConv_SlipType.layer.borderColor = [UIColor blackColor].CGColor;
    _lblConv_SlipType.layer.borderWidth = 1;
    
    _lblRecord_SlipNo.text = PrintInfo[@"SlipNo"];
    _lblConv_SlipNo.text = PrintInfo[@"SlipNo"];
    
    _signImageView.image = [CommonFunc getImageFromBase64:PrintInfo[@"Sign_Image"]];
    _lblConv_SellerName.text = PrintInfo[@"Seller_Info"][@"Seller"];
    
    
    _lblRecord_Description.frame = CGRectMake(0, _lblRecord_Description.frame.origin.y, _viewRecord_Description.frame.size.width, 20);
    _lblRecord_Description.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", PrintInfo[@"Desc_Info"][@"1"], PrintInfo[@"Desc_Info"][@"2"], PrintInfo[@"Desc_Info"][@"3"], PrintInfo[@"Desc_Info"][@"4"]];
    [_lblRecord_Description sizeToFit];
    _lblRecord_Description.frame = CGRectMake(0, _lblRecord_Description.frame.origin.y, _viewRecord_Description.frame.size.width, _lblRecord_Description.frame.size.height);
    
    float h_RecordTable = cell_height * 13;
//    h_RecordTable += cell_height * (6 + [PrintInfo[@"Goods_Info"][@"list"] count] + [PrintInfo[@"Consum_Info"][@"list"] count]);
    h_RecordTable += cell_height * 18;
    
    _RecordTableView.frame = CGRectMake(_RecordTableView.frame.origin.x, _RecordTableView.frame.origin.y, _RecordTableView.frame.size.width, h_RecordTable);
    _viewRecord_Description.frame = CGRectMake(_viewRecord_Description.frame.origin.x, _RecordTableView.frame.origin.y + _RecordTableView.frame.size.height + cell_height, _viewRecord_Description.frame.size.width, _lblRecord_Description.frame.origin.y + _lblRecord_Description.frame.size.height);
    
    _viewRecord.frame = CGRectMake(_viewRecord.frame.origin.x, 0, _viewRecord.frame.size.width, _viewRecord_Description.frame.origin.y + _viewRecord_Description.frame.size.height);
    
    
    float h_ConvTable = cell_height * 9;
//    h_ConvTable += cell_height * (6 + [PrintInfo[@"Goods_Info"][@"list"] count] + [PrintInfo[@"Consum_Info"][@"list"] count]);
    h_ConvTable += cell_height * 18;
    
    _ConvTableView.frame = CGRectMake(_ConvTableView.frame.origin.x, _ConvTableView.frame.origin.y, _ConvTableView.frame.size.width, h_ConvTable);
    _viewConv_Content.frame = CGRectMake(_viewConv_Content.frame.origin.x, _viewConv_Content.frame.origin.y, _viewConv_Content.frame.size.width, _ConvTableView.frame.origin.y + _ConvTableView.frame.size.height);
    _viewConvenant.frame = CGRectMake(_viewConvenant.frame.origin.x, _viewConvenant.frame.origin.y, _viewConvenant.frame.size.width, _viewConv_Content.frame.origin.y + _viewConv_Content.frame.size.height);
}

- (void) Print:(NSArray *)printingItems {
    UIPrintInfo *pi = [UIPrintInfo printInfo];
    pi.outputType = UIPrintInfoOutputGeneral;
    pi.jobName = @"TaxFree Receipt";
    pi.orientation = UIPrintInfoOrientationPortrait;
    pi.duplex = UIPrintInfoDuplexNone;
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
//    pic.delegate = self;
    pic.printInfo = pi;
    pic.printingItem =  printingItems[item_num];
    
    [pic presentAnimated:NO completionHandler:^(UIPrintInteractionController *pic2, BOOL completed, NSError *error) {
        if (completed) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PrintNotification"
                                                                object:self
                                                              userInfo:@{@"SlipNo" : self->PrintList[self->item_num][@"SlipNo"]}];
        }
        
        self->item_num++;
        
        if (printingItems.count > self->item_num) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self Print:printingItems];
            });
        }
        else {
            self->item_num = 0;
        }
    }];
}

//- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray<UIPrintPaper *> *)paperList {
//    return [UIPrintPaper bestPaperForPageSize:CGSizeMake(595.2, 841.8) withPapersFromArray:paperList];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((tableView == _ConvTableView) && section == 0) {
        return CGFLOAT_MIN;
    }
    return cell_height * 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((tableView == _ConvTableView) && section == 0) {
        return nil;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kContentWidth, 2 * cell_height)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    UIView *line_Middle = [[UIView alloc] initWithFrame:CGRectMake(0, cell_height - 1, kContentWidth, 1)];
    line_Middle.backgroundColor = [UIColor blackColor];
    [headerView addSubview:line_Middle];
    
    UIView *line_Bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 2 * cell_height - 1, kContentWidth, 1)];
    line_Bottom.backgroundColor = [UIColor blackColor];
    [headerView addSubview:line_Bottom];
    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(cell_width, 0, 1, 2 * cell_height)];
    line_1.backgroundColor = [UIColor blackColor];
    [headerView addSubview:line_1];
    
    UIView *line_2 = [[UIView alloc] initWithFrame:CGRectMake(cell_width * 2, 0, 1, 2 * cell_height)];
    line_2.backgroundColor = [UIColor blackColor];
    [headerView addSubview:line_2];
    
    UIView *line_3 = [[UIView alloc] initWithFrame:CGRectMake(cell_width * 3, 0, 1, 2 * cell_height)];
    line_3.backgroundColor = [UIColor blackColor];
    [headerView addSubview:line_3];
    
    UIView *line_4 = [[UIView alloc] initWithFrame:CGRectMake(cell_width * 4, 0, 1, 2 * cell_height)];
    line_4.backgroundColor = [UIColor blackColor];
    [headerView addSubview:line_4];
    
    
    
    
    UILabel *lbl_A_S1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell_width, cell_height - 1)];
    lbl_A_S1.font = default_font;
    lbl_A_S1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_A_S1];
    
    UILabel *lbl_A_S2 = [[UILabel alloc] initWithFrame:CGRectMake(0, cell_height, cell_width, cell_height - 1)];
    lbl_A_S2.font = default_font;
    lbl_A_S2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_A_S2];
    
    UILabel *lbl_B_S1 = [[UILabel alloc] initWithFrame:CGRectMake(cell_width, 0, cell_width, cell_height - 1)];
    lbl_B_S1.font = default_font;
    lbl_B_S1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_B_S1];
    
    UILabel *lbl_B_S2 = [[UILabel alloc] initWithFrame:CGRectMake(cell_width, cell_height, cell_width, cell_height - 1)];
    lbl_B_S2.font = default_font;
    lbl_B_S2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_B_S2];
    
    UILabel *lbl_C_S1 = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, 0, cell_width, cell_height - 1)];
    lbl_C_S1.font = default_font;
    lbl_C_S1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_C_S1];
    
    UILabel *lbl_C_S2 = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, cell_height, cell_width, cell_height - 1)];
    lbl_C_S2.font = default_font;
    lbl_C_S2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_C_S2];
    
    UILabel *lbl_D_S1 = [[UILabel alloc] initWithFrame:CGRectMake(3 * cell_width, 0, cell_width, cell_height - 1)];
    lbl_D_S1.font = default_font;
    lbl_D_S1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_D_S1];
    
    UILabel *lbl_D_S2 = [[UILabel alloc] initWithFrame:CGRectMake(3 * cell_width, cell_height, cell_width, cell_height - 1)];
    lbl_D_S2.font = default_font;
    lbl_D_S2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_D_S2];
    
    UILabel *lbl_E_S1 = [[UILabel alloc] initWithFrame:CGRectMake(4 * cell_width, 0, cell_width, cell_height - 1)];
    lbl_E_S1.font = default_font;
    lbl_E_S1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_E_S1];
    
    UILabel *lbl_E_S2 = [[UILabel alloc] initWithFrame:CGRectMake(4 * cell_width, cell_height, cell_width, cell_height - 1)];
    lbl_E_S2.font = default_font;
    lbl_E_S2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_E_S2];
    
    
    UILabel *lbl_A_L1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2 * cell_width, cell_height - 1)];
    lbl_A_L1.font = default_font;
    lbl_A_L1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_A_L1];
    
    UILabel *lbl_A_L2 = [[UILabel alloc] initWithFrame:CGRectMake(0, cell_height, 2 * cell_width, cell_height - 1)];
    lbl_A_L2.font = default_font;
    lbl_A_L2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_A_L2];
    
    UILabel *lbl_C_L1 = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, 0, 2 * cell_width, cell_height - 1)];
    lbl_C_L1.font = default_font;
    lbl_C_L1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_C_L1];
    
    UILabel *lbl_C_L2 = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, cell_height, 2 * cell_width, cell_height - 1)];
    lbl_C_L2.font = default_font;
    lbl_C_L2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_C_L2];
    
    UILabel *lbl_D_L1 = [[UILabel alloc] initWithFrame:CGRectMake(3 * cell_width, 0, 2 * cell_width, cell_height - 1)];
    lbl_D_L1.font = default_font;
    lbl_D_L1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_D_L1];
    
    UILabel *lbl_D_L2 = [[UILabel alloc] initWithFrame:CGRectMake(3 * cell_width, cell_height, 2 * cell_width, cell_height - 1)];
    lbl_D_L2.font = default_font;
    lbl_D_L2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lbl_D_L2];
    
        
    if (section == 0) {
        line_4.hidden = YES;
        
        lbl_A_S1.text = @"所 轄 税 務 署";
        lbl_A_S2.text = @"Tax office concerned";
        
        lbl_B_S1.text = @"納 税 地";
        lbl_B_S2.text = @"Place for Tax Payment";
        
        lbl_C_S1.text = @"販売場所在地";
        lbl_C_S2.text = @"Selling Place";
        
        lbl_D_L1.text = @"販売者氏名";
        lbl_D_L2.text = @"Seller's Name";        
    }
    else if (section == 1) {
        lbl_A_S1.text = @"旅券等の種類";
        lbl_A_S2.text = @"Passport etc.";
        
        lbl_B_S1.text = @"番号";
        lbl_B_S2.text = @"No.";
        
        lbl_C_S1.text = @"国籍";
        lbl_C_S2.text = @"Nationality";
        
        lbl_D_S1.text = @"購入年月日";
        lbl_D_S2.text = @"Date of Purchase";
        
        lbl_E_S1.text = @"購入者氏名(活字体)";
        lbl_E_S2.text = @"Name in Full(in block letters)";
    }
    else if (section == 2) {
        line_1.hidden = YES;
        line_3.hidden = YES;
        
        lbl_A_L1.text = @"上陸年月日";
        lbl_A_L2.text = @"Date of Landing";
        
        lbl_C_L1.text = @"在留資格";
        lbl_C_L2.text = @"Status of Residence";
        
        lbl_E_S1.text = @"生年月日";
        lbl_E_S2.text = @"Date of Birth of Purchaser";
    }
    else {
        line_1.hidden = YES;
        headerView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:200.0/255.0 alpha:1];
        
        if (section == 3) {
            lbl_A_L1.text = @"消耗品/Consumable Commodities";
            
        }
        else {
            lbl_A_L1.text = @"一般品/Non Consumable Commodities";
        }
        lbl_A_L2.text = @"品名/Name of Commodity";
        
        lbl_C_S1.text = @"単価";
        lbl_C_S2.text = @"Unit Price";
        
        lbl_D_S1.text = @"数量";
        lbl_D_S2.text = @"Quantity";
        
        lbl_E_S1.text = @"販売価額";
        lbl_E_S2.text = @"Price";
        
        
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ((tableView == _ConvTableView) && section == 0) {
        return 0;
    }
    NSInteger rows = 1;
    if (section > 2) {
        if (section == 3) {
            rows = 7;  // [PrintInfo[@"Consum_Info"][@"list"] count] + 1;
        }
        else if (section == 4) {
            rows = 8;  // [PrintInfo[@"Goods_Info"][@"list"] count] + 2;
        }
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float row_height = cell_height;
    if (indexPath.section < 3) {
        row_height = 2 * cell_height;
    }
    
    return row_height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView * subview in cell.subviews) {
        if (subview != nil)
            [subview removeFromSuperview];
    }
    
    float row_height = cell_height;
    if (indexPath.section < 3) {
        row_height = 2 * cell_height;
    }
    
    UIView *line_Bottom = [[UIView alloc] initWithFrame:CGRectMake(0, row_height - 1, kContentWidth, 1)];
    line_Bottom.backgroundColor = [UIColor blackColor];
    [cell addSubview:line_Bottom];
    
    UIView *line_1 = [[UIView alloc] initWithFrame:CGRectMake(cell_width, 0, 1, row_height)];
    line_1.backgroundColor = [UIColor blackColor];
    [cell addSubview:line_1];
    
    UIView *line_2 = [[UIView alloc] initWithFrame:CGRectMake(cell_width * 2, 0, 1, row_height)];
    line_2.backgroundColor = [UIColor blackColor];
    [cell addSubview:line_2];
    
    UIView *line_3 = [[UIView alloc] initWithFrame:CGRectMake(cell_width * 3, 0, 1, row_height)];
    line_3.backgroundColor = [UIColor blackColor];
    [cell addSubview:line_3];
    
    UIView *line_4 = [[UIView alloc] initWithFrame:CGRectMake(cell_width * 4, 0, 1, row_height)];
    line_4.backgroundColor = [UIColor blackColor];
    [cell addSubview:line_4];
    
    if (indexPath.section == 0) {
        line_4.hidden = YES;
        
        UILabel *lblTaxOffice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell_width, 2 * cell_height)];
        lblTaxOffice.font = default_font;
        lblTaxOffice.textAlignment = NSTextAlignmentCenter;
        lblTaxOffice.numberOfLines = 0;
        [cell addSubview:lblTaxOffice];
        
        UILabel *lblTaxPlace = [[UILabel alloc] initWithFrame:CGRectMake(cell_width, 0, cell_width, 2 * cell_height)];
        lblTaxPlace.font = default_font;
        lblTaxPlace.textAlignment = NSTextAlignmentCenter;
        lblTaxPlace.numberOfLines = 0;
        [cell addSubview:lblTaxPlace];
        
        UILabel *lblSellingPlace = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, 0, cell_width, 2 * cell_height)];
        lblSellingPlace.font = default_font;
        lblSellingPlace.textAlignment = NSTextAlignmentCenter;
        lblSellingPlace.numberOfLines = 0;
        [cell addSubview:lblSellingPlace];
        
        UILabel *lblSellerName = [[UILabel alloc] initWithFrame:CGRectMake(3 * cell_width, 0, 2 * cell_width, 2 * cell_height)];
        lblSellerName.font = default_font;
        lblSellerName.textAlignment = NSTextAlignmentCenter;
        lblSellerName.numberOfLines = 0;
        [cell addSubview:lblSellerName];
        
        lblTaxOffice.text = PrintInfo[@"Seller_Info"][@"TaxOffice"];
        lblTaxPlace.text = PrintInfo[@"Seller_Info"][@"TaxPlace"];
        lblSellingPlace.text = PrintInfo[@"Seller_Info"][@"SellerAddr"];
        lblSellerName.text = PrintInfo[@"Seller_Info"][@"Seller"];
    }
    else if (indexPath.section == 1) {
        UILabel *lblPassportType = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell_width, 2 * cell_height)];
        lblPassportType.font = default_font;
        lblPassportType.textAlignment = NSTextAlignmentCenter;
        lblPassportType.numberOfLines = 0;
        [cell addSubview:lblPassportType];
        
        UILabel *lblPassportNo = [[UILabel alloc] initWithFrame:CGRectMake(cell_width, 0, cell_width, 2 * cell_height)];
        lblPassportNo.font = default_font;
        lblPassportNo.textAlignment = NSTextAlignmentCenter;
        lblPassportNo.numberOfLines = 0;
        [cell addSubview:lblPassportNo];
        
        UILabel *lblNational = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, 0, cell_width, 2 * cell_height)];
        lblNational.font = default_font;
        lblNational.textAlignment = NSTextAlignmentCenter;
        lblNational.numberOfLines = 0;
        [cell addSubview:lblNational];
        
        UILabel *lblSaleDate = [[UILabel alloc] initWithFrame:CGRectMake(3 * cell_width, 0, cell_width, 2 * cell_height)];
        lblSaleDate.font = default_font;
        lblSaleDate.adjustsFontSizeToFitWidth = YES;
        lblSaleDate.textAlignment = NSTextAlignmentCenter;
        lblSaleDate.numberOfLines = 0;
        [cell addSubview:lblSaleDate];
        
        UILabel *lblUserName = [[UILabel alloc] initWithFrame:CGRectMake(4 * cell_width, 0, cell_width, 2 * cell_height)];
        lblUserName.font = default_font;
        lblUserName.textAlignment = NSTextAlignmentCenter;
        lblUserName.numberOfLines = 0;
        [cell addSubview:lblUserName];
        
        lblPassportType.text = PrintInfo[@"User_Info"][@"PassportType"];
        lblPassportNo.text = PrintInfo[@"User_Info"][@"PassportNo"];
        lblNational.text = PrintInfo[@"User_Info"][@"National"];
        lblSaleDate.text = [NSString stringWithFormat:@"%@\nMonth  Date  Year", PrintInfo[@"User_Info"][@"SaleDate"]];
        lblUserName.text = PrintInfo[@"User_Info"][@"Name"];
    }
    else if (indexPath.section == 2) {
        line_1.hidden = YES;
        line_3.hidden = YES;
        
        UILabel *lblLandingDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2 * cell_width, 2 * cell_height)];
        lblLandingDate.font = default_font;
        lblLandingDate.adjustsFontSizeToFitWidth = YES;
        lblLandingDate.textAlignment = NSTextAlignmentCenter;
        lblLandingDate.numberOfLines = 0;
        [cell addSubview:lblLandingDate];
        
        UILabel *lblResidence = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, 0, 2 * cell_width, 2 * cell_height)];
        lblResidence.font = default_font;
        lblResidence.textAlignment = NSTextAlignmentCenter;
        lblResidence.numberOfLines = 0;
        [cell addSubview:lblResidence];
        
        UILabel *lblBirth = [[UILabel alloc] initWithFrame:CGRectMake(4 * cell_width, 0, cell_width, 2 * cell_height)];
        lblBirth.font = default_font;
        lblBirth.adjustsFontSizeToFitWidth = YES;
        lblBirth.textAlignment = NSTextAlignmentCenter;
        lblBirth.numberOfLines = 0;
        [cell addSubview:lblBirth];
        
        lblLandingDate.text = [NSString stringWithFormat:@"%@\nMonth  Date  Year", PrintInfo[@"User_Info"][@"LandingDate"]];
        lblResidence.text = PrintInfo[@"User_Info"][@"Residence"];
        lblBirth.text = [NSString stringWithFormat:@"%@\nMonth  Date  Year", PrintInfo[@"User_Info"][@"Birth"]];
    }
    else {
        line_1.hidden = YES;
        
        UILabel *lblProductName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2 * cell_width, cell_height)];
        lblProductName.font = default_font;
        lblProductName.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:lblProductName];
        
        UILabel *lblUnitPrice = [[UILabel alloc] initWithFrame:CGRectMake(2 * cell_width, 0, cell_width - 5, cell_height)];
        lblUnitPrice.font = default_font;
        lblUnitPrice.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lblUnitPrice];
        
        UILabel *lblQty = [[UILabel alloc] initWithFrame:CGRectMake(3 * cell_width, 0, cell_width - 5, cell_height)];
        lblQty.font = default_font;
        lblQty.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lblQty];
        
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(4 * cell_width, 0, cell_width - 5, cell_height)];
        lblPrice.font = default_font;
        lblPrice.textAlignment = NSTextAlignmentRight;
        lblPrice.text = @"0";
        [cell addSubview:lblPrice];
        
        if (indexPath.section == 3) {
            if (indexPath.row == 6){
                lblProductName.text = @"消耗品合計金額/Total Amount";
                lblPrice.text = PrintInfo[@"Consum_Info"][@"total"][@"price"];
            }
            else if (indexPath.row < [PrintInfo[@"Consum_Info"][@"list"] count]) {
                lblProductName.text = PrintInfo[@"Consum_Info"][@"list"][indexPath.row][@"name"];
                lblUnitPrice.text = PrintInfo[@"Consum_Info"][@"list"][indexPath.row][@"unit"];
                lblQty.text = PrintInfo[@"Consum_Info"][@"list"][indexPath.row][@"qty"];
                lblPrice.text = PrintInfo[@"Consum_Info"][@"list"][indexPath.row][@"price"];
            }
        }
        else if (indexPath.section == 4) {
            if (indexPath.row == 6) {
                lblProductName.text = @"一般品合計金額/Total Amount";
                lblPrice.text = PrintInfo[@"Goods_Info"][@"total"][@"price"];
            }
            else if (indexPath.row == 7) {
                lblProductName.text = @"総合計金額/Total Amount";
                lblProductName.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
                lblPrice.text = PrintInfo[@"Total_Price"];
            }
            else if (indexPath.row < [PrintInfo[@"Goods_Info"][@"list"] count]) {
                lblProductName.text = PrintInfo[@"Goods_Info"][@"list"][indexPath.row][@"name"];
                lblUnitPrice.text = PrintInfo[@"Goods_Info"][@"list"][indexPath.row][@"unit"];
                lblQty.text = PrintInfo[@"Goods_Info"][@"list"][indexPath.row][@"qty"];
                lblPrice.text = PrintInfo[@"Goods_Info"][@"list"][indexPath.row][@"price"];
            }
        }
    }
    
    return cell;
}

- (NSData *)pdfDataOfScrollView:(UIScrollView *)scrollView {
    CGRect origFrame = scrollView.frame;

    CGFloat maxHeight = kDefaultPageHeight - 2 * kMargin;
    CGFloat maxWidth = kDefaultPageWidth - 2 * kMargin;
    CGFloat height = scrollView.contentSize.height;
    // Set up we the pdf we're going to be generating is
    [scrollView setFrame:CGRectMake(0, 0, maxWidth, maxHeight)];
    NSInteger pages = (NSInteger) ceil(height / maxHeight);
    
    NSMutableData *pdfData = [NSMutableData data];
    // スクリーンショットを撮る準備
    [scrollView setContentOffset:CGPointZero animated:NO];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    for (int i = 0 ;i < pages ;i++){
        if (maxHeight * (i + 1) > height){
            // Check to see if page draws more than the height of the UIWebView
            CGRect scrollViewFrame = [scrollView frame];
            scrollViewFrame.size.height -= (((i + 1) * maxHeight) - height);
            [scrollView setFrame:scrollViewFrame];
        }
        // Specify the size of the pdf page
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();

        // Move the context for the margins
        // マージン
        CGContextTranslateCTM(currentContext, kMargin, -(maxHeight * i) + kMargin);
        // 中身をスクロールさせて描画する領域を変える
        [scrollView setContentOffset:CGPointMake(0, maxHeight * i) animated:NO];
        // draw the layer to the pdf, ignore the "renderInContext not found" warning.
        [scrollView.layer renderInContext:currentContext];
    }
    // all done with making the pdf
    UIGraphicsEndPDFContext();
    [scrollView setFrame:origFrame];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    return pdfData;
}


@end
