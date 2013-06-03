//
//  MGBoxBrowserTableViewController.m
//  medigram
//
//  Created by Yuhao Ding on 3/28/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//

#import "MGBoxBrowserTableViewController.h"
#import "SVProgressHUD.h"

@interface MGBoxBrowserTableViewController ()
- (void)_initialize;
- (void)setNavBarTitle;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MGBoxBrowserTableViewController

@synthesize tableView = _tableView;
@synthesize folderID = _folderID;
@synthesize rootFolder = _rootFolder;

@synthesize browserDelegate = _browserDelegate;

- (id)initWithFolderID:(BoxID *)folderID
{
    self = [super initWithNibName:@"MGBoxBrowserTableViewController_iPhone" bundle:nil];
    if (self) {
        //Custom initialization
        [self _initialize];
        
        self.folderID = folderID;
        self.rootFolder = [Box folderWithID:self.folderID];
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self _initialize];
    }
    return self;
}

- (void)_initialize
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 480);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Loading...";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self refreshTableViewSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavBarTitle
{
    if ([self.rootFolder.boxID intValue] == 0) {
        self.title = @"All Files";
    } else {
        self.title = self.rootFolder.name;
    }
}

- (void)refreshTableViewSource {
    [self.rootFolder updateWithCallbacks:^(id<BoxOperationCallbacks> on) {
        on.after(^(BoxCallbackResponse response) {
            [self setNavBarTitle];
            [self.tableView reloadData];
        });
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.rootFolder.children count];
    return count;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BoxObject* boxObject = (BoxObject*)[self.rootFolder.children objectAtIndex:indexPath.row];
    
    cell.textLabel.text = boxObject.name;
    cell.detailTextLabel.text = boxObject.subtitle;
    
    if ([boxObject isFolder]) {
        cell.imageView.image = [UIImage imageNamed:@"FileType-Folder"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.imageView.image = [UIImage imageNamed:((BoxFile *)boxObject).fileExtension];
        if (cell.imageView.image == nil) {
            BoxFile *file = (BoxFile *)boxObject;
            if (file.fileType == BoxFileTypeImage) {
                cell.imageView.image = [UIImage imageNamed:@"FileType-Photo"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"FileType-Blank"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *BoxBrowserCellIdentifier = @"BoxFolderCell";
    
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:BoxBrowserCellIdentifier];
    if (cell != nil) {
        assert([cell isKindOfClass:[UITableViewCell class]]);
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:BoxBrowserCellIdentifier];
    }
    
    cell.accessibilityLabel = [NSString stringWithFormat:@"Box Browser Table %d:%d", indexPath.section, indexPath.row];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BoxObject * boxObject = ((BoxObject*)[self.rootFolder.children objectAtIndex:indexPath.row]);
    if ([boxObject isFolder]) {
        MGBoxBrowserTableViewController * browserTableViewController = [[[self class] alloc] initWithFolderID:boxObject.boxID];
        browserTableViewController.browserDelegate = self;
        [self.navigationController pushViewController:browserTableViewController animated:YES];
    } else if ([boxObject isFile]) {
        BoxFile *file = (BoxFile *)boxObject;
        if ([file fileType] == BoxFileTypeImage) {
            [SVProgressHUD showWithStatus:@"Importing Image..."];
//            
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.labelText = @"Importing image...";
//            
            [file previewWithCallbacks:^(id<BoxOperationCallbacks> on) {
                on.after(^(BoxCallbackResponse response){
                    if (response == BoxCallbackResponseSuccessful) {
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [SVProgressHUD dismiss];
                        
                        UIImage *image = [UIImage imageWithData:file.fileData];
                        if ([self.browserDelegate respondsToSelector:@selector(boxBrowserTableViewController:selectedAnImage:)]) {
                            [self.browserDelegate boxBrowserTableViewController:self selectedAnImage:image];
                        }
                        
                    } else {
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [BoxErrorHandler presentErrorAlertViewForResponse:response];
                        [SVProgressHUD dismiss];
                    }
                });
            }];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"We currently only support attaching images from Box. Please select an image file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MGBoxBrowserTableVieControllerDelegate
- (void)boxBrowserTableViewController:(MGBoxBrowserTableViewController *)controller selectedAnImage:(UIImage *)image
{
    if ([self.browserDelegate respondsToSelector:@selector(boxBrowserTableViewController:selectedAnImage:)]) {
        [self.browserDelegate boxBrowserTableViewController:self selectedAnImage:image];
    }
}

@end
