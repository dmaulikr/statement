//
//  SettingsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/22/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "SettingsViewController.h"
#import "EnableNotificationsCell.h"
#import "NotificationTimeTableViewCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

UNNotificationSettings *notificationSettings;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _settingsTableView.delegate = self;
    _settingsTableView.dataSource = self;
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
       
        notificationSettings = settings;
    }];
    
    [self createDatePicker];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else {
        
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
    
        EnableNotificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"enableNotificationsCell"];
        
        if (notificationSettings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            
            cell.enableNotificationsButton.enabled = NO;
            
        } else {
            
            cell.enableNotificationsButton.enabled = YES;
        }
        
        [cell.enableNotificationsButton addTarget:self action:@selector(enableNotifications) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            NotificationTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"morningNotificationCell"];
            
            cell.notificationTextField.delegate = self;
            
            [cell.notificationTextField setInputView:[self createDatePicker]];
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDatePicker)];
            
            [toolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
            
            [cell.notificationTextField setInputAccessoryView:toolbar];
            
            return cell;
            
        } else if (indexPath.row == 1) {
            
            NotificationTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eveningNotificationCell"];
            
            cell.notificationTextField.delegate = self;
            
            [cell.notificationTextField setInputView:[self createDatePicker]];
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDatePicker)];
            
            [toolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
            
            [cell.notificationTextField setInputAccessoryView:toolbar];
            
            return cell;
        }
    }
    
    UITableViewCell *cell;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"Notification Access";
        
    } else {
        
        return @"Notification Time Settings";
    }
}

#pragma mark - Helper Notification Methods

- (void)enableNotifications {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"We need your permission to send you reminder notifications." message:@"Tap 'Settings' to grant that access." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsUrl options:@{} completionHandler:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIDatePicker *)createDatePicker {
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height / 3))];
    
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.date = [NSDate date];
    
    return datePicker;
}

- (void)dismissDatePicker {
    
    [self.view endEditing:YES];
}

@end
