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

#import <UIKit/UIKit.h>
#import <Box/Box.h>

@protocol BoxLoginViewControllerDelegate;

@interface BoxLoginViewController : UIViewController <UIWebViewDelegate>
{
	UIWebView *_webView;
	id<BoxLoginViewControllerDelegate> _loginDelegate;
}

@property (nonatomic, assign) id<BoxLoginViewControllerDelegate> loginDelegate;

- (id)initWithLoginDelegate:(id<BoxLoginViewControllerDelegate>)delegate;

@end



@protocol BoxLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogIn:(BoxLoginViewController *)loginViewController;

@optional
- (BOOL)loginViewController:(BoxLoginViewController *)loginViewController didFailLoginWithResponse:(BoxCallbackResponse)response;

@end

