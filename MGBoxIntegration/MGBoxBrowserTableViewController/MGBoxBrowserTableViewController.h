//
//  MGBoxBrowserTableViewController.h
//  medigram
//
//  Created by Yuhao Ding on 3/28/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//
#import <Box/Box.h>
#import <UIKit/UIKit.h>

@class MGBoxBrowserTableViewController;

@protocol MGBoxBrowserTableViewControllerDelegate <NSObject>
- (void)boxBrowserTableViewController:(MGBoxBrowserTableViewController *)controller selectedAnImage:(UIImage *)image;
@end

@interface MGBoxBrowserTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MGBoxBrowserTableViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BoxID *folderID;
@property (nonatomic, strong) BoxFolder *rootFolder;
@property (nonatomic, weak) id <MGBoxBrowserTableViewControllerDelegate> browserDelegate;

- (id)initWithFolderID:(BoxID *)folderID;
- (void)refreshTableViewSource;

@end
