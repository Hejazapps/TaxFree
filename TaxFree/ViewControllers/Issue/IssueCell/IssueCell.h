//
//  IssueCell.h
//  TaxFree
//
//  Created by Smile on 30/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *shadowView;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UILabel *colorView;

@property (strong, nonatomic) IBOutlet UILabel *lblRctNo;
@property (strong, nonatomic) IBOutlet UILabel *lblKind;
@property (strong, nonatomic) IBOutlet UILabel *lblItemNo;
@property (strong, nonatomic) IBOutlet UILabel *lblShopName;
@property (strong, nonatomic) IBOutlet UILabel *lblMainCat;
@property (strong, nonatomic) IBOutlet UILabel *lblMidCat;
@property (strong, nonatomic) IBOutlet UILabel *lblItemType;
@property (strong, nonatomic) IBOutlet UILabel *lblItemName;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundAmt;


@property (strong, nonatomic) IBOutlet UIButton *btnDelete;


@end
