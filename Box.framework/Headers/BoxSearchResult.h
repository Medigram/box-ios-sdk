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

// Box search result represents a single search result.  See also BoxSearchResultsListController,
// which houses a list of search results.


@class BoxObject;

@interface BoxSearchResult : NSObject

// The BoxObject the search result corresponds to.  Note that the search operation
// should fill this object with info from the network
@property (nonatomic, readwrite, retain) BoxObject *objectModel;

// Information about the match between the search and the object.  See BoxSearchResultsListController
// for list of keys
@property (nonatomic, readwrite, retain) NSDictionary *matchType;

@end
