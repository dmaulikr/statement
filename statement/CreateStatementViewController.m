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

#pragma mark - UIViewController

@synthesize createdStatement;

AppDelegate *appDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [[appDelegate persistentContainer] viewContext];
    
    _fetchController = [appDelegate initializeFetchedResultsController];
    _fetchController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFirstResponder) name:UIKeyboardWillShowNotification object:nil];
    
    [self createInputAccessoryView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [appDelegate saveContext];
}

- (void)createStatement {
    
    if (![_inputTextField.text isEqual:@""]) {
        
        NSError *error = nil;
        
        self.createdStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        self.createdStatement.statementText = _inputTextField.text;
        
        [appDelegate saveContext];
        
        if(![_fetchController performFetch:&error]) {
            
            NSLog(@"Failed to perform fetch: %@", error);
        }
    }
    
    [_inputTextField resignFirstResponder];
}

#pragma mark: Input Accessory View Implementation

- (void)createInputAccessoryView {
    
    _inputAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40)];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 0.0, self.view.frame.size.width * 0.75, 40)];
    [_inputTextField setPlaceholder:@"Add a new Statement"];
    [_inputTextField setBorderStyle:UITextBorderStyleNone];
    _inputTextField.delegate = self;
    UIBarButtonItem *textFieldItem = [[UIBarButtonItem alloc] initWithCustomView:_inputTextField];
    
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30, 30)];
    [_addButton setTitle:@"Add" forState:UIControlStateNormal];
    [_addButton setImage:[UIImage imageNamed:@"Create Arrow"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(createStatement) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addButton];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [_inputAccessoryView setItems:@[textFieldItem, flexibleSpace, addButtonItem]];
}

#pragma mark - Keyboard Notification Selectors

- (void)changeFirstResponder {
    
    [_inputTextField becomeFirstResponder];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_fetchController.fetchedObjects.count > 0) {
        return _fetchController.fetchedObjects.count;
    } else {
        return 0;
    }
}

#pragma mark - TableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statementCell"];
    Statement *statementIndexObject = (Statement *)[_fetchController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = statementIndexObject.statementText;
    
    return cell;
}

#pragma mark - Fetched Results Controller Delegate

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    controller = _fetchController;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView]insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![_inputTextField.text  isEqual: @""]) {
        
        [self createStatement];
    }

    [textField resignFirstResponder];
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    textField.text = nil;
}

@end
