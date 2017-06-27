//
//  NotificationDatePickerViewController.h
//  statement
//
//  Created by Alexander Kuhar on 6/26/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationDatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *notificationDatePicker;

@property (weak, nonatomic) NSString *notificationIdentifier;

@end
