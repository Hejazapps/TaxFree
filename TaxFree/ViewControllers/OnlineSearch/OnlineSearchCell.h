//
//  OnlineSearchCell.h
//  TaxFree
//
//  Created by Smile on 08/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnlineSearchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UILabel *colorView;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *lblNo;
@property (strong, nonatomic) IBOutlet UILabel *lblSlipNo;
@property (strong, nonatomic) IBOutlet UILabel *lblRctNo;
@property (strong, nonatomic) IBOutlet UILabel *lblSaleDate;
@property (strong, nonatomic) IBOutlet UILabel *lblShopName;
@property (strong, nonatomic) IBOutlet UILabel *lblExcommBuy;
@property (strong, nonatomic) IBOutlet UILabel *lblExcommTax;
@property (strong, nonatomic) IBOutlet UILabel *lblExcommRefund;
@property (strong, nonatomic) IBOutlet UILabel *lblCommBuy;
@property (strong, nonatomic) IBOutlet UILabel *lblCommRefund;
@property (strong, nonatomic) IBOutlet UILabel *lblCommTax;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundState;
@property (strong, nonatomic) IBOutlet UILabel *lblSendFlag;


@property (strong, nonatomic) IBOutlet UIButton *btnCheck;



@end

NS_ASSUME_NONNULL_END


