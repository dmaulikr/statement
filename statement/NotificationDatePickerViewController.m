//
//  NotificationDatePickerViewController.m
//  statement
//
//  Created by Alexander Kuhar on 6/26/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "NotificationDatePickerViewController.h"
#import "SettingsViewController.h"

@interface NotificationDatePickerViewController ()

@end

@implementation NotificationDatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    NSLog(@"%@", _notificationIdentifier);
    
    [_notificationDatePicker addTarget:self action:@selector(rescheduleNotification) forControlEvents:UIControlEventValueChanged];
    
    UIColor *blueGreenColor = [UIColor colorWithRed:56.0/255.0 green:199.0/255.0 blue:185.0/255.0 alpha:1.0];
    [_notificationDatePicker setValue:blueGreenColor forKey:@"textColor"];
}

-(void)rescheduleNotification {
    
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:[NSArray arrayWithObject:_notificationIdentifier]];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *currentDateComponents = [currentCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:_notificationDatePicker.date];
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        if(settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            
            NSString *title = @"";
            NSString *body = @"";
            
            UNMutableNotificationContent *notificationContent = [UNMutableNotificationContent new];
            
            if([_notificationIdentifier isEqualToString:@"morningGoalIdentifier"]) {
                
                title = @"Good morning!";
                body = @"Don't forget to set your goals for the day!";
            }
            
            if([_notificationIdentifier isEqualToString:@"eveningGoalIdentifier"]) {
                
                title = @"How'd your day go?";
                body = @"Judge how your goals went today!";
            }
            
            notificationContent.title = title;
            notificationContent.body = body;
            notificationContent.sound = [UNNotificationSound defaultSound];
            //NSLog(@"%@", notificationContent);
            
            NSDate *date = [NSDate date];
            
            NSDateComponents *triggerComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
            
            triggerComponents.hour = currentDateComponents.hour;
            triggerComponents.minute = currentDateComponents.minute;
            triggerComponents.second = 0;
            //NSLog(@"%@", triggerComponents);
            
            if ([_notificationIdentifier isEqualToString:@"morningGoalIdentifier"]) {
                
                self.morningNotificationDateComponents = triggerComponents;
                //NSLog(@"%@", _morningNotificationDateComponents);
            }
            
            if ([_notificationIdentifier isEqualToString:@"eveningGoalIdentifier"]) {
                
                self.eveningNotificationDateComponents = triggerComponents;
                //NSLog(@"%@", _eveningNotificationDateComponents);
            }
            
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerComponents repeats:YES];
            //NSLog(@"%@", trigger);
        
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_notificationIdentifier content:notificationContent trigger:trigger];
            //NSLog(@"%@", request.identifier);
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
                if (error != nil) {
                    
                    NSLog(@"Something went wrong: %@", error);
                } else {
                    
                    //NSLog(@"Notification added");
                }
            }];
        }
    }];
}

#pragma mark - Navigation Controller Delegate Methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([_notificationIdentifier isEqualToString:@"morningGoalIdentifier"]) {
    
        SettingsViewController *settingsViewController = (SettingsViewController *) viewController;
        settingsViewController.morningNotificationDateComponents = _morningNotificationDateComponents;
        
        //NSLog(@"%@", self.morningNotificationDateComponents);
    }
    
    if ([_notificationIdentifier isEqualToString:@"eveningGoalIdentifier"]) {
        
        SettingsViewController *settingsViewController = (SettingsViewController *) viewController;
        settingsViewController.eveningNotificationDateComponents = _eveningNotificationDateComponents;
        
        //NSLog(@"%@", self.eveningNotificationDateComponents);
    }
    
    NSLog(@"Navigation Delegate Method Called");
}

@end
