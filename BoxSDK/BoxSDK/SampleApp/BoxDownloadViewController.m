//
//  BoxDownloadViewController.m
//  BoxSDK
//
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

#import "BoxDownloadViewController.h"
#import "Box/Box.h"


@interface BoxDownloadViewController () {
    BoxFile *__boxFile;
    IBOutlet UILabel *__fileDumpLabel;
}

@property (nonatomic, readonly, retain) UILabel *fileDumpLabel;

@end

@implementation BoxDownloadViewController

@synthesize boxFile = __boxFile, fileDumpLabel = __fileDumpLabel;

- (void)downloadFile {
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a download operation.               \\
    
    [self.boxFile previewWithCallbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response){
            if (response == BoxCallbackResponseSuccessful) {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"The files dump is shown on this screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alertView show];
                
                NSString *dataString = [[[NSString alloc] initWithData:self.boxFile.fileData encoding:NSUTF8StringEncoding] autorelease];
                if (dataString == nil) {
                    dataString = [self.boxFile.fileData description];
                }
                self.fileDumpLabel.text = dataString;
                self.fileDumpLabel.accessibilityValue = dataString;
            } else {
                [BoxErrorHandler presentErrorAlertViewForResponse:response];
            }
        });
    }];
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Download";
    [self downloadFile];
}

- (void)dealloc {
    [__boxFile release];
    __boxFile = nil;
    [__fileDumpLabel release];
    __fileDumpLabel = nil;
    [super dealloc];
}


@end
