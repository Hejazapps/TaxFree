//
//  IssueCell.m
//  TaxFree
//
//  Created by Smile on 30/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "IssueCell.h"

@implementation IssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _cellView.layer.cornerRadius = 8;
    _cellView.clipsToBounds = YES;
    
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    _shadowView.layer.shadowOpacity = 0.5;
    _shadowView.layer.shadowRadius = 2.0;
    _shadowView.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
