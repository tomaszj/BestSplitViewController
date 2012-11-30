//
//  DetailViewController.m
//  BestSplitViewControllerDemo
//
//  Created by Tomasz Janeczko on 27.11.2012.
//  Copyright (c) 2012 Tomasz Janeczko. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "BestSplitViewController.h"

@interface DetailViewController () {
    __weak IBOutlet UIBarButtonItem *toggleMasterBarButton;
}

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BestSplitViewController *splitVC = appDelegate.splitViewController;
    
    if ([splitVC isShowingTheMasterViewInLeftSplit]) {
        toggleMasterBarButton.title = @"Hide Master";
    } else {
        toggleMasterBarButton.title = @"Show Master";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleMaster:(id)sender {
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BestSplitViewController *splitVC = appDelegate.splitViewController;

    if ([splitVC isShowingTheMasterViewInLeftSplit]) {
        toggleMasterBarButton.title = @"Show Master";
    } else {
        toggleMasterBarButton.title = @"Hide Master";
    }
    
    [splitVC toggleMasterView];
}

- (void)bestSplitViewController:(BestSplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = @"Master";
    NSArray *items = [[NSArray arrayWithObject:barButtonItem] arrayByAddingObjectsFromArray:toolbar.items];
    [toolbar setItems:items animated:YES];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    BestSplitViewController *splitVC = appDelegate.splitViewController;
    
    if ([splitVC isShowingTheMasterViewInLeftSplit]) {
        toggleMasterBarButton.title = @"Hide Master";
    } else {
        toggleMasterBarButton.title = @"Show Master";
    }
}

- (void)bestSplitViewController:(BestSplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button {
    if ([toolbar.items count] > 1) {
        NSRange range;
        range.location = 1;
        range.length = toolbar.items.count - 1;
        
        [toolbar setItems:[toolbar.items subarrayWithRange:range] animated:YES];
    }
}

@end
