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

// This file defines the callback protocols and callback responses for asynchronous operations


// These responses are passed by BoxOperationCallbacks in the on.after block
typedef enum _BoxCallbackReponse {
	BoxCallbackResponseNone = 0,
	BoxCallbackResponseSuccessful,
	BoxCallbackResponseNotLoggedIn,
	BoxCallbackResponseWrongPermissions,
	BoxCallbackResponseInvalidInput,
	BoxCallbackResponseInvalidName,
	BoxCallbackResponseInvalidUser,
	BoxCallbackResponseInvalidReceipt,
	BoxCallbackResponseUnverifiedReceipt,
	BoxCallbackResponseCannotReuseReceipt,
	BoxCallbackResponseDiskError,
	BoxCallbackResponseProtectedWriteError,
	BoxCallbackResponseUnknownFolderID,
	BoxCallbackResponseUserCancelled,
	BoxCallbackResponseSyncStateAlreadySet,
	BoxCallbackResponseInternalAPIError,
	BoxCallbackResponseUnauthorizedDevice,
	BoxCallbackResponseDeviceLimit,
	BoxCallbackResponseLoginLimit,
	BoxCallbackResponseSSORequired,
	BoxCallbackResponseTwoFactorRequired,
	BoxCallbackResponseEmailExists,
	BoxCallbackResponseEmailInvalid,
	BoxCallbackResponseEmailVerificationRequired,
	BoxCallbackResponseClientUpgradeRequired,
	BoxCallbackResponseOSUpgradeRequired,
	BoxCallbackResponseRegistrationPasswordInvalid,
	BoxCallbackResponseRegistrationRollInRequired,
	BoxCallbackResponseFileSizeLimitReached,
	BoxCallbackResponseFileIsLocked,
	BoxCallbackResponseNotEnoughFreeSpace,
	BoxCallbackResponseNoInternetConnection,
	BoxCallbackResponseUnexpectedConnectionTermination,
	BoxCallbackResponseNameTooLong,
	BoxCallbackResponseNameExists,
	BoxCallbackResponseNameIsEmpty,
	BoxCallbackResponseItemDoesNotExist,
	BoxCallbackResponseUnknownError = 100
} BoxCallbackResponse;

// These protocols define the box operation call back.  In general, the syntax looks like:
//
//[self.folder childrenWithCallbacks:^(id<BoxOperationCallbacks> on) 
// {
//	 on.before(^{
//		 // do something before the operation starts
//	 });
//	 on.after (^(BoxCallbackResponse response) {
//		 // do something after the operation ends
//	 });
//	 on.userInfo (^(NSDictionary* result) {
//		 // do something with the return value (typically stored with key @"results") of the operation
//	});
// }];
// 
// Note that all arguments are optional, so for example, it is perfectly ok to use only on.after or on.before

@protocol BoxOperationCallbacks;
typedef void (^BoxOperationCallbacksDefine)(id <BoxOperationCallbacks> on);

typedef void (^BoxOperationCallback)();
typedef void (^BoxOperationCallbackContainer)(BoxOperationCallback callback);
typedef void (^BoxOperationResponseCallback)(BoxCallbackResponse response);
typedef void (^BoxOperationResponseCallbackContainer)(BoxOperationResponseCallback callback);
typedef void (^BoxOperationProgressCallback)(NSNumber *ratio);
typedef void (^BoxOperationProgressCallbackContainer)(BoxOperationProgressCallback callback);
typedef void (^BoxOperationUserInfoCallback)(NSDictionary *userInfo);
typedef void (^BoxOperationUserInfoCallbackContainer)(BoxOperationUserInfoCallback callback);

@protocol BoxOperationCallbacks <NSObject>

@property (readonly) BoxOperationCallbackContainer before;
@property (readonly) BoxOperationProgressCallbackContainer progress;
@property (readonly) BoxOperationResponseCallbackContainer after;
@property (readonly) BoxOperationUserInfoCallbackContainer userInfo;

@end
