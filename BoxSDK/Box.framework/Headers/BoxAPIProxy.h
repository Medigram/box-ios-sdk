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

// The BoxAPIProxy is the base class for all box objects.  It provides functionality for forwarding
// method calls to in-memory cache and in the case of database-backed apps, to the database.
// In general, there should be no reason to instantiate or interact with BoxAPIProxy objects directly.

#import "BoxObserverProtocol.h"

@interface BoxAPIProxy : NSProxy <BoxObserver>

// The BoxID of the item this object represents
@property (readonly) BoxID *boxID;

// Whether the object a valid database-backed object. If the app is not database-backed, this will return NO.
@property (readonly, getter = isValid) BOOL valid;

// Whether the item is currently being updated by a network call. For example, if its a file, and you
// call an update on the file, it will be in updating state from the time the file update operation
// begins to when the results are committed to the cache.
@property (readonly, getter = isUpdating) BOOL updating;

// Invalidate the cache for this item.  If the app is database-backed, this will result in refetching
// properties and relationships from the database. If it is not database-backed, this will clear all
// information associated with the object.
- (void)invalidate;
- (void)invalidateForKeys:(NSSet *)changedKeys;

// Access a list of all the cached properties for this object.
- (NSArray *)makeCachedKeys;

// If the app is database-backed, this method moves commonly used variables from the database into the
// in-memory cache. It can be useful to call this in a background thread before the object is used
// in order to improve responsiveness in the main thread. If the app is not database-backed, this does nothing.
- (void)prepopulateCache;

@end