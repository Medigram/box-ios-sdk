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

// The BoxFile objects represent files that are stored on Box. It provides access to information
// about the file type, file location on disk, and exposes actions related to preview and download.
// Note that this class inherits from BoxObject, which implements many of the more common methods (like name, updateTime, etc.)


#import "BoxObject.h"

@protocol BoxFile

#pragma mark - File Type Information

// The file type (image, document, video, music, etc.) - Defined in BoxConstants.h
@property (readonly) BoxFileType fileType;

// The extension of the file
@property (readonly) NSString *fileExtension;

// This method converts the file type to a string.  Note that is not localized,
// and so should not be used for anything user facing.  Instead, it should only
// be used as a key for analytics calls
@property (readonly) NSString *fileAnalyticsType;

@property (readonly) NSString *mimeType; // The mime type, as returned by the server when the file is downloaded

#pragma mark - Local File Storage

// URL to the location of the file on disk - expected to be nil if the file has not been stored locally
@property (readonly) NSURL *localURL;

// The sha1 of the file that is stored locally - expected to nil if the file has not been stored locally
// note that this should be compared to the property "sha1" defined in BoxObject
@property (readonly) NSString *localSha1;

// The data of the locally stored file - expected to be nil the file has not been stored locally
// Note - in encrypted apps, this will be the unencrypted fileData, and so should be preferred to
// direct usage of localURL if the data is needed and can be loaded into memory safely
@property (readonly) NSData *fileData;

// The last time the stored local file was accessed - this is used for evicted local files
// from the local cache
@property (readonly) NSDate *storeLastAccessTime;

// The time of the most recent download of the file to local storage
@property (readonly) NSDate *storeLastDownloadTime;

// The time of the first download of the file to local storage - differs from the above if
// multiple versions of the file were downloaded
@property (readonly) NSDate *storeFirstDownloadTime;

// Whether the user has permissions to download the file
@property (readonly) BOOL hasDownloadPermissions;

// Media files are typically streamed rather than downloaded - this is the URL to pass to
// the media player to stream the video or music file from
@property (readonly) NSURL *streamingURL;

#pragma mark - Download actions

// This downloads the file and prepares it for preview.  If the file is already downloaded (and up to date), this method
// simply calls the callbacks
- (void)previewWithCallbacks:(BoxOperationCallbacksDefine)callbacksDefine;

// Cancel the current download of this file.  Note that this is merely a request - even after calling this downloads may
// continue, if, for example, the user explicitly requested the file be stored for offline access
- (void)cancelDownload;

// Remove the localSha1 and localURL information - useful for marking a file as having been deleted locally
- (void)clearDownloadInfo;

// Delete the local copy of the file 
- (void)removeLocalFile;

@end

@interface BoxFile : BoxObject <BoxFile> 

+ (Class)cacheType;

@end
