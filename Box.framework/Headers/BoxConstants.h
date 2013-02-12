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

@class BoxObject;

#define BoxAPIErrorDomain @"net.box.error.api"

typedef enum {
	BoxObjectTypeUnknown = 0,
	BoxObjectTypeFile,
	BoxObjectTypeWebLink,
	BoxObjectTypeFolder
} BoxObjectType;

typedef enum {
	BoxFileTypeUnknown = 0,
	BoxFileTypePDF,
	BoxFileTypeMusic,
	BoxFileTypeVideo,
	BoxFileTypeImage,
	BoxFileTypeWebdoc,
	BoxFileTypeGeneral
} BoxFileType;

typedef enum _BoxUpdateType {
	BoxUpdateTypeUnknown = -1, //NOTE: Using -1 for the unknown entry for backwards compatability with cached values
	BoxUpdateTypeSent,
	BoxUpdateTypeDownloaded,
	BoxUpdateTypeCommentedOn,
	BoxUpdateTypeMoved,
	BoxUpdateTypeUpdated,
	BoxUpdateTypeAdded,
	BoxUpdateTypePreviewed,
	BoxUpdateTypeDownloadedAndPreviewed,
	BoxUpdateTypeCopied,
	BoxUpdateTypeLocked,
	BoxUpdateTypeUnlocked,
	BoxUpdateTypeAssignedTask,
	BoxUpdateTypeRespondedToTask,
	BoxUpdateTypeLiked
} BoxUpdateType;

typedef enum {
	BoxSortTypeDefault = 0,
	BoxSortTypeFileType,
	BoxSortTypeCollaborators,
	BoxSortTypeItemType,
	BoxSortTypeName,
	BoxSortTypeCreationDate,
	BoxSortTypeUpdateDate,
	BoxSortTypeOwner,
	BoxSortTypeSize
} BoxSortType;

typedef NSNumber UploadID; //NOTE: This does not correspond to an actual ID on the server so it doesn't make sense to use BoxID.
typedef NSNumber BoxID;

#if TARGET_OS_IPHONE
@class UIImage;
typedef UIImage BoxImage;
#else
@class NSImage;
typedef NSImage BoxImage;
#endif

typedef void (^BoxCallback)();
typedef void (^BoxProgressCallback)(NSNumber *progressRatio);
typedef void (^BoxObjectCallback)(BoxObject *object);
