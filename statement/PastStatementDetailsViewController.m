//
//  PastStatementDetailsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "PastStatementDetailsViewController.h"
#import "StatementDetailsTableViewCell.h"

@interface PastStatementDetailsViewController ()

@end

@implementation PastStatementDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", _pastStatement);
    
    _statementDetailsTableView.delegate = self;
    
    _statementDetailsTableView.rowHeight = UITableViewAutomaticDimension;
    _statementDetailsTableView.estimatedRowHeight = 60;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)setUiColor {
    
    if ([_pastStatement.type isEqualToString:@"personal"]) {
        
        UIColor *blueColor = [UIColor colorWithRed:0.0/255.0 green:181.0/255.0 blue:244.0/255.0 alpha:1.0];
        _statementDetailsView.layer.borderWidth = 2;
        _statementDetailsView.layer.borderColor = blueColor.CGColor;
    }
    
    if ([_pastStatement.type isEqualToString:@"professional"]) {
        
        UIColor *greenColor = [UIColor colorWithRed:112.0/255.0 green:217.0/255.0 blue:125.0/255.0 alpha:1.0];
        _statementDetailsView.layer.borderWidth = 2;
        _statementDetailsView.layer.borderColor = greenColor.CGColor;
    }
}*/

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StatementDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statementDetailsCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if (_pastStatement.statementText != nil) {
                
                cell.detailsLabel.text = _pastStatement.statementText;
            }
        }
        
        if (indexPath.row == 1) {
            
            if (_pastStatement.createdDate != nil) {
                
                cell.detailsLabel.text = [self formatDate:_pastStatement.createdDate];
            }
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if (_pastStatement.completed == 0) {
                
                cell.detailsLabel.text = @"🤔 Looks like you never judged this goal!";
            }
            
            if (_pastStatement.completed == 1) {
                
                cell.detailsLabel.text = @"You didn't complete this one. Give it another try!";
            }
            
            if (_pastStatement.completed == 2) {
                
                cell.detailsLabel.text = @"You did it! Nice work 😁";
            }
        }
        
        if (indexPath.row == 1) {
            
            if (_pastStatement.comments != nil) {
                
                cell.detailsLabel.text = _pastStatement.comments;
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"Statement Details";
    }
    
    if (section == 1) {
        
        return @"How'd you do?";
    }
    
    return @"";
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        return 120;
    } else {
        
        return 50;
    }
}*/

#pragma mark - Helper Functions

- (NSString *)formatDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *formattedString = [dateFormatter stringFromDate:date];
    return formattedString;
}

@end
