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

// This class controls a list of search results, which can be accessed and queried

#import "Box.h"

@class BoxSearchResult;

// These keys are used to access the matchType dictionary
extern NSString *const BoxSearchResultSortKeyRelevance;
extern NSString *const BoxSearchResultSortKeyDate;
extern NSString *const BoxSearchResultSortKeyName;
extern NSString *const BoxSearchResultSortKeySize;
extern NSString *const BoxSearchResultsListControllerWillBeginSearchNotification;
extern NSString *const BoxSearchResultsListControllerDidFinishSearchNotification;

@protocol BoxSearchResultsListDelegate;

@interface BoxSearchResultsListController : NSObject <BoxObserver>

// Access the searchString that was submitted for this query
@property (nonatomic, readonly, retain) NSString *searchString;

// Access the results of the search
@property (nonatomic, readonly, retain) NSMutableArray *searchResults;

// Assign a search results list delegate - a delegate can be useful if you would like to
// update the UI based on the search state
@property (nonatomic, readwrite, assign) id<BoxSearchResultsListDelegate> delegate;

// The results of the search are paged - i.e., if resultsPerPage is set to 10, then
// only 10 results are retrieved everytime you call retrieveNextPage.
- (id)initWithResultsPerPage:(int)resultsPerPage;

// Retrieves next page of search results and adds it to searchResults array
- (void)retrieveNextPage;

// Add a search result to the results array
- (void)addSearchResult:(BoxSearchResult *)result;

// Perform the search with a given string
- (void)performSearchWithString:(NSString *)queryString;

// Clear all received results
- (void)clearResults;

@end

@protocol BoxSearchResultsListDelegate <NSObject>

@required
- (void)controllerWillBeginSearch:(NSNotification *)notification;
- (void)controllerDidFinishSearch:(NSNotification *)notification;

@end