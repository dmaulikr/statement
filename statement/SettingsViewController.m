//
//  SettingsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/22/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "SettingsViewController.h"
#import "EnableNotificationsCell.h"

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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"morningNotificationCell"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"Notification Access";
        
    } else {
        
        return @"Notification Time Settings";
    }
}

- (void)enableNotifications {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"We need your permission to send you reminder notifications." message:@"Tap 'Settings' to grant that access." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsUrl options:@{} completionHandler:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
