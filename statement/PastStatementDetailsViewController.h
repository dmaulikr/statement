//
//  PastStatementDetailsViewController.h
//  statement
//
//  Created by Alexander Kuhar on 6/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastStatementDetailsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *statementDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsCompletedLabel;

@end
