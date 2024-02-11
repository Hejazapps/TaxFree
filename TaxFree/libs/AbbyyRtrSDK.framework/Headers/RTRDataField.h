/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@class RTRCharInfo;
@class RTRDataField;
@class RTRDataFieldInfo;

/// Field description.
RTR_API_LINKAGE
@interface RTRDataFieldInfo : NSObject

/// Field Identifier.
@property (nonatomic, copy, readonly) NSString* id;
/// Extended localized field description.
@property (nonatomic, copy, readonly) NSString* name;
/// In some cases the field contains several components, like for example passport number or last name.
@property (nonatomic, copy, readonly, nullable) NSArray<RTRDataFieldInfo*>* components;

- (instancetype)init __unavailable;

@end

/// Field of recognized DataCapture scenario.
RTR_API_LINKAGE
@interface RTRDataField : NSObject

/// Field Identifier.
@property (nonatomic, copy, readonly, nullable) NSString* id;
/// Extended localized (RU) field description.
@property (nonatomic, copy, readonly, nullable) NSString* name;
/// Recognized text value for field.
@property (nonatomic, copy, readonly, nullable) NSString* text;
/// The bounding rectangle.
@property (nonatomic, assign, readonly) CGRect rect;
/// Four vertices of the bounding quadrangle.
@property (nonatomic, copy, readonly, nullable) NSArray<NSValue*>* quadrangle;
/// Additional information about the characters (may be nil).
@property (nonatomic, copy, readonly, nullable) NSArray<RTRCharInfo*>* charsInfo;
/// In some cases the field contains several components, like for example passport number or last name.
@property (nonatomic, copy, readonly, nullable) NSArray<RTRDataField*>* components;

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
