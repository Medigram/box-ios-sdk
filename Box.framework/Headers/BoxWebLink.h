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

// The BoxWebLink represents weblinks/bookmarks on Box.  More detailed information
// can be found in the BoxObject class, which it inherits from.

#import "BoxObject.h"

@protocol BoxWebLink

// The URL that that weblink points to
@property (readonly) NSURL *URL;

@end

@interface BoxWebLink : BoxObject <BoxWebLink>
    
+ (Class)cacheType;

@end