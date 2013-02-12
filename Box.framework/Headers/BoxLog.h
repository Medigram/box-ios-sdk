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

#ifdef BOX_DEBUG
#define BOXLog(...) NSLog(@"%@", [@"BOX: " stringByAppendingFormat:__VA_ARGS__])
#define BOX_NSLOG_STRING(...) NSLog(@"%@", [@"BOX: " stringByAppendingFormat:__VA_ARGS__])
#else
#define BOXLog(...)
#define BOX_NSLOG_STRING(...)
#endif

#ifdef BOX_DEBUG
#define BOXAssert(...) NSAssert(__VA_ARGS__)
#define BOXCAssert(...) NSCAssert(__VA_ARGS__)
#define BOXAssert1(...) NSAssert1(__VA_ARGS__)
#else
#define BOXAssert(...)
#define BOXCAssert(...)
#define BOXAssert1(...)
#endif
