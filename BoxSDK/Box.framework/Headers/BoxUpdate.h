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

// BoxUpdate represents Updates on the Box server, and may be used to access information
// about the updater (person whose action generated the update), and the type of the update,
// and the object that was updated.

#import "BoxAPIProxy.h"

@class BoxFolder;

@protocol BoxUpdate

#pragma mark - Update properties

// The BoxID of the udpate
@property (readonly) BoxID *updateID;

// The type of the update - see BoxConstants.h
@property (readonly) BoxUpdateType type;

// The real name (first and last) of the updater
@property (readonly) NSString *userName;

// The email address of the updater
@property (readonly) NSString *userEmail;

// The BoxID of the updater
@property (readonly) BoxID *userID;

// The time at which the update occurred
@property (readonly) NSDate *updateTime;

// A human readable string describing what happened during the update
@property (readonly) NSString *extendedDescription;

#pragma mark - Local update information

// The following methods are convenient for recording whether the current user has viewed
// this update or not.  These are local to your app and are not set by Box.
@property (readonly, getter = isViewed) BOOL viewed;
@property (readonly, getter = isUnread) BOOL unread;

- (void)markAsViewed;
- (void)markAsUnread;


#pragma mark - Update Conents

// An array of BoxObjects that the update affected.  These should be filled from the network
// simply by reading the update.
@property (readonly) NSArray *objects;


@end

@interface BoxUpdate : BoxAPIProxy <BoxUpdate>

+ (Class)cacheType;

@end