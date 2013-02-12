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

// The BoxUpload class is used to track an upload before it becomes a BoxFile.

#import "BoxOperationCallbacksProtocol.h"
#import "BoxConstants.h"

@class ALAsset;
@class BoxFile;

typedef enum __BoxUploadState
{
	BoxUploadStatePending, // The upload is queued up
	BoxUploadStateUploading, // The upload has started and is in progress
	BoxUploadStateComplete, // The upload has completed successfully
	BoxUploadStateFailed // The upload failed with an error
} BoxUploadState;

@interface BoxUpload : NSObject

// The ID of the upload - note that unlike all other classes, this ID does not
// correspond to anything on the Box servers.  This is a local ID for tracking the upload.
@property (nonatomic, readonly, retain) UploadID *uploadID;

// The name of the file being uploaded (including the extension).
@property (nonatomic, readwrite, retain) NSString *fileName;

// The ID of the folder on Box that the file is being uploaded to.
@property (nonatomic, readwrite, retain) BoxID *targetFolderID;

// The size of the file (in bytes).
@property (nonatomic, readonly, assign) NSUInteger fileSize;

// A path to the file on disk (if it is being uploaded from a path - uploadFileWithPath:fileName:targetFolderID:callbacks:).
@property (nonatomic, readonly, retain) NSString *pathToFile;

// The reference URL (if the file is being uploaded by reference URL -
// uploadFileWithReferenceURL:fileName:targetFolderID:callbacks: - like photos and videos
// from the device's media library).
@property (nonatomic, readonly, retain) NSURL *referenceURLToFile;

// The data of the file (if the file is being uploaded by data - uploadFileWithData:fileName:targetFolderID:callbacks:).
@property (nonatomic, readonly, retain) NSData *dataOfFile;

// The ALAsset corresponding to the file (if applicable, by refernce URL).
@property (nonatomic, readwrite, retain) ALAsset *asset; 

// The state of the upload (enum defined above).
@property (nonatomic, readwrite, assign) BoxUploadState state;

// The number of bytes, of the file associated with this upload, already uploaded.
@property (nonatomic, readwrite, assign) NSUInteger bytesUploaded;

// The response of the upload operation is stored here for convenience.
@property (nonatomic, readwrite, assign) BoxCallbackResponse errorCode;

// Designated initializer
// Initialize the upload object. Of the various possible file (to be uploaded) representations
// only, and at least, one is required - nil can be passed in for the others.
- (id)initWithUploadID:(UploadID *)ID fileName:(NSString *)name targetFolder:(BoxID *)targetFolder filePath:(NSString *)path fileReference:(NSURL *)referenceURL andData:(NSData *)data;

// Helper method which determines whether this upload will be replacing a particular existing
// file on Box.
- (BOOL)isReplacementOfExistingFile:(BoxFile *)file;

@end
