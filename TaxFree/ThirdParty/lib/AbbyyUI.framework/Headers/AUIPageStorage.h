/// ABBYY® Mobile Capture © 2019 ABBYY Production LLC.
/// ABBYY is a registered trademark or a trademark of ABBYY Software Ltd.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* AUIPageId;

#pragma mark -

/**
 Storage API. You can implement custom storage if in some reason the default one (see 'AUIImageStorageFactory' interface) is not acceptable. For advanced users.
 */
@protocol AUIPageStorage <NSObject>

/**
Writes empty record to the storage.

@param error If there is an error, upon return contains an error object that describes the problem.
@return Returns identifier associated with new record in the storage.
*/
- (nullable AUIPageId)createWithError:(NSError**)error;

/**
 Returns the data associated with a given key.

 @param identifier Record id.
 @param key The key for which to return the corresponding data.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns the data associated with a given key or nil on error.
 */
- (nullable NSData*)loadDataForPage:(AUIPageId)identifier key:(NSString*)key error:(NSError**)error;

/**
 Adds new key-value pair to the record.

 @param identifier Record id.
 @param data The value for key. Use nil data to remove associated pair from the record.
 @param key The key for value. If key already exists, data are replaced.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns YES on success or NO on error.
 */
- (BOOL)storeData:(nullable NSData*)data page:(AUIPageId)identifier key:(NSString*)key error:(NSError**)error;

/**
 Removes record from storage.

 @param identifier Record id.
 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns YES on success or NO on error.
 */
- (BOOL)deleteWithId:(AUIPageId)identifier error:(NSError**)error;

/**
 Returns all record identifers in the storage.

 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns all record identifers or nil on error.
 */
- (nullable NSArray<AUIPageId>*)pagesWithError:(NSError**)error;

/**
 Removes all images.

 @param error If there is an error, upon return contains an error object that describes the problem.
 @return Returns YES on success or NO on error.
 */
- (BOOL)clearWithError:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
