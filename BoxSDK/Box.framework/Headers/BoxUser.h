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

// BoxUser represents a user on Box (associated with a comment, for example).
// BoxUser does not contain information about the user who is using the application,
// please see BoxCurrentUser for that info.

#import "BoxAPIProxy.h"

@protocol BoxUser

// The BoxID of the user
@property (readonly) BoxID *userID;

// The username (i.e., email address) of the user
@property (readonly) NSString *username;

// The profile image of the user.  Note that this will only be non-nil if the image is already
// cached in memory
@property (readonly) BoxImage *avatar;

@end

@interface BoxUser : BoxAPIProxy <BoxUser>

+ (Class)cacheType;

@end