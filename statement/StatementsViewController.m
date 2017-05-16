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
    _fetchController = [statementsVCAppDelegate initializeFetchedResultsControllerForEntity:@"Statement" withSortDescriptor:@"type"];
    
    _personalStatementTextField.delegate = self;
    _professionalStatementTextField.delegate = self;
    
    NSError *fetchError = nil;
    if(![_fetchController performFetch:&fetchError]){
        
        NSLog(@"Failed to perform fetch: %@", fetchError);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [statementsVCAppDelegate saveContext];
}

-(void)createStatement {
    
    if ([_personalStatementTextField isFirstResponder]) {
        
        personalStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:_context];
        personalStatement.statementText = _personalStatementTextField.text;
        personalStatement.type = @"personal";
        personalStatement.completed = NO;
        personalStatement.createdDate = [NSDate date];
        
        NSLog(@"%@", personalStatement);
        
        [statementsVCAppDelegate saveContext];
        
        [self fetchStatementWithType:@"personal"];
        
    } else if ([_professionalStatementTextField isFirstResponder]){
        
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

-(Statement *)fetchStatementWithType:(NSString *)type {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Statement"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"type == %@", type]];
    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSError *error = nil;
    
    NSArray *fetchedPersonal = [_context executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        
        NSLog(@"%@", error);
    }
    
    NSLog(@"%@", fetchedPersonal[0]);
    
    return fetchedPersonal[0];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (![textField.text  isEqual: @""]) {
        
        [self createStatement];
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
