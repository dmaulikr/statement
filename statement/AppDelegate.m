//
//  AppDelegate.m
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionAlert + UNAuthorizationOptionBadge + UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        NSLog(@"Notification permission status: %d", granted);
        
        [self setNotificationWithTitle:@"Good morning!" andBody:@"Don't forget to set your goals for the day!" forHour:9 withIdentifer:@"morningGoalIdentifier"];
        [self setNotificationWithTitle:@"How'd your day go?" andBody:@"Judge how your goals went today!" forHour:19 withIdentifer:@"eveningEvaluateIdentifier"];
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self saveContext];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Registration failed: %@", error);
}

#pragma mark - Core Data Stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    
    @synchronized (self) {
        
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"DataModel"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                
                if (error != nil) {
                    
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    NSLog(@"Unresolved error creating persistent container: %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving

- (void)saveContext {
    
    NSManagedObjectContext *context = _persistentContainer.viewContext;
    NSError *error = nil;
    
    if ([context hasChanges] && ![context save:&error]) {
        
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        NSLog(@"Unresolved error saving context: %@, %@", error, error.userInfo);
        abort();
    } else {
        
        NSLog(@"Context successfully saved.");;
    }
}

#pragma mark - Fetched Results Controller Initialization

- (NSFetchedResultsController *)initializeFetchedResultsControllerForEntity:(NSString *)entity withSortDescriptor:(NSString *)sortDescriptor {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: entity];
    NSSortDescriptor *textSort = [NSSortDescriptor sortDescriptorWithKey: sortDescriptor ascending:YES];
    
    [request setSortDescriptors:@[textSort]];
    
    NSManagedObjectContext *moc = _persistentContainer.viewContext;
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    
    [_fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    
    if (![_fetchedResultsController performFetch:&error]) {
        
        NSLog(@"Failed to initialize Fetched Requests Controller : %@, %@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        
        NSLog(@"Fetched Results Controller successfully initialized.");
    }
    
    return _fetchedResultsController;
}

#pragma mark - Notification Configuration

- (void)setNotificationWithTitle:(NSString *)title andBody:(NSString *)body forHour:(NSInteger)hour withIdentifer:(NSString *)identifer {
    
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        if(settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
            
            UNMutableNotificationContent *notificationContent = [UNMutableNotificationContent new];
            notificationContent.title = title;
            notificationContent.body = body;
            notificationContent.sound = [UNNotificationSound defaultSound];
            
            NSDate *date = [NSDate date];
            
            NSDateComponents *triggerComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
            
            triggerComponents.hour = hour;
            triggerComponents.minute = 0;
            triggerComponents.second = 0;
            NSLog(@"%@", triggerComponents);
            
            UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerComponents repeats:YES];
            
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
