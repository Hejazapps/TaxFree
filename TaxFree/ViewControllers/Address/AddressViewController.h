//
//  AddressViewController.h
//  TaxFree
//
//  Created by Smile on 2023/01/16.
//  Copyright © 2023 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtState;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;


@property (strong, nonatomic) IBOutlet UIView *viewField;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end

NS_ASSUME_NONNULL_END
