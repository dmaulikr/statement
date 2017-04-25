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
NSMutableArray *statementArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _context = [[appDelegate persistentContainer] viewContext];
    
    _fetchController = [appDelegate initializeFetchedResultsController];
    
    statementArray = [_fetchController.fetchedObjects mutableCopy];
    
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
        
        self.createdStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        self.createdStatement.statementText = _inputTextField.text;
        
        [statementArray addObject:createdStatement];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[statementArray indexOfObject:createdStatement] inSection:0];
        
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [_tableView endUpdates];
        
        [appDelegate saveContext];
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
    
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(_inputTextField.frame.size
                                                            .width + 10, 0.0, 40, 40)];
    [_addButton setTitle:@"Add" forState:UIControlStateNormal];
    [_addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(createStatement) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_addButton];
    
    [_inputAccessoryView setItems:@[textFieldItem, addButtonItem]];
}

#pragma mark - Keyboard Notification Selectors

- (void)changeFirstResponder {
    
    [_inputTextField becomeFirstResponder];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (statementArray == nil) {
        return 0;
    } else {
        return [statementArray count];
    }
}

#pragma mark - TableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statementCell"];
    Statement *statementIndexObject = (Statement *)[statementArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = statementIndexObject.statementText;
    
    return cell;
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
