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

#import "BoxBrowserTableViewController.h"
#import "Box/Box.h"


@interface BoxBrowserTableViewController () {
    BoxFolder *__rootFolder;
    BoxID *__folderID;
}

@property (nonatomic, readwrite, retain) BoxID * folderID; //overriding readonly properties from .h file
@property (nonatomic, readwrite, retain) BoxFolder * rootFolder;

@end

@implementation BoxBrowserTableViewController

@synthesize folderID = __folderID, rootFolder = __rootFolder;

#pragma mark - View Life Cycle

- (id)initWithFolderID:(BoxID *)folderID {
    self = [super init];
    if (self) {
        self.folderID = folderID;
        self.rootFolder = [Box folderWithID:self.folderID];
    }
    return self;
}

- (id)init {
    return [self initWithFolderID:[BoxID numberWithInt:0]]; //Default value
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Loading...";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTableViewSource];
}

- (void)dealloc {
    [__rootFolder release];
    __rootFolder = nil;
    [__folderID release];
    __folderID = nil;
    
    [super dealloc];
}

#pragma mark - Table view data source

- (void)refreshTableViewSource {
    [self.rootFolder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
            if ([self.rootFolder.boxID intValue] == 0) {
                self.title = @"All Files";
            } else {
                self.title = self.rootFolder.name;
            }
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rootFolder.children count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
    }
    BoxObject* boxObject = (BoxObject*)[self.rootFolder.children objectAtIndex:indexPath.row];
    
    cell.textLabel.text = boxObject.name;
    
    cell.detailTextLabel.text = boxObject.subtitle;
    
    if ([boxObject isFolder]) {
        BoxFolder * folder = (BoxFolder*)boxObject;
        if(folder.hasCollaborators) {
            cell.imageView.image = [UIImage imageNamed:@"boxFolderIconShared"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"boxFolderIcon"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;  
    } else {
        cell.imageView.image = [UIImage imageNamed:((BoxFile *)boxObject).fileExtension];
        if (cell.imageView.image == nil) {
            cell.imageView.image = [UIImage imageNamed:@"generic"];            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessibilityLabel = cell.textLabel.text;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxObject * boxObject = ((BoxObject*)[self.rootFolder.children objectAtIndex:indexPath.row]);
    if ([boxObject isFolder]) {
        BoxBrowserTableViewController * browserTableViewController = [[[[self class] alloc] initWithFolderID:boxObject.boxID] autorelease]; //Using [self class] ensures that if this class is subclassed, it pushes the correct kind of BoxBrowserTableViewController
        [self.navigationController pushViewController:browserTableViewController animated:YES];
    }
}


@end
