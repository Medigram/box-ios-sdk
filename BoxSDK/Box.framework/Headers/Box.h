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

// Public protocols
#import "BoxObserverProtocol.h"
#import "BoxOperationCallbacksProtocol.h"
#import "BoxUpdatableImageProtocol.h"

// Public models
#import "BoxAPIProxy.h"
#import "BoxComment.h"
#import "BoxCurrentUser.h"
#import "BoxFile.h"
#import "BoxFolder.h"
#import "BoxObject.h"
#import "BoxSearchResult.h"
#import "BoxSearchResultsListController.h"
#import "BoxUpdate.h"
#import "BoxUpload.h"
#import "BoxUser.h"
#import "BoxWebLink.h"

// Public Helpers
#import "BoxErrorHandler.h"

// Internal protocols
#import "BoxDataStoreDelegateProtocol.h"
#import "BoxOperationControllerDelegateProtocol.h"
#import "BoxUploadManagerDelegateProtocol.h"

@interface Box : NSObject <BoxDataStoreDelegate, BoxOperationControllerDelegate, BoxUploadManagerDelegate>

#pragma mark - Box Setup and Configuration

// These methods allow you to customize global properties of the app, such as the URL to use for API calls
// and the API key to use.  

// It is required that you set an API Key for your app for the app to run
+ (void)setBoxAPIKey:(NSString *)boxAPIKey;
+ (NSString *)boxAPIKey;

#pragma mark - Creating Box objects

// Returns the currently logged in user
+ (BoxCurrentUser *)user;

// Retrieve Box objects using their IDs
+ (BoxComment *)commentWithID:(BoxID *)commentID;
+ (BoxFile *)fileWithID:(BoxID *)fileID;
+ (BoxFolder *)folderWithID:(BoxID *)folderID;
+ (BoxObject *)objectWithID:(BoxID *)objectID;
+ (BoxUpdate *)updateWithID:(BoxID *)updateID;
+ (BoxUser *)userWithID:(BoxID *)userID;
+ (BoxWebLink *)weblinkWithID:(BoxID *)weblinkID;

#pragma mark - Accessing the root folder ("All Files")

+ (BoxFolder *)rootFolder;
+ (BoxID *)rootFolderID;

#pragma mark - Login and logout
// Steps for authenticating a user with Box:
//      0. Go to your app settings on the Box developer site and make sure that your app has
//      a redirect URL field set to some custom url scheme, e.g. myappsboxlogin://auth_token_received
//      0.5. Go to your Info.plist and make sure that your app registers for being able to open
//      URLs with the custom url scheme you specified in your app settings on the developer site.
//      1. Call [Box initiateWebViewLoginWithCallbacks:callbacks]. This will make an HTTP
//      request to the Box servers to get an authentication ticket. Upon receipt of the ticket,
//		the SDK will construct an authentication page URL will will be returned in on.userInfo (using the
//		dictionary key auth_url). Loading this URL in a web view will guide the user through login, and
//		depending on the kind of account they have, also SSO process.
//		2. Once the user has been authenticated in the web view, it will try to load a URL request
//		with your application's custom URL scheme. This can be intercepted in the web view's delegate.
//		You should then call [Box initializeSessionWithRedirectURL:url callbacks:callbacks], where url
//		is the URL the web view was loading. By the time on.userInfo and on.after of your callbacks get called,
//		the user will have been logged in.


// Alternate process: these steps will cause your app to redirect to Safari for the Box login process.
// This allows for a rhobust system that will support very complex SSO (Single Sign On) enterprise
// identity configurations however Apple may reject App Store submissions of applications that
// redirect to Safari for login. Discussions with Apple about this are ongoing.
//      1. Call [Box initiateLoginUsingURLRedirectWithCallbacks:callbacks]. This will make an HTTP
//      request to the Box servers to get an authentication ticket. Upon receipt of the ticket, the
//      SDK will pass the control to another app (most likely Safari), which will guide the user
//      through login, and depending on the kind of account they have, also SSO process. Please read the
//      method documentation for details on the callbacks you can implement to listen for progress
//      in the login setup process.
//      2. Inside your app delegate's application:openURL:sourceApplication:annotation: implementation,
//      check the passed in URL for your custom URL scheme, and if it matches call
//      [Box initializeSessionWithRedirectURL:url callbacks:callbacks], where url is the URL
//      your app was asked to open. By the time on.userInfo and on.after of your callbacks get called,
//      the user will have been logged in.

// If there is already a user logged in, this method is a no-op. Passed-in callbacks will not be called.
// You can use an in-app web view for login. This method begins the login process. Your callbacks' on.before
// will be called immediately before the authentication ticket retrieval is attempted. The callbacks'
// on.after will be called upon success or failure of the HTTP call that retrieves the authentication ticket.
// The response argument will be set accordingly. If the authentication ticket retrieval is a success,
// on.userInfo will be called with the authentication page URL in the info dictionary's auth_url key.
// Loading that URL in a web view will take the user through Box login crendentials entry and authentication.
// Once the webview completes the login process, it will redirect to the application's specified redirect URL.
// That URL request can be intercepted and the URL should be used to call
// [Box initializeSessionWithRedirectURL:url callbacks:callbacks].
+ (void)initiateWebViewLoginWithCallbacks:(BoxOperationCallbacksDefine)callbacks;

// If there is already a user logged in, this method is a no-op. Passed-in callbacks will not be called.
// Otherwise, this begins the login process. Your callbacks' on.before will be called immediately before
// the authentication ticket retrieval is attempted. The callbacks' on.after will be called upon success
// or failure of the HTTP call that retrieves the authentication ticket. The response argument will be set
// accordingly. If the authentication ticket retrieval is a success, the user will be taken to another app
// (most likely) Safari for login credentials entry.
+ (void)initiateLoginUsingURLRedirectWithCallbacks:(BoxOperationCallbacksDefine)callbacks;

// If there is already a user logged in, this method is a no-op. Passed in callbacks will not be called in that case.
// Otherwise, this method initializes the authenticating user's session. You can expect your callbacks' on.before to be called
// immediately before initialization. on.after will be called upon success or failure of the operation. The response
// argument will be set accordingly.
+ (void)initializeSessionWithRedirectURL:(NSURL *)url callbacks:(BoxOperationCallbacksDefine)callbacks;

// You can also use the Box web APIs detailed at http://developers.box.com to implement your own user login.
// If you choose to do that, please call initializeSessionWithAuthToken:callbacks: with the auth token you
// obtain during login to take advantage of the library after authentication.

// If there is already a user logged in, this method is a no-op. No callbacks will be called in that case.
// Otherwise, this method initializes the authenticating user's session. You can expect your callbacks' on.before to
// be called immediately before initialization. on.after will be called upon success or failure of the operation.
// The response argument will be set accordingly.
+ (void)initializeSessionWithAuthToken:(NSString *)authToken callbacks:(BoxOperationCallbacksDefine)callbacks;

+ (void)logoutWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;
+ (BOOL)isLoggedIn;

#pragma mark - Updates

// Request a new set of updates from the server
+ (void)requestUpdatesWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// Grab all the locally cached updates
+ (void)requestAllCachedUpdatesWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// No more than maxNumberOfUpdates will be returned, and updates older than maxAgeOfUpdates
// will not be returned. cleanOldUpdates will remove updates beyond these limits from the database
// and should typically be done at application launch. This cleanup is not necessary if the app
// is not database backed.
+ (void)setMaximumNumberOfUpdates:(NSUInteger)maxNumberOfUpdates;
+ (void)setMaximumAgeOfUpdates:(NSTimeInterval)maxAgeOfUpdates;
+ (void)cleanOldUpdates;

#pragma mark - Upload

// Perform uploads with file data, local path, or reference URL
+ (void)uploadFileWithData:(NSData *)data fileName:(NSString *)fileName targetFolderID:(BoxID *)targetFolderID callbacks:(BoxOperationCallbacksDefine)callbacksDefine;
+ (void)uploadFileWithPath:(NSString *)path fileName:(NSString *)fileName targetFolderID:(BoxID *)targetFolderID callbacks:(BoxOperationCallbacksDefine)callbacksDefine;
+ (void)uploadFileWithReferenceURL:(NSURL *)referenceURL fileName:(NSString *)fileName targetFolderID:(BoxID *)targetFolderID callbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// Cancel uploads
+ (void)cancelUpload:(BoxUpload *)upload;
+ (void)cancelUploadWithID:(UploadID *)identifier;

// Query information about the current state of uploads
+ (NSUInteger)numberOfActiveUploads; // Number of uploads that are either ongoing or pending.
+ (NSUInteger)numberOfAllCurrentUploads; // Total umber of uploads in current batch (either pending, ongoing, completed, or failed). A batch is the same as long as it has any ongoing or pending uploads. As soon as all uploads either completed or failed, the batch is finished and any upcoming uploads will belong to a new batch.
+ (NSUInteger)currentSizeUploaded; // Size (in bytes) of completed and failed uploads, as well as the number of bytes uploaded from the current active upload (so not including any pending uploads).
+ (NSUInteger)totalSizeOfAllCurrentUploads; // Size (in bytes) of all of the files that uploaded, failed, or are pending upload in the current batch.
+ (NSArray *)uploadErrors; // Array of all the BoxUpload objects that are in the failed/error state
+ (BoxUpload *)uploadForUploadID:(UploadID *)identifier; // Get a BoxUpload object by it's upload ID
+ (void)removeFailedUploadWithID:(UploadID *)identifier; // Used for clearing failed uploads

#pragma mark - Create, rename, delete
+ (void)createFolderWithName:(NSString *)name parentFolderID:(BoxID *)parentID share:(BOOL)shouldShare callbacks:(BoxOperationCallbacksDefine)callbacksDefine;
+ (void)renameItem:(BoxObject *)item toNewName:(NSString *)newName callbacks:(BoxOperationCallbacksDefine)callbacksDefine;
+ (void)deleteItem:(BoxObject *)item withCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

#pragma mark - Comments

// Note that adding and accessing comments can be done directly off the BoxObject
+ (void)deleteComment:(BoxComment *)comment withCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

#pragma mark - Add files to my box account

// These methods copy files (specified by ID or shared name) into the current user's Box account
+ (void)addFileToMyBoxWithID:(BoxID *)fileID targetFolderID:(BoxID *)targetFolderID callbacks:(BoxOperationCallbacksDefine)callbacksDefine;
+ (void)addFileToMyBoxWithPublicName:(NSString *)publicName targetFolderID:(BoxID *)targetFolderID callbacks:(BoxOperationCallbacksDefine)callbacksDefine;

#pragma mark - Search

+ (void)searchWithQuery:(NSString *)queryString callbacks:(BoxOperationCallbacksDefine)callbacksDefine;

#pragma mark - Download

// Query information about the current state of downloads
+ (BOOL)isDownloading; // Boolean indicating whether there are downloads currently pending or in-progress
+ (NSUInteger)bytesDownloadedForAllCurrentDownloads; // Number of bytes actually downloaded for the currently pending and in-progress downloads
+ (NSUInteger)expectedBytesForAllCurrentDownloads; // Total number of bytes for the currently pending and in-progress downloads
// Note that bytes downloaded and expectedBytes are both cleared when the number of pending and in-progress downloads goes down to 0.

#pragma mark - Observing box objects

// Registering as an observer allows your controller class to be notified when changes to the box objects take place (typically due
// to network operations refreshing the item).  In general, it is better to use observing than rely on the operation callbacks to display
// the state of objects, as by observing you will receive notifications when the object has changed, even if you did not initiate
// the update.

// Note - currently observers are retained, which means observing classes should not remove themselves as observers in their dealloc methods
// or they will never be released.

// Register to be alerted when a cache value is changed for the corresponding item.
// By default, registering as an observer for an item sends a network request to update it, to avoid that behavior
// pass NO for forceUpdate
+ (void)registerObserver:(id<BoxObserver>)observer forItem:(BoxID *)itemID;
+ (void)registerObserver:(id<BoxObserver>)observer forItem:(BoxID *)itemID forceUpdate:(BOOL)forceUpdate;
+ (void)removeObserver:(id<BoxObserver>)observer forItem:(BoxID *)itemID;
+ (void)removeObserverForAllItems:(id<BoxObserver>)observer;
+ (void)performSelector:(SEL)sel onObserversOfItem:(BoxID *)itemID withObject:(id)object;

// Register to be alerted when the updates list changes.
+ (void)registerObserverForUpdates:(id<BoxObserver>)observer;
+ (void)removeObserverForUpdates:(id<BoxObserver>)observer;

// Register to be alerted when the user performs global actions (like login and logout).
+ (void)registerObserverForActions:(id<BoxObserver>)observer;
+ (void)removeObserverForActions:(id<BoxObserver>)observer;

// Register to be alerted when an item's download status has changed.
+ (void)registerObserverForDownloadQueue:(id<BoxObserver>)observer;
+ (void)removeObserverForDownloadQueue:(id<BoxObserver>)observer;

// Register to be alerted when an item's upload status has changed.
+ (void)registerObserverForUploadQueue:(id<BoxObserver>)observer;
+ (void)removeObserverForUploadQueue:(id<BoxObserver>)observer;

// Register to be alerted when the user favorites (stores) or unfavorites (unstores) an item.
+ (void)registerObserverForFavorites:(id<BoxObserver>)observer;
+ (void)removeObserverForFavorites:(id<BoxObserver>)observer;

#pragma mark - Local file handling

// Allow the app to locally cache files it downloads. The default value is YES.
+ (void)setCacheLocalFiles:(BOOL)cacheFiles;
+ (BOOL)cacheLocalFiles;

// List of files that the user has "stored" - these will be stored locally until explicitly deleted.
+ (NSArray *)storedFiles; 

// List of files that are cached locally for performance reasons, but will be deleted on app termination
// or low space conditions.
+ (NSArray *)tempFiles;

// Deletes all temporary files.
+ (void)clearTempFiles;

// Deletes all locally cached file thumbnails.
+ (void)clearThumbnails;

// Delete all "stored" (favorited) files.
+ (void)clearStoredFiles;

// Deletes all locally stored files and unfavorites all favorited files.
+ (void)clearLocalFilesAndRemoveFavorites;

// Set how large (in bytes) the temp cache size can grow before files are deleted. The default value is 50 MB.
+ (void)setMaximumTempFilesSize:(NSUInteger)size;

// Get the amount of space (in bytes) taken up by the temp cache.
+ (NSUInteger)currentTempFilesSize;

// Get the amount of space (in bytes) taken up by the stored/favorited files.
+ (NSUInteger)currentSavedFilesSize;

// Get the amount of space (in bytes) taken up by the cached thumbnails.
+ (NSUInteger)currentCachedImagesSize;

@end


