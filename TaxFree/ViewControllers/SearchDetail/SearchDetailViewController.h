//
//  SearchDetailViewController.h
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

@interface SearchDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, Epos2DiscoveryDelegate, Epos2PtrReceiveDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;

@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UILabel *lblBuyerName1;
@property (strong, nonatomic) IBOutlet UILabel *lblDOB;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyerNo;
@property (strong, nonatomic) IBOutlet UILabel *lblExpiry;
@property (strong, nonatomic) IBOutlet UILabel *lblNationality1;
@property (strong, nonatomic) IBOutlet UILabel *lblResidence1;
@property (strong, nonatomic) IBOutlet UILabel *lblPassportType1;
@property (strong, nonatomic) IBOutlet UILabel *lblSex;
@property (strong, nonatomic) IBOutlet UILabel *lblDateLanding;

@property (strong, nonatomic) IBOutlet UILabel *lblSlipNo;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblRctNo;
@property (strong, nonatomic) IBOutlet UILabel *lblRefund;
@property (strong, nonatomic) IBOutlet UIButton *btnEditRefund;


@property (strong, nonatomic) IBOutlet UILabel *lblSlipStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblPayMethod;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundDate;
@property (strong, nonatomic) IBOutlet UILabel *lblUser;


@property (strong, nonatomic) IBOutlet UILabel *lblRealPayAmt;
@property (strong, nonatomic) IBOutlet UIView *viewRealPayAmt;


@property (strong, nonatomic) IBOutlet UIView *viewTable;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsFeeAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumFeeAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalFeeAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsRefundAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumRefundAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalRefundAmt;
@property (weak, nonatomic) IBOutlet UILabel *showMemoLabel;




@property (strong, nonatomic) IBOutlet UIView *viewField;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UIButton *btnRefund;

@property (strong, nonatomic) NSString *SlipNo;
@property (strong, nonatomic) NSString *isOnline;

///// Print ScrollView  /////////

@property (strong, nonatomic) IBOutlet UIScrollView *printScrollView;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;

@property (strong, nonatomic) IBOutlet UILabel *lblSlipType;
@property (strong, nonatomic) IBOutlet UILabel *lblSlipTypeDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblRepublish;

@property (strong, nonatomic) IBOutlet UIView *viewBarCode;
@property (strong, nonatomic) IBOutlet UIImageView *imageBarCode;
@property (strong, nonatomic) IBOutlet UILabel *lblBarCode;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptNo;


@property (strong, nonatomic) IBOutlet UIView *viewRetailer;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxOffice;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxPlace;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxPlaceInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblSellerName;
@property (strong, nonatomic) IBOutlet UILabel *lblSellerNameInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblOperationName;
@property (strong, nonatomic) IBOutlet UILabel *lblOperationNameInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblSellerPlace;
@property (strong, nonatomic) IBOutlet UILabel *lblSellerPlaceInfo;


@property (strong, nonatomic) IBOutlet UIView *viewGoodsDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblPurchaseDate;

@property (strong, nonatomic) IBOutlet UIView *viewConsumables;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumName;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumQty;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumBuyAmount;

@property (strong, nonatomic) IBOutlet UIView *viewConsumList;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumNameInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumUnitInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumQtyInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumBuyAmountInfo;

@property (strong, nonatomic) IBOutlet UIView *viewConsumTotalList;

@property (strong, nonatomic) IBOutlet UILabel *lblConsumTotalBuyAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTotalBuyAmountInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTotalTaxAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTotalTaxAmountInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTotalRefundAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblConsumTotalRefundAmountInfo;


@property (strong, nonatomic) IBOutlet UIView *viewGoods;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsUnit;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsQty;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsBuyAmount;

@property (strong, nonatomic) IBOutlet UIView *viewGoodsList;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsNameInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsUnitInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsQtyInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsBuyAmountInfo;

@property (strong, nonatomic) IBOutlet UIView *viewGoodsTotalList;

@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTotalBuyAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTotalBuyAmountInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTotalTaxAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTotalTaxAmountInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTotalRefundAmount;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsTotalRefundAmountInfo;



@property (strong, nonatomic) IBOutlet UIView *viewRefundDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundWay;


@property (strong, nonatomic) IBOutlet UIView *viewTourist;
@property (strong, nonatomic) IBOutlet UILabel *lblPassportType;
@property (strong, nonatomic) IBOutlet UILabel *lblPassportNo;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyerName;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyerNameInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblNationality;
@property (strong, nonatomic) IBOutlet UILabel *lblBirthDay;
@property (strong, nonatomic) IBOutlet UILabel *lblResidence;
@property (strong, nonatomic) IBOutlet UILabel *lblLandingDate;


@property (strong, nonatomic) IBOutlet UIView *viewUniqueID;
@property (strong, nonatomic) IBOutlet UILabel *lblUniqueID;
@property (strong, nonatomic) IBOutlet UILabel *lblUniqueIDTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptAdd;



@property (strong, nonatomic) IBOutlet UIView *viewFooter;
@property (strong, nonatomic) IBOutlet UILabel *lblFooterContents;

@property (strong, nonatomic) IBOutlet UIView *viewSignature;
@property (strong, nonatomic) IBOutlet UIImageView *imageSignature;
@property (strong, nonatomic) IBOutlet UILabel *lblSignature;

@end
