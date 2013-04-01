//
//  MGBoxManager.h
//  medigram
//
//  Created by Yuhao Ding on 3/27/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGBoxManager : NSObject

+ (id)sharedInstance;

- (void)updateAccountInformation;
- (void)signOut;

@end
