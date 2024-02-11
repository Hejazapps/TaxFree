/// ABBYY Mobile Capture © 2020 ABBYY Development, Inc.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <AVFoundation/AVFoundation.h>

#import "RTRRecognitionService.h"
#import "RTRConstants.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - RTRTextCaptureService

/**
 * A background text recognition service.
 */
@protocol RTRTextCaptureService <RTRRecognitionService>

/**
 * Sets the languages to be used for recognition.
 *
 * Setting the correct languages for your text will improve
 * recognition accuracy. However, setting too many languages may slow down performance.
 *
 * @param recognitionLanguages The set of languages to be used for recognition.
 */
- (void)setRecognitionLanguages:(NSSet<RTRLanguageName>*)recognitionLanguages;

/**
 * By default, only the 'Normal' text type is set. This is sufficient in most cases.
 * Setting the correct text type for your text could improve the accuracy of recognition.
 * However, setting multiple text types may slow down the performance.
 *
 * @param textTypes one or more text types to be used for recognition.
 */
- (void)setTextTypes:(NSSet<RTRTextType>*)textTypes;

/**
 * Sets the name of the translation dictionary.
 *
 * By default, no translation dictionary is used. Translation dictionaries should be
 * put in the 'Translation' subfolder of the app bundle.
 *
 * @param dictionaryName The name of the translation dictionary. Set nil for default value.
 */
- (void)setTranslationDictionary:(nullable NSString*)dictionaryName;

@end

NS_ASSUME_NONNULL_END
