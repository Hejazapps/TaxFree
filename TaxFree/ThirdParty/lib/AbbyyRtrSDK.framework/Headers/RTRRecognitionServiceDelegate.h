/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTRConstants.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - RTRRecognitionServiceDelegate

/**
 * A callback protocol to interact with the recognition service: input the data and obtain the results.
 */
@protocol RTRRecognitionServiceDelegate <NSObject>

@required
/**
 * Reports an error.
 *
 * @param error The description of the error that has occurred.
 */
- (void)onError:(NSError*)error;

@optional
/**
 * Reports a warning.
 *
 * @param warningCode The warning; for a list of possible values see the RTRCallbackWarningCode constant descriptions.
 */
- (void)onWarning:(RTRCallbackWarningCode)warningCode;

@end

NS_ASSUME_NONNULL_END
