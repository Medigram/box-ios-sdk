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

// The BoxCurrentUser class represents a currently logged in application user.  Note that this is different from BoxUser, 
// which can represent an arbitrary BoxUser (for example, the owner of a comment or update).  This class contains not only
// information about the user from Box (like their email, storage quota, etc.), but also local preferences about storing files
// and security

#import "BoxAPIProxy.h"

@class BoxFolder;

extern NSString *BoxAuthTokenKey;
extern NSString *BoxAlertMessageReceivedNotification;

@protocol BoxCurrentUser

// The Box ID of the user
@property (nonatomic, readonly) BoxID *userID;

// The e-mail address of the user
@property (nonatomic, readonly) NSString *username;

// The user's auth token - note that client code should generally not modify this value
@property (nonatomic, readwrite, retain) NSString *authToken;

// Information about the user's Box account (storageQuota, upload size, etc.)
@property (nonatomic, readonly) NSNumber *storageQuota; // Space in the account (in bytes) - this is the total amount, the combination of used space and free space
@property (nonatomic, readonly) NSNumber *storageUsed; // Space used in the account (in bytes)
@property (nonatomic, readonly) NSNumber *maxUploadSize; // The maximum single-file size allowed for this account (in bytes)

@property (nonatomic, readonly) NSDate *lastCheckedUpdates; // when the user last checked their updates

// Whether the app caches the user's recently visited files (defaults to YES).
@property (nonatomic, readwrite, assign) BOOL cacheLocalFiles;
// Prevent the app from downloading any files locally (defaults to NO).
@property (nonatomic, readwrite, assign) BOOL disableDownloads;

// The Box ID of the file that was last sent to another application. This is used for streamlining Open-In round trips.
@property (nonatomic, readwrite, retain) BoxID *lastExportedFileBoxID;

// Calculate the best place (on Box) to place the file based on past user behavior
- (BoxFolder *)defaultUploadLocationForFileURL:(NSURL *)fileURL;
- (void)setLastUploadFolderID:(BoxID *)folderID;

// Send off a network request to get the account information values (max uplaod size, storage quota, etc.)
- (void)updateAccountInformationWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;
  
@end

@interface BoxCurrentUser : BoxAPIProxy <BoxCurrentUser>

+ (Class)cacheType;

@end