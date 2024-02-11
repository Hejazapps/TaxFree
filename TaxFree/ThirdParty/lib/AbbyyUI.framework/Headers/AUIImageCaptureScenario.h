/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "AUICaptureScenario.h"
#import <AbbyyRtrSDK/AbbyyRtrSDK.h>

NS_ASSUME_NONNULL_BEGIN

/// Document size for capture suggest.
typedef CGSize AUIDocumentSize NS_TYPED_EXTENSIBLE_ENUM;

/// Any document size.
ABBYYUI_EXTERN
AUIDocumentSize const AUIDocumentSizeAny;

/// A4 210 x 297 mm.
ABBYYUI_EXTERN
AUIDocumentSize const AUIDocumentSizeA4;

/// BusinessCard 53.98 x 85.6 mm.
ABBYYUI_EXTERN
AUIDocumentSize const AUIDocumentSizeBusinessCard;

/// Letter 215.9 x 279.4 mm.
ABBYYUI_EXTERN
AUIDocumentSize const AUIDocumentSizeLetter;

ABBYYUI_EXTERN
@interface AUIImageCaptureResult : NSObject

/// Captured image.
@property (nonatomic, strong) UIImage* image;

/// Boundary for document. NSValue contains CGPoint.
/// You can modify boundary by manual tunning.
@property (nonatomic, strong, nullable) NSArray<NSValue*>* documentBoundary;

@end

@protocol AUIImageCaptureScenarioDelegate;

@class AUIImageCaptureScenario;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol AUIImageCaptureScenarioDelegate <AUICaptureScenarioDelegate>

- (void)captureScenarioDidCancel:(AUICaptureScenario*)scenario;

- (void)captureScenario:(AUIImageCaptureScenario*)captureScenario didCaptureImageWithResult:(AUIImageCaptureResult*)result;

- (void)captureScenario:(AUIImageCaptureScenario*)scenario didFailWithError:(NSError*)error;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol AUIImageCaptureSettings

/// Minimum document area relative to frame area - 0...1. Default 0.15.
@property (nonatomic, assign) CGFloat minimumDocumentToViewRatio;

/**
 * Sets the physical size of the document to be captured.
 * If the physical size of the document being captured is known, setting this parameter will
 * help to improve document boundary detection accuracy. Will allow to detect document orientation during capture.
 * Will preserve aspect ratio after crop. Will allow to automatically calculate image resolution before export.
 *
 * The size of the document in millimeters.
 */
@property (nonatomic, assign) AUIDocumentSize documentSize;

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
@property (nonatomic, assign) CGFloat aspectRatioMin;

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
@property (nonatomic, assign) CGFloat aspectRatioMax;

/// Maximum pixel size of max side of image picked from gallery. Default 4096.
@property (nonatomic, assign) NSInteger imageFromGalleryMaxSize;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ABBYYUI_EXTERN
@interface AUIImageCaptureScenario : AUICaptureScenario<AUIImageCaptureSettings>

@property (nonatomic, weak, nullable) id<AUIImageCaptureScenarioDelegate> delegate;

/// If NO automatic image capturing is disabled. Default YES. After each capture is set to NO.
@property (nonatomic, assign) BOOL active;

- (void)setActive:(BOOL)active animated:(BOOL)animated;

/// Cancel scenario.
- (void)cancel;

/// If YES result image will be cropped and quadrangle result will be nil. Default NO.
@property (nonatomic, assign) BOOL cropEnabled;

- (instancetype)initWithEngine:(RTREngine*)engine;

/// Capture image immediately.
- (void)captureImageManually;
/// Pick Image from gallery.
- (void)pickImageFromGallery;

@end

NS_ASSUME_NONNULL_END
