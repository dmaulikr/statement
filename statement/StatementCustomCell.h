//
//  StatementCustomCell.h
//  statement
//
//  Created by Alexander Kuhar on 4/27/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StatementCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *checkboxButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
