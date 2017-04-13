//
//  ViewController.m
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//
#import "CreateStatementViewController.h"

@interface CreateStatementViewController ()

@end

@implementation CreateStatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statementTextField.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createStatement:(UITextField *)sender {
    
    _statementLabel.text = _statementTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return TRUE;
}

@end
