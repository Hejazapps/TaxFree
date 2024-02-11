//
//  SearchDetailCell.h
//  TaxFree
//
//  Created by Smile on 08/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *colorView;

@property (strong, nonatomic) IBOutlet UILabel *lblNo;
@property (strong, nonatomic) IBOutlet UILabel *lblItemType;
@property (strong, nonatomic) IBOutlet UILabel *lblMainCat;
@property (strong, nonatomic) IBOutlet UILabel *lblMidCat;
@property (strong, nonatomic) IBOutlet UILabel *lblItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblFee;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxFormula;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxType;



@end

NS_ASSUME_NONNULL_END
