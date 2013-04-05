//
//  MGBoxImagePickerControllerViewController.h
//  medicam
//
//  Created by Yuhao Ding on 4/4/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGBoxBrowserTableViewController.h"

@class MGBoxImagePickerController;

@protocol MGBoxImagePickerControllerDelegate <NSObject>

- (void)boxImagePickerController:(MGBoxImagePickerController *)picker didSelectAnImage:(UIImage *)image;
- (void)boxImagePickerControllerDidCancel:(MGBoxImagePickerController *)picker;

@end

@interface MGBoxImagePickerController : UINavigationController <MGBoxBrowserTableViewControllerDelegate>
@property (nonatomic, assign) id <MGBoxImagePickerControllerDelegate> pickerDelegate;
@property (nonatomic, strong) MGBoxBrowserTableViewController *browserTableViewController;

- (IBAction)cancelButtonPressed:(id)sender;

@end
