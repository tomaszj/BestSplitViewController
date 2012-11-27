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
    UIView *_masterView;
    UIView *_detailView;
    
    BOOL _masterShown;
}

@end

@implementation BestSplitViewController

- (void)setup {
    _masterShown = YES;
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
    
    _masterView = [[UIView alloc] initWithFrame:CGRectZero];
    _masterView.backgroundColor = [UIColor orangeColor];
    _masterView.autoresizingMask = UIViewAutoresizingFlexibleHeight; 
    
    _detailView = [[UIView alloc] initWithFrame:CGRectZero];
    _detailView.backgroundColor = [UIColor blueColor];
    _detailView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:_masterView];
    [self.view addSubview:_detailView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 161, 100);
    [button addTarget:self action:@selector(hideMasterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.text = @"Hide master";
    button.center = self.view.center;
    
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self layoutViews];
}

- (void)layoutViews {
    
    int masterWidth = 320;
    CGRect viewBounds = self.view.bounds;

    _masterView.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
    
    int detailWidth = viewBounds.size.width - masterWidth - 1;
    _detailView.frame = CGRectMake(masterWidth + 1, 0, detailWidth, viewBounds.size.height);
}

- (void)hideMaster {
    
    if (_masterShown) {
    
        _masterShown = NO;
        
        CGRect masterFrame = _masterView.frame;
        masterFrame.origin = CGPointMake(-masterFrame.size.width, 0);
        
        CGRect newDetailFrame = self.view.bounds;
        
        [UIView animateWithDuration:0.5 animations:^{
            _masterView.frame = masterFrame;
            _detailView.frame = newDetailFrame;
        } completion:^(BOOL finished) {
            [_masterView removeFromSuperview];
        }];
    }
}

- (void)showMaster {

    if (!_masterShown) {
        
        _masterShown = YES;
        
        int masterWidth = 320;
        CGRect viewBounds = self.view.bounds;
        CGRect offscreenFrame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
        
        _masterView.frame = offscreenFrame;
        [self.view addSubview:_masterView];
        
        CGRect finalFrame = offscreenFrame;
        finalFrame.origin = CGPointMake(0.0, 0.0);
        
        [UIView animateWithDuration:0.5 animations:^{
            _masterView.frame = finalFrame;
        } completion:^(BOOL finished) {
            [self layoutViews];
        }];
    }
}

// ---

- (void)hideMasterButtonTapped:(UIButton *)sender {
    if (_masterShown) {
        [self hideMaster];
    } else {
        [self showMaster];
    }
}

@end