/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#pragma mark -

#import <Foundation/Foundation.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Output stream protocol.
 */
@protocol RTROutputStream
@required

/** Write the provided 'data' to the receiver. */
- (BOOL)writeData:(NSData*)data;

@end

#pragma mark -

/** An initialized output stream that will write stream data to memory. */
RTR_API_LINKAGE
@interface RTRMemoryOutputStream : NSObject <RTROutputStream>

/** Access to the contents of the memory stream. */
@property (nonatomic, strong, readonly) NSData* data;

@end

#pragma mark -

/** An initialized output stream for writing to a specified file. */
RTR_API_LINKAGE
@interface RTRFileOutputStream : NSObject <RTROutputStream>

/** The path to the file the output stream will write to. */
@property (nonatomic, copy, readonly) NSString* filePath;

/** Error occured, equals to nil on success. */
@property (nonatomic, copy, readonly, nullable) NSError* error;

/** Returns an initialized output stream for writing to a specified 'filePath'. */
- (instancetype)initWithFilePath:(NSString*)filePath DEPRECATED_MSG_ATTRIBUTE("Use -initWithFilePath:error: instead");

/** Returns an initialized output stream for writing to a specified 'filePath' or nil if error occured. */
- (nullable instancetype)initWithFilePath:(NSString*)filePath error:(NSError**)error;

@end

#pragma mark -

/** An initialized output stream for writing to a specified 'stream'. */
RTR_API_LINKAGE
@interface RTROutputStream : NSObject <RTROutputStream>

/** The outputStream the receiver will write to. */
@property (nonatomic, strong, readonly) NSOutputStream* outputStream;

/** Error occured, equals to nil on success. */
@property (nonatomic, copy, readonly, nullable) NSError* error;

/**
 * Returns an initialized output stream for writing to a specified 'outputStream'.
 * The 'outputStream' must be opened before using.
 */
- (instancetype)initWithOutputStream:(NSOutputStream*)outputStream;

@end

NS_ASSUME_NONNULL_END
