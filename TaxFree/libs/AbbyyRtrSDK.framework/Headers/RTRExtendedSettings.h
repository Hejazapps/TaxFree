/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

/// Extended service configuration settings. Settings for advanced using. Not used in typical scenarios.
RTR_API_LINKAGE
@interface RTRExtendedSettings : NSObject

/// The number of threads, zero if the number should be determined automatically (default is zero).
@property (nonatomic, assign) NSInteger processingThreadsCount;

@end

NS_ASSUME_NONNULL_END
