/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTRRecognitionServiceDelegate.h"
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@class RTRImageCaptureStatus;
@class RTRImageCaptureResult;
@class RTRQualityAssessmentForOCRBlock;

/**
 * A callback interface to interact with the image capture service: input the data and obtain the results.
 */
@protocol RTRImageCaptureServiceDelegate <RTRRecognitionServiceDelegate>
@required

/**
 * Delivers the feedback and result of image capture.
 *
 * @param status
 * 		The current status of capture (for UI feedback).
 *
 * @param result
 * 		Result of the capture - status of the best buffer (nullable).
 */
- (void)onBufferProcessedWithStatus:(RTRImageCaptureStatus*)status result:(nullable RTRImageCaptureResult*)result;

@end

#pragma mark -

/** The current status of the capture, for UI feedback. */
RTR_API_LINKAGE
@interface RTRImageCaptureStatus : NSObject

/** The motion vector. */
@property (nonatomic, assign, readonly) CGVector motionVector;
/** The relative buffer quality. */
@property (nonatomic, assign, readonly) NSInteger relativeQuality;
/** The document boundary. The array of CGPoint-based values. */
@property (nonatomic, strong, readonly, nullable) NSArray<NSValue*>* documentBoundary;
/** The quality assesment blocks. */
@property (nonatomic, strong, readonly, nullable) NSArray<RTRQualityAssessmentForOCRBlock*>* qualityAssessmentForOCRBlocks;
/** The result image size. */
@property (nonatomic, assign, readonly) CGSize imageSize;

- (instancetype)init __unavailable;

@end

#pragma mark -

/** The result of the capture. */
RTR_API_LINKAGE
@interface RTRImageCaptureResult : NSObject

/** The captured image. */
@property (nonatomic, strong, readonly, nullable) UIImage* image;
/** The image size. */
@property (nonatomic, assign, readonly) CGSize imageSize;

/** The document boundary. The array of CGPoint-based values. */
@property (nonatomic, strong, readonly, nullable) NSArray<NSValue*>* documentBoundary;
/** The document size (as specified in setDocumentSize:). */
@property (nonatomic, assign, readonly) CGSize documentSize;
/** The quality assesment blocks. */
@property (nonatomic, strong, readonly, nullable) NSArray<RTRQualityAssessmentForOCRBlock*>* qualityAssessmentForOCRBlocks;

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
