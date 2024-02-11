//
//  AddItemViewController.h
//  TaxFree
//
//  Created by Smile on 25/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

@interface AddItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UILabel *backShopName;
@property (strong, nonatomic) IBOutlet UITextField *txtShopName;

@property (strong, nonatomic) IBOutlet UIButton *btnInit;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnClose;


@property (strong, nonatomic) IBOutlet UIView *viewTable;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalRefundAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxFormula;


@property (strong, nonatomic) IBOutlet UIView *viewField;

@property (strong, nonatomic) IBOutlet UITableView *ItemTableView;
@property (strong, nonatomic) IBOutlet UIView *viewNoItem;

@property (strong, nonatomic) IBOutlet UIView *viewInsert;

@property (strong, nonatomic) IBOutlet UIButton *btnGoods;
@property (strong, nonatomic) IBOutlet UIButton *btnConsumable;

@property (strong, nonatomic) IBOutlet UIButton *btn10Percent;
@property (strong, nonatomic) IBOutlet UIButton *btn8Percent;
@property (strong, nonatomic) IBOutlet UILabel *Lbl10Percent;
@property (strong, nonatomic) IBOutlet UILabel *Lbl8Percent;


@property (strong, nonatomic) IBOutlet UITextField *txtItemNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtMainCategory;
@property (strong, nonatomic) IBOutlet UITextField *txtMidCategory;
@property (strong, nonatomic) IBOutlet UITextField *txtItemName;
@property (strong, nonatomic) IBOutlet UITextField *txtQty;
@property (strong, nonatomic) IBOutlet UITextField *txtItemAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtTaxAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtBuyAmount;
@property (strong, nonatomic) IBOutlet UITextField *txtTaxType;

@property (strong, nonatomic) IBOutlet UILabel *lineMainCat;
@property (strong, nonatomic) IBOutlet UILabel *lineMidCat;
@property (strong, nonatomic) IBOutlet UILabel *lineItemName;
@property (strong, nonatomic) IBOutlet UILabel *lineQty;
@property (strong, nonatomic) IBOutlet UILabel *lineItemAmount;
@property (strong, nonatomic) IBOutlet UILabel *lineTaxType;
@property (strong, nonatomic) IBOutlet UILabel *lineTaxAmount;
@property (strong, nonatomic) IBOutlet UILabel *lineBuyAmount;


@property (strong, nonatomic) IBOutlet UIImageView *dropMainCat;
@property (strong, nonatomic) IBOutlet UIImageView *dropMidCat;



@property (strong, nonatomic) NSString *RctNo;

@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIButton *btnAddMore;

@property (strong, nonatomic) IBOutlet UIView *viewPlus1;
@property (strong, nonatomic) IBOutlet UIView *viewPlus2;

@end
