/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <UIKit/UIKit.h>
#import "AUIMultiPageImageCaptureScenario.h"

NS_ASSUME_NONNULL_BEGIN
/**
 Result of a multi page document capturing.
 */
@protocol AUIMultiPageImageCaptureResult <NSObject>

/**
 Returns all record identifers in the result.

 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns all record identifers or nil on error.
 */
- (nullable NSArray<AUIPageId>*)pagesWithError:(NSError**)error;

/**
 Returns image of the record.

 @param identifier Record id.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns an image or nil on error.
 */
- (nullable UIImage*)loadImageWithId:(AUIPageId)identifier error:(NSError**)error;

/**
 Returns thumbnail image of the record.

 @param identifier Record id.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns an thumbnail image or nil on error.
 */
- (nullable UIImage*)loadThumbnailWithId:(AUIPageId)identifier error:(NSError**)error;

/**
 Returns original image of the record.

 @param identifier Record id.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns an image or nil on error.
 */
- (nullable UIImage*)loadOriginalImageWithId:(AUIPageId)identifier error:(NSError**)error;

/**
 Returns detected document boundary of the record.

 @param identifier Record id.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns 4 points describing document boundary or nil on error or empty array if the boundary was not found.
 */
- (nullable NSArray<NSValue*>*)loadBoundaryWithId:(AUIPageId)identifier error:(NSError**)error;

/**
 Returns document size of the record.

 @param identifier Record id.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Value describing document size of nil on error.
 */
- (nullable NSValue*)loadDocumentSizeWithId:(AUIPageId)identifier error:(NSError**)error;

/**
 Deletes a page with a specific identifier

 @param identifier page id.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns YES on success or NO on error.
 */
- (BOOL)deleteWithId:(AUIPageId)identifier error:(NSError**)error;

/**
 Removes all images.

 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns YES on success or NO on error.
 */
- (BOOL)clearWithError:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
