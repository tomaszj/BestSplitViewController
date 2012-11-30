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
 * Sets the displaying of the master view in either full screen or normal mode.
 *
 * @param isFullScreen indicating if should be shown in full screen
 */
- (void)setDisplayMasterViewInFullScreenMode:(BOOL)isFullScreen;

/**
 * Indicates if it's displaying the master view in full screen mode.
 *
 * @return YES if it's displaying in full screen
 */
- (BOOL)isDisplayingMasterViewInFullScreenMode;

/**
 * Toggles the master view.
 */
- (void)toggleMasterView;

/**
 * Checks if the master view is displayed in the left pane.
 *
 * @return YES if it's true.
 */
- (BOOL)isShowingTheMasterViewInLeftSplit;

/**
 * Sets default layout settings (master hidden in portrait mode and shown in landscape).
 */
- (void)setDefaultMasterVisibility;

@end
