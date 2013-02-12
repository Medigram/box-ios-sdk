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

// The BoxFolder objects represent folders that are stored on Box.  It provides access to 
// information about the folder's children (items in the folder).
// Note that this class inherits from BoxObject, which implements many of the more common methods (like name, updateTime, etc.)


#import "BoxObject.h"

@protocol BoxFolder	

// The number of children the folder has - note that this is available before the actual
// children are loaded from the network
@property (readonly) NSUInteger childCount;

// Access the children of the folder - note that this will be nil until the children are
// loaded from the network
// This is an array of BoxObject subclasses (file, folder, or weblink/bookmark).
@property (readonly) NSArray *children;

// Whether or not the folder has collaborators
@property (readonly) BOOL hasCollaborators;

// The total number of files within the folder
@property (readonly) NSUInteger descendentsCount;

// Convenience method used for slideshows of all of the images in a particular folder
// Returns an array of BoxFile object instances that represent image files.
- (NSArray *)imageChildren;

// If the Box SDK is used in database-backed mode, this method loads the metadata for the children of the folder into the in-memory cache.
// It might be useful to call this method to quickly load previously fetched (and potentially stale) metadata for the children,
// immediately prior to calling updateWithCallbacks:inBackground:checkLastSyncDate: which will asynchronously populate both the
// database and cache with the most up to date information. The folder metadata (NSArray of BoxObject subclass instances) is available
// in the @"results" property of the info dictionary in the on.userInfo callback. The children property of BoxFolder is updated and is
// ready to be accessed directly in the on.after callback.
// If the SDK is not in database-backed mode, this method is a no-op,
// however, the callbacks are still called with the metadata contained in the children property.
- (void)childrenWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;


// This method updates the folder metadata both in the database (if the Box SDK is used in database-backed mode) and the in-memory
// cache via a network call. Pass YES for inBackground to put the request in the lowest priority network queue (i.e., the request
// will only be sent if there are no higher priority requests being processed). Pass YES for checkLastSyncDate to only perform
// the update if the server reports that the folder's metadata has changed since it was stored in the database and cache.
// The folder metadata (NSArray of BoxObject subclass instances) is available in the @"results" property of the info dictionary
// in the on.userInfo callback. The children property of BoxFolder is updated and is ready to be accessed directly in the on.after callback.
- (void)updateWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine inBackground:(BOOL)inBackground checkLastSyncDate:(BOOL)checkLastSyncDate;

@end

@interface BoxFolder : BoxObject <BoxFolder>

+ (Class)cacheType;

@end