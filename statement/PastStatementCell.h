//
//  PastStatementCell.h
//  statement
//
//  Created by Alexander Kuhar on 6/21/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastStatementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statementText;
@property (weak, nonatomic) IBOutlet UILabel *statementType;
@property (weak, nonatomic) IBOutlet UIImageView *completionStatusImage;

@end
