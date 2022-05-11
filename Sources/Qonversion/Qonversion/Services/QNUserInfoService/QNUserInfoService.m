//
//  QNUserInfoService.m
//  Qonversion
//
//  Created by Surik Sarkisyan on 18.03.2021.
//  Copyright © 2021 Qonversion Inc. All rights reserved.
//

#import "QNUserInfoService.h"
#import "QNUserInfoServiceInterface.h"
#import "QNLocalStorage.h"
#import "QNInternalConstants.h"
#import "QNKeychainStorage.h"
#import "QNUserInfoMapperInterface.h"
#import "QNAPIClient.h"

static NSUInteger const kKeychainAttemptsCount = 3;

@implementation QNUserInfoService

- (void)obtainUserInfo:(QNUserInfoCompletionHandler)completion {
  NSString *userID = [self obtainUserID];
  
  __block __weak QNUserInfoService *weakSelf = self;
  [self.apiClient userInfoRequestWithID:userID completion:^(NSDictionary * _Nullable dict, NSError * _Nullable error) {
    QNUser *user = [weakSelf.mapper mapUserInfo:dict];
    completion(user, error);
  }];
}

- (NSString *)obtainUserID {
  NSString *cachedUserID = [self.localStorage loadStringForKey:kKeyQUserDefaultsUserID];
  NSString *resultUserID = cachedUserID;
  
  if (resultUserID.length == 0) {
    resultUserID = [self.keychainStorage obtainUserID:kKeychainAttemptsCount];
    [self.keychainStorage resetUserID];
  }
  
  if (resultUserID.length == 0) {
    resultUserID = [self generateRandomUserID];
  }
  
  if (cachedUserID.length == 0) {
    [self.localStorage setString:resultUserID forKey:kKeyQUserDefaultsUserID];
  }
  
  return resultUserID;
}

- (void)storeIdentity:(NSString *)userID {
  [self.localStorage setString:userID forKey:kKeyQUserDefaultsUserID];
}

- (NSString *)logout {
  NSString *defaultUserID = [self.localStorage loadStringForKey:kKeyQUserDefaultsUserID];
  NSString *userID = [self generateRandomUserID];
  
  [self.localStorage setString:userID forKey:kKeyQUserDefaultsUserID];
  
  return userID;
}

- (void)deleteUser {
  [self.localStorage removeObjectForKey:kKeyQUserDefaultsUserID];
  [self.keychainStorage resetUserID];
}

#pragma mark - Private

- (NSString *)generateRandomUserID {
  NSUUID *uuid = [NSUUID new];
  NSString *uuidString = [uuid.UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
  NSString *qonversionUID = [NSString stringWithFormat:@"%@%@%@", kKeyQUserIDPrefix, kKeyQUserIDSeparator, uuidString.lowercaseString];
  
  return qonversionUID;
}

@end
