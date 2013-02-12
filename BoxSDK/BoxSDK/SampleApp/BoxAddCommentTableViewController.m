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

#import "BoxAddCommentTableViewController.h"
#import "BoxAddCommentsViewController.h"


@interface BoxAddCommentTableViewController ()

@end

@implementation BoxAddCommentTableViewController

#pragma mark - Table view delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    BoxObject *object = [self.rootFolder.children objectAtIndex:indexPath.row];
    if ([object isFile]) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    BoxObject* boxObject = (BoxObject*)[self.rootFolder.children objectAtIndex:indexPath.row];
    BoxAddCommentsViewController * addCommentVC = [[BoxAddCommentsViewController alloc] init];
    addCommentVC.boxObject = boxObject;
    [self.navigationController pushViewController:addCommentVC animated:YES];
    [addCommentVC release];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
