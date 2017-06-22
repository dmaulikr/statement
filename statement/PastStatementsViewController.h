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

@property (weak, nonatomic) NSArray *oldPersonalStatementArray;
@property (weak, nonatomic) NSArray *oldProfessionalStatementArray;

@property (weak, nonatomic) IBOutlet UITableView *pastPersonalTableView;
@property (weak, nonatomic) IBOutlet UITableView *pastProfessionalTableView;

@property (retain, nonatomic) NSManagedObjectContext *context;
@property (retain, nonatomic) NSFetchedResultsController *fetchController;

- (NSArray *)fetchOldStatementsWithType:(NSString *)type;

@end
