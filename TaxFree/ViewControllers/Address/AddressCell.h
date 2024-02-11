//
//  AddressCell.h
//  TaxFree
//
//  Created by Smile on 2023/01/17.
//  Copyright © 2023 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIView *cellView;

@property (strong, nonatomic) IBOutlet UILabel *lblAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress3;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress4;
@property (strong, nonatomic) IBOutlet UILabel *lblPostCode;

@end

NS_ASSUME_NONNULL_END
