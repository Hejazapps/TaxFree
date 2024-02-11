/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTRRecognitionServiceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class RTRTextLine;

#pragma mark - RTRTextCaptureServiceDelegate

/**
 * A specified callback protocol to obtain the text capture results.
 */
@protocol RTRTextCaptureServiceDelegate <RTRRecognitionServiceDelegate>

@required
/**
 * Delivers the result after recognizing the buffers that were supplied.
 * The result stability status is also provided and should be used to determine if the accuracy
 * is high enough for the result to be used for any practical purposes. We recommend not to use
 * the data in any way until stability level has reached RTRResultStabilityVerified.
 * When stability of the result has reached the desired level,
 * the service may be stopped by calling the -stopTasks method.
 *
 * @param textLines The result as an array with RTRTextLine objects that contain recognition results.
 * @param resultStatus The estimate of how stable the result is.
 *      It may go up and down. It is not guaranteed that it ever reaches desired levels for a particular scene.
 *      For a list of possible values see the RTRResultStabilityStatus constant descriptions.
 */
- (void)onBufferProcessedWithTextLines:(NSArray<RTRTextLine*>*)textLines resultStatus:(RTRResultStabilityStatus)resultStatus;

@end

NS_ASSUME_NONNULL_END
