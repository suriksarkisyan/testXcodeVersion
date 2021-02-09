#import <StoreKit/StoreKit.h>

#import "QNUtils.h"
#import "QNErrors.h"

@implementation QNUtils

+ (BOOL)isEmptyString:(NSString *)string {
  return string == nil || [string isKindOfClass:[NSNull class]] || [string length] == 0;
}

+ (NSString *)convertHexData:(NSData *)tokenData {
    const unsigned char *bytes = (const unsigned char *)tokenData.bytes;
    NSMutableString *hex = [NSMutableString new];
    for (NSInteger i = 0; i < tokenData.length; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    return [hex copy];
}

+ (BOOL)isCacheOutdated:(NSTimeInterval)cacheDataTimeInterval {
  NSDate *currentDate = [NSDate date];
  return (currentDate.timeIntervalSince1970 - cacheDataTimeInterval) > (60.0 * 60.0 * 24.0);
}

@end
