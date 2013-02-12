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

#import "BoxDeleteActionViewController.h"
#import "Box/Box.h"


@interface BoxDeleteActionViewController ()

- (void)deleteBoxObject:(BoxObject*)boxObject;
- (void)deleteButton:(UIButton *)sender;

@end

@implementation BoxDeleteActionViewController

#pragma mark - Delete Method

- (void)deleteBoxObject:(BoxObject*)boxObject {
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a delete operation. Any other code  \\
    // in this class is for handling the table view so it can be ignored.              \\

    [Box deleteItem:boxObject withCallbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
            if (response == BoxCallbackResponseSuccessful) {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Object deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alertView show];
                [self refreshTableViewSource];
            } else {
                [BoxErrorHandler presentErrorAlertViewForResponse:response];
            }
        });
    }];
        
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rootFolder.children count];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Table view delegate

//This code is needed for our tests. You can ignore it.
#if RUN_KIF_TESTS
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    UIButton *deleteButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteButton.frame = CGRectMake(cell.bounds.size.width-40, 0, 40, cell.bounds.size.height);
    [cell addSubview:deleteButton];
    deleteButton.accessibilityLabel = [NSString stringWithFormat:@"Delete button %@", cell.textLabel.text];
    [deleteButton setTitle:[NSString stringWithFormat:@"%d", indexPath.row] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
#endif

- (void)deleteButton:(UIButton *)sender {
    int index = [sender.titleLabel.text intValue];
    [self deleteBoxObject:[self.rootFolder.children objectAtIndex:index]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteBoxObject:[self.rootFolder.children objectAtIndex:indexPath.row]];
    }
}

@end
