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

#import "BoxGetUpdatesTableViewController.h"
#import "Box/Box.h"


@interface BoxGetUpdatesTableViewController () {
    NSArray * __updates;
}

@property (nonatomic, retain) NSArray * updates;

- (NSDate *)yesterdaysDate;

@end

@implementation BoxGetUpdatesTableViewController

@synthesize updates = __updates;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Loading...";
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a getUpdates operation              \\

    [Box requestUpdatesWithCallbacks: ^(id<BoxOperationCallbacks> on) {
        on.userInfo(^(NSDictionary *data){
            NSArray *updates = [data objectForKey:@"updates"];
            if (updates) {
                self.title = @"Updates";

                if ([updates count] == 0) {
                    UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Operation was a success, but there are no updates to show for the past 24 hours." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                    [alert show];
                } else {
                    self.updates = updates;
                    [self.tableView reloadData];
                }
            }
        });
        on.after(^(BoxCallbackResponse response){
            if (response != BoxCallbackResponseSuccessful) {
                self.title = @"Error";
                [BoxErrorHandler presentErrorAlertViewForResponse:response];
            }
        });
    }];

    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

- (void)dealloc {
    [__updates release];
    __updates = nil;
    
    [super dealloc];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.updates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BoxUpdate * update = (BoxUpdate*)[self.updates objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ did something", update.userName];
    cell.detailTextLabel.text = @"See BoxUpdate.h for more info that's returned";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //nothing
}

#pragma mark - Private Methods

- (NSDate *)yesterdaysDate {
    return [NSDate dateWithTimeIntervalSinceNow:-3600*24];
}

@end
