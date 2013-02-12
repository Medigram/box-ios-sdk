//
// Copyright 2012 Box, Inc.
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

#import "MainViewController.h"
#import "BoxActionTableViewController.h"
#import "Box/Box.h"
#import "AppDelegate.h"


@interface MainViewController () {
    UILabel * __loginLabel;
}

@property (nonatomic, retain) IBOutlet UILabel * loginLabel;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (void)logoutPressed:(id)sender;

@end

@implementation MainViewController

@synthesize loginLabel = __loginLabel;

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(boxUserDidLogin:)
                                                 name:BOX_USER_DID_LOGIN_NOTIFICATION_NAME
                                               object:nil];
    UIBarButtonItem * logoutButton = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutPressed:)] autorelease];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    if ([[Box boxAPIKey] length] == 0) {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Currently the API key is not set so the SDK will not work. Go to the app delegate to update the API key." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshAuthenticationStatus];
}

- (void)refreshAuthenticationStatus
{
    BoxCurrentUser *currentUser = [Box user];
    if (currentUser.authToken.length > 0)
    {
        if ([[[Box user] username] length] > 0)
        {
            self.loginLabel.text = [NSString stringWithFormat:@"%@ is currently logged in.", [[Box user] username]];
        }
        else
        {
            [[Box user] updateAccountInformationWithCallbacks:^(id<BoxOperationCallbacks>on)
             {
                 on.before(^
                 {
                     self.loginLabel.text = [NSString stringWithFormat:@"User with ID %@ is currently logged in.", [[Box user] userID]];
                 });
                 on.after(^(BoxCallbackResponse response)
                 {
                     if (response == BoxCallbackResponseSuccessful)
                     {
                         self.loginLabel.text = [NSString stringWithFormat:@"%@ is currently logged in.", [[Box user] username]];
                     }
                 });
             }];
        }
    }
    else
    {
        self.loginLabel.text = @"User not logged in.";
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [__loginLabel release];
    __loginLabel = nil;
    [super dealloc];
}

#pragma mark - Buttons

- (IBAction)loginButtonPressed:(id)sender
{
	[self.navigationController pushViewController:[[BoxLoginViewController alloc] initWithLoginDelegate:self] animated:YES];
//    [Box initiateLoginUsingURLRedirectWithCallbacks:nil];
}


- (IBAction)actionButtonPressed:(id)sender
{
    BoxActionTableViewController * vc = [[BoxActionTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)logoutPressed:(id)sender
{
    [Box logoutWithCallbacks:^(id <BoxOperationCallbacks> on)
     {
         on.after(^(BoxCallbackResponse response)
        {
            [self refreshAuthenticationStatus];
        });
     }];
}

#pragma mark - BoxLoginViewControllerDelegate methods

- (void)loginViewControllerDidLogIn:(BoxLoginViewController *)loginViewController
{
	[self.navigationController popToRootViewControllerAnimated:YES];
	[self refreshAuthenticationStatus];
}

#pragma mark - User Login Notification Handling

- (void)boxUserDidLogin:(NSNotification *)notification
{
    [self refreshAuthenticationStatus];
}

@end
