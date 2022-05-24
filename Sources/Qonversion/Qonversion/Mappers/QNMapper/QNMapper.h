#import <Foundation/Foundation.h>

@class QNMapperObject, QNLaunchResult, QNPermission, QNIntroEligibility, QNUser;

@interface QNMapper : NSObject

+ (QNMapperObject * _Nonnull)mapperObjectFrom:(NSDictionary * _Nullable)dict;

+ (QNLaunchResult * _Nonnull)fillLaunchResult:(NSDictionary * _Nullable)dict;

+ (QNUser * _Nonnull)fillUser:(NSDictionary * _Nullable)dict;

+ (QNPermission *)fillPermissions:(NSDictionary * _Nullable)dict;

+ (NSDictionary<NSString *, QNIntroEligibility *> * _Nonnull)mapProductsEligibility:(NSDictionary * _Nullable)dict;

+ (NSInteger)mapInteger:(NSObject * _Nullable)object orReturn:(NSInteger)defaultValue;

@end
