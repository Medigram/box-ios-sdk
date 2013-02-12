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

#import "BoxActionTableViewController.h"
#import "BoxUploadActionViewController.h"
#import "BoxDeleteActionViewController.h"
#import "BoxAddCommentTableViewController.h"
#import "BoxSelectToDeleteTableViewController.h"
#import "BoxCreateFolderViewController.h"
#import "BoxSelectToPubShareViewController.h"
#import "BoxGetUpdatesTableViewController.h"
#import "BoxSelectToRenameTableViewController.h"
#import "BoxSelectToDownloadViewController.h"


typedef enum _BoxActionType {
BoxActionTypeUpload = 0,
BoxActionTypeDownload,
BoxActionTypeDelete,
BoxActionTypeAddComment,
BoxActionTypeGetComment,
BoxActionTypePublicShare,
BoxActionTypeCreateFolder,
BoxActionTypeGetUpdates,
BoxActionTypeRename,
BoxActionTypeNoAction = 100
} BoxActionType;

@interface BoxActionTableViewController()

@property (nonatomic, readwrite, retain) NSArray *actionTypes;

@end

@implementation BoxActionTableViewController

@synthesize actionTypes = __actionTypes;

#pragma mark - View Life Cycle

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Actions";
    self.actionTypes = [NSArray arrayWithObjects:[NSNumber numberWithInt:BoxActionTypeUpload], [NSNumber numberWithInt:BoxActionTypeDownload], [NSNumber numberWithInt:BoxActionTypeDelete], [NSNumber numberWithInt:BoxActionTypeAddComment], [NSNumber numberWithInt:BoxActionTypeGetComment], [NSNumber numberWithInt:BoxActionTypePublicShare], [NSNumber numberWithInt:BoxActionTypeCreateFolder], [NSNumber numberWithInt:BoxActionTypeGetUpdates], [NSNumber numberWithInt:BoxActionTypeRename], nil];
}

- (void)dealloc {
    [__actionTypes release];
    __actionTypes = nil;
    
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actionTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"ActionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
    switch ([[self.actionTypes objectAtIndex:indexPath.row] intValue]) {
        case BoxActionTypeUpload:
            cell.textLabel.text = @"Upload";
            break;
        case BoxActionTypeDownload:
            cell.textLabel.text = @"Download";
            break;
        case BoxActionTypeDelete:
            cell.textLabel.text = @"Delete";
            break;
        case BoxActionTypeAddComment:
            cell.textLabel.text = @"Add Comment";
            break;
        case BoxActionTypeGetComment:
            cell.textLabel.text = @"Get Comments";
            break;
        case BoxActionTypePublicShare:
            cell.textLabel.text = @"Public Share";
            break;
        case BoxActionTypeCreateFolder:
            cell.textLabel.text = @"Create Folder";
            break;
        case BoxActionTypeGetUpdates:
            cell.textLabel.text = @"Get Updates";
            break;
        case BoxActionTypeRename:
            cell.textLabel.text = @"Rename";
            break;    
        default:
            cell.textLabel.text = @"Error in BoxActionTableViewController";
            break;
    }
	
	return cell;
}

//Here every folderID is [BoxID numberWithInt:0] which refers to the root folder
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == BoxActionTypeAddComment) {
		BoxAddCommentTableViewController * addCommentTableViewController = [[BoxAddCommentTableViewController alloc] initWithFolderID:[BoxID numberWithInt:0]];
        [self.navigationController pushViewController:addCommentTableViewController animated:YES];
        [addCommentTableViewController release];
	} else if (indexPath.row == BoxActionTypePublicShare) {
		BoxSelectToPubShareViewController * pubShareController = [[BoxSelectToPubShareViewController alloc] initWithFolderID:[BoxID numberWithInt:0]];
        [self.navigationController pushViewController:pubShareController animated:YES];
        [pubShareController release];
	} else if (indexPath.row == BoxActionTypeGetComment) {
		BoxSelectToDeleteTableViewController * selectToDeleteController = [[BoxSelectToDeleteTableViewController alloc] initWithFolderID:[BoxID numberWithInt:0]];
        [self.navigationController pushViewController:selectToDeleteController animated:YES];
        [selectToDeleteController release];
	} else if (indexPath.row == BoxActionTypeDelete) {
		BoxDeleteActionViewController * deleteActionViewController = [[BoxDeleteActionViewController alloc] initWithFolderID:[BoxID numberWithInt:0]];
        [self.navigationController pushViewController:deleteActionViewController animated:YES];
        [deleteActionViewController release];
	} else if (indexPath.row == BoxActionTypeCreateFolder) {
		BoxCreateFolderViewController * addFolderController = [[BoxCreateFolderViewController alloc] initWithNibName:@"BoxCreateFolderViewController" bundle:nil];
        [self.navigationController pushViewController:addFolderController animated:YES];
        [addFolderController release];
	} else if (indexPath.row == BoxActionTypeGetUpdates) {
		BoxGetUpdatesTableViewController * updatesController = [[BoxGetUpdatesTableViewController alloc] init];
        [self.navigationController pushViewController:updatesController animated:YES];
        [updatesController release];
	} else if (indexPath.row == BoxActionTypeRename) {
		BoxSelectToRenameTableViewController * renameController = [[BoxSelectToRenameTableViewController alloc] initWithFolderID:[BoxID numberWithInt:0]];
        [self.navigationController pushViewController:renameController animated:YES];
        [renameController release];
	} else if (indexPath.row == BoxActionTypeUpload) {
		BoxUploadActionViewController *inputController = [[BoxUploadActionViewController alloc] initWithNibName:@"BoxUploadActionViewController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
        [inputController release];
	} else if (indexPath.row == BoxActionTypeDownload) {
		BoxSelectToDownloadViewController *inputController = [[BoxSelectToDownloadViewController alloc] init];
		[self.navigationController pushViewController:inputController animated:YES];
        [inputController release];
	}
}

@end
