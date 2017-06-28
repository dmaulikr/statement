//
//  PastStatementDetailsViewController.h
//  statement
//
//  Created by Alexander Kuhar on 6/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Statement+CoreDataClass.h"

@interface PastStatementDetailsViewController : UIViewController

@property (weak, nonatomic) NSString *statementIdentifier;
@property (weak, nonatomic) Statement *pastStatement;

@property (strong, nonatomic) IBOutlet UIView *statementDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsCommentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *statementDetailsCompletedLabel;

@end
