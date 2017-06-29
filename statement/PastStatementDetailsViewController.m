//
//  PastStatementDetailsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "PastStatementDetailsViewController.h"

@interface PastStatementDetailsViewController ()

@end

@implementation PastStatementDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", _pastStatement);
    
    [self setUiColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setStatementUi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUiColor {
    
    if ([_pastStatement.type isEqualToString:@"personal"]) {
        
        UIColor *blueColor = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:244.0/255.0 alpha:1.0];
        _statementDetailsView.layer.borderWidth = 2;
        _statementDetailsView.layer.borderColor = blueColor.CGColor;
        _statementDetailsTextLabel.textColor = blueColor;
        _statementDetailsDateLabel.textColor = blueColor;
        _statementDetailsCompletedLabel.textColor = blueColor;
        _statementDetailsCommentsLabel.textColor = blueColor;
    }
    
    if ([_pastStatement.type isEqualToString:@"professional"]) {
        
        UIColor *greenColor = [UIColor colorWithRed:112.0/255.0 green:217.0/255.0 blue:125.0/255.0 alpha:1.0];
        _statementDetailsView.layer.borderWidth = 2;
        _statementDetailsView.layer.borderColor = greenColor.CGColor;
        _statementDetailsTextLabel.textColor = greenColor;
        _statementDetailsDateLabel.textColor = greenColor;
        _statementDetailsCompletedLabel.textColor = greenColor;
        _statementDetailsCommentsLabel.textColor = greenColor;
    }
}

- (void)setStatementUi {
    
    if (_pastStatement.statementText != nil) {
        
        _statementDetailsTextLabel.text = _pastStatement.statementText;
    }
    
    if (_pastStatement.comments != nil) {
        
        _statementDetailsCommentsLabel.text = _pastStatement.comments;
    }
    
    if (_pastStatement.createdDate != nil) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, MMM d, yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:_pastStatement.createdDate];
        _statementDetailsDateLabel.text = dateString;
    }
    
    if (_pastStatement.completed == 0) {
        
        _statementDetailsCompletedLabel.text = @"Completed? 🤔 It looks like you forgot to judge your progress that day!";
        
    } else if (_pastStatement.completed == 1) {
        
        _statementDetailsCompletedLabel.text = @"Completed? Doesn't look like you finished this goal, but keep trying!";
        
    } else if (_pastStatement.completed == 2) {
        
        _statementDetailsCompletedLabel.text = @"Completed? Yes! Nice work 😁👍";
    }
}

@end
