//
//  StatementDetailsViewController.h
//  statement
//
//  Created by Alexander Kuhar on 4/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Statement+CoreDataClass.h"

@interface StatementDetailsViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchController;
@property (nonatomic) NSFetchRequest *statementFetch;
@property (strong, nonatomic) Statement *selectedStatement;

@end
