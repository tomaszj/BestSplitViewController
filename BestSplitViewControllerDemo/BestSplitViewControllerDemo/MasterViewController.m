//
//  MasterViewController.m
//  BestSplitViewControllerDemo
//
//  Created by Tomasz Janeczko on 27.11.2012.
//  Copyright (c) 2012 Tomasz Janeczko. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "BestSplitViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Master";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *fullScreenButton = [[UIBarButtonItem alloc] initWithTitle:@"Full screen" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToFullScreen)];
    
    self.navigationItem.rightBarButtonItem = fullScreenButton;
}

- (void)switchToFullScreen {
    [self switchToFullScreen:YES];
}

- (void)switchFromFullScreen {
    [self switchToFullScreen:NO];
}

- (void)switchToFullScreen:(BOOL)isFullScreen {
    UIBarButtonItem *fullScreenButton;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BestSplitViewController *splitVC = appDelegate.splitViewController;
    
    [splitVC setDisplayMasterViewInFullScreenMode:isFullScreen];
    
    if (isFullScreen) {
        fullScreenButton = [[UIBarButtonItem alloc] initWithTitle:@"Switch Back" style:UIBarButtonItemStyleBordered target:self action:@selector(switchFromFullScreen)];
    } else {
        fullScreenButton = [[UIBarButtonItem alloc] initWithTitle:@"Full screen" style:UIBarButtonItemStyleBordered target:self  action:@selector(switchToFullScreen)];
    }
    
    [self.navigationItem setRightBarButtonItem:fullScreenButton animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
