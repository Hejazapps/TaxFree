/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTREngine.h"

NS_ASSUME_NONNULL_BEGIN

@class RTRExtendedSettings;
@protocol RTRImageCaptureService;
@protocol RTRImageCaptureServiceDelegate;

#pragma mark -

@interface RTREngine (MobileImaging)

/**
 * Creates a background image capture service configured with default settings.
 *
 * @param delegate The delegate object used to interact with the service.
 *
 * @return Image capture service that conforms to RTRImageCaptureService protocol.
 */
- (id<RTRImageCaptureService>)createImageCaptureServiceWithDelegate:(id<RTRImageCaptureServiceDelegate>)delegate;

/**
 * Creates a background image capture service.
 *
 * @param delegate The delegate object used to interact with the service.
 * @param settings The settings used to configure the service.
 *
 * @return Image capture service that conforms to RTRImageCaptureService protocol.
 */
- (id<RTRImageCaptureService>)createImageCaptureServiceWithDelegate:(id<RTRImageCaptureServiceDelegate>)delegate settings:(nullable RTRExtendedSettings*)settings;

@end

NS_ASSUME_NONNULL_END
