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
NSManagedObjectContext *context;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statementTextField.delegate = self;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = [[appDelegate persistentContainer] viewContext];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createStatement:(UITextField *)sender {
    
    _statementLabel.text = _statementTextField.text;
    
    self.createdStatement.statementText = _statementLabel.text;
    
    self.createdStatement = [NSEntityDescription insertNewObjectForEntityForName:@"Statement" inManagedObjectContext:context];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return TRUE;
}

@end
