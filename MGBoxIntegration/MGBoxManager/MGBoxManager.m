//
//  MGBoxManager.m
//  medigram
//
//  Created by Yuhao Ding on 3/27/13.
//  Copyright (c) 2013 Medigram, Inc. All rights reserved.
//
#import <Box/Box.h>
#import "MGBoxManager.h"

@implementation MGBoxManager

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static MGBoxManager *sharedInstance;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)updateAccountInformation
{
    BoxCurrentUser *currentUser = [Box user];
    if (currentUser.authToken.length > 0)
    {
        if ([[[Box user] username] length] > 0)
        {
        }
        else
        {
            [[Box user] updateAccountInformationWithCallbacks:^(id<BoxOperationCallbacks>on)
             {
                 on.before(^
                           {
                           });
                 on.after(^(BoxCallbackResponse response)
                          {
                              if (response == BoxCallbackResponseSuccessful)
                              {
                              }
                          });
             }];
        }
    }
    else
    {
    }
}

- (void)signOut
{
    [Box logoutWithCallbacks:^(id <BoxOperationCallbacks> on)
     {
         on.after(^(BoxCallbackResponse response)
                  {
                      [self updateAccountInformation];
                  });
     }];
}

@end
