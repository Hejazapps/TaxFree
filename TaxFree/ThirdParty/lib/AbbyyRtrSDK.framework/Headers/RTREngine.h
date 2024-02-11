/// ABBYY Mobile Capture © 2020 ABBYY Development, Inc.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>
#import "RTRDefinitions.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RTRCoreAPI;

#pragma mark - RTREngine

/**
 * The main ABBYY Mobile Capture SDK class which serves to initialize the library
 * and create a background recognition service and core API objects.
 */
RTR_API_LINKAGE
@interface RTREngine : NSObject

/**
 * Returns the shared instance ot the engine or nil if there was no successful calls of `+ sharedEngineWithLicenseData:` method.
 *
 * @return The RTREngine object or nil.
 */
@property (class, atomic, strong, readonly, nullable) RTREngine* sharedEngine;

/**
 * Creates (or returns) the RTREngine object. Repeated calls to this method will result in the same object instance.
 *
 * @param licenseData The license data to initialize ABBYY Mobile Capture SDK.
 *
 * @return The RTREngine object or nil on failure.
 */
+ (nullable instancetype)sharedEngineWithLicenseData:(NSData*)licenseData;

- (instancetype)init __unavailable;

- (void)unload;

/**
 * Creates a core API object, which provides access to low-level single image processing functions for the current thread.
 *
 * @return An object that conforms to RTRCoreAPI protocol.
 */
- (id<RTRCoreAPI>)createCoreAPI;

@end

NS_ASSUME_NONNULL_END
