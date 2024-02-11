//
//  SearchCell.h
//  TaxFree
//
//  Created by Smile on 08/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UILabel *colorView;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *lblNo;
@property (strong, nonatomic) IBOutlet UILabel *lblSend;
@property (strong, nonatomic) IBOutlet UILabel *lblSlipNo;
@property (strong, nonatomic) IBOutlet UILabel *lblRctNo;
@property (strong, nonatomic) IBOutlet UILabel *lblSaleDate;
@property (strong, nonatomic) IBOutlet UILabel *lblShopName;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblGRefundAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblGTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConRefundAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundState;
@property (strong, nonatomic) IBOutlet UILabel *lblPrintCount;




@end

NS_ASSUME_NONNULL_END
