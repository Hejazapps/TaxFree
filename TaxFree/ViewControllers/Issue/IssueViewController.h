//
//  IssueViewController.h
//  TaxFree
//
//  Created by Smile on 30/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"
#import "UBSignatureDrawingViewController.h"
#import <AbbyyRtrSDK/AbbyyRtrSDK.h>


@interface IssueViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIPrintInteractionControllerDelegate, Epos2DiscoveryDelegate, Epos2PtrReceiveDelegate, UBSignatureDrawingViewControllerDelegate, ChooseDatePickerViewDelegate,UITextViewDelegate> //

//@property (strong, nonatomic) RGLDocReader *docReader;

@property (strong, nonatomic) IBOutlet UIButton *btnLeft;
@property (strong, nonatomic) IBOutlet UIButton *btnRight;
@property (strong, nonatomic) IBOutlet UIButton *btnLeft2;
@property (strong, nonatomic) IBOutlet UIButton *btnRight2;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnRefundDate;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundDate;
@property (strong, nonatomic) IBOutlet UIButton *btnRefundType;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundType;
@property (strong, nonatomic) IBOutlet UIView *viewCardNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblRealPayAmt;
@property (strong, nonatomic) IBOutlet UIView *viewRealPayAmt;


@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UIView *viewIssue;
@property (strong, nonatomic) IBOutlet UIView *viewShopInfo;
@property (strong, nonatomic) IBOutlet UIView *viewItemList;

//  ISSUE
@property (strong, nonatomic) IBOutlet UIButton *btnChangePassport;
@property (strong, nonatomic) IBOutlet UIButton *btnQRScan;
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UITextField *txtPassportName;
@property (strong, nonatomic) IBOutlet UILabel *linePassportName;
@property (strong, nonatomic) IBOutlet UILabel *lblPassportNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtPassportNumber;
@property (strong, nonatomic) IBOutlet UILabel *linePassportNumber;
@property (strong, nonatomic) IBOutlet UITextField *txtNationality;
@property (strong, nonatomic) IBOutlet UILabel *lineNationality;
@property (strong, nonatomic) IBOutlet UIButton *btnNationality;
@property (strong, nonatomic) IBOutlet UIImageView *dropIconNationality;

@property (strong, nonatomic) IBOutlet UITextField *txtSex;
@property (strong, nonatomic) IBOutlet UILabel *lineSex;
@property (strong, nonatomic) IBOutlet UITextField *txtDOB;
@property (strong, nonatomic) IBOutlet UILabel *lineDOB;
@property (strong, nonatomic) IBOutlet UITextField *txtExpiry;
@property (strong, nonatomic) IBOutlet UILabel *lineExpiry;
@property (strong, nonatomic) IBOutlet UITextField *txtResidenceState;
@property (strong, nonatomic) IBOutlet UILabel *lineResidenceState;
@property (strong, nonatomic) IBOutlet UITextField *txtPassportType;
@property (strong, nonatomic) IBOutlet UILabel *linePassportType;
@property (strong, nonatomic) IBOutlet UITextField *txtDateLanding;
@property (strong, nonatomic) IBOutlet UILabel *lineDateLanding;

@property (strong, nonatomic) IBOutlet UIButton *btnSex;
@property (strong, nonatomic) IBOutlet UIImageView *dropIconSex;

@property (strong, nonatomic) IBOutlet UIButton *iconCalendarDOB;
@property (strong, nonatomic) IBOutlet UIButton *iconCalendarExpiry;

@property (strong, nonatomic) IBOutlet UIView *viewAddInfo;
@property (strong, nonatomic) IBOutlet UIButton *btnResidenceOption1;
@property (strong, nonatomic) IBOutlet UIButton *btnResidenceOption2;

@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, strong) dispatch_queue_t queue;

//  SHOP INFO
@property (strong, nonatomic) IBOutlet UITextField *txtShopName;
@property (strong, nonatomic) IBOutlet UITextField *txtShopType;
@property (strong, nonatomic) IBOutlet UITextField *txtShopType2;
@property (strong, nonatomic) IBOutlet UITextField *txtShopAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtShopManager;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNo;
@property (strong, nonatomic) IBOutlet UITextField *txtTaxOffice;

//  ITEM LIST
@property (strong, nonatomic) IBOutlet UILabel *backReceiptNo;
@property (strong, nonatomic) IBOutlet UITextField *txtReceiptNo;

@property (strong, nonatomic) IBOutlet UIView *viewField;
@property (strong, nonatomic) IBOutlet UITableView *ItemTableView;

@property (strong, nonatomic) IBOutlet UIView *viewMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;



@property (strong, nonatomic) IBOutlet UIButton *btnRefund;
@property (strong, nonatomic) IBOutlet UIButton *btnClear;


@property (strong, nonatomic) IBOutlet UIView *viewSignPad;
@property (strong, nonatomic) IBOutlet UIView *signatureView;

@property (nonatomic) UBSignatureDrawingViewController *signatureViewController;

@property (strong, nonatomic) IBOutlet UIButton *btnSignRefund;
@property (strong, nonatomic) IBOutlet UIButton *btnSignCancel;


@property (strong, nonatomic) IBOutlet UIView *viewRefundFee;
@property (strong, nonatomic) IBOutlet UILabel *lblRFBuyAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblRFTaxAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblRFFeeAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblRFRefundAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblRFPayAmt;

@property (strong, nonatomic) IBOutlet UIView *viewLimitNotification;
@property (strong, nonatomic) IBOutlet UILabel *lblLNPassportNo;
@property (strong, nonatomic) IBOutlet UILabel *lblLNBuySumAmt;
@property (strong, nonatomic) IBOutlet UITableView *BuyHistoryTableView;


///// Print ScrollView  /////////

@property (strong, nonatomic) IBOutlet UIScrollView *printScrollView;

@property (strong, nonatomic) IBOutlet UIView *viewHeader;

@property (strong, nonatomic) IBOutlet UILabel *lblSlipType;
@property (strong, nonatomic) IBOutlet UILabel *lblSlipTypeDetail;


@property (strong, nonatomic) IBOutlet UIImageView *imageBarCode;
@property (strong, nonatomic) IBOutlet UILabel *lblBarCode;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptNo;

@property (strong, nonatomic) IBOutlet UIView *viewBarCode;
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

@property (strong, nonatomic) IBOutlet UIView *viewGuide;
@property (weak, nonatomic) IBOutlet UITextView *memoTextView;


@end
