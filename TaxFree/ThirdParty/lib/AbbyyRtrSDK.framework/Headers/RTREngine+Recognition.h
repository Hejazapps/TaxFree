/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTREngine.h"
#import "RTRConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class RTRExtendedSettings;
@protocol RTRTextCaptureService;
@protocol RTRTextCaptureServiceDelegate;

#pragma mark - RTREngine

@interface RTREngine (TextCapture)

/**
 * Creates a background recognition service configured with default settings.
 *
 * @param delegate The delegate object used to interact with the service.
 *
 * @return Recognition service that conforms to RTRRecognitionService protocol.
 */
- (id<RTRTextCaptureService>)createTextCaptureServiceWithDelegate:(id<RTRTextCaptureServiceDelegate>)delegate;

/**
 * Creates a background recognition service.
 *
 * @param delegate The delegate object used to interact with the service.
 * @param settings The settings used to configure background recognition service.
 *
 * @return Recognition service that conforms to RTRRecognitionService protocol.
 */
- (id<RTRTextCaptureService>)createTextCaptureServiceWithDelegate:(id<RTRTextCaptureServiceDelegate>)delegate settings:(nullable RTRExtendedSettings*)settings;

/**
 * Examines bundle directories and returns the list of languages available for text recognition.
 *
 * @return A set of strings with internal language names.
 */
- (NSSet<RTRLanguageName>*)languagesAvailableForOCR;

@end

NS_ASSUME_NONNULL_END
