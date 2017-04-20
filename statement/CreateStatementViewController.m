//
//  ViewController.m
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//
#import "CreateStatementViewController.h"
#import "AppDelegate.h"

@interface CreateStatementViewController ()

@end

@implementation CreateStatementViewController

@synthesize createdStatement;

AppDelegate *appDelegate;
Statement *fetchedStatement;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statementTextField.delegate = self;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [[appDelegate persistentContainer] viewContext];
    
    _fetchController = [appDelegate initializeFetchedResultsController];
    fetchedStatement = (Statement *)_fetchController.fetchedObjects.firstObject;
    
    NSLog(@"%@", fetchedStatement.statementText);
    
    _statementLabel.text = fetchedStatement.statementText;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createStatement:(UITextField *)sender {
    
    for (NSManagedObject *object in _fetchController.fetchedObjects) {
     [_fetchController.managedObjectContext deleteObject:object];
    }
    
    _statementLabel.text = _statementTextField.text;
    NSLog(@"%@", _statementLabel.text);
    
    
    self.createdStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
    self.createdStatement.statementText = _statementLabel.text;
    
    [appDelegate saveContext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return TRUE;
}

@end
