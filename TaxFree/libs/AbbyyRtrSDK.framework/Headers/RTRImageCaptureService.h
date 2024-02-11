/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTRRecognitionService.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - RTRImageCaptureService

/**
 * An image capture service protocol.
 */
@protocol RTRImageCaptureService <RTRRecognitionService>
@required

/**
 * Sets the physical size of the document to be captured.
 * If the physical size of the document being captured is known, setting this parameter will
 * help to improve document boundary detection accuracy. Will allow to detect document orientation during capture.
 * Will preserve aspect ratio after crop. Will allow to automatically calculate image resolution before export.
 *
 * @param size The size of the document in millimeters.
 */
- (void)setDocumentSize:(CGSize)size;

/**
 * Minimum appropriate value of document's aspect ratio.
 * This will help to improve boundary detection accuracy.
 * Value is found by division maximum size to minimum size.
 * Value must be either greater than or equal to 1, or not set (property set to 0).
 * If only maximum is set, minimum will be set to 1.
 * Not set by default (property set to 0).
 *
 * If not set, the values will be calculated from documentSize setting.
 */
@property (atomic, assign) CGFloat aspectRatioMin;

/**
 * Maximum appropriate value of document's aspect ratio.
 * This will help to improve boundary detection accuracy.
 * Value is found by division maximum size to minimum size.
 * Value must be either greater than or equal to 1, or not set (property set to 0).
 * If only minimum is set, maximum will be set to CGFLOAT_MAX.
 * Not set by default (property set to 0).
 *
 * If not set, the values will be calculated from documentSize setting.
 */
@property (atomic, assign) CGFloat aspectRatioMax;

@end

NS_ASSUME_NONNULL_END
