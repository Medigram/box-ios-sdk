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
           DLog(@"%@ is currently logged in.", [[Box user] username]);
        }
        else
        {
            [[Box user] updateAccountInformationWithCallbacks:^(id<BoxOperationCallbacks>on)
             {
                 on.before(^
                           {
                               DLog(@"User with ID %@ is currently logged in.", [[Box user] userID]);
                           });
                 on.after(^(BoxCallbackResponse response)
                          {
                              if (response == BoxCallbackResponseSuccessful)
                              {
                                  DLog(@"%@ is currently logged in.", [[Box user] username]);
                              }
                          });
             }];
        }
    }
    else
    {
        DLog(@"User not logged in.");
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
