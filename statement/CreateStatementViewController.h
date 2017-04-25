//
//  ViewController.h
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Statement+CoreDataClass.h"

@interface CreateStatementViewController : UIViewController <UITextFieldDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UIToolbar *inputAccessoryView;
@property (strong) UITextField *inputTextField;
@property (strong) UIButton *addButton;

@property (nonatomic, retain) NSFetchedResultsController *fetchController;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (strong, nonatomic) Statement *createdStatement;

- (void)createStatement;

@end

