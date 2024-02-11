/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RTRCoreAPIImage;
@protocol RTROutputStream;

@protocol RTRCoreAPICropOperation;
@protocol RTRCoreAPIRotateOperation;
@protocol RTRCoreAPIDetectDocumentBoundaryOperation;
@protocol RTRCoreAPIQualityAssessmentForOCROperation;

@protocol RTRCoreAPIExportToPngOperation;
@protocol RTRCoreAPIExportToJpgOperation;
@protocol RTRCoreAPIExportToJpeg2000Operation;
@protocol RTRCoreAPIExportToPdfOperation;

#pragma mark -

/**
 * Provides access to low-level single image core API functions for current thread. Should be used on the same thread on
 * which it was created. Multiple objects can be created on different threads and used concurrently.
 * All methods are synchronous (blocking) and should not be used on UI thread. For advanced users.
 */
@protocol RTRImagingCoreAPI
@required

/**
 * Load image.
 */
- (nullable id<RTRCoreAPIImage>)loadImage:(UIImage*)image error:(__autoreleasing NSError* _Nullable *)error;

/**
 * Create 'detect document boundary' operation.
 *
 * @return the requested image operation. Use -applyToImage: method to apply operation to the image.
 */
- (id<RTRCoreAPIDetectDocumentBoundaryOperation>)createDetectDocumentBoundaryOperation;

/**
 * Create 'quality assessment for OCR' operation.
 *
 * @return the requested image operation. Use -applyToImage: method to apply operation to the image.
 */
- (id<RTRCoreAPIQualityAssessmentForOCROperation>)createQualityAssessmentForOCROperation;

/**
 * Create 'crop' operation.
 *
 * @return the requested image operation. Use -applyToImage: method to apply operation to the image.
 */
- (id<RTRCoreAPICropOperation>)createCropOperation;

/**
 * Create 'rotate' operation.
 *
 * @return the requested image operation. Use -applyToImage: method to apply operation to the image.
 */
- (id<RTRCoreAPIRotateOperation>)createRotateOperation;

#pragma mark -

/**
 * Create export to PNG operation.
 *
 * @param outputStream    The output stream for export.
 *
 * @return the requested export operation. Use -addPageWithImage: method to export the image.
 */
- (id<RTRCoreAPIExportToPngOperation>)createExportToPngOperation:(id<RTROutputStream>)outputStream;

/**
 * Create export to JPG operation.
 *
 * @param outputStream    The output stream for export.
 *
 * @return the requested export operation. Use -addPageWithImage: method to export the image.
 */
- (id<RTRCoreAPIExportToJpgOperation>)createExportToJpgOperation:(id<RTROutputStream>)outputStream;

/**
 * Create export to JPG operation.
 *
 * @param outputStream    The output stream for export.
 *
 * @return the requested export operation. Use -addPageWithImage: method to export the image.
 */
- (id<RTRCoreAPIExportToJpeg2000Operation>)createExportToJpeg2000Operation:(id<RTROutputStream>)outputStream;

/**
 * Create export to PDF operation.
 *
 * @param outputStream    The output stream for export.
 *
 * @return the requested export operation. Use -addPageWithImage: method to export individual images.
 */
- (id<RTRCoreAPIExportToPdfOperation>)createExportToPdfOperation:(id<RTROutputStream>)outputStream;

@end

#pragma mark -

/** Loaded image. */
@protocol RTRCoreAPIImage <NSObject>
@required

/**
 * Convert the receiver to a UIImage.
 * The result is created with corrected orientation if applicable.
 */
- (nullable UIImage*)UIImage;

/**
 * Return size of the image.
 */
- (CGSize)size;

/**
 * To handle errors occured.
 */
@property (nonatomic, copy, nullable) void(^onError)(NSError* error);

@end

#pragma mark -

/**
 * Common operation interface.
 */
@protocol RTRCoreAPIOperation <NSObject>
@required

/** The error occured, equals to nil on success. */
@property (nonatomic, copy, nullable) NSError* error;

@end

#pragma mark -

/**
 * Image operation interface. Image operations are applied an image. Some operations modify the image and some do not.
 * The result of the operation is either a modified image or filled in [out] parameters of the operation or both.
 */
@protocol RTRCoreAPIImageOperation <RTRCoreAPIOperation>
@required

/** Apply operation to the image. */
- (BOOL)applyToImage:(id<RTRCoreAPIImage>)image;

@end

#pragma mark -

/** Mode of document boundary detection. */
typedef NS_ENUM(NSUInteger, RTRDetectDocumentBoundaryMode) {
	/** Default value. */
	RTRDetectDocumentBoundaryModeDefault,
	/** Fast detector. */
	RTRDetectDocumentBoundaryModeFast,
};

/**
 * 'Detect document boundary' operation.
 */
@protocol RTRCoreAPIDetectDocumentBoundaryOperation <RTRCoreAPIImageOperation>
@required

/** Area of interest for the operation. */
@property (nonatomic, assign) CGRect areaOfInterest;
/** [in] Switch document boundary detection mode. */
@property (nonatomic, assign) RTRDetectDocumentBoundaryMode mode;
/** [in, out] The document size in millimeters. */
@property (nonatomic, assign) CGSize documentSize;
/** [out] The detected document boundary. Currently the result is always a quadrangle. The array of CGPoint-based values. */
@property (nonatomic, strong, readonly, nullable) NSArray<NSValue*>* documentBoundary;

@end

#pragma mark -

/** Type of quality assessment block. */
typedef NS_ENUM(NSUInteger, RTRQualityAssessmentForOCRBlockType) {
	/** Text detected. */
	RTRQualityAssessmentForOCRTextBlock,
	/** Unknown type. */
	RTRQualityAssessmentForOCRUnknownBlock,
};

/**
 * Quality assessment block.
 */
RTR_API_LINKAGE
@interface RTRQualityAssessmentForOCRBlock : NSObject

/** Type of quality assessment block. */
@property (nonatomic, assign, readonly) RTRQualityAssessmentForOCRBlockType type;
/** Text quality. */
@property (nonatomic, assign, readonly) NSInteger quality;
/** Block rectangle. */
@property (nonatomic, assign, readonly) CGRect rect;

- (instancetype)init __unavailable;

@end

#pragma mark -

/**
 * 'Quality assessment for OCR' operation.
 */
@protocol RTRCoreAPIQualityAssessmentForOCROperation <RTRCoreAPIImageOperation>
@required

/** [in, optional] Document boundary as defined by its corners. CGPoint-based values. */
@property (nonatomic, copy, nullable) NSArray<NSValue*>* documentBoundary;

/** [out] The quality assessment blocks. */
@property (nonatomic, strong, readonly, nullable) NSArray<RTRQualityAssessmentForOCRBlock*>* qualityAssessmentBlocks;

@end

#pragma mark -

/**
 * 'Crop' operation.
 */
@protocol RTRCoreAPICropOperation <RTRCoreAPIImageOperation>
@required

/** [in] Document boundary as defined by its corners. Currently it must be a quadrangle. */
@property (nonatomic, copy) NSArray<NSValue*>* documentBoundary;

/** [in, optional] the document size in millimeters. */
@property (nonatomic, assign) CGSize documentSize;

/** [out] Image resolution as calculated from image size and physical page size. */
@property (nonatomic, assign, readonly) CGSize imageResolution;

@end

#pragma mark -

/** 'Rotate' operation. */
@protocol RTRCoreAPIRotateOperation <RTRCoreAPIImageOperation>
@required

/** The angle in degrees (0, 90, 180, 270). */
@property (nonatomic, assign) NSInteger angle;

@end

#pragma mark -

/**
 * Export operation interface.
 * Images are added as pages. Some export operations support adding multiple pages and some do not.
 * Export operations should be properly closed (call 'close' method) to ensure that all required
 * content has been written to the output stream.
 */
@protocol RTRCoreAPIExportOperation <RTRCoreAPIOperation>
@required

/**
 * Add a page to the export target.
 *
 * @param page	The image to add.
 */
- (BOOL)addPageWithImage:(UIImage*)page;

/** Call this method to ensure that all required content has been written to the output stream. */
- (BOOL)close;

@end

#pragma mark -

/** Uniform image compression scale for all lossy formats. */
typedef NS_ENUM(NSUInteger, RTRCoreAPIExportCompressionLevel) {
	/** The lowest compression rate, that still might have any noticeable effect on recognition of small text. */
	RTRCoreAPIExportCompressionLowLevel,
	/** [Default] Balanced trade-off between compression and quality. Good safety margin. */
	RTRCoreAPIExportCompressionNormalLevel,
	/** More compression, less safety margin. Might perform poorly with small text, but generally still ok. */
	RTRCoreAPIExportCompressionHighLevel,
	/** The maximum recommended compression rate. Will perform poorly with small text. Advisable only for relatively large text and very slow networks. */
	RTRCoreAPIExportCompressionExtraHighLevel,
};

/**
 * Export to PNG operation.
 */
@protocol RTRCoreAPIExportToPngOperation <RTRCoreAPIExportOperation>
@required

/** Image resolution to be set in EXIF, zero by default. */
@property (nonatomic, assign) CGSize imageResolution;

@end

#pragma mark -

/**
 * Export to JPG operation.
 */
@protocol RTRCoreAPIExportToJpgOperation <RTRCoreAPIExportOperation>
@required

/** Image resolution to be set in EXIF, zero by default. */
@property (nonatomic, assign) CGSize imageResolution;

/** Page compression quality. Needs to be tuned depending on image resolution and font size. */
@property (nonatomic, assign) RTRCoreAPIExportCompressionLevel compression;

@end

#pragma mark -

/**
 * Export to JPEG2000 operation.
 */
@protocol RTRCoreAPIExportToJpeg2000Operation <RTRCoreAPIExportOperation>
@required

/** Image resolution to be set in EXIF, zero by default. */
@property (nonatomic, assign) CGSize imageResolution;

/** Page compression quality. Needs to be tuned depending on image resolution and font size. */
@property (nonatomic, assign) RTRCoreAPIExportCompressionLevel compression;

@end

#pragma mark -

/** Page compression. */
typedef NS_ENUM(NSUInteger, RTRCoreAPIPdfExportCompressionType) {
	RTRCoreAPIPdfExportJpgCompression,
	RTRCoreAPIPdfExportJpeg2000Compression,
};

/**
 * Export to PDF operation.
 */
@protocol RTRCoreAPIExportToPdfOperation <RTRCoreAPIExportOperation>
@required

/** Page compression. The default value is Jpg. */
@property (nonatomic, assign) RTRCoreAPIPdfExportCompressionType compressionType;
/** Page compression quality. Needs to be tuned depending on image resolution and font size. */
@property (nonatomic, assign) RTRCoreAPIExportCompressionLevel compression;
/**
 * Page width in points (1/72 of an inch). The page size of A4 is 595x842.
 * If the value is 'CGSizeZero' (the default), the page size is the same as the size of the image in pixels.
 */
@property (nonatomic, assign) CGSize pageSize;

/** PDF Info Tags: 'Title'. */
@property (nonatomic, copy, nullable) NSString* pdfInfoTitle;
/** PDF Info Tags: 'Subject'. */
@property (nonatomic, copy, nullable) NSString* pdfInfoSubject;
/** PDF Info Tags: 'Keywords'. */
@property (nonatomic, copy, nullable) NSString* pdfInfoKeywords;
/** PDF Info Tags: 'Author'. */
@property (nonatomic, copy, nullable) NSString* pdfInfoAuthor;
/** PDF Info Tags: 'Company'. */
@property (nonatomic, copy, nullable) NSString* pdfInfoCompany;
/** PDF Info Tags: 'Creator'. */
@property (nonatomic, copy, nullable) NSString* pdfInfoCreator;
/** PDF Info Tags: 'Producer'. */
@property (nonatomic, copy, nullable) NSString* pdfInfoProducer;

@end

NS_ASSUME_NONNULL_END
