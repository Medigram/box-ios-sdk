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

#import "BoxConstants.h"
#import "BoxOperationCallbacks.h"

@protocol BoxDataStoreDelegate

- (void)requestUpdateForObject:(BoxID *)objectID type:(Class)type callback:(BoxCallback)callback;
- (void)unableToRetrieveObject:(BoxID *)objectID type:(Class)type;
- (void)updatedObject:(BoxID *)objectID withType:(Class)type forKeys:(NSArray *)changedKeys;

// Update the cache that is stored in the proxy item with given ID and type using the info dictionary
// The return value is the set of keys that were changed
- (NSSet *)updateCacheForObject:(BoxID *)objectID type:(Class)type dictionary:(NSDictionary *)info;

- (BOOL)requestDeviceAccess;

- (void)uploadValue:(id)value forKey:(NSString*)key object:(BoxID *)ID type:(Class)type;

- (void)operationQueueWillBegin;
- (void)operationQueueDidEnd;

// Download observer methods
- (void)downloadDidBeginForItem:(BoxID *)itemID;
- (void)downloadDidProgressForItem:(BoxID *)itemID bytesDownloaded:(NSUInteger)bytes;
- (void)downloadDidCompleteForItem:(BoxID *)itemID withResponse:(BoxCallbackResponse)response;
- (void)downloadDidCompleteForAllItems;

// called when there was a version change
// TODO - B. Smith - 11/18/11 - This should probably provide arguments about the migration versions
// For now we assume its 2.4 to 2.5
- (void)didPerformVersionMigration;

@end
