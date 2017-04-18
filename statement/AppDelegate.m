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

@synthesize persistentContext = _persistentContext;
@synthesize mainQueueContext = _mainQueueContext;
@synthesize backgroundContext = _backgroundContext;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource: @"DataModel" withExtension: @"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelUrl];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [[self applicationDirectory] URLByAppendingPathComponent: @"DataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration: nil URL: storeUrl options: nil error: &error]) {
        
        NSLog(@"Unresolved error: %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)persistentContext {
    
    if (_persistentContext != nil) {
        return _persistentContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        
        _persistentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
        [_persistentContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _persistentContext;
}

- (NSManagedObjectContext *)mainQueueContext {
    
    if (_mainQueueContext != nil) {
        return _mainQueueContext;
    }
    
    _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
    [_mainQueueContext setParentContext:_persistentContext];
    
    return _mainQueueContext;
}

- (NSManagedObjectContext *)backgroundContext {
    
    if (_backgroundContext != nil) {
        return _backgroundContext;
    }
    
    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    [_backgroundContext setParentContext:_mainQueueContext];
    
    return _backgroundContext;
}

- (void)saveBackgroundContext {
    
    NSError *error = nil;
    NSManagedObjectContext *backgroundContext = [self backgroundContext];
    
    if (backgroundContext != nil) {
        
        if ([backgroundContext hasChanges] && ![backgroundContext save: &error]) {
            
            NSLog(@"Unresolved errors saving: %@, %@", error, [error userInfo]);
            abort();
        } else {
            
            [backgroundContext save: &error];
            NSLog(@"Background context saved");
        }
    }
}

- (void)saveContext {
    
    NSError *error = nil;
    NSManagedObjectContext *mainQueueContext = [self mainQueueContext];
    NSManagedObjectContext *persistentContext = [self persistentContext];
    
    if (mainQueueContext != nil) {
        
        if ([mainQueueContext hasChanges] && ![mainQueueContext save: &error]) {
            
            NSLog(@"Unresolved errors saving: %@, %@", error, [error userInfo]);
            abort();
        } else {
            
            [mainQueueContext save: &error];
            NSLog(@"Main queue context saved");
        }
        
        if (persistentContext != nil) {
            
            if ([persistentContext hasChanges] && ![persistentContext save: &error]) {
                
                NSLog(@"Unresolved errors saving: %@, %@", error, [error userInfo]);
                abort();
            } else {
                
                [persistentContext save: &error];
                NSLog(@"Persistent context saved");
            }
        }
    }
}

- (NSURL *)applicationDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject];
}

@end
