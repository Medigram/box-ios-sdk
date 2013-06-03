//
//  MGBoxLoginViewController.m
//  medigram
//
//  Created by Yuhao Ding on 3/27/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//
#import "SVProgressHUD.h"
#import "MGBoxLoginViewController.h"
#import "MGBoxManager.h"

@interface MGBoxLoginViewController ()
- (void)_initialize;
- (void)loadLogin;
@end

@implementation MGBoxLoginViewController

@synthesize webView = _webView;
@synthesize loginDelegate = _loginDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.title = @"Sign in to Box";
    
    self.contentSizeForViewInPopover = CGSizeMake(400, 640);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        [self.view addSubview:self.webView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [NSThread detachNewThreadSelector:@selector(loadLogin) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if ([self.loginDelegate respondsToSelector:@selector(boxLoginViewControllerDidCancel:)]) {
        [self.loginDelegate boxLoginViewControllerDidCancel:self];
    }
}

- (void)loadLogin
{
    [Box initiateWebViewLoginWithCallbacks:^(id<BoxOperationCallbacks> on)
     {
         on.before(^
				   {
					   //
				   });
         on.after(^(BoxCallbackResponse response)
				  {
					  // If could not get the ticket and construct the URL for loading the authentication page, report error
					  if (response != BoxCallbackResponseSuccessful)
					  {
						  if ([self.loginDelegate respondsToSelector:@selector(boxLoginViewController:didFailLoginWithResponse:)])
						  {
							  [self.loginDelegate boxLoginViewController:self didFailLoginWithResponse:response];
						  }
					  }
				  });
         on.userInfo(^(NSDictionary *info)
					 {
						 NSURL *authenticationURL = [info objectForKey:@"auth_url"];
						 [self.webView loadRequest:[NSURLRequest requestWithURL:authenticationURL]];
					 });
	 }];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [SVProgressHUD showWithStatus:@"Loading..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	//
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	// Before we proceed with handling this request, check if it's about:blank - if it is, do not attempt to load it.
	// Background: We've run into a scenario where an admin included a support help-desk plugin on their SSO page
	// which would (probably erroneously) first load about:blank, then attempt to load it's component. The web view would
	// fail to load about:blank, which would cause the whole page to not appear. So we realized that we can and should
	// generally protect against loading about:blank.
	if ([request.URL isEqual:[NSURL URLWithString:@"about:blank"]])
	{
		return NO;
	}
    
	if ([[request.URL scheme] isEqualToString:@"medigram"])
    {
        [Box initializeSessionWithRedirectURL:request.URL callbacks:^(id <BoxOperationCallbacks>on)
         {
             on.after(^(BoxCallbackResponse response)
					  {
						  if (response == BoxCallbackResponseSuccessful)
						  {
							  [self.loginDelegate boxLoginViewControllerDidLogIn:self];
                              [[MGBoxManager sharedInstance] updateAccountInformation];
						  }
						  else if ([self.loginDelegate respondsToSelector:@selector(boxLoginViewController:didFailLoginWithResponse:)])
						  {
							  [self.loginDelegate boxLoginViewController:self didFailLoginWithResponse:response];
						  }
					  });
         }];
        
		return NO;
	}
    
	return YES;
}

@end
