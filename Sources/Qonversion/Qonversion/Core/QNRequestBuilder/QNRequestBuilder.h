#import <Foundation/Foundation.h>

@interface QNRequestBuilder : NSObject

- (void)setApiKey:(NSString *)apiKey;
- (NSURLRequest *)makeInitRequestWith:(NSDictionary *)parameters;
- (NSURLRequest *)makeSendPushTokenRequestWith:(NSDictionary *)parameters;
- (NSURLRequest *)makeUserInfoRequestWithID:(NSString *)userID apiKey:(NSString *)apiKey;
- (NSURLRequest *)makePropertiesRequestWith:(NSDictionary *)parameters;
- (NSURLRequest *)makeAttributionRequestWith:(NSDictionary *)parameters;
- (NSURLRequest *)makePurchaseRequestWith:(NSDictionary *)parameters userID:(NSString *)userID;
- (NSURLRequest *)makeUserActionPointsRequestWith:(NSString *)parameter;
- (NSURLRequest *)makeScreensRequestWith:(NSString *)parameters;
- (NSURLRequest *)makeCreateIdentityRequestWithUserID:(NSString *)userID parameters:(NSDictionary *)parameters;
- (NSURLRequest *)makeGetIdentityRequestWith:(NSString *)userID;
- (NSURLRequest *)makeGetEntitlementsRequestWith:(NSString *)userID;
- (NSURLRequest *)makeScreenShownRequestWith:(NSString *)parameter body:(NSDictionary *)body;
- (NSURLRequest *)makeIntroTrialEligibilityRequestWithData:(NSDictionary *)parameters;
- (NSURLRequest *)makeEventRequestWithEventName:(NSString *)eventName payload:(NSDictionary *)payload userID:(NSString *)userID;

@end
