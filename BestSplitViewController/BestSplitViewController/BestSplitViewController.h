//
//  BestSplitViewController.h
//  BestSplitViewController
//
//  Created by Tomasz Janeczko on 27.11.2012.
//  Copyright (c) 2012 Tomasz Janeczko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BestSplitViewController;

/**
 * Delegate to BestSplitViewController class, responds to events allowing popover handling.
 */
@protocol BestSplitViewControllerDelegate <NSObject>

- (void)bestSplitViewController:(BestSplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc;

- (void)bestSplitViewController:(BestSplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button;

@end

/**
 * Split View Controller based on parent-child relationships and ARC.
 */
@interface BestSplitViewController : UIViewController <UIPopoverControllerDelegate>

@property (nonatomic, strong) IBOutlet UIViewController *masterViewController;
@property (nonatomic, strong) IBOutlet UIViewController *detailViewController;
@property (nonatomic, weak) IBOutlet id<BestSplitViewControllerDelegate> delegate;

/**
 * Sets default layout settings (master hidden in portrait mode and shown in landscape).
 */
- (void)setDefaultMasterVisibility;

@end
