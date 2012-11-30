//
//  AppDelegate.h
//  BestSplitViewControllerDemo
//
//  Created by Tomasz Janeczko on 27.11.2012.
//  Copyright (c) 2012 Tomasz Janeczko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BestSplitViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) BestSplitViewController *splitViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
