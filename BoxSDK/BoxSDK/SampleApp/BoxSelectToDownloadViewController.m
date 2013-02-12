//
//  BoxSelectToDownloadViewController.m
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

#import "BoxSelectToDownloadViewController.h"
#import "BoxDownloadViewController.h"


@interface BoxSelectToDownloadViewController ()

@end

@implementation BoxSelectToDownloadViewController

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    BoxObject *object = [self.rootFolder.children objectAtIndex:indexPath.row];
    if ([object isFile]) {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    BoxFile *boxObject = (BoxFile *)[self.rootFolder.children objectAtIndex:indexPath.row];
    BoxDownloadViewController *downloadVC = [[BoxDownloadViewController alloc] init];
    downloadVC.boxFile = boxObject;
    [self.navigationController pushViewController:downloadVC animated:YES];
    [downloadVC release];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
