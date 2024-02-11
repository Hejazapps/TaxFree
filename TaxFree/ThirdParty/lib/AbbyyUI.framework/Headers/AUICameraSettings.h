/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AUICameraResolution) {
	/// 1280x720 iPhone. 1024x768 iPad.
	AUICameraResolutionHD,

	/// 1920x1080 iPhone. 1920x1440 iPad. Default value.
	AUICameraResolutionFullHD,

	/// 3840x2160 iPhone. 3264x2448 iPad.
	AUICameraResolution4K,
};

@protocol AUICameraSettings <NSObject>

/// Preferred camera resolution.
@property (nonatomic, assign) AUICameraResolution preferredResolution;

/// Does current capture device support flash.
@property (nonatomic, readonly) BOOL hasFlashlight;

/// Turn on/off flashlight.
@property (nonatomic, assign) BOOL flashlightEnabled;

@end

NS_ASSUME_NONNULL_END
