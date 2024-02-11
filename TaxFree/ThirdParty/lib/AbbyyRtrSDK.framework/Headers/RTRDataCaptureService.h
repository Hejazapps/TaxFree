/// ABBYY Mobile Capture © 2020 ABBYY Development, Inc.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <AVFoundation/AVFoundation.h>

#import "RTRRecognitionService.h"
#import "RTRConstants.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - RTRDataCaptureService

@protocol RTRDataFieldBuilder;
@protocol RTRDataSchemeBuilder;
@protocol RTRDataCaptureProfileBuilder;

/**
 * A background data capture recognition service.
 */
@protocol RTRDataCaptureService <RTRRecognitionService>

/**
 * Creates a profile builder object with which you will be able to configure the data capture service
 * to recognize a custom field.
 *
 * @return Profile builder object or nil in unsupported scenarios.
 */
- (nullable id<RTRDataCaptureProfileBuilder>)configureDataCaptureProfile;

@end

#pragma mark -

/**
 * Signature for a callback field validation block.
 */
typedef BOOL (^RTRFieldPredicateBlock)(NSString* value);

/**
 * Describes a field which should be extracted by the data capture service.
 */
@protocol RTRDataFieldBuilder

/**
 * The field name.
 * Field name will be returned by the callback delegate methods.
 */
- (id<RTRDataFieldBuilder>)setName:(NSString*)name;

/**
 * A regular expression against which the field should be validated in the custom data capture scenario.
 */
- (id<RTRDataFieldBuilder>)setRegEx:(NSString*)regEx;

/**
 * Sets a user-defined validation block which will be used to verify the recognized field data.
 *
 * The validation block is called only after the data passes the regular expression check.
 * If no validation block is specified, the field is captured on the basis of the regular
 * expression only.
 */
- (id<RTRDataFieldBuilder>)setPredicateBlock:(RTRFieldPredicateBlock)predicateBlock;

@end

#pragma mark -

/**
 * A protocol for the scheme builder object. Using the scheme builder you will be able to add the data field
 * and define the rules to which it should conform.
 */
@protocol RTRDataSchemeBuilder

/**
 * Sets the scheme name.
 *
 * @return self
 */
- (id<RTRDataSchemeBuilder>)setName:(NSString*)name;

/**
 * Creates a new data field in the scheme.
 * @param id Field identifier.
 *
 * @return Field builder object.
 */
- (id<RTRDataFieldBuilder>)addField:(NSString*)id;

@end

#pragma mark -

/**
 * Profile builder. Allows you to create a custom profile for data capture scenarios.
 */
@protocol RTRDataCaptureProfileBuilder

/**
 * Sets the languages to be used for recognition.
 *
 * Setting the correct languages for your text will improve
 * recognition accuracy. However, setting too many languages may slow down performance.
 *
 * @param languages The set of languages to be used for recognition.
 *
 * @return self
 */
- (id<RTRDataCaptureProfileBuilder>)setRecognitionLanguages:(NSSet<RTRLanguageName>*)languages;

/**
 * By default, only the 'Normal' text type is set. This is sufficient in most cases.
 * Setting the correct text type for your text could improve the accuracy of recognition.
 * However, setting multiple text types may slow down the performance.
 *
 * @param textTypes one or more text types to be used for recognition.
 *
 * @return self
 */
- (id<RTRDataCaptureProfileBuilder>)setTextTypes:(NSSet<RTRTextType>*)textTypes;

/**
 * Create a new scheme in the profile.
 *
 * @param id The scheme identifier.
 *
 * @return Scheme builder object or nil in unsupported scenarios.
 */
- (nullable id<RTRDataSchemeBuilder>)addScheme:(NSString*)id;

/**
 * Submit the created profile for use in the data capture service.
 *
 * @return Error object in case an error occurs while submitting profile, otherwise - nil.
 */
- (nullable NSError*)checkAndApply;

@end

NS_ASSUME_NONNULL_END
