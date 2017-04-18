//
//  AppDelegate.h
//  statement
//
//  Created by Alexander Kuhar on 4/4/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *persistentContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *mainQueueContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *backgroundContext;

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

- (NSURL *) applicationDirectory;

@end

