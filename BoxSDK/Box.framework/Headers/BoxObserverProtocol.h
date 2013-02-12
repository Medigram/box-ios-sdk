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

#import "BoxOperationCallbacksProtocol.h" // for BoxCallbackResponse 
#import "BoxConstants.h" // For declaration of BoxID

@class BoxCurrentUser;

@protocol BoxObserver <NSObject>

@optional

#pragma mark - Called when you register for actions

// Called anytime a network operation receives an error.
// This can be useful for monitoring for things like revoked auth tokens.
- (void)actionDidReceiveErrorResponse:(BoxCallbackResponse)response;

// Called anytime a user logs in
- (void)userDidLogIn:(BoxCurrentUser *)user;

// Called before the user logs out (i.e., the auth token is still valid)
- (void)userWillLogOut:(BoxCurrentUser *)user;

// Called after the user logs out (i.e., the auth token is no longer valid)
- (void)userDidLogOut:(BoxCurrentUser *)user;

// Called anytime the admin settings change
- (void)userSettingsDidChange:(NSSet *)changedKeys;

#pragma mark - Called when you register to observe a specific item

// Called when the item was unable to be retrieved from the database due to a lock/encryption event.
// If the app is not database-backed, then this can be ignored.
- (void)unableToRetrieveItem:(BoxID *)itemID;

// Called anytime the in memory cache for an object changes values.  The keys are the names of
// the methods that will have changed outputs.
- (void)item:(BoxID *)itemID didUpdateWithKeys:(NSSet *)updatedKeys;

// Called anytime an item starts a network update
- (void)itemDidBeginUpdating:(BoxID *)itemID;

#pragma mark - Called when you register to observe updates

// Called anytime the Updates list changes
- (void)updatesDidUpdate;

#pragma mark - Called when you register to receive download events

// Called anytime an item begins downloading - that is, the download operation moves from pending to active state
- (void)downloadDidBeginForItem:(BoxID *)itemID;

// Called anytime an item download receives data
- (void)downloadDidProgressForItem:(BoxID *)itemID bytesDownloaded:(NSUInteger)bytes;

// Called anytime an item download finishes (even if the download was cancelled by the user or because the
// item has already been downloaded)
- (void)downloadDidCompleteForItem:(BoxID *)itemID withResponse:(BoxCallbackResponse)response;

// Called anytime the download queue goes from non-zero to zero length
- (void)downloadDidCompleteForAllItems;

#pragma mark - Called when you register to receive upload events

// Called anytime an item is registered for upload - not necessary that the item has started upload
// - that is, the upload operation has been added to the queue
- (void)uploadDidRegisterForItem:(UploadID *)uploadID;

// Called anytime an item begins uploading - that is, the upload operation moves from pending to active state
- (void)uploadDidBeginForItem:(UploadID *)uploadID;

// Called whenever data is sent to Box as part of an upload
- (void)uploadDidProgressForItem:(UploadID *)uploadID bytesUploaded:(NSUInteger)bytes;

// Called whenever an item completes uploading (even if there was an error or it was cancelled by the user)
- (void)uploadDidCompleteForItem:(UploadID *)uploadID withResponse:(BoxCallbackResponse)response;

// Called whenever the upload queue goes from non-zero to zero length
- (void)uploadDidCompleteForAllItems;

// Called whenever the unresolved upload errors list goes from non-zero to zero length
- (void)uploadErrorsDidResolveForAllItems;

#pragma mark - Called when you register to receive favorite events

// Called whenever a favorite is added to or removed from the favorites list
- (void)favoritesDidUpdateWithNewFavorites:(NSArray *)newFavorites;

@end
