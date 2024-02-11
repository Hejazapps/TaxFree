/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <UIKit/UIKit.h>
#import "AUIDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

/// Button with borders and blurred background. The color of the borders depends on the theme color.
ABBYYUI_EXTERN
@interface AUIThemeButton : UIButton

@property (nonatomic, copy) UIColor* selectedColor UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END
