//
// Copyright 2013 Box, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "BoxLoginViewController.h"


@interface BoxLoginViewController ()

@property (nonatomic, readwrite, retain) UIWebView *webView;

- (void)loadLogin;

@end

@implementation BoxLoginViewController

@synthesize loginDelegate = _loginDelegate;
@synthesize webView = _webView;

- (id)initWithLoginDelegate:(id<BoxLoginViewControllerDelegate>)delegate
{
	self = [super init];

	if (self != nil)
	{
		_loginDelegate = delegate;
		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}

	return self;
}

#pragma mark - View Lifecycle


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (self.webView == nil)
	{
		self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
		self.webView.scalesPageToFit = YES;
		self.webView.delegate = self;
		[self.view addSubview:self.webView];

		[NSThread detachNewThreadSelector:@selector(loadLogin) toTarget:self withObject:nil];
	}
}

- (void)dealloc
{
	_webView.delegate = nil;
    [_webView release];
    _webView = nil;
    _loginDelegate = nil;

    [super dealloc];
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
						  if ([self.loginDelegate respondsToSelector:@selector(loginViewController:didFailLoginWithResponse:)])
						  {
							  [self.loginDelegate loginViewController:self didFailLoginWithResponse:response];
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
	//
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	//
}

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

	if ([[request.URL scheme] isEqualToString:@"boxsamplecustomurl"])
    {
        [Box initializeSessionWithRedirectURL:request.URL callbacks:^(id <BoxOperationCallbacks>on)
         {
             on.after(^(BoxCallbackResponse response)
					  {
						  if (response == BoxCallbackResponseSuccessful)
						  {
							  [self.loginDelegate loginViewControllerDidLogIn:self];
						  }
						  else if ([self.loginDelegate respondsToSelector:@selector(loginViewController:didFailLoginWithResponse:)])
						  {
							  [self.loginDelegate loginViewController:self didFailLoginWithResponse:response];
						  }
					  });
         }];

		return NO;
	}

	return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	//
}


@end
