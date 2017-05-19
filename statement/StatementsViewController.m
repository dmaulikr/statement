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
UITextView *activeTextView;

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
    self.professionalView.layer.borderColor = [UIColor colorWithRed:112.0f/255.0f green:217.0f/255.0f blue:125.0f/255.0f alpha:1.0f].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    NSArray *personalStatementArray = [self fetchStatementWithType:@"personal"];
    
    if ([personalStatementArray count] > 0) {
        
        personalStatement = personalStatementArray[0];
        Statement *currentPersonalStatement = personalStatementArray[0];
        _personalStatementTextField.text = currentPersonalStatement.statementText;
        
    } else {
        
        [_personalYesButton setUserInteractionEnabled:NO];
        [_personalYesButton setSelected:NO];
        _personalYesButton.alpha = 0.25;
        
        [_personalNoButton setUserInteractionEnabled:NO];
        [_personalNoButton setSelected:NO];
        _personalNoButton.alpha = 0.25;
    }
    
    NSArray *professionalStatementArray = [self fetchStatementWithType:@"professional"];
    
    if ([professionalStatementArray count] > 0) {
        
        professionalStatement = professionalStatementArray[0];
        Statement *currentProfessionalStatement = professionalStatementArray[0];
        _professionalStatementTextField.text = currentProfessionalStatement.statementText;
        
    } else {
        
        [_professionalYesButton setUserInteractionEnabled:NO];
        [_professionalYesButton setSelected:NO];
        _professionalYesButton.alpha = 0.25;
        
        [_professionalNoButton setUserInteractionEnabled:NO];
        [_professionalNoButton setSelected:NO];
        _professionalNoButton.alpha = 0.25;
    }
    
    if (personalStatement.completed == 2) {
        
        [_personalYesButton setSelected:YES];
        [_personalNoButton setSelected:NO];
        
    } else if (personalStatement.completed == 1) {
        
        [_personalYesButton setSelected:NO];
        [_personalNoButton setSelected:YES];
    }
    
    if (professionalStatement.completed == 2) {
        
        [_professionalYesButton setSelected:YES];
        [_professionalNoButton setSelected:NO];
        
    } else if (professionalStatement.completed == 1) {
        
        [_professionalYesButton setSelected:NO];
        [_professionalNoButton setSelected:YES];
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
        personalStatement.completed = 0;
        personalStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", personalStatement);
        
        [statementsVCAppDelegate saveContext];
        
        NSArray *personalArray = [self fetchStatementWithType:@"personal"];
        personalStatement = personalArray[0];
        
        [_personalYesButton setUserInteractionEnabled:YES];
        _personalYesButton.alpha = 1.0;
        
        [_personalNoButton setUserInteractionEnabled:YES];
        _personalNoButton.alpha = 1.0;
        
    } else if ([_professionalStatementTextField isFirstResponder]) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"type == %@", @"professional"]];
        
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        NSError *deleteError = nil;
        
        [[[statementsVCAppDelegate persistentContainer] persistentStoreCoordinator] executeRequest:deleteRequest withContext:_context error:&deleteError];
        
        professionalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        professionalStatement.statementText = _professionalStatementTextField.text;
        professionalStatement.type = @"professional";
        professionalStatement.completed = 0;
        professionalStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", professionalStatement);
        
        [statementsVCAppDelegate saveContext];
        
        NSArray *professionalArray = [self fetchStatementWithType:@"professional"];
        professionalStatement = professionalArray[0];
        
        [_professionalYesButton setUserInteractionEnabled:YES];
        _professionalYesButton.alpha = 1.0;
        
        [_professionalNoButton setUserInteractionEnabled:YES];
        _professionalNoButton.alpha = 1.0;
    }
}

#pragma mark - Button Functionality

- (IBAction)thumbsUp:(id)sender {
    
    NSLog(@"button pressed");
    
    if ([sender tag] == 1) {
        
        if (personalStatement.completed == 0 || personalStatement.completed == 1) {
            
            personalStatement.completed = 2;
            [_personalYesButton setSelected:YES];
            [_personalNoButton setSelected:NO];
            
            NSLog(@"%@", personalStatement);
            
        } else if (personalStatement.completed == 2) {
            
            personalStatement.completed = 1;
            [_personalYesButton setSelected:NO];
            
            NSLog(@"%@", personalStatement);
        }
    }
    
    if ([sender tag] == 3) {
        
        if (professionalStatement.completed == 0 || professionalStatement.completed == 1) {
            
            professionalStatement.completed = 2;
            [_professionalYesButton setSelected:YES];
            [_professionalNoButton setSelected:NO];
            
            NSLog(@"%@", professionalStatement);
            
        } else if (professionalStatement.completed == 2) {
            
            professionalStatement.completed = 1;
            [_professionalYesButton setSelected:NO];
            
            NSLog(@"%@", professionalStatement);
        }
    }
}

- (IBAction)thumbsDown:(id)sender {
    
    if ([sender tag] == 2) {
        
        if (personalStatement.completed == 0 || personalStatement.completed == 2) {
            
            personalStatement.completed = 1;
            [_personalNoButton setSelected:YES];
            [_personalYesButton setSelected:NO];
            
            NSLog(@"%@", personalStatement);
        } else if (personalStatement.completed == 1) {
            
            personalStatement.completed = 0;
            [_personalNoButton setSelected:NO];
            
            NSLog(@"%@", personalStatement);
        }
        
    } else if ([sender tag] == 4) {
        
        if (professionalStatement.completed == 0 || professionalStatement.completed == 2) {
            
            professionalStatement.completed = 1;
            [_professionalNoButton setSelected:YES];
            [_professionalYesButton setSelected:NO];
            
            NSLog(@"%@", professionalStatement);
            
        } else if (professionalStatement.completed == 1) {
            
            professionalStatement.completed = 0;
            [_professionalNoButton setSelected:NO];
            
            NSLog(@"%@", professionalStatement);
        }
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
