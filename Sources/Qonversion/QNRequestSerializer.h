#import "QNLaunchResult.h"

@class SKProduct, SKPaymentTransaction;

NS_ASSUME_NONNULL_BEGIN
@interface QNRequestSerializer : NSObject

- (NSDictionary *)launchData;

- (NSDictionary *)purchaseData:(SKProduct *)product
                   transaction:(SKPaymentTransaction *)transaction
                       receipt:(nullable NSString *)receipt;

- (NSDictionary *)introTrialEligibilityDataForProducts:(NSArray<QNProduct *> *)products;

- (NSDictionary *)attributionDataWithDict:(NSDictionary *)data fromProvider:(QNAttributionProvider)provider;

@end

NS_ASSUME_NONNULL_END
