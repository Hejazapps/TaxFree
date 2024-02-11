//
//  PrintView.h
//  TaxFree
//
//  Created by Smile on 24/03/2019.
//  Copyright © 2019 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunc.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrintView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UIFont *default_font;
    NSMutableArray *PrintList;
    NSMutableDictionary *PrintInfo;
    NSInteger item_num;
}
+ (id)loadXIB:(id)owner;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UIView *viewRecord;
@property (strong, nonatomic) IBOutlet UILabel *lblRecord_SlipType;
@property (strong, nonatomic) IBOutlet UILabel *lblRecord_SlipNo;
@property (strong, nonatomic) IBOutlet UITableView *RecordTableView;
@property (strong, nonatomic) IBOutlet UIView *viewRecord_Description;
@property (strong, nonatomic) IBOutlet UILabel *lblRecord_Description;



@property (strong, nonatomic) IBOutlet UIView *viewConvenant;
@property (strong, nonatomic) IBOutlet UILabel *lblConv_SlipType;
@property (strong, nonatomic) IBOutlet UILabel *lblConv_SlipNo;
@property (strong, nonatomic) IBOutlet UIView *viewConv_Content;
@property (strong, nonatomic) IBOutlet UIImageView *signImageView;
@property (strong, nonatomic) IBOutlet UILabel *lblConv_SellerName;
@property (strong, nonatomic) IBOutlet UITableView *ConvTableView;




@end

NS_ASSUME_NONNULL_END
