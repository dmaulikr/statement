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

@interface StatementsViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *personalStatementTextField;
@property (weak, nonatomic) IBOutlet UITextField *professionalStatementTextField;

@property (retain, nonatomic) NSManagedObjectContext *context;

@property Statement *personalStatement;
@property Statement *professionalStatement;

-(void)createStatement;

@end
