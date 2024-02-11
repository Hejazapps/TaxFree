/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@class RTRDataFieldInfo;

/// Represents the data scheme applied to the recognized frame.
RTR_API_LINKAGE
@interface RTRDataScheme : NSObject

/// The scheme identifier.
@property (nonatomic, copy, readonly) NSString* id;
/// The human-readable name of the scheme.
@property (nonatomic, copy, readonly) NSString* name;
/// Supported fields.
@property (nonatomic, copy, readonly) NSArray<RTRDataFieldInfo*>* fields;

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
