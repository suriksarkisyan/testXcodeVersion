//
//  QNIdentityManager.m
//  Qonversion
//
//  Created by Surik Sarkisyan on 22.03.2021.
//  Copyright © 2021 Qonversion Inc. All rights reserved.
//

#import "QNIdentityManager.h"
#import "QNIdentityServiceInterface.h"
#import "QNUserInfoServiceInterface.h"

@implementation QNIdentityManager

- (void)identify:(NSString *)userID completion:(QNIdentityCompletionHandler)completion {
  __block __weak QNIdentityManager *weakSelf = self;
  
  NSString *anonUserID = [self.userInfoService obtainUserID];
  
  [weakSelf.identityService obtainIdentify:userID completion:^(NSString * _Nullable result, NSError * _Nullable error) {
    if (error.code == 404) {
      [weakSelf.identityService createIdentity:userID anonUserID:anonUserID completion:^(NSString * _Nullable result, NSError * _Nullable error) {
        completion(result, error);
      }];
      return;
    } else if (result.length > 0) {
      [weakSelf.userInfoService storeIdentity:result];
    }
    completion(result, error);
  }];
}

- (NSString *)logout {
  return [self.userInfoService logout];
}

@end
