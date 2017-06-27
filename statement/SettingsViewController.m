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
#import "NotificationDatePickerViewController.h"

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
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSLog(@"%@, %@", _morningNotificationDateComponents, _eveningNotificationDateComponents);
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
            
            return cell;
            
        } else if (indexPath.row == 1) {
            
            NotificationTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eveningNotificationCell"];
            
            cell.notificationTextField.delegate = self;
            
            return cell;
        }
    }
    
    UITableViewCell *cell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqual: @"morningNotification"]) {
        
        NotificationDatePickerViewController *viewController = [segue destinationViewController];
        [viewController setNotificationIdentifier:@"morningGoalIdentifier"];
    }
    
    if ([segue.identifier isEqual:@"eveningNotification"]) {
        
        NotificationDatePickerViewController *viewController = [segue destinationViewController];
        [viewController setNotificationIdentifier:@"eveningGoalIdentifier"];
    }
}

@end
