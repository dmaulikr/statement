//
//  SettingsViewController.h
//  statement
//
//  Created by Alexander Kuhar on 6/22/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (nonatomic) NSDateComponents *morningNotificationDateComponents;
@property (nonatomic) NSDateComponents *eveningNotificationDateComponents;

@end
