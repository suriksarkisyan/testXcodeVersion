#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "QonversionCheckResult.h"
#import "QonversionProperties.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QAttributionProvider) {
    QAttributionProviderAppsFlyer = 0,
    QAttributionProviderBranch,
    QAttributionProviderAdjust
};

@interface Qonversion : NSObject

/**
 Sets the environment for receipt.
 @param debugMode        true If your app run under debug mode, default: false
 @see [Setting Debug Mode](https://docs.qonversion.io/getting-started/debug-mode)
 */
+ (void)setDebugMode:(BOOL)debugMode;

/**
 Sets Qonversion reservered user properties, like email or one-signal id
 @param property        Defined enum key that will be transformed to string
 @param value               Property value
 */
+ (void)setProperty:(QProperty)property value:(NSString *)value;

/**
 Sets custom user properties
 @param property        Defined enum key that will be transformed to string
 @param value               Property value
 */
+ (void)setUserProperty:(NSString *)property value:(NSString *)value;

/**
 Launches Qonversion SDK with the given project key, you can get one in your account on qonversion.io.
 @param key - project key to setup the SDK.
 @param completion - will return `uid` for Ads integrations.
 @warning Will track any purchase events (trials, subscriptions, basic purchases) automatically.
 */
+ (void)launchWithKey:(nonnull NSString *)key completion:(nullable void (^)(NSString *uid))completion;

/**
 @param key - project key to setup the SDK.
 @param uid - Client side user-id (instead of Qonversion user-id) will be used for matching data in the third party data.
 */

+ (void)launchWithKey:(nonnull NSString *)key userID:(nonnull NSString *)uid;

/**
 Launches Qonversion SDK with the given project key, you can get one in your account on qonversion.io.
 @param key - project key to setup the SDK.
 @param autoTrack - with this parameter turned off you need to call `trackPurchase:transaction:` method.
 @param completion - will return `uid` for Ads integrations.
 @warning Will track any purchase events (trials, subscriptions, basic purchases) automatically. But if `autoTrackPurchases` disabled you need to call `trackPurchase:transaction:` method. Otherwise, purchases tracking won't work.
 */
+ (void)launchWithKey:(nonnull NSString *)key autoTrackPurchases:(BOOL)autoTrack completion:(nullable void (^)(NSString *uid))completion;

/**
 Tracks purchases manually. Do nothing if you pass `true`/`YES` to `autoTrackPurchases` in `launchWithKey:autoTrackPurchases:` method or call `launchWithKey:completion:` method.
 @param product - SKProduct. Any of: trials, subscriptions, basic purchases.
 @param transaction - SKPaymentTransaction of the SKProduct.
 */
+ (void)trackPurchase:(nonnull SKProduct *)product transaction:(nonnull SKPaymentTransaction *)transaction;

/**
 Send your attribution data
 @param data Dictionary received by the provider
 @param provider Attribution provider
 */
+ (void)addAttributionData:(NSDictionary *)data
              fromProvider:(QAttributionProvider)provider;

+ (void)checkUser:(void(^)(QonversionCheckResult *result))result
          failure:(QonversionCheckFailer)failure;


// MARK: - Deprecated methods

/**
 Send your attribution data
 @param data Dictionary received by the provider
 @param provider Attribution provider
 @param uid ??? User Id that should be sent to the provider
 */
+ (void)addAttributionData:(NSDictionary *)data
              fromProvider:(QAttributionProvider)provider
                    userID:(nullable NSString *)uid
                    __deprecated_msg("Use addAttributionData:fromProvider: instead");

@end

NS_ASSUME_NONNULL_END
