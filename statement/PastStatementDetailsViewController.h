//
//  PastStatementDetailsViewController.h
//  statement
//
//  Created by Alexander Kuhar on 6/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Statement+CoreDataClass.h"

@interface PastStatementDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSString *statementIdentifier;
@property (weak, nonatomic) Statement *pastStatement;

@property (weak, nonatomic) IBOutlet UIView *statementDetailsView;
@property (weak, nonatomic) IBOutlet UITableView *statementDetailsTableView;

@end
