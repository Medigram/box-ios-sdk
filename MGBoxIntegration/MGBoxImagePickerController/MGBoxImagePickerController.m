//
//  MGBoxImagePickerControllerViewController.m
//  medicam
//
//  Created by Yuhao Ding on 4/4/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//

#import "MGBoxImagePickerController.h"

@interface MGBoxImagePickerController ()

@end

@implementation MGBoxImagePickerController

- (id)init
{
    self.browserTableViewController = [[MGBoxBrowserTableViewController alloc] initWithFolderID:[NSNumber numberWithInt:0]];
    self.browserTableViewController.browserDelegate = self;
    
    self = [super initWithRootViewController:self.browserTableViewController];
    if (self) {
        
    }
    return self;
    
}

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
	// Do any additional setup after loading the view.
    
    self.contentSizeForViewInPopover = CGSizeMake(320, 480);
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    [self.browserTableViewController.navigationItem setLeftBarButtonItem:barButton];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if ([self.pickerDelegate respondsToSelector:@selector(boxImagePickerControllerDidCancel:)]) {
        [self.pickerDelegate boxImagePickerControllerDidCancel:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)boxBrowserTableViewController:(MGBoxBrowserTableViewController *)controller selectedAnImage:(UIImage *)image
{
    if ([self.pickerDelegate respondsToSelector:@selector(boxImagePickerController:didSelectAnImage:)]) {
        [self.pickerDelegate boxImagePickerController:self didSelectAnImage:image];
    }
}

@end
