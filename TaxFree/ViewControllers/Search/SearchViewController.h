//
//  SearchViewController.h
//  TaxFree
//
//  Created by Smile on 02/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ChooseDatePickerViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *btnRefundDate;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundDate;


@property (strong, nonatomic) IBOutlet UIButton *btnRefundStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblRefundStatus;

@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UILabel *lblSend;


@property (strong, nonatomic) IBOutlet UILabel *viewSlipNo;
@property (strong, nonatomic) IBOutlet UITextField *txtSlipNo;


@property (strong, nonatomic) IBOutlet UIView *viewField;

@property (strong, nonatomic) IBOutlet UITableView *mainTableView;


@property (strong, nonatomic) IBOutlet UIButton *btnSearch;


@end
