//
//  NotificationDatePickerViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/26/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "NotificationDatePickerViewController.h"

@interface NotificationDatePickerViewController ()

@end

@implementation NotificationDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", _notificationIdentifier);
}

- (void)removeOldNotificationAndSetNotificationWithTitle:(NSString *)title andBody:(NSString *)body forHour:(NSInteger)hour forMinute:(NSInteger)minute withIdentifer:(NSString *)identifer {
    
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers: [NSArray arrayWithObject:identifer]];
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        if(settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            
            UNMutableNotificationContent *notificationContent = [UNMutableNotificationContent new];
            notificationContent.title = title;
            notificationContent.body = body;
            notificationContent.sound = [UNNotificationSound defaultSound];
            
            NSDate *date = [NSDate date];
            
            NSDateComponents *triggerComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
            
            triggerComponents.hour = hour;
            triggerComponents.minute = minute;
            triggerComponents.second = 0;
            NSLog(@"%@", triggerComponents);
            
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerComponents repeats:YES];
            NSLog(@"%@", trigger);
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifer content:notificationContent trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
                if(error != nil) {
                    
                    NSLog(@"Something went wrong: %@", error);
                } else {
                    NSLog(@"Notification added");
                }
            }];
        }
    }];
}

@end
