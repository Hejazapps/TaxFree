/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import "AUIImageCaptureScenario.h"
#import "AUIPageStorage.h"

NS_ASSUME_NONNULL_BEGIN

@class RTREngine;
@class AUIMultiPageImageCaptureScenario;
@class AUICaptureController;
@protocol AUIMultiPageImageCaptureResult;

/**
 A delegate protocol through which the multi image capture scenario returns its results.
 */
@protocol AUIMultiPageImageCaptureScenarioDelegate <AUICaptureScenarioDelegate>

/**
 Tells the delegate that the user successfully saved document pages.

 @param captureScenario The capture scenario.
 @param result The result with scanned document pages.
 */
- (void)captureScenario:(AUIMultiPageImageCaptureScenario*)captureScenario didFinishWithResult:(id<AUIMultiPageImageCaptureResult>)result;

/**
 Tells the delegate that the user cancelled scan action.

 @param captureScenario The capture scenario.
 @param result The result with scanned document pages.
 */
- (void)captureScenario:(AUIMultiPageImageCaptureScenario*)captureScenario
	onCloseWithResult:(id<AUIMultiPageImageCaptureResult>)result;

/**
 Tells the delegate that document scanning failed while the captureScenario was active. You are responsible for further actions: to delete scanned pages or to restore scenario.

 @param captureScenario The capture scenario.
 @param error The error containing the reason for failure.
 @param result The result with scanned document pages.
 */
- (void)captureScenario:(AUIMultiPageImageCaptureScenario*)captureScenario
	didFailWithError:(NSError*)error
	result:(id<AUIMultiPageImageCaptureResult>)result;

@end

#pragma mark -

typedef NS_ENUM(NSUInteger, AUIMultiPageResourceType) {
	/// Use this tip to advise user what document page place in front of the camera.
	AUIMultiPageResourceTypeLookingForPageTip,
	/// Text to display while scenario waits to manual capture.
	AUIMultiPageResourceTypeManualCaptureTip,
	/// Page name to display in preview navigation bar.
	AUIMultiPageResourceTypePageTitle,
	/// Text to display in preview in not filled image slot, for example: Tap to add image of the third document page.
	AUIMultiPageResourceTypeAddPageTip,
};

/**
 Additional page info datasource. All methods are optional.
 */
@protocol AUIMultiPageUISettings <NSObject>

@optional
/**
 Returns text to show for end-user for specific page.

 @param captureScenario Capture scenario informing delegate.
 @param event Specific event.
 @param index image index.
 @return Returns text to show for end-user for specific page or nil to display default text.
 */
- (nullable NSString*)captureScenario:(AUIMultiPageImageCaptureScenario*)captureScenario
	stringForResourceType:(AUIMultiPageResourceType)event
	forPageAtIndex:(NSUInteger)index;

@end

@protocol AUIMultiPageCaptureSettings <NSObject>
/**
 Provides access to image capture settings

 @param captureScenario Capture scenario informing delegate.
 @param settings settings that can be specialized for the current page.
 @param index current page index.
 */
- (void)captureScenario:(AUIMultiPageImageCaptureScenario*)captureScenario
	onConfigureImageCaptureSettings:(id<AUIImageCaptureSettings>)settings
	forPageAtIndex:(NSUInteger)index;

@end

#pragma mark -

/**
 Capture scenario to capture images of multi page documents.
 */
ABBYYUI_EXTERN
@interface AUIMultiPageImageCaptureScenario : AUICaptureScenario

/// Additional info about ui.
@property (nonatomic, weak, nullable) id<AUIMultiPageUISettings> uiSettings;
/// Additional info about capture settings at specific pages.
@property (nonatomic, weak, nullable) id<AUIMultiPageCaptureSettings> captureSettings;
/// If NO automatic image capturing is disabled. Default YES. After each capture is set to NO.
@property (nonatomic, assign) BOOL active;
- (void)setActive:(BOOL)active animated:(BOOL)animated;

/// To show preview of the captured page. Default YES.
@property (nonatomic, assign) BOOL isShowPreviewEnabled;
/// Number of pages in document or 0 if unknown. Default 0 (no pages limit). You should set this settings before scenario is started.
@property (nonatomic, assign) NSUInteger requiredPageCount;
/// Record id to show preview. You can specify record id to start with preview rather than camera. If nil scenario will be started with camera, otherwise - with preview of specified image.
@property (nonatomic, copy, nullable) AUIPageId startAsEditorAtPageId;

/// Current result.
@property (nonatomic, copy, readonly) id<AUIMultiPageImageCaptureResult> result;

/// Creates scenario with valid engine and storage of image data.
- (instancetype)initWithEngine:(RTREngine*)engine pageStorage:(id<AUIPageStorage>)storage NS_DESIGNATED_INITIALIZER;
/// Creates scenario with default AUIPageStorage based on the file system.
- (nullable instancetype)initWithEngine:(RTREngine*)engine storagePath:(NSString*)path error:(NSError**)error;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
