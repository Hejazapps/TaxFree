/// ABBYY Mobile Capture © 2020 ABBYY Development, Inc.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

/// Extended information about the character's formatting.
RTR_API_LINKAGE
@interface RTRCharInfo : NSObject

/// The bounding rectangle.
@property (nonatomic, assign, readonly) CGRect rect;
/// Four vertices of the bounding quadrangle.
@property (nonatomic, strong, readonly, nullable) NSArray<NSValue*>* quadrangle;
/// The color of the symbol.
@property (nonatomic, assign, readonly) NSInteger foregroundColor;
/// The color of the background.
@property (nonatomic, assign, readonly) NSInteger backgroundColor;

@property (nonatomic, assign, readonly) BOOL isItalic;
@property (nonatomic, assign, readonly) BOOL isBold;
@property (nonatomic, assign, readonly) BOOL isUnderlined;
@property (nonatomic, assign, readonly) BOOL isStrikethrough;
@property (nonatomic, assign, readonly) BOOL isSmallcaps;
@property (nonatomic, assign, readonly) BOOL isSuperscript;
@property (nonatomic, assign, readonly) BOOL isUncertain;

- (instancetype)init __unavailable;

@end

#pragma mark - RTRTextLine

/// A line of recognized (translated) text; the location and additional information are also available.
RTR_API_LINKAGE
@interface RTRTextLine : NSObject

/// The recognized (translated) text.
@property (nonatomic, strong, readonly) NSString* text;
/// The bounding rectangle.
@property (nonatomic, assign, readonly) CGRect rect;
/// Four vertices of the bounding quadrangle.
@property (nonatomic, strong, readonly) NSArray<NSValue*>* quadrangle;
/// Additional information about the characters (may be nil).
@property (nonatomic, strong, readonly, nullable) NSArray<RTRCharInfo*>* charsInfo;

/// YES for right-to-left lines of text.
@property (nonatomic, assign, readonly) BOOL isRTL;

- (instancetype)init __unavailable;

@end

#pragma mark - RTRTextBlock

/// The RTRTextBlock is a collection of lines of recognized text.
RTR_API_LINKAGE
@interface RTRTextBlock : NSObject

/// Lines of recognized text.
@property (nonatomic, strong, readonly) NSArray<RTRTextLine*>* textLines;

- (instancetype)init __unavailable;

@end

NS_ASSUME_NONNULL_END
