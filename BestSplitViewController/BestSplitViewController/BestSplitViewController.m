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
}

@end

@implementation BestSplitViewController

// Setup methods

- (void)setup {
    _masterShown = YES;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    
    UIButton *showPopoverButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showPopoverButton.frame = CGRectMake(400, 0, 161, 100);
    [showPopoverButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    showPopoverButton.titleLabel.text = @"Popover";

    [self.view addSubview:showPopoverButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self layoutViews];
}

// View layouting

- (void)layoutViews {
    
    _masterViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _detailViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    int masterWidth = 320;
    CGRect viewBounds = self.view.bounds;

    _masterViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
    
    int detailWidth = viewBounds.size.width - masterWidth - 1;
    _detailViewController.view.frame = CGRectMake(masterWidth + 1, 0, detailWidth, viewBounds.size.height);
    
    if (!_masterViewController.view.superview) {
        [self.view addSubview:_masterViewController.view];
        [self.view sendSubviewToBack:_masterViewController.view];
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
    
}

// Master view interactions

- (void)hideMaster {
    
    if (_masterShown) {
    
        _masterShown = NO;
        
        CGRect masterFrame = _masterViewController.view.frame;
        masterFrame.origin = CGPointMake(-masterFrame.size.width, 0);
        
        CGRect newDetailFrame = self.view.bounds;
        
        [UIView animateWithDuration:0.5 animations:^{
            _masterViewController.view.frame = masterFrame;
            _detailViewController.view.frame = newDetailFrame;
        } completion:^(BOOL finished) {
            [_masterViewController.view removeFromSuperview];
        }];
    }
}

- (void)showMaster {

    if (!_masterShown) {
        
        _masterShown = YES;
        
        int masterWidth = 320;
        CGRect viewBounds = self.view.bounds;
        CGRect offscreenFrame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
        
        _masterViewController.view.frame = offscreenFrame;
        [self.view addSubview:_masterViewController.view];
        
        CGRect finalFrame = offscreenFrame;
        finalFrame.origin = CGPointMake(0.0, 0.0);
        
        [UIView animateWithDuration:0.5 animations:^{
            _masterViewController.view.frame = finalFrame;
        } completion:^(BOOL finished) {
            [self layoutViews];
        }];
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
    [self layoutViews];
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
    [self layoutViews];

}

// --- Temporary methods

- (void)hideMasterButtonTapped:(UIButton *)sender {
    if (_masterShown) {
        [self hideMaster];
    } else {
        [self showMaster];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [_masterViewController willMoveToParentViewController:self];
    [self addChildViewController:_masterViewController];
    [_masterViewController didMoveToParentViewController:self];
    
    _popoverController = nil;
}

- (void)showPopover:(UIButton *)sender {
    if (!_masterViewController.view.superview) {

        [_masterViewController willMoveToParentViewController:nil];
        [_masterViewController removeFromParentViewController];
        
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:_masterViewController];
        
        float availableHeight = self.view.bounds.size.height - sender.frame.origin.y - sender.frame.size.height - 30;
        
        [popoverController setPopoverContentSize:CGSizeMake(320, availableHeight)];
        popoverController.delegate = self;
        
        [popoverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        _popoverController = popoverController;
    }
}

@end