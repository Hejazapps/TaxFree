/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <UIKit/UIKit.h>
#import "AUIDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AUICaptureScenarioDelegate;

ABBYYUI_EXTERN
@interface AUICaptureScenario : NSObject

+ (NSArray<NSNumber*>*)supportedCameraResolutionsForDevice;

@property (nonatomic, weak, nullable) id<AUICaptureScenarioDelegate> delegate;

@end

@protocol AUICaptureScenarioDelegate <NSObject>
@end

NS_ASSUME_NONNULL_END
