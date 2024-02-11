//
//  OnlineSearchViewController.h
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

@interface OnlineSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ChooseDatePickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnDateType;
@property (strong, nonatomic) IBOutlet UILabel *lblDateType;

@property (strong, nonatomic) IBOutlet UIButton *btnStartDate;
@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;


@property (strong, nonatomic) IBOutlet UIButton *btnEndDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEndDate;



@property (strong, nonatomic) IBOutlet UILabel *viewSlipNo;
@property (strong, nonatomic) IBOutlet UITextField *txtSlipNo;

@property (strong, nonatomic) IBOutlet UIButton *btnRefundStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundStatus;

@property (strong, nonatomic) IBOutlet UIView *viewField;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) IBOutlet UIButton *btnSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end
