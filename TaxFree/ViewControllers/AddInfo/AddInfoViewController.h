//
//  AddInfoViewController.h
//  TaxFree
//
//  Created by Smile on 2023/01/16.
//  Copyright © 2023 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddInfoViewController : UIViewController < ChooseDatePickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *btnOption1;
@property (strong, nonatomic) IBOutlet UIButton *btnOption2;

@property (strong, nonatomic) IBOutlet UIView *viewOption1;
@property (strong, nonatomic) IBOutlet UIView *viewOption2;

@property (strong, nonatomic) IBOutlet UITextField *txtInstituteName;
@property (strong, nonatomic) IBOutlet UILabel *lineInstituteName;

@property (strong, nonatomic) IBOutlet UITextField *txtIssueDate;
@property (strong, nonatomic) IBOutlet UILabel *lineIssueDate;


@property (strong, nonatomic) IBOutlet UITextField *txtIssueNo;
@property (strong, nonatomic) IBOutlet UILabel *lineIssueNo;


@property (strong, nonatomic) IBOutlet UITextField *txtIssueDate2;
@property (strong, nonatomic) IBOutlet UILabel *lineIssueDate2;


@property (strong, nonatomic) IBOutlet UITextField *txtPostNo;

@property (strong, nonatomic) IBOutlet UITextField *txtAddress;

@property (strong, nonatomic) IBOutlet UITextField *txtAddressNo;

@property (strong, nonatomic) IBOutlet UIButton *btnOk;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;


@end

NS_ASSUME_NONNULL_END
