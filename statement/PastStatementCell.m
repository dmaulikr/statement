//
//  PastStatementCell.m
//  statement
//
//  Created by Alexander Kuhar on 6/21/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "PastStatementCell.h"

@implementation PastStatementCell

@synthesize statementText;
@synthesize statementType;
@synthesize completionStatusImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
