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

#import "BoxOperationCallbacksProtocol.h"

#define BOX_OPERATION_CALLBACK_USER_INFO_RESULT_KEY @"results"

@interface BoxOperationCallbacks : NSObject <BoxOperationCallbacks> {
    BoxOperationCallbackContainer __before;
    BoxOperationProgressCallbackContainer __progress;
    BoxOperationResponseCallbackContainer __after;
    BoxOperationUserInfoCallbackContainer __userInfo;

    BoxOperationCallback __beforeCallback;
    BoxOperationProgressCallback __progressCallback;
    BoxOperationResponseCallback __afterCallback;
    BoxOperationUserInfoCallback __userInfoCallback;
}

+ (BoxOperationCallbacks *)callbacksForCallbacksDefine:(BoxOperationCallbacksDefine)callbacksDefine;

- (void)callBeforeCallback;
- (void)callProgressCallback:(NSNumber *)ratio;
- (void)callAfterCallback:(BoxCallbackResponse)response;
- (void)callUserInfoCallback:(NSDictionary *)result;

- (void)clearCallbacks;

@end