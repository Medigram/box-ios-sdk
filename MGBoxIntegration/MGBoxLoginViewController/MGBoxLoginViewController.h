//
//  MGBoxLoginViewController.h
//  medigram
//
//  Created by Yuhao Ding on 3/27/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Box/Box.h>

@class MGBoxLoginViewController;

@protocol MGBoxLoginViewControllerDelegate <NSObject>

- (void)boxLoginViewControllerDidLogIn:(MGBoxLoginViewController *)loginController;

@optional
- (void)boxLoginViewControllerDidCancel:(MGBoxLoginViewController *)loginController;
- (BOOL)boxLoginViewController:(MGBoxLoginViewController *)loginController didFailLoginWithResponse:(BoxCallbackResponse)response;

@end

@interface MGBoxLoginViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, weak) id <MGBoxLoginViewControllerDelegate> loginDelegate;

- (IBAction)cancelButtonPressed:(id)sender;

@end
