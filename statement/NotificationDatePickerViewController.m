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
    
    [_notificationDatePicker addTarget:self action:@selector(rescheduleNotification) forControlEvents:UIControlEventValueChanged];
    
    UIColor *blueGreenColor = [UIColor colorWithRed:56.0/255.0 green:199.0/255.0 blue:185.0/255.0 alpha:1.0];
    [_notificationDatePicker setValue:blueGreenColor forKey:@"textColor"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_notificationIdentifier isEqualToString:@"morningGoalIdentifier"]) {
        
        [self setInitialDatePickerTimeForKey:@"morningNotificationTime"];
    }
    
    if ([_notificationIdentifier isEqualToString:@"eveningGoalIdentifier"]) {
        
        [self setInitialDatePickerTimeForKey:@"eveningNotificationTime"];
    }
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
            
            NSDate *date = [NSDate date];
            
            NSDateComponents *triggerComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
            
            triggerComponents.hour = currentDateComponents.hour;
            triggerComponents.minute = currentDateComponents.minute;
            triggerComponents.second = 0;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"h:mm a"];
            
            NSDate *dateToFormat = [[NSCalendar currentCalendar] dateFromComponents:triggerComponents];
            NSString *formattedDateString = [dateFormatter stringFromDate:dateToFormat];
            
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerComponents repeats:YES];
        
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_notificationIdentifier content:notificationContent trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
                if (error != nil) {
                    
                    NSLog(@"Something went wrong: %@", error);
                    
                } else {
                    
                    if ([_notificationIdentifier isEqualToString:@"morningGoalIdentifier"]) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:formattedDateString forKey:@"morningNotificationTime"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    if ([_notificationIdentifier isEqualToString:@"eveningGoalIdentifier"]) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:formattedDateString forKey:@"eveningNotificationTime"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    NSLog(@"Notification added");
                }
            }];
        }
    }];
}

- (void)setInitialDatePickerTimeForKey:(NSString *)key {
    
    // Sets the time that the date picker shows when first displayed. Time is based off of saved value in NSUserDefaults.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    NSString *stringToFormat = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    NSDate *formattedTime = [dateFormatter dateFromString:stringToFormat];
    
    NSLog(@"%@", formattedTime);
    [_notificationDatePicker setDate:formattedTime];
}

@end
