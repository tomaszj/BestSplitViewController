//
//  BestSplitViewController.m
//  BestSplitViewController
//
//  Created by Tomasz Janeczko on 27.11.2012.
//  Copyright (c) 2012 Tomasz Janeczko. All rights reserved.
//

#import "BestSplitViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BestSplitViewController() {
    UIViewController *_masterViewController;
    UIViewController *_detailViewController;
    
    BOOL _masterShown;
    
    BOOL _showsMasterInPortrait;
    BOOL _showsMasterInLandscape;
    
    UIPopoverController *_popoverController;
    
    UIBarButtonItem *_popoverBarButtonItem;
}

@end

@implementation BestSplitViewController

@synthesize delegate = _delegate;

// Setup methods

- (void)setup {
    _masterShown = YES;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _showsMasterInPortrait = NO;
    _showsMasterInLandscape = YES;
}

// View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 161, 100);
    [button addTarget:self action:@selector(hideMasterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.text = @"Hide master";
    button.center = self.view.center;
    
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self layoutViewsAtStart];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self layoutViewsAtStart];
}

// View layouting
- (void)layoutViews {
    [self layoutViewsForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation animated:YES];
}

- (void)layoutViewsAtStart {
    [self layoutViewsForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation animated:NO];
}

- (void)layoutViewsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation animated:(BOOL)animated {

    if (!_masterViewController || !_detailViewController) {
        return;
    }
    
    _masterViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    // Set the standard width
    int masterWidth = 320;
    CGRect viewBounds = self.view.bounds;
    
    // Check the interface orientation
    if ((_showsMasterInPortrait && UIInterfaceOrientationIsPortrait(interfaceOrientation)) || (_showsMasterInLandscape && UIInterfaceOrientationIsLandscape(interfaceOrientation))) {
            
        // Should show the master
        _masterViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
        
         // Add the master view to the split view if not set
        if (!_masterViewController.view.superview) {
            [self.view addSubview:_masterViewController.view];
            [self.view sendSubviewToBack:_masterViewController.view];
            _masterShown = YES;
        }
        
        // Set the detail view accordingly
        int detailWidth = viewBounds.size.width - masterWidth - 1;
        _detailViewController.view.frame = CGRectMake(masterWidth + 1, 0, detailWidth, viewBounds.size.height);
        
        // Hide the popover view controller
        if (_popoverBarButtonItem) {
            [self.delegate bestSplitViewController:self willShowViewController:_masterViewController invalidatingBarButtonItem:_popoverBarButtonItem];
            
            [self dismissPopover];
            _popoverBarButtonItem = nil;
        }

    } else {
        
        // Master should be hidden
        if (_masterShown) {
            [self hideMaster:NO];
        }
        
        _detailViewController.view.frame = viewBounds;
    }
    
    if (!_detailViewController.view.superview) {
        [self.view addSubview:_detailViewController.view];
        [self.view sendSubviewToBack:_detailViewController.view];
    }

}

// Rotations
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (_popoverController) {
        [_popoverController dismissPopoverAnimated:NO];
    }
    
    [self layoutViewsForInterfaceOrientation:toInterfaceOrientation animated:NO];
}

// Master view interactions

- (void)hideMaster:(BOOL)animated {
    
    if (_masterShown) {
    
        _masterShown = NO;
        
        CGRect masterFrame = _masterViewController.view.frame;
        masterFrame.origin = CGPointMake(-masterFrame.size.width, 0);
        
        CGRect newDetailFrame = self.view.bounds;
        
        // Define operations for animations
        void(^mainBlock)() = ^{
            _masterViewController.view.frame = masterFrame;
            _detailViewController.view.frame = newDetailFrame;
        };
        
        void(^completionBlock)(BOOL) = ^(BOOL finished) {
            [_masterViewController.view removeFromSuperview];
        };
        
        if (animated) {
            [UIView animateWithDuration:0.5 animations:mainBlock completion:completionBlock];
        } else {
            mainBlock();
            completionBlock(YES);
        }
    }
    
    // Master was hidden, make sure that the delegate has received the suitable bar button item.
    if (!_popoverBarButtonItem) {
        _popoverBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(showPopover:)];
        _popoverBarButtonItem.title = @"Master";
        
        [self.delegate bestSplitViewController:self willHideViewController:_masterViewController withBarButtonItem:_popoverBarButtonItem forPopoverController:nil];
    }
}

- (void)showMaster:(BOOL)animated {

    if (!_masterShown) {
        
        _masterShown = YES;
        
        int masterWidth = 320;
        CGRect viewBounds = self.view.bounds;
        CGRect offscreenFrame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
        
        _masterViewController.view.frame = offscreenFrame;
        [self.view addSubview:_masterViewController.view];
        
        CGRect finalFrame = offscreenFrame;
        finalFrame.origin = CGPointMake(0.0, 0.0);
        
        
        // Define operations for animations
        void(^mainBlock)() = ^{
            _masterViewController.view.frame = finalFrame;
        };
        
        void(^completionBlock)(BOOL finished) = ^(BOOL finished) {
            [self layoutViews];
            
        };
        
        if (animated) {
            [UIView animateWithDuration:0.5 animations:mainBlock completion:completionBlock];
        } else {
            mainBlock();
            completionBlock(YES);
        }
    }
}

// Master and Detail VC accessors
- (UIViewController *)masterViewController {
    return _masterViewController;
}

- (void)setMasterViewController:(UIViewController *)masterViewController {
    
    // Remove old view controller
    UIViewController *oldViewController = _masterViewController;
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    
    // Add new one
    _masterViewController = masterViewController;
    
    [masterViewController willMoveToParentViewController:self];
    [self addChildViewController:masterViewController];
    [masterViewController didMoveToParentViewController:self];
    
    masterViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    
    // Layout
    if (self.isViewLoaded) {
        [self layoutViewsAtStart];
    }
}

- (UIViewController *)detailViewController {
    return _detailViewController;
}

- (void)setDetailViewController:(UIViewController *)detailViewController {
    // Remove old view controller
    UIViewController *oldViewController = _detailViewController;
    [oldViewController willMoveToParentViewController:nil];
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    
    // Add new one
    _detailViewController = detailViewController;
    
    [detailViewController willMoveToParentViewController:self];
    [self addChildViewController:detailViewController];
    [detailViewController didMoveToParentViewController:self];
    
    detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // Layout
    if (self.isViewLoaded) {
        [self layoutViewsAtStart];
    }
}

- (void)setDefaultMasterVisibility {
    
}

// --- Temporary methods

- (void)hideMasterButtonTapped:(UIButton *)sender {
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (_masterShown) {
        [self hideMaster:YES];
        
        if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
            _showsMasterInPortrait = NO;
        } else {
            _showsMasterInLandscape = NO;
        }
    } else {
        [self showMaster:YES];
        
        if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
            _showsMasterInPortrait = YES;
        } else {
            _showsMasterInLandscape = YES;
        }
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [_masterViewController willMoveToParentViewController:self];
    [self addChildViewController:_masterViewController];
    [_masterViewController didMoveToParentViewController:self];
    
    _popoverController = nil;
}

- (void)showPopover:(UIBarButtonItem *)sender {
    if (!_masterViewController.view.superview) {

        [_masterViewController willMoveToParentViewController:nil];
        [_masterViewController removeFromParentViewController];
        
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:_masterViewController];
        
        float availableHeight = self.view.bounds.size.height;
        
        popoverController.popoverContentSize = CGSizeMake(320, availableHeight);
        popoverController.delegate = self;
        
        [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        _popoverController = popoverController;
    }
}

- (void)dismissPopover {
    if (_popoverController) {
        [_popoverController dismissPopoverAnimated:NO];
    }
}

@end