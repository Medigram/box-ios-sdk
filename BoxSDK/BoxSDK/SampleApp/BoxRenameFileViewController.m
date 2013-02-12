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

#import "BoxRenameFileViewController.h"
#import "Box/Box.h"

@interface BoxRenameFileViewController () {
    BoxObject * __boxObject;
    UITextField * __textField;
}

@property (nonatomic, retain) IBOutlet UITextField * textField;

- (IBAction)submitButtonPressed:(id)sender;

@end

@implementation BoxRenameFileViewController

@synthesize boxObject = __boxObject, textField = __textField;

- (IBAction)submitButtonPressed:(id)sender {
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a rename operation.                 \\
    
    [Box renameItem:self.boxObject toNewName:self.textField.text callbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response){
            if (response == BoxCallbackResponseSuccessful) {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Object renamed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
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
    self.title = @"Rename";
    [self.textField becomeFirstResponder];
}

- (void)dealloc {
    [__boxObject release];
    __boxObject = nil;
    [__textField release];
    __textField = nil;
    
    [super dealloc];
}

@end
