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

// This protocol is used by the local image cache to update images as they become available from disk/network
// A typical example usage is to make a UITableViewCell that impelements updateImage to set the table view cell
// image as the supplied image.

#import "BoxConstants.h"

@protocol BoxUpdatableImage <NSObject>

- (void)updateImage:(BoxImage *)image;

@optional

@property (nonatomic, retain) NSString *loadingImageLocation;

@end
