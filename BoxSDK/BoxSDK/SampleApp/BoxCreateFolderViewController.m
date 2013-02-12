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

#import "BoxCreateFolderViewController.h"
#import "Box/Box.h"


@interface BoxCreateFolderViewController () {
    UITextField * __textView;
    BoxObject * __boxObject;
}

@property (nonatomic, retain) IBOutlet UITextField * textView;

@end

@implementation BoxCreateFolderViewController

@synthesize textView = __textView, boxObject = __boxObject;

- (IBAction)goButtonPressed:(id)sender {
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run an add comment operation.           \\
    
    [Box createFolderWithName:self.textView.text parentFolderID:[BoxID numberWithInt:0] share:NO callbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
            if (response == BoxCallbackResponseSuccessful) {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Folder created." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alertView show];
            } else {
                [BoxErrorHandler presentErrorAlertViewForResponse:response];
            }
        });
    }];
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Folder";
    [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [__boxObject release];
    __boxObject = nil;
    [__textView release];
    __textView = nil;
    [super dealloc];
}

@end