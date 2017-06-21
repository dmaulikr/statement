//
//  StatementsViewController.h
//  statement
//
//  Created by Alexander Kuhar on 5/11/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Statement+CoreDataClass.h"

@interface StatementsViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *personalStatementTextField;
@property (weak, nonatomic) IBOutlet UITextField *professionalStatementTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *personalView;
@property (weak, nonatomic) IBOutlet UIView *professionalView;

@property (weak, nonatomic) IBOutlet UIButton *personalYesButton;
@property (weak, nonatomic) IBOutlet UIButton *personalNoButton;
@property (weak, nonatomic) IBOutlet UIButton *professionalYesButton;
@property (weak, nonatomic) IBOutlet UIButton *professionalNoButton;

@property (weak, nonatomic) IBOutlet UITextView *personalTextView;
@property (weak, nonatomic) IBOutlet UITextView *professionalTextView;

@property (retain, nonatomic) NSManagedObjectContext *context;
@property (retain, nonatomic) NSFetchedResultsController *fetchController;

@property Statement *personalStatement;
@property Statement *professionalStatement;

-(void)createStatement;
-(void)thumbsUp:(id)sender;
-(void)thumbsDown:(id)sender;
-(NSArray *)fetchStatementWithType:(NSString *)type andStatus:(NSString *)status;

@end
