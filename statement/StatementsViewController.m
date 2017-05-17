//
//  StatementsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 5/11/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "StatementsViewController.h"

@interface StatementsViewController ()

@end

@implementation StatementsViewController

@synthesize personalStatement;
@synthesize professionalStatement;

AppDelegate *statementsVCAppDelegate;
UITextField *activeField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    statementsVCAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    _context = [[statementsVCAppDelegate persistentContainer] viewContext];
    _fetchController = [statementsVCAppDelegate initializeFetchedResultsControllerForEntity:@"Statement" withSortDescriptor:@"type"];
    
    _personalStatementTextField.delegate = self;
    _professionalStatementTextField.delegate = self;
    
    self.personalView.layer.borderWidth = 3;
    self.personalView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:181.0f/255.0f blue:244.0f/255.0f alpha:1.0f].CGColor;
    
    self.professionalView.layer.borderWidth = 3;
    self.professionalView.layer.borderColor = [UIColor colorWithRed:126.0f/255.0f green:243.0f/255.0f blue:139.0f/255.0f alpha:1.0f].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    NSArray *personalStatementArray = [self fetchStatementWithType:@"personal"];
    
    if ([personalStatementArray count] > 0) {
        
        Statement *currentPersonalStatement = personalStatementArray[0];
        _personalStatementTextField.text = currentPersonalStatement.statementText;
    }
    
    NSArray *professionalStatementArray = [self fetchStatementWithType:@"professional"];
    
    if ([professionalStatementArray count] > 0) {
        
        Statement *currentProfessionalStatement = professionalStatementArray[0];
        _professionalStatementTextField.text = currentProfessionalStatement.statementText;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [statementsVCAppDelegate saveContext];
}

-(void)createStatement {
    
    if ([_personalStatementTextField isFirstResponder]) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"type == %@", @"personal"]];
        
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        NSError *deleteError = nil;
        
        [[[statementsVCAppDelegate persistentContainer] persistentStoreCoordinator] executeRequest:deleteRequest withContext:_context error:&deleteError];
        
        personalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        personalStatement.statementText = _personalStatementTextField.text;
        personalStatement.type = @"personal";
        personalStatement.completed = NO;
        personalStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", personalStatement);
        
        [statementsVCAppDelegate saveContext];
        
    } else if ([_professionalStatementTextField isFirstResponder]) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"type == %@", @"professional"]];
        
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        NSError *deleteError = nil;
        
        [[[statementsVCAppDelegate persistentContainer] persistentStoreCoordinator] executeRequest:deleteRequest withContext:_context error:&deleteError];
        
        professionalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        professionalStatement.statementText = _professionalStatementTextField.text;
        professionalStatement.type = @"professional";
        professionalStatement.completed = NO;
        professionalStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", professionalStatement);
        
        [statementsVCAppDelegate saveContext];
        
        [self fetchStatementWithType:@"professional"];
    }
}

#pragma mark - Button Functionality

- (IBAction)thumbsUp:(id)sender {
    
    if ([sender tag] == 1) {
        
        personalStatement.completed = YES;
        NSLog(@"%@", personalStatement);
        
    } if ([sender tag] == 3) {
        
        professionalStatement.completed = YES;
        NSLog(@"%@", professionalStatement);
    }
}

- (IBAction)thumbsDown:(id)sender {
    
    if ([sender tag] == 2) {
        
        personalStatement.completed = NO;
        
    } else if ([sender tag] == 4) {
        
        professionalStatement.completed = NO;
    }
}

- (void)keyboardWasShown:(NSNotification *)keyboardNotification {
    
    NSDictionary *userInfo = [keyboardNotification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height + 5, 0.0);
    
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect viewRect = self.view.frame;
    viewRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(viewRect, activeField.frame.origin)) {
        
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHiden:(NSNotification *)keyboardNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Core Data Helper Functions

-(NSArray *)fetchStatementWithType:(NSString *)type {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"type == %@", type]];
    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSError *error = nil;
    
    NSArray *fetchedPersonal = [_context executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedPersonal count] < 1) {
        
        return nil;
    }
    
    NSLog(@"%@", fetchedPersonal[0]);
    
    return fetchedPersonal;
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![textField.text  isEqual: @""]) {
        
        [self createStatement];
    }
    
    if (textField == _personalStatementTextField) {
        
        NSArray *personalStatementArray = [self fetchStatementWithType:@"personal"];
        Statement *thisPersonalStatement = personalStatementArray[0];
        textField.text = thisPersonalStatement.statementText;
    }
    
    if (textField == _professionalStatementTextField) {
        
        NSArray *professionalStatementArray = [self fetchStatementWithType:@"professional"];
        Statement *thisProfessionalStatement = professionalStatementArray[0];
        textField.text = thisProfessionalStatement.statementText;
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
