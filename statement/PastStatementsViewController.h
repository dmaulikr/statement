//
//  PastStatementsViewController.h
//  statement
//
//  Created by Alexander Kuhar on 6/19/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Statement+CoreDataClass.h"

@interface PastStatementsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSArray *oldStatementsArray;

@property (weak, nonatomic) IBOutlet UITableView *pastStatementsTableView;

@property (retain, nonatomic) NSManagedObjectContext *context;
@property (retain, nonatomic) NSFetchedResultsController *fetchController;

@end
