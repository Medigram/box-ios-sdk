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

// BoxObject is the base class for BoxFile, BoxFolder, and BoxWebLink. It provides
// access to item metadata. You should instantiate BoxObject's subclasses,
// rather than BoxObject itself.

#import "BoxAPIProxy.h"
#import "BoxUpdatableImageProtocol.h"
#import "BoxConstants.h"

@class BoxUser;
@class BoxFolder;
@class BoxUpdate;

@protocol BoxObject

# pragma mark - Object Type

// Whether the object is a folder
@property (readonly) BOOL isFolder;

// Whether the object is a file
@property (readonly) BOOL isFile;

// Whether the object is a web-link/bookmark
@property (readonly) BOOL isWebLink;

// Enum value for the type of the object
@property (readonly) BoxObjectType type;

#pragma mark - Basic Object Information

// Object name (including the extension for files)
@property (assign) NSString *name;

// The parent folder of the object
@property (readonly) BoxFolder *parent;

// The size (in bytes) of the object.  If this is a file, it will return the file size.  If it is a
// folder, it will return the total size of all items within the folder (at all levels, recursively).
@property (readonly) NSNumber *size;

// A string version of the last modified time (for example: "Updated Feb 12, 2012"). The date
// formatting is localized.
@property (readonly) NSString *lastModifiedString;

// A subtitle for the item (typically the size, number of items for folder, and last modified string)
@property (readonly) NSString *subtitle;

// An even longer description than the subtitle for the item
@property (readonly) NSString *extendedDescription;

// The SHA1 of the version of the item on the Box servers, as opposed to localSha1 property of
// BoxFile which is the SHA1 of the version of the file that is local.
@property (readonly) NSString *sha1;

// The date and time that the object was created on Box (on the servers)
@property (readonly) NSDate *creationTime;

// The date and time that the object was last modified on Box (on the servers), this includes new versions
// being uploaded, name changes, etc.
@property (readonly) NSDate *updatedDate;

// A pointer to the Box Update (single Updates entry) that was last applied to this object.  Note that
// this will be nil unless updates have been loaded from the network
@property (readonly) BoxUpdate *lastUpdate;

// Object representation of whether an object has collaborators or not - should not be used directly.
// Note: This does not represent the number of collaborators.
@property (readonly) NSNumber *hasCollaboratorsObject;

# pragma mark - Local Object Information

// Whether the object is marked to be permenantly stored locally (saved for offline access)
@property (readonly, getter = isStored) BOOL stored;

// A string describing the local storage state of the object (i.e., whether it is up to date, when it was last downloaded)
// For example: "Downloaded Feb 23, 2012 | 5.2 MB". The date is localized.
@property (readonly) NSString *storeDescription;

// Whether the downloaded file is the same as the file that is on Box (for folders this is recursive on their children).
@property (readonly) BOOL downloadIsOutOfDate;

// Whether the object is in the process of downloading. For folders, this means that any sub item of the folder is downloading,
// if the subitem download was triggered as part of the folder download.
@property (readonly, getter = isDownloading) BOOL downloading;

// Whether the object's current state is pending download. For folder downloads, this means that no subitem has begun downloading.
@property (readonly, getter = isWaitingForDownload) BOOL waitingForDownload;

// The number of bytes downloaded in the current download operation for the item.  For folders, this sums
// all subitems of the folder (at all levels).
@property (readonly) NSUInteger bytesDownloaded;

// The most recent date and time on which the item was downloaded.
@property (readonly) NSDate *lastDownloadDate;

// This is similar to "downloadIsOutOfDate", except that it
// does not check if the file actually exists locally, which
// can be an expensive operation.  Instead, it only checks
// the sha1 that was recorded when the file was downloaded.
@property (readonly) BOOL localFileNetworkFileMismatch;

// Whether the object is marked as a favorite. Favorites are used to mark "bookmarks" for the user. In general, all favorited items
// should be stored, but not all stored objects are favorites.
@property (readonly, getter = isFavorite) BOOL favorite;

// Returns true if any of the item's ancestors are favorited.
@property (readonly) BOOL hasFavoritedAncestor;

// The date and time that the object was last fetched from Box (servers), metadata and all.
// This can be useful for preventing unnecessary network operations and processing.
@property (readonly) NSDate *lastSyncDate;

#pragma mark - Detailed Object Information

// Information about the owner of the item. Note that this property may be nil until updateWithCallbacks: is called
// to get updated info about the item from Box (servers). The property is ready to be accessed by the time the
// on.after callback of updateWithCallbacks: is called.
@property (readonly) BoxUser *owner;

// String version of the permissions of the item (download, comment, delete rights, etc).
// For example, the permission string @"densuv" means downloading, deleting, renaming,
// sharing, uploading and viewing are allowed.
// For additional details see the Box API documentation for API Object permissions information.
@property (readonly) NSString *permissions;

// Information about the shared state of the item
@property (readonly, getter = isShared) BOOL shared;
@property (readonly) NSString *sharedLink;

// Information about the comments associated with the item
// Note that commentCount is set (and can be used) before the comments array is pulled from the network.
@property (readonly) NSArray *comments;
@property (readonly) NSUInteger commentCount;

// All updates associated with the item.  Note that this will only apply to updates that have
// already been pulled from the network, it will not fetch new updates.
@property (readonly) NSArray *updates;

#pragma mark - Thumbnail Information

// Access the various sized thumbnails.  Note that these calls do not hit the network - they only query the in-memory cache.
// In general, you should use the load<x>Thumbnail methods below, as they will handle pulling from the network
// and updating the image view when the thumbnail becomes available
@property (readonly) BoxImage *smallThumbnail;
@property (readonly) BoxImage *largeThumbnail;
@property (readonly) BoxImage *largerThumbnail;
@property (readonly) BoxImage *previewThumbnail;

// These methods are used to simplify thumbnail management.  Calling them can have three effects:
// (1) The thumbnail is already cached in memory, in which case the image is written immediately to the specified object
// (2) The thumbnail is not in memory, but is cached on disk or in the bundle, in which case the image
//     is promoted to in memory cache and then loaded into the specified object
// (3) The thumbnail is not available locally, in which case the thumbnail is downloaded to disk, promoted to in memory
//     cache, and then loaded into the specified object
- (void)loadSmallThumbnailIntoUpdatableImage:(id<BoxUpdatableImage>)updatableImage;
- (void)loadLargeThumbnailIntoUpdatableImage:(id<BoxUpdatableImage>)updatableImage;
- (void)loadLargerThumbnailIntoUpdatableImage:(id<BoxUpdatableImage>)updatableImage;
- (void)loadPreviewThumbnailIntoUpdatableImage:(id<BoxUpdatableImage>)updatableImage;

#pragma mark - General helper methods

// This method returns an array of BoxFolder objects starting at index 0 with All Files, and proceeding
// down the tree until the current item is reached, not including the item itself (unless it is a folder).  
// For example, if object A is inside folder B, which is inside folder C, which is inside All Files,
// the array will be All Files, C, B if A is not a folder, and All Files, C, B, A if A is a folder.
// Note that this information is not always known (for example, if the item has only been accessed via search
// or update), so if the parent chain to all files cannot be found, nil is return.  All files will return
// an empty array, to distinguish from nil.
@property (readonly) NSArray *pathArray;

// This returns the result of calling pathArray and then appending the name of each folder to the result.
// In the first example from above, the return value is @"All Files/C/B"
@property (readonly) NSString *pathStringByName;

// This method is similar to pathStringByName, except folder IDs are used instead of folder names.
@property (readonly) NSString *pathStringByID;

// List the file path in a human readable string like "All Files > Folder A > Folder B > File".  maxLength sets the maximum number of characters
// before "..." will be used in the middle of the string, and customBaseLabel lets you set the first part of the string so that it says something
// other than "All Files"
- (NSString *)breadcrumbLabelAppendingFileName:(BOOL)appendFileName withMaxLength:(NSUInteger)maxLength;
- (NSString *)breadcrumbLabelAppendingFileName:(BOOL)appendFileName withMaxLength:(NSUInteger)maxLength customBaseLabel:(NSString *)customBase;

# pragma mark - Manipulating local files

// Store the object locally (for offline access).  For folders, this means download and store the folder's entire contents.
// For files, this means download and store the file.  For weblinks/bookmarks this is a no-op.
// Note - this method is smart enough to not download an already downloaded object.
- (void)storeWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// Unstore the object.  This will mark the object as no longer stored (and for folders every object below it),
// and will delete the file from the local cache.
- (void)unstoreWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// Deprecated - included only for backwards compatibility
- (void)unstore:(BOOL)unstore;

- (void)favoriteWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;
- (void)unfavoriteWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

# pragma mark - Updating from the network

// This will synchronize the object metadata with Box.  Note that for folders, this is not recursive, and will
// only sync the folder itself, not the folder's children.
- (void)updateWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// This is similar to updateWithCallbacks, except that instead of only doing the top level,
// all children of a folder are recursively updated as well.  For files and weblinks, this is
// equivalent to updating, but for folders this can be quite a bit more expensive.
// Note that this is always performed in the lowest priority queue.
- (void)synchronizeWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// This is used to request a folder update in the background, which will give it lower priority.
// It is useful when performing multiple requests that do not need to happen immediately.
- (void)updateWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine inBackground:(BOOL)inBackground;

#pragma mark - Comments

// NOTE - COMMENTS ARE NOT SUPPORTED ON FOLDERS.  DO NOT ATTEMPT TO ADD OR RETRIEVE COMMENTS ON FOLDERS
// USING THESE METHODS

// This will synchronize an object's comments with Box.
- (void)updateCommentsWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// This method invalides the comments cache and request the comments be updated from the server.  Ideally, comments would update
// automatically as necessary.  However, because the server does not provide an indication that comments have changed without
// reloading the comments, this can be done manually.
- (void)refreshComments;

// Add a comment to the current item
- (void)addComment:(NSString *)message withCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

#pragma mark - Sharing

// Send an email to the supplied email addresses containing a link to this file
- (void)shareWithPassword:(NSString *)password message:(NSString *)message emails:(NSArray *)emails callbacks:(BoxOperationCallbacksDefine)callbacksDefine;


@end

@interface BoxObject : BoxAPIProxy <BoxObject>

+ (Class)cacheType;

@end
