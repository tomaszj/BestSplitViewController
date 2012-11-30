//
//  DetailViewController.h
//  BestSplitViewControllerDemo
//
//  Created by Tomasz Janeczko on 27.11.2012.
//  Copyright (c) 2012 Tomasz Janeczko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BestSplitViewController.h"

@interface DetailViewController : UIViewController <BestSplitViewControllerDelegate> {
    
    __weak IBOutlet UIToolbar *toolbar;
}

@end
