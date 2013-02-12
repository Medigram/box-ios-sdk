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

// The BoxComment object represents comments on BoxObjects.  They can be accessed
// by calling comments on the BoxObject.  Calling this method will kick off a network
// operation to fetch the comments.


#import "BoxAPIProxy.h"

@class BoxObject;
@class BoxUser;

@protocol BoxComment

// Access the ID of the comment
@property (readonly) BoxID *commentID;

// Access the full text of the comment
@property (readonly) NSString *message;

// The user who made the comment
@property (readonly) BoxUser *commenter;

// The time the comment was made
@property (readonly) NSDate *creationTime;

// Whether or not the comment is open for replies
@property (readonly) BOOL canReply;

// The object the comment was made on
@property (readonly) BoxObject *object;

// The comments that were made in reply to the current comment
@property (readonly) NSArray *replyComments;

@end

@interface BoxComment : BoxAPIProxy <BoxComment>

+ (Class)cacheType;

@end
