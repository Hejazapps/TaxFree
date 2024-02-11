/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <UIKit/UIKit.h>
#import "AUICaptureScenario.h"
#import "AUICameraSettings.h"

NS_ASSUME_NONNULL_BEGIN

/// Color theme
typedef NS_ENUM(NSUInteger, AUITheme) {
	AUIThemeLight,
	AUIThemeDark,
};

/// Controller for capture image. If created without initial view controller, pushes camera controller automatically.
ABBYYUI_EXTERN
@interface AUICaptureController : UINavigationController

/// Bundle for localized strings table AbbyyUI.strings.
@property (class, nonatomic, strong, null_resettable) NSBundle* localizedStringsBundle;

/// AbbyyCaptureScenario that controlls capture process.
@property (nonatomic, strong, nullable) AUICaptureScenario* captureScenario;

/// Camera overlay view. Shows over camera view.
/// To define in storyboard it must be placed outside AUICaptureController.
@property (nonatomic, strong, nullable) IBOutlet UIView* cameraOverlayView;

/// Camera torch toggle button. Selected state stores in NSUserDefaults.
@property (nonatomic, strong, nullable) IBOutlet UIButton* flashButton;

/// Capture image immediately button.
@property (nonatomic, strong, nullable) IBOutlet UIButton* captureButton;

/// Pick image from gallery button.
@property (nonatomic, strong, nullable) IBOutlet UIButton* galleryButton;

/// Close button.
@property (nonatomic, strong, nullable) IBOutlet UIButton* closeButton;

/// Camera settings for current capture session. Nil if capture session not run.
@property (nonatomic, readonly, nullable) id<AUICameraSettings> cameraSettings;

/// Color theme.
@property (nonatomic, assign) AUITheme theme;

/// Color of selected controls.
@property (nonatomic, copy) UIColor* customColor;

/// Paused  state.
@property (nonatomic, assign) BOOL paused;

/// Set paused state with animation flag.
- (void)setPaused:(BOOL)paused animated:(BOOL)animated;

/// Push camera controller.
- (void)pushCameraControllerAnimated:(BOOL)animated;

/// Set or change capture scenario.
- (void)setCaptureScenario:(AUICaptureScenario*)captureScenario animated:(BOOL)animated;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ABBYYUI_EXTERN
@interface UIView (AUIAnimationRotation)
/// Add this method to custom control and return YES to rotate according to device orientation on iPhone
- (BOOL)aui_canRotate;
@end

NS_ASSUME_NONNULL_END
