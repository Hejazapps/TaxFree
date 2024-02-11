//
//  BuyHistoryCell.h
//  TaxFree
//
//  Created by Smile on 2023/06/27.
//  Copyright © 2023 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyHistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblShopName;
@property (strong, nonatomic) IBOutlet UILabel *lblAmt;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;



@end

NS_ASSUME_NONNULL_END
