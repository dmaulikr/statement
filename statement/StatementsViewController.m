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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    statementsVCAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    _context = [[statementsVCAppDelegate persistentContainer] viewContext];
    
    _personalStatementTextField.delegate = self;
    _professionalStatementTextField.delegate = self;
}

-(void)createStatement {
    
    if ([_personalStatementTextField isFirstResponder]) {
        
        personalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        personalStatement.statementText = _personalStatementTextField.text;
        personalStatement.completed = NO;
        personalStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", personalStatement);
        
    } else if ([_professionalStatementTextField isFirstResponder]){
        
        professionalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        professionalStatement.statementText = _professionalStatementTextField.text;
        professionalStatement.completed = NO;
        professionalStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", professionalStatement);
    }
    
     [statementsVCAppDelegate saveContext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![textField.text  isEqual: @""]) {
        
        [self createStatement];
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
