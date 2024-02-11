//
//  CommonFunc.h
//  CloudWings
//
//  Created by Admin on 7/22/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>


@interface CommonFunc : NSObject

// Utils
+ (BOOL)isNetworkAvailable;

+ (void) delayForSecond:(NSInteger)delay;
+ (void)saveUserDefaults:(NSString *)key value:(id)value;
+ (id)getValuesForKey:(NSString *)key;

+ (void)saveArrayToLocal:(NSMutableArray*)destArray key:(NSString*)key;
+ (NSMutableArray*)getArrayToLocal:(NSString*)key;
+ (void)deleteLocalArray:(NSString*)key;

+ (void) createBackButtonWithController:(UIViewController*) controller andSelector:(SEL) selector;
+ (void) createLeftNavButtonWithImage: (UIImage*) image withController:(UIViewController*) controller andSelector:(SEL) selector;
+ (void) createLeftNavButtonWithName: (NSString*) Name withController:(UIViewController*) controller andSelector:(SEL) selector;
+ (void) createLeftNavButtonWithImageName: (NSString*) imageName withController:(UIViewController*) controller andSelector:(SEL) selector;
+ (void) createRightNavButtonWithImageName: (NSString*) imageName withController:(UIViewController*) controller andSelector: (SEL) selector;
+ (void) createRightNavButtonWithName: (NSString*) Name withController:(UIViewController*) controller andSelector: (SEL) selector;
+ (void) imageviewScaleAnimation:(CALayer*)srcLayer;

+ (NSString*) copyResourceFileToDocuments:(NSString*)fileName withExt:(NSString*)fileExt;

+(NSString*)ConvertDictionarytoXML:(NSDictionary*)dictionary withStartElement:(NSString*)startelement;

+ (BOOL) validateEmail: (NSString *) candidate;

+ (UIImage *)imageResize :(UIImage*)img size:(CGSize)Size;
+ (UIImage *)signImageResize :(UIImage*)img size:(CGSize)Size;

+ (void)copyBundleDBToAppDocument;
+ (NSString *) makeStringForDB:(NSString *)original;

+ (NSString *) getStringFromDate:(NSDate *)date;
+ (NSDate *) getDateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSDate *) getDateFromString:(NSString *)dateString;
+ (NSString *) getDateStringWithFormat:(NSDate *)date format:(NSString *)format;

+ (UIColor *)getColorFromHex:(NSString *)hexStr;

+ (NSString *)stringPaddingLeft:(NSString *)oldString newLength:(NSUInteger)newLength;
+ (long long) getSeq:(NSString *) strKey;
+ (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileLocation;

+ (void) InsertSlip:(NSMutableDictionary *) jsonSlip arrItems:(NSMutableArray *) arrItems jsonSlipDocs:(NSMutableDictionary *) jsonSlipDocs;
+ (void) InsertSlip:(NSMutableDictionary *) jsonSlip jsonSlipDocs:(NSMutableDictionary *) jsonSlipDocs;
+ (void) InsertSlipSign:(NSMutableDictionary *) jsonSlipSign;
+ (BOOL) isExistSlip:(NSString *)slipNo;

+ (NSMutableArray *) SearchSlips:(NSString *) strStartDate strEndDate:(NSString *) strEndDate strSendFlag:(NSString *)strSendFlag strSlipStatus:(NSString *)strSlipStatus strSlipNo:(NSString *)strSlipNo;
+ (NSMutableArray *) SearchSlipDetail:(NSString *) strSlipNo;
+ (NSMutableDictionary *) getRCTInfo :(NSString *) strSlipNo;
+ (NSMutableDictionary *) BuildSlipDoc:(NSString *) strSlipNo;
+ (BOOL) Upi_BinCHeck:(NSString *) strCardNo;
+ (BOOL) QQ_Check:(NSString *) strQQID;

+ (NSString *)imageToNSString:(UIImage *)image;
+ (UIImage *)getImageFromBase64:(NSString *)string;

+ (NSMutableDictionary *) getParseDocid:(NSString *) docid;
+ (NSMutableDictionary *) getParseRetailer:(NSString *) retailer;
+ (NSMutableDictionary *) getParseTourist:(NSString *) tourist;
+ (NSMutableDictionary *) getParseGoods:(NSString *) goods;
+ (NSMutableDictionary *) getParseAdsInfo:(NSString *) adsinfo;
+ (NSMutableDictionary *) getParseRefundWayInfo:(NSString *) refundwayinfo;

+ (NSString *)getCommaString:(NSString *)oldString;
+ (UIImage *)screenShotScrollView:(UIScrollView *)scrollView;
+ (UIImage *)screenShotUIView:(UIView *)view;
+ (NSData *) createPdfFromView:(UIView *)aView;
+ (NSString *) DictionaryToString:(NSMutableDictionary *)dictionary;

+ (BOOL) validateName: (NSString *) candidate;
+ (BOOL) validateNumber: (NSString *) candidate;

+ (NSArray *)readJapanStates;
+ (NSArray *)searchAddress:(NSString *)stateString keyString:(NSString *)keyString;


+ (NSString*) getOsVersion;
+ (NSString*) getModel;
+ (NSString *)getModelName;
+ (NSString *)deviceModelName;

+ (NSString *)convertNumberToJapaneseString:(NSString *)numberString;
@end
