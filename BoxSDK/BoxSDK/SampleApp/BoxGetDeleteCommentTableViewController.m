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

#import "BoxGetDeleteCommentTableViewController.h"
#import "Box/Box.h"


@interface BoxGetDeleteCommentTableViewController () {
    NSMutableArray * __comments;
    BoxObject * __boxObject;
}

@property (nonatomic, readwrite, retain) NSMutableArray * comments;

- (void)deleteComment:(BoxComment *)comment;
- (void)deleteButton:(UIButton *)sender;

@end

@implementation BoxGetDeleteCommentTableViewController

@synthesize comments = __comments, boxObject = __boxObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Comments";
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a getComments operation.            \\
    
    [self.boxObject updateCommentsWithCallbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
            if (response == BoxCallbackResponseSuccessful) {
                self.comments = [NSMutableArray arrayWithArray:self.boxObject.comments];
                [self.tableView reloadData];
                if ([self.comments count] == 0) {
                    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"No Comments" message:@"There are no comments to show for this file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [alert show];
                }
            } else {
                [BoxErrorHandler presentErrorAlertViewForResponse:response];
            }

        });
    }];
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\

}

- (void)deleteComment:(BoxComment *)comment {
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to delete a comment.                       \\
    
    [Box deleteComment:comment withCallbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
            if (response == BoxCallbackResponseSuccessful) {
                [self.comments removeObject:comment];
                [self.tableView reloadData];
                if ([self.comments count] == 0) {
                    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"No Comments" message:@"There are no comments to show for this file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [alert show];
                } else {
                    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Comment deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [alert show];
                }
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
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
    }
    
    BoxComment * comment = (BoxComment*)[self.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.message;
    cell.detailTextLabel.text = comment.commenter.username;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //This code is needed for our tests. You can ignore it.
#if RUN_KIF_TESTS
    UIButton *deleteButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    deleteButton.frame = CGRectMake(cell.bounds.size.width-40, 0, 40, cell.bounds.size.height);
    [cell addSubview:deleteButton];
    deleteButton.accessibilityLabel = [NSString stringWithFormat:@"Delete button %@", cell.textLabel.text];
    [deleteButton setTitle:[NSString stringWithFormat:@"%d", indexPath.row] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
#endif

    return cell;
}

- (void)deleteButton:(UIButton *)sender {
    int index = [sender.titleLabel.text intValue];
    [self deleteComment:[self.comments objectAtIndex:index]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteComment:[self.comments objectAtIndex:indexPath.row]];
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    [__boxObject release];
    __boxObject = nil;
    [__comments release];
    __comments = nil;
    
    [super dealloc];
}

@end
