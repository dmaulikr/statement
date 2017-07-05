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
            } else {
                
                cell.detailsLabel.text = @"No comments provided";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helper Functions

- (NSString *)formatDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *formattedString = [dateFormatter stringFromDate:date];
    return formattedString;
}

@end
