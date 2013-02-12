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

#import "BoxShareViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Box/Box.h"

@interface BoxShareViewController () {
    UILabel * __passwordLabel;
    UITextField * __emailField;
    UITextField * __passwordField;
    UITextView * __textView;
    UIScrollView * __scrollView;
    UIView * __contentView;
    BoxObject * __boxObject;
}

@property (nonatomic, retain) IBOutlet UILabel * passwordLabel;
@property (nonatomic, retain) IBOutlet UITextField * emailField;
@property (nonatomic, retain) IBOutlet UITextField * passwordField;
@property (nonatomic, retain) IBOutlet UITextView * textView;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UIView * contentView;

- (void)doneButtonPressed:(id)sender;

@end

@implementation BoxShareViewController

@synthesize passwordField = __passwordField, emailField = __emailField, textView = __textView, passwordLabel = __passwordLabel, scrollView = __scrollView, contentView = __contentView;
@synthesize boxObject = __boxObject;

- (void)doneButtonPressed:(id)sender {
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a publicShare operation.            \\

    [self.boxObject shareWithPassword:self.passwordField.text message:self.textView.text emails:[NSArray arrayWithObject:self.emailField.text] callbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response){
            if (response == BoxCallbackResponseSuccessful) {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"File Shared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alertView show];
            } else {
                [BoxErrorHandler presentErrorAlertViewForResponse:response];
            }
        });
    }];

    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Public Share";
    
    self.scrollView.contentSize = self.contentView.bounds.size;
    [self.scrollView addSubview:self.contentView];
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
	self.textView.layer.borderWidth = 1;
	self.textView.layer.cornerRadius = 8.;
    [self.emailField becomeFirstResponder];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)dealloc {
    [__passwordLabel release];
    __passwordLabel = nil;
    [__emailField release];
    __emailField = nil;
    [__passwordField release];
    __passwordField = nil;
    [__textView release];
    __textView = nil;
    [__scrollView release];
    __scrollView = nil;
    [__contentView release];
    __contentView = nil;
    [__boxObject release];
    __boxObject = nil;
    
    [super dealloc];
}

@end
