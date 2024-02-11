//
//  OnlineSearchCell.m
//  TaxFree
//
//  Created by Smile on 08/11/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "OnlineSearchCell.h"

@implementation OnlineSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _cellView.layer.cornerRadius = 4;
    _cellView.clipsToBounds = YES;
    
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _shadowView.layer.shadowOpacity = 0.5;
    _shadowView.layer.shadowRadius = 2.0;
    _shadowView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
