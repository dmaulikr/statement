//
//  AppDelegate.h
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, readonly) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)saveContext;
- (NSFetchedResultsController *)initializeFetchedResultsControllerForEntity:(NSString *)entity withSortDescriptor:(NSString *)sortDescriptor;

@end

