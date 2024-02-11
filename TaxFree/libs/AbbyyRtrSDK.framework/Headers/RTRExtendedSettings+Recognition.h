/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import "RTRExtendedSettings.h"

/// Extended service configuration settings. Settings for advanced using. Not used in typical scenarios.
@interface RTRExtendedSettings (Recognition)

/// Enables or disables frame merging (default is true).
@property (nonatomic, assign, getter = isFrameMergingEnabled) BOOL frameMergingEnabled;
/// Enables or disables vertical text in CJK (default is true).
@property (nonatomic, assign, getter = isCJKVerticalTextEnabled) BOOL CJKVerticalTextEnabled;

@end
