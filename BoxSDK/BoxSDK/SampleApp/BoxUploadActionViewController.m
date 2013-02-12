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

#import "BoxUploadActionViewController.h"
#import "Box/Box.h"

typedef enum {
BoxPopupControllerTestButtonImageWithBaseFileAndDate, // Upload an image with a base file name defined and attach a date to the file name
BoxPopupControllerTestButtonTextFileWithBaseFile,	  // Upload a text file with a base file name defined
BoxPopupControllerTestButtonWordDocWithBaseFile,      // Upload a word document with a base file defined 
} FileType;

@interface BoxUploadActionViewController() {
    UIButton * __imageButton;
    UIButton * __rtfButton;
    UIButton * __docButton;
}

@property (nonatomic, retain) IBOutlet UIButton * imageButton;
@property (nonatomic, retain) IBOutlet UIButton * rtfButton;
@property (nonatomic, retain) IBOutlet UIButton * docButton;

-(NSData*)data:(FileType)selection;
-(NSString*)fileExtension:(FileType)selection;
-(NSString*)suggestedFileName:(FileType)selection;

@end

@implementation BoxUploadActionViewController

@synthesize imageButton = __imageButton, rtfButton = __rtfButton, docButton = __docButton;

#pragma mark - Button Methods

-(IBAction)buttonPressed:(id)sender
{
    FileType selection = -1;
	if(sender == self.imageButton) {
		selection = BoxPopupControllerTestButtonImageWithBaseFileAndDate;
	} else if(sender == self.rtfButton) {
		selection = BoxPopupControllerTestButtonTextFileWithBaseFile;
	} else if(sender == self.docButton) {
		selection = BoxPopupControllerTestButtonWordDocWithBaseFile;
    }
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run an upload operation. Any other code \\
    // in this class is for handling the buttons/default values so it can be ignored.  \\
    
    [Box uploadFileWithData:[self data:selection] fileName:[self suggestedFileName:selection] targetFolderID:[BoxID numberWithInt:0] callbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
            if (response == BoxCallbackResponseSuccessful) {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"File uploaded." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alertView show];
            } else {
                [BoxErrorHandler presentErrorAlertViewForResponse:response];
            }
        });
    }];
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Upload";
}

#pragma mark - GetFileInfo Methods

- (NSData*)data:(FileType)selection {
switch (selection) {
    case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
        return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"gif"]];
        break;
    case BoxPopupControllerTestButtonTextFileWithBaseFile:
        return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestTextDocument" ofType:@"rtf"]];
        break;			
    case BoxPopupControllerTestButtonWordDocWithBaseFile:
        return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestWordDocument" ofType:@"docx"]];
        break;
    default:
        return nil;
        break;
    }
}

-(NSString*)fileExtension:(FileType)selection {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return @"gif";
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return @"rtf";
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return @"docx";
			break;
		default:
			return nil;
			break;
	}
}

-(NSString*)suggestedFileName:(FileType)selection {
	switch (selection) {
		case BoxPopupControllerTestButtonImageWithBaseFileAndDate:
			return @"TestImage.gif";
			break;
		case BoxPopupControllerTestButtonTextFileWithBaseFile:
			return @"TestTextDocument.rtf";
			break;			
		case BoxPopupControllerTestButtonWordDocWithBaseFile:
			return @"TestWordDocument.docx";
			break;
		default:
			return nil;
			break;
	}
	
}

#pragma mark - View Life Cycle

- (void)dealloc {
    [__imageButton release];
    __imageButton = nil;
    [__rtfButton release];
    __rtfButton = nil;
    [__docButton release];
    __docButton = nil;
    
    [super dealloc];
}

@end
