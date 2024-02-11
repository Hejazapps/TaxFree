//
//  CommonFunc.m
//  CloudWings
//
//  Created by Admin on 7/22/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "CommonFunc.h"
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation CommonFunc

+ (BOOL)isNetworkAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    
    BOOL canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}

+ (void) delayForSecond:(NSInteger)delay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
    });
}
+ (void)saveUserDefaults:(NSString *)key value:(id)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    
    [defaults synchronize];
    
}

+ (id)getValuesForKey:(NSString *)key
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)saveArrayToLocal:(NSMutableArray*)destArray key:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:destArray forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray*)getArrayToLocal:(NSString*)key
{
    NSMutableArray* destArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:key] mutableCopy];
    return destArray;
}

+ (void)deleteLocalArray:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (void) createLeftNavButtonWithImageName: (NSString*) imageName withController:(UIViewController*) controller andSelector:(SEL) selector {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 36.2f, 36.2f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-10.0f, 0.0f, 36.2f, 36.2f)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton addSubview:imageView];
    [leftButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
}

+ (void) createLeftNavButtonWithName: (NSString*) Name withController:(UIViewController*) controller andSelector:(SEL) selector {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 40.0f)];
    [leftButton setTitle:Name forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
}


+ (void) createLeftNavButtonWithImage: (UIImage*) image withController:(UIViewController*) controller andSelector:(SEL) selector {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 40.0f)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    controller.navigationItem.leftBarButtonItem = backButtonItem;
}

+ (void) createBackButtonWithController:(UIViewController*) controller andSelector:(SEL) selector {
    
    [controller.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    controller.navigationController.navigationBar.shadowImage = [UIImage new];
    controller.navigationController.navigationBar.translucent = YES;
    controller.navigationController.view.backgroundColor = [UIColor clearColor];
    
    UIImage *iconImage = [UIImage imageNamed:@"fa-angle-left"];
    [self createLeftNavButtonWithImage:[iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withController:controller andSelector:selector];
}

+ (void) createRightNavButtonWithImageName: (NSString*) imageName withController:(UIViewController*) controller andSelector: (SEL) selector {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 34.0f, 34.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 34.0f, 34.0f)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightButton addSubview:imageView];
    [rightButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    controller.navigationItem.rightBarButtonItem = backButtonItem;
}

+ (void) createRightNavButtonWithName: (NSString*) Name withController:(UIViewController*) controller andSelector: (SEL) selector {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 40.0f)];
    [rightButton setTitle:Name forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    controller.navigationItem.rightBarButtonItem = backButtonItem;
}

+ (void) imageviewScaleAnimation:(CALayer*)srcLayer
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5),@(5.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(1.0),@(2.5)];
    k.calculationMode = kCAAnimationLinear;
    
    [srcLayer addAnimation:k forKey:@"SHOW"];
}

+ (NSString*) copyResourceFileToDocuments:(NSString*)fileName withExt:(NSString*)fileExt
{
    //Look at documents for existing file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExt]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:path])
        {
        NSError *nError;
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExt inDirectory:@"www"] toPath:path error:&nError];
        
        }
    
    return path;
}


+ (NSString*) ConvertDictionarytoXML:(NSDictionary*)dictionary withStartElement:(NSString*)startelement
{
    NSMutableString *xml = [[NSMutableString alloc] initWithString:@""];
    NSArray *arr = [dictionary allKeys];
    [xml appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    [xml appendString:[NSString stringWithFormat:@"<%@>",startelement]];
    for(int i=0;i<[arr count];i++)
        {
        id nodeValue = [dictionary objectForKey:[arr objectAtIndex:i]];
        if([nodeValue isKindOfClass:[NSArray class]] )
            {
            if([nodeValue count]>0){
                for(int j=0;j<[nodeValue count];j++)
                    {
                    id value = [nodeValue objectAtIndex:j];
                    if([ value isKindOfClass:[NSDictionary class]])
                        {
                        [xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                        [xml appendString:[NSString stringWithFormat:@"%@",[value objectForKey:@"text"]]];
                        [xml appendString:[NSString stringWithFormat:@"</%@>",[arr objectAtIndex:i]]];
                        }
                    
                    }
            }
            }
        else if([nodeValue isKindOfClass:[NSDictionary class]])
            {
            [xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
            if([[nodeValue objectForKey:@"Id"] isKindOfClass:[NSString class]])
                [xml appendString:[NSString stringWithFormat:@"%@",[nodeValue objectForKey:@"Id"]]];
            else
                [xml appendString:[NSString stringWithFormat:@"%@",[[nodeValue objectForKey:@"Id"] objectForKey:@"text"]]];
            [xml appendString:[NSString stringWithFormat:@"</%@>",[arr objectAtIndex:i]]];
            }
        
        else
            {
            if([nodeValue length]>0){
                [xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                [xml appendString:[NSString stringWithFormat:@"%@",[dictionary objectForKey:[arr objectAtIndex:i]]]];
                [xml appendString:[NSString stringWithFormat:@"</%@>",[arr objectAtIndex:i]]];
            }
            }
        }
    
    [xml appendString:[NSString stringWithFormat:@"</%@>",startelement]];
    NSString *finalxml=[xml stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    //  NSLog(@"%@",xml);
    return finalxml;
}

+ (BOOL) validateEmail: (NSString *) candidate {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) validateName: (NSString *) candidate {
    NSString *stricterFilterString = @"[A-Za-z]";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [nameTest evaluateWithObject:candidate];
}

+ (BOOL) validateNumber: (NSString *) candidate {
    NSString *stricterFilterString = @"[A-Z0-9a-z]";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [nameTest evaluateWithObject:candidate];
}

+(UIImage *)imageResize :(UIImage*)img size:(CGSize)Size
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    UIGraphicsBeginImageContext(Size);
    UIGraphicsBeginImageContextWithOptions(Size, NO, 1);
    [img drawInRect:CGRectMake(0,0,Size.width,Size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)signImageResize :(UIImage*)img size:(CGSize)Size
{
    UIGraphicsBeginImageContext(Size);
    UIGraphicsBeginImageContextWithOptions(Size, NO, 1);
    [img drawInRect:CGRectMake(0,0,Size.width,Size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)copyBundleDBToAppDocument
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *dbpath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, DatabaseName];
    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"TaxfreeDB" ofType:@"db"];
    NSError *error = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbpath]) {
        NSLog(@"DB exist");
        return;
    }
    
    if([[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:dbpath error:&error]) {
        NSLog(@"DB successfully copied");
    }
}


+ (NSString *) makeStringForDB:(NSString *)original {
    return [original stringByReplacingOccurrencesOfString:@"'" withString:@"’"];
}


+ (NSString *) getStringFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"ja"];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    NSString *strHour = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)hour] newLength:2];
    NSString *strMin = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)minute] newLength:2];
    NSString *strSec = [CommonFunc stringPaddingLeft:[NSString stringWithFormat:@"%ld", (long)second] newLength:2];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yy/MM/dd"];
    return [NSString stringWithFormat:@"%@ %@:%@:%@", [dateformat stringFromDate:date], strHour, strMin, strSec];
}

+ (NSDate *) getDateFromString:(NSString *)dateString {
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yy/MM/dd HH:mm:ss"];
    return [dateformat dateFromString:dateString];
}

+ (NSDate *) getDateFromString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:format];
    return [dateformat dateFromString:dateString];
}


+ (NSString *) getDateStringWithFormat:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    
    [dateformat setDateFormat:format];
    return [dateformat stringFromDate:date];
}


+ (UIColor *)getColorFromHex:(NSString *)hexStr
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1];
    
    return color;
}

+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}


+ (NSString *)stringPaddingLeft:(NSString *)oldString newLength:(NSUInteger)newLength
{
    if ([oldString length] < newLength)
        return [[@"" stringByPaddingToLength:newLength - [oldString length] withString:@"0" startingAtIndex:0] stringByAppendingString:oldString];
    else
        return oldString;
}

+ (long long) getSeq:(NSString *) strKey
{
    long long nSeq = 0;
    
    NSString *strValue = [CommonFunc getValuesForKey:strKey];
    
    if (strValue == nil) {
        [CommonFunc saveUserDefaults:strKey value:@"0"];
    }
    else {
        nSeq = [strValue longLongValue];
        nSeq++;
        if (nSeq == 10000) {
            nSeq = 0;
        }
        [CommonFunc saveUserDefaults:strKey value:[NSString stringWithFormat:@"%lld", nSeq]];
    }
    return nSeq;
}

+ (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileLocation {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}



+ (void) InsertSlip:(NSMutableDictionary *) jsonSlip arrItems:(NSMutableArray *) arrItems jsonSlipDocs:(NSMutableDictionary *) jsonSlipDocs
{
    //전표저장
    NSMutableDictionary *Slip = [[NSMutableDictionary alloc] initWithDictionary:jsonSlip];
    Slip[USERID] = kAppDelegate.LoginID;
    [[DatabaseManager sharedInstance] insertData:REFUNDSLIP_TABLE_KIND data:@[Slip]];
    
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrItems.count; i++) {
        NSMutableDictionary *Item = [[NSMutableDictionary alloc] initWithDictionary:arrItems[i]];
        Item[USERID] = kAppDelegate.LoginID;
        [itemList addObject:Item];
    }
    [[DatabaseManager sharedInstance] insertData:SALES_GOODS_TABLE_KIND data:itemList];
    
    
    NSMutableDictionary *SlipDocs = [[NSMutableDictionary alloc] initWithDictionary:jsonSlipDocs];
    SlipDocs[REG_DTM] = [self getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
    SlipDocs[USERID] = kAppDelegate.LoginID;
    [[DatabaseManager sharedInstance] insertData:SLIP_PRINT_DOCS_TABLE_KIND data:@[SlipDocs]];
}

+ (void) InsertSlip:(NSMutableDictionary *) jsonSlip jsonSlipDocs:(NSMutableDictionary *) jsonSlipDocs
{
    NSMutableDictionary *Slip = [[NSMutableDictionary alloc] initWithDictionary:jsonSlip];
    Slip[USERID] = kAppDelegate.LoginID;
    [[DatabaseManager sharedInstance] insertData:REFUNDSLIP_TABLE_KIND data:@[Slip]];
    
    NSMutableDictionary *SlipDocs = [[NSMutableDictionary alloc] initWithDictionary:jsonSlipDocs];
    SlipDocs[REG_DTM] = [self getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
    SlipDocs[USERID] = kAppDelegate.LoginID;
    [[DatabaseManager sharedInstance] insertData:SLIP_PRINT_DOCS_TABLE_KIND data:@[SlipDocs]];
    
}

+ (void) InsertSlipSign:(NSMutableDictionary *) jsonSlipSign
{
    NSMutableDictionary *SlipSign = [[NSMutableDictionary alloc] initWithDictionary:jsonSlipSign];
    SlipSign[USERID] = kAppDelegate.LoginID;
    [[DatabaseManager sharedInstance] insertData:REFUND_SLIP_SIGN_TABLE_KIND data:@[SlipSign]];
}

+ (BOOL) isExistSlip:(NSString *)slipNo {
    NSMutableArray *AllSlips = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:REFUNDSLIP_TABLE_KIND fieldName:USERID fieldValue:kAppDelegate.LoginID fieldName2:SLIP_NO fieldValue2:slipNo]];
    if (AllSlips.count > 0) {
        return YES;
    }
    return NO;
}
//전표 조회
//로컬DB 조회 또는 서버 조회 양쪽 공용으로 사용하기 위해서...
+ (NSMutableArray *) SearchSlips:(NSString *) strStartDate strEndDate:(NSString *) strEndDate strSendFlag:(NSString *)strSendFlag strSlipStatus:(NSString *)strSlipStatus strSlipNo:(NSString *)strSlipNo
{
    NSMutableDictionary *conditionData = [[NSMutableDictionary alloc] init];
    conditionData[USERID] = kAppDelegate.LoginID;
    if (strSlipNo && ![strSlipNo isEqualToString:@""]) {
        conditionData[SLIP_NO] = strSlipNo;
    }
    if (strSendFlag && ![strSendFlag isEqualToString:@""]) {
        if (![strSendFlag isEqualToString:@"ALL"]) {
            conditionData[SEND_FLAG] = strSendFlag;
        }
    }
    if (strSlipStatus && ![strSlipStatus isEqualToString:@""]) {
        if (![strSlipStatus isEqualToString:@"ALL"]) {
            conditionData[SLIP_STATUS_CODE] = strSlipStatus;
        }
    }
    
    NSMutableArray *allArray = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:REFUNDSLIP_TABLE_KIND conditionData:conditionData]];
    
    int StartDate = 20010101;
    int EndDate = 29991231;
    if (strStartDate) {
        StartDate = [strStartDate intValue];
    }
    if (strEndDate) {
        EndDate = [strEndDate intValue];
    }
    
    
    for (int i = 0; i < allArray.count; i++) {
        if ((StartDate > [allArray[i][@"REG_DTM"] intValue]) || (EndDate < [allArray[i][@"REG_DTM"] intValue])) {
            [allArray removeObjectAtIndex:i];
            i--;
        }
    }
    
    return allArray;
}

//세부항목조회
+ (NSMutableArray *) SearchSlipDetail:(NSString *) strSlipNo
{
    return [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:SALES_GOODS_TABLE_KIND fieldName:USERID fieldValue:kAppDelegate.LoginID fieldName2:SLIP_NO fieldValue2:strSlipNo]];
}

+ (NSMutableDictionary *) getRCTInfo :(NSString *) strSlipNo {
    NSMutableDictionary *RCTInfo = [[NSMutableDictionary alloc] init];
    NSMutableArray *allArray = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:SALES_GOODS_TABLE_KIND fieldName:USERID fieldValue:kAppDelegate.LoginID fieldName2:SLIP_NO fieldValue2:strSlipNo]];
    for (int i = 0; i < allArray.count; i++) {
        if (!(allArray[i][@"RCT_NO"] == nil)) {
            RCTInfo = allArray[i];
            break;
        }
    }
    
    return RCTInfo;
}

//서버 송신용 전문 생성
+ (NSMutableDictionary *) BuildSlipDoc:(NSString *) strSlipNo
{
    NSMutableArray *ArrItemsRet = [[NSMutableArray alloc] init];
    NSMutableArray *ArrSlipRet = [[NSMutableArray alloc] init];
    
    //로컬DB 조회 결과
    
    NSMutableDictionary *jsonSlip = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *arrSlip = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:REFUNDSLIP_TABLE_KIND fieldName:USERID fieldValue:kAppDelegate.LoginID fieldName2:SLIP_NO fieldValue2:strSlipNo]];
    
    NSMutableArray *ArrSlipItems = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:SALES_GOODS_TABLE_KIND fieldName:USERID fieldValue:kAppDelegate.LoginID fieldName2:SLIP_NO fieldValue2:strSlipNo]];
    
    if (arrSlip.count > 0) {
        for (int j = 0; j < arrSlip.count; j++) {
            NSMutableDictionary *jsonRet = arrSlip[j];
            NSMutableDictionary *SlipRet = [[NSMutableDictionary alloc] init];
            SlipRet[@"buyer_name"] = jsonRet[@"BUYER_NAME"];
            SlipRet[@"memo_text"] = jsonRet[@"MEMO_TEXT"];
            
            SlipRet[@"passport_serial_no"] = jsonRet[@"PASSPORT_SERIAL_NO"];
            SlipRet[@"permit_no"] = jsonRet[@"PERMIT_NO"];
            
            SlipRet[@"nationality_code"] = @"KOR";
            if (jsonRet[@"NATIONALITY_CODE"]) {
                SlipRet[@"nationality_code"] = jsonRet[@"NATIONALITY_CODE"];
            }
            
            SlipRet[@"gender_code"] = jsonRet[@"GENDER_CODE"];
            SlipRet[@"buyer_birth"] = jsonRet[@"BUYER_BIRTH"];
            SlipRet[@"pass_expirydt"] = jsonRet[@"PASS_EXPIRYDT"];
            SlipRet[@"input_way_code"] = jsonRet[@"INPUT_WAY_CODE"]; //여권스캐너 입력
            SlipRet[@"residence_no"] = jsonRet[@"RESIDENCE_NO"];
            
            SlipRet[@"entrydt"] = jsonRet[@"ENTRYDT"]; //상륙연월일
            SlipRet[@"passport_type"] = jsonRet[@"PASSPORT_TYPE"];
            SlipRet[@"slip_no"] = jsonRet[@"SLIP_NO"];
            SlipRet[@"merchant_no"] = jsonRet[@"MERCHANT_NO"];
            SlipRet[@"out_div_code"] = jsonRet[@"OUT_DIV_CODE"];
            SlipRet[@"refund_way_code"] = jsonRet[@"REFUND_WAY_CODE"];
            SlipRet[@"slip_status_code"] = jsonRet[@"SLIP_STATUS_CODE"];
            SlipRet[@"tml_id"] = jsonRet[@"TML_ID"];
            SlipRet[@"refund_cardno"] = jsonRet[@"REFUND_CARDNO"];
            SlipRet[@"refund_card_code"] = jsonRet[@"REFUND_CARD_CODE"];
            SlipRet[@"total_slipseq"] = jsonRet[@"TOTAL_SLIPSEQ"];
            SlipRet[@"tax_proc_time_code"] = jsonRet[@"TAX_PROC_TIME_CODE"];
            
            
            SlipRet[@"unikey"] = jsonRet[@"UNIKEY"];
            
            SlipRet[@"saledt"] = jsonRet[@"SALEDT"];
            SlipRet[@"refunddt"] = jsonRet[@"REFUNDDT"];
            SlipRet[@"userId"] = jsonRet[@"USERID"];
            SlipRet[@"merchantNo"] = jsonRet[@"MERCHANTNO"];
            SlipRet[@"deskId"] = jsonRet[@"DESKID"];
            SlipRet[@"companyID"] = jsonRet[@"COMPANYID"];
            
            SlipRet[@"refund_note"] = jsonRet[@"REFUND_NOTE"];
            SlipRet[@"type"] = jsonRet[@"TYPE"];
            SlipRet[@"a_issue_date"] = jsonRet[@"A_ISSUE_DATE"];
            SlipRet[@"jp_addr1"] = jsonRet[@"JP_ADDR1"];
            SlipRet[@"jp_addr2"] = jsonRet[@"JP_ADDR2"];
            SlipRet[@"agency"] = jsonRet[@"AGENCY"];
            SlipRet[@"a_issue_no"] = jsonRet[@"A_ISSUE_NO"];
            
            SlipRet[@"s_m_fee"] = jsonRet[@"S_M_FEE"];
            SlipRet[@"s_g_fee"] = jsonRet[@"S_G_FEE"];
            SlipRet[@"merchant_fee"] = jsonRet[@"MERCHANT_FEE"];
            SlipRet[@"gtf_fee"] = jsonRet[@"GTF_FEE"];
            SlipRet[@"p_input_type"] = jsonRet[@"P_INPUT_TYPE"];
            
            SlipRet[@"app_type"] = @"iOS";
            SlipRet[@"app_device"] = [self deviceModelName];
            SlipRet[@"app_os"] = [self getOsVersion];
            SlipRet[@"version_info"] = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
            
            //1. 전표정보
            long total_comm_sale_amt = 0;
            long total_comm_tax_amt = 0;
            long total_comm_refund_amt = 0;
            long total_comm_fee_amt = 0;
            
            long total_excomm_sale_amt = 0;
            long total_excomm_tax_amt = 0;
            long total_excomm_refund_amt = 0;
            long total_excomm_fee_amt = 0;
            
            
            //2. 물품정보
            for (int i = 0; i < ArrSlipItems.count; i++) {
                NSMutableDictionary *tempObj = [[NSMutableDictionary alloc] init];
                NSMutableDictionary *jsonRetItem = ArrSlipItems[i];
                
                tempObj[@"slip_no"] = strSlipNo;
                tempObj[@"sale_seq"] = jsonRetItem[@"ITEM_NO"];
                tempObj[@"rec_no"] = jsonRetItem[@"RCT_NO"];
                tempObj[@"tax_amt"] = jsonRetItem[@"TAX_AMT"];
                tempObj[@"refund_amt"] = jsonRetItem[@"REFUND_AMT"];
                tempObj[@"fee_amt"] = jsonRetItem[@"FEE_AMT"];
                tempObj[@"goods_items_code"] = jsonRetItem[@"ITEM_TYPE"];
                tempObj[@"goods_group_code"] = jsonRetItem[@"MAIN_CAT"];
                tempObj[@"goods_division"] = jsonRetItem[@"MID_CAT"];//@"C0167";
                tempObj[@"tax_proc_time_code"] = jsonRetItem[@"TAX_TYPE"];
                if (jsonRetItem[@"TAX_TYPE_CODE"]) {
                    tempObj[@"tax_type"] = jsonRetItem[@"TAX_TYPE_CODE"];
                }
                else {
                    tempObj[@"tax_type"] = @"2";
                }
                tempObj[@"goods_amt"] = jsonRetItem[@"BUY_AMT"];
                tempObj[@"tax_point_proc_code"] = jsonRet[@"TAX_POINT_PROC_CODE"];
                tempObj[@"goods_qty"] = jsonRetItem[@"QTY"];
                tempObj[@"goods_unit_price"] = jsonRetItem[@"UNIT_AMT"];
                tempObj[@"goods_name"] = jsonRetItem[@"ITEM_NAME"];
                tempObj[@"goods_tax_code"] = @"SCT";
                tempObj[@"same_unit_saleAmt"] = @"Y";
                tempObj[@"worker_id"] =  kAppDelegate.LoginID;
                
                
                ////소비용품
                //if ("A0002".Equals(jsonRetItem[@"ITEM_TYPE"])
                //{
                //    total_comm_sale_amt += Int64.Parse(jsonRetItem[@"BUY_AMT"];    //소비용품 판매액 합산 //(Int64.Parse(jsonRetItem[@"BUY_AMT"] - Int64.Parse(jsonRetItem[@"TAX_AMT"]);//내세토탈 판매액
                //    total_comm_tax_amt += Int64.Parse(jsonRetItem[@"TAX_AMT"];   //내세 세금합산
                //    total_comm_refund_amt += Int64.Parse(jsonRetItem[@"REFUND_AMT"]; //내세 환급금 합산
                //}
                //else
                //{
                //    total_excomm_sale_amt += Int64.Parse(jsonRetItem[@"BUY_AMT"];    //외세 판매액 합산
                //    total_excomm_tax_amt += Int64.Parse(jsonRetItem[@"TAX_AMT"];     //외세 세금 합산
                //    total_excomm_refund_amt += Int64.Parse(jsonRetItem[@"REFUND_AMT"];   //외세 환급금 합산
                //}
                [ArrItemsRet addObject:tempObj];
            }
            
            
            total_excomm_sale_amt = [jsonRet[@"GOODS_BUY_AMT"] intValue];
            total_excomm_tax_amt = [jsonRet[@"GOODS_TAX_AMT"] intValue];
            total_excomm_refund_amt = [jsonRet[@"GOODS_REFUND_AMT"] intValue];
            
            total_comm_sale_amt = [jsonRet[@"CONSUMS_BUY_AMT"] intValue];
            total_comm_tax_amt = [jsonRet[@"CONSUMS_TAX_AMT"] intValue];
            total_comm_refund_amt = [jsonRet[@"CONSUMS_REFUND_AMT"] intValue];
            
            SlipRet[@"total_excomm_in_tax_sale_amt"] = jsonRet[@"TOTAL_EXCOMM_IN_TAX_SALE_AMT"];
            SlipRet[@"total_comm_in_tax_sale_amt"] = jsonRet[@"TOTAL_COMM_IN_TAX_SALE_AMT"];
            
            total_comm_fee_amt = total_comm_tax_amt - total_comm_refund_amt;//소비용품 총 수수료
            total_excomm_fee_amt = total_excomm_tax_amt - total_excomm_refund_amt;//일반물품 총 수수료
            
            //소비용품
            SlipRet[@"comm"] = @"";
            if (total_comm_sale_amt > 0) {
                SlipRet[@"comm"] = @"A0002";
            }
            
            SlipRet[@"total_comm_sale_amt"] = [NSString stringWithFormat:@"%ld", total_comm_sale_amt];
            SlipRet[@"total_comm_tax_amt"] = [NSString stringWithFormat:@"%ld", total_comm_tax_amt];
            SlipRet[@"total_comm_refund_amt"] = [NSString stringWithFormat:@"%ld", total_comm_refund_amt];
            SlipRet[@"total_comm_fee_amt"] = [NSString stringWithFormat:@"%ld", total_comm_fee_amt];
            
            //일반용품
            SlipRet[@"excomm"] = @"";
            if (total_excomm_sale_amt > 0) {
                SlipRet[@"excomm"] = @"A0001";
            }
            SlipRet[@"total_excomm_sale_amt"] = [NSString stringWithFormat:@"%ld", total_excomm_sale_amt];
            SlipRet[@"total_excomm_tax_amt"] = [NSString stringWithFormat:@"%ld", total_excomm_tax_amt];
            SlipRet[@"total_excomm_refund_amt"] = [NSString stringWithFormat:@"%ld", total_excomm_refund_amt];
            SlipRet[@"total_excomm_fee_amt"] = [NSString stringWithFormat:@"%ld", total_excomm_fee_amt];
            
            SlipRet[@"remit_amt"] = [NSString stringWithFormat:@"%ld", (total_comm_refund_amt + total_excomm_refund_amt)];
            
            SlipRet[@"saleGoodsList"] = ArrItemsRet;
            
            [ArrSlipRet addObject:SlipRet];
            
            jsonSlip[@"slipList"] = ArrSlipRet;
        }
        jsonSlip[@"userId"] = kAppDelegate.LoginID;
        jsonSlip[@"companyID"] = COMPANY_ID;
        jsonSlip[@"languageCD"] = LANGUAGE;
        jsonSlip[@"merchantNo"] = [CommonFunc getValuesForKey:MERCHANT_NO];
        jsonSlip[@"deskId"] = [CommonFunc getValuesForKey:DESK_ID];
    }
    
    return jsonSlip;
}

//UPI Bin 체크
+ (BOOL) Upi_BinCHeck:(NSString *) strCardNo
{
    BOOL bRet = NO;
    NSString *CardNo = [strCardNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSMutableArray *arrjsonRes = [[NSMutableArray alloc] initWithArray:[CommonFunc getArrayToLocal:BIN_LIST]];
    for (int i = 0; i < arrjsonRes.count; i++) {
        if (![arrjsonRes[i][@"BIN"] isEqualToString:CardNo] || ![arrjsonRes[i][@"PAN_LENGTH"] isEqualToString:[NSString stringWithFormat:@"%lu", (unsigned long)CardNo.length]]) {
            [arrjsonRes removeObjectAtIndex:i];
            i--;
        }
    }
    
    if (arrjsonRes.count > 0)
        bRet = YES;
    return bRet;
}

//QQ 체크
+ (BOOL) QQ_Check:(NSString *) strQQID
{
    BOOL bRet = YES;
    long long tempDec = [strQQID longLongValue];
    //데이터 체크
    if (tempDec < 10000 || tempDec > 4294967295)
        {
        bRet = NO;
        }
    return bRet;
}

+ (NSString *)imageToNSString:(UIImage *)image
{
    //    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData3 = UIImageJPEGRepresentation(image, 0.05);
    return [imageData3 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)getImageFromBase64:(NSString *)string
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (NSMutableDictionary *) getParseDocid:(NSString *) docid
{
    NSMutableDictionary *DocInfo = [[NSMutableDictionary alloc] init];
    NSArray *arrDocid = [docid componentsSeparatedByString:@"|"];
    
    DocInfo[@"LangCode"] = arrDocid[0];
    DocInfo[@"PublishCnt"] = arrDocid[1];
    DocInfo[@"PublishType"] = [arrDocid[2] componentsSeparatedByString:@"/"];
    DocInfo[@"RePublish"] = arrDocid[3];
    DocInfo[@"SlipNo"] = arrDocid[4];
    DocInfo[@"AllStoreAmtPrint"] = arrDocid[5];
    DocInfo[@"REFUND_WAY_CODE"] = arrDocid[6];
    DocInfo[@"REFUND_WAY_CODE_DESC"] = arrDocid[7];
    DocInfo[@"MASK_REMIT_NO"] = arrDocid[8];
    DocInfo[@"Unikey"] = arrDocid[9];
    
    return DocInfo;
}

+ (NSMutableDictionary *) getParseRetailer:(NSString *) retailer
{
    NSMutableDictionary *RetailerInfo = [[NSMutableDictionary alloc] init];
    NSArray *arrRetailer = [retailer componentsSeparatedByString:@"|"];
    
    RetailerInfo[@"TaxOffice"] = arrRetailer[0];
    RetailerInfo[@"TaxPlace1"] = arrRetailer[1];
    RetailerInfo[@"TaxPlace2"] = arrRetailer[2];
    RetailerInfo[@"Seller"] = arrRetailer[3];
    RetailerInfo[@"SellerAddr1"] = arrRetailer[4];
    RetailerInfo[@"SellerAddr2"] = arrRetailer[5];
    RetailerInfo[@"OptCorpJpnm"] = arrRetailer[6];
    
    return RetailerInfo;
}

+ (NSMutableDictionary *) getParseTourist:(NSString *) tourist
{
    NSMutableDictionary *TouristInfo = [[NSMutableDictionary alloc] init];
    NSArray *arrTourist = [tourist componentsSeparatedByString:@"|"];
    
    TouristInfo[@"PassportType"] = arrTourist[0];
    TouristInfo[@"PassportNo"] = arrTourist[1];
    TouristInfo[@"Name"] = [arrTourist[2] uppercaseString];
    TouristInfo[@"National"] = arrTourist[3];
    TouristInfo[@"Birth"] = [self getDateStringWithFormat:[self getDateFromString:arrTourist[4] format:@"yyyyMMdd"] format:@"yyyy-MM-dd"];
    TouristInfo[@"Residence"] = arrTourist[5];
    TouristInfo[@"LandingDate"] = [self getDateStringWithFormat:[self getDateFromString:arrTourist[6] format:@"yyyyMMdd"] format:@"yyyy-MM-dd"];
    
    return TouristInfo;
}


+ (NSMutableDictionary *) getParseGoods:(NSString *) goods
{
    /*//////////////////////////////////////////////////////////////////////////
     * Format
     * [0] : Sale Date          (8)
     * [1] : Item Type Seq      (3)
     *
     * { [2] ~ [7] X [1] }
     * [2] : Item Type Code     (2)
     * [3] : Goods Seq         (3)
     * { [4]~[7] x [3] }
     * [4] : Goods Name
     * [5] : Goods Unit Price
     * [6] : Goods Qty
     * [7] : Goods Amount
     *
     * [8] : Tax Amt
     * [9] : Sale Amt
     * [10] : Refund Amt
     *
     * [11] : Item Type Code
     * [12] : Goods Seq
     * { [13]~[16] x [12] }
     * [13] : Goods Name
     * [14] : Goods Unit Price
     * [15] : Goods Qty
     * [16] : Goods Amount
     *
     * [17] : Tax Amt
     * [18] : Sale Amt
     * [19] : Refund Amt
     *
     * [20] : Total Tax Amt
     * [21] : Total Sale Amt
     * [22] : Total Fee Amt
     * [23] : Total Refund Amt
     *
     * ex)
     * 20150310
     * 2
     *
     * 01
     * 2
     * a01 | 10000 | 1 | 10000
     * a02 | 10000 | 1 | 10000
     * 1600 | 20000 | 1280
     *
     * 02
     * 2
     * b01 | 10000 | 1 | 10000
     * b02 | 10000 | 1 | 10000
     * 1600 | 20000 | 1280
     *
     * 40000 | 2560 | 640 | 1920
     /////////////////////////////////////////////////////////////////////////*/
    NSMutableDictionary *GoodsInfo = [[NSMutableDictionary alloc] init];
    NSArray *arrGoods = [goods componentsSeparatedByString:@"|"];
    
    GoodsInfo[@"SaleDate"] = [self getDateStringWithFormat:[self getDateFromString:arrGoods[0] format:@"yyyyMMdd"] format:@"yyyy-MM-dd"];
    GoodsInfo[@"ItemTypeSeq"] = arrGoods[1];
    
    int nOffSet = 2;
    
    for (int i = 0; i < [GoodsInfo[@"ItemTypeSeq"] intValue]; i++)
        {
        NSMutableDictionary *ItemMap = [[NSMutableDictionary alloc] init];
        ItemMap[@"ItemTypeCode"] = arrGoods[nOffSet++];
        ItemMap[@"GoodsSeq"] = arrGoods[nOffSet++];
        
        for(int j = 0; j < [ItemMap[@"GoodsSeq"] intValue]; j++)
            {
            NSMutableDictionary *GoodsMap = [[NSMutableDictionary alloc] init];
            GoodsMap[@"Name"] = arrGoods[nOffSet++];
            GoodsMap[@"UnitPrice"] = arrGoods[nOffSet++];
            GoodsMap[@"Qty"] = arrGoods[nOffSet++];
            GoodsMap[@"Amt"] = arrGoods[nOffSet++];
            NSString *ItemMapKey = [NSString stringWithFormat:@"GoodsMap_%i", j];
            ItemMap[ItemMapKey] = GoodsMap;
            }
        ItemMap[@"SaleAmt"] = arrGoods[nOffSet++];
        ItemMap[@"TaxAmt"] = arrGoods[nOffSet++];
        ItemMap[@"RefundAmt"] = arrGoods[nOffSet++];
        if ([arrGoods[nOffSet] isEqualToString:@""])
            nOffSet++;
        else
            ItemMap[@"AllStoresTotalAmt"] = arrGoods[nOffSet++];
        
        
        NSString * MapGoodsKey =[NSString stringWithFormat:@"ItemsMap_%i", i];
        GoodsInfo[MapGoodsKey] = ItemMap;
        }
    GoodsInfo[@"TotalTaxAmt"] = arrGoods[nOffSet++];
    GoodsInfo[@"TotalSaleAmt"] = arrGoods[nOffSet++];
    GoodsInfo[@"TotalFeeAmt"] = arrGoods[nOffSet++];
    GoodsInfo[@"TotalRefundAmt"] = arrGoods[nOffSet];
    
    return GoodsInfo;
}

+ (NSMutableDictionary *) getParseAdsInfo:(NSString *) adsinfo
{
    NSMutableDictionary *AdsInfo = [[NSMutableDictionary alloc] init];
    
    if(adsinfo != nil && adsinfo.length > 0)
        {
        NSArray *arrAdsinfo = [adsinfo componentsSeparatedByString:@"|"];
        
        int idx = 0;
        AdsInfo[@"Count"] = arrAdsinfo[idx++];
        
        for(int i = 0; i < [AdsInfo[@"Count"] intValue]; i++)
            {
            NSMutableDictionary *AdsItemMap = [[NSMutableDictionary alloc] init];
            AdsItemMap[@"Type"] = arrAdsinfo[idx++];
            
            NSMutableArray *targetList = [[NSMutableArray alloc] init];
            int targetCount = [arrAdsinfo[idx++] intValue];
            for (int j = 0; j < targetCount; j++)
                [targetList addObject:arrAdsinfo[idx++]];
            
            AdsItemMap[@"Target"] = targetList;
            if ([AdsItemMap[@"Type"] isEqualToString:@"01"])  // IMAGE
                {
                AdsItemMap[@"IMG"] = arrAdsinfo[idx++];//URL 에서 이미지 데이터 로드하는것으로 변경
                }
            else if ([AdsItemMap[@"Type"] isEqualToString:@"02"])  // TEXT
                {
                NSMutableArray *adsTextList = [[NSMutableArray alloc] init];
                for (int j = 0; j < 5; j++)
                    {
                    if(![arrAdsinfo[idx] isEqualToString:@""])
                        [adsTextList addObject:arrAdsinfo[idx++]];
                    }
                AdsItemMap[@"TEXT"] = adsTextList;
                }
            AdsInfo[[NSString stringWithFormat:@"%i", i]] = AdsItemMap;
            }
        }
    
    return AdsInfo;
}

+ (NSMutableDictionary *) getParseRefundWayInfo:(NSString *) refundwayinfo
{
    NSMutableDictionary *RefundInfo = [[NSMutableDictionary alloc] init];
    NSArray *arrRefundInfo = [refundwayinfo componentsSeparatedByString:@"|"];
    
    RefundInfo[@"REFUND_WAY_CODE"] = arrRefundInfo[0];
    RefundInfo[@"REFUND_WAY_CODE_DESC"] = arrRefundInfo[1];
    RefundInfo[@"MASK_REMIT_NO"] = arrRefundInfo[2];
    
    return RefundInfo;
}

+ (NSString *)getCommaString:(NSString *)oldString {
    if (oldString.length >= 16) {
        oldString = [oldString substringToIndex:15];
    }
    long long oldNumber = [oldString longLongValue];
    NSNumber *number = [NSNumber numberWithLongLong: oldNumber];
    NSNumberFormatter *frmtr = [[NSNumberFormatter alloc] init]; [frmtr setGroupingSize:3];
    [frmtr setGroupingSeparator:@","];
    [frmtr setUsesGroupingSeparator:YES];
    NSString *commaString = [frmtr stringFromNumber:number];
    
    return commaString;
}


+ (UIImage *)screenShotScrollView:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointZero animated:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    UIImage *image = nil;
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, scale);
    {
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil){
        return image;
    }
    return nil;
}

+ (UIImage *)screenShotUIView:(UIView *)view {
    UIImage *image = nil;
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (image != nil){
        return image;
    }
    return nil;
}

+ (NSData *) createPdfFromView:(UIView *)aView {
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    return pdfData;
}


- (UIImage *)grayscaleImage:(UIImage *)image {
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CGContextDrawImage(context, imageRect, [image CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *grayscaleImage = [UIImage imageWithCGImage:imageRef];
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    return grayscaleImage;
}

+ (NSString *) DictionaryToString:(NSMutableDictionary *)dictionary {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions
                                                     error:nil];
    NSString * myString = [[NSString alloc] initWithData:data   encoding:NSUTF8StringEncoding];
    return myString;
}

+ (BOOL)openAddressDB_2:(sqlite3**)db
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *dbpath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"address.db"];
    return (BOOL) (sqlite3_open([dbpath UTF8String], db) == SQLITE_OK);
}

+ (BOOL)openAddressDB:(sqlite3**)db {
    NSString *dbpath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"db"];
    return (BOOL) (sqlite3_open([dbpath UTF8String], db) == SQLITE_OK);
}


+ (NSArray *)readJapanStates
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openAddressDB:&db] == YES)
        {
        sqlite3_stmt* statement;
        
        NSString* querySQL = @"SELECT * FROM POST_AREA";
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            NSArray *tableStructure = @[@{FieldType:@(TEXTKind), FieldName: @"CODEDIV"}, @{FieldType:@(INTEGERKind), FieldName: @"COMCODE"}, @{FieldType:@(TEXTKind), FieldName: @"CODENAME"}];
            while (sqlite3_step(statement) == SQLITE_ROW)
                {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                NSInteger index = 0;
                for (NSDictionary *dic in tableStructure)
                    {
                    DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
                    NSString *fieldName = dic[FieldName];
                    if (fieldType == PRIMARYKEYKind || fieldType == INTEGERKind)
                        data[fieldName] = @(sqlite3_column_int(statement, (int)index));
                    else if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
                        data[fieldName] = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, (int)index)];
                    index ++;
                    }
                
                [result addObject:data];
                }
            
            sqlite3_finalize(statement);
            }
        
        sqlite3_close(db);
        }
    else
        {
#ifdef _LOG_
        NSLog(@"Failed to open/create database");
#endif
        }
    
    return result;
}

+ (NSArray *)searchAddress:(NSString *)stateString keyString:(NSString *)keyString
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openAddressDB:&db] == YES)
        {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM POST_CODE WHERE KANJI_TODOFUKEN_NAME='%@' AND KANJI_SIGUCHOSON_NAME || KANJI_CHOIKI_NAME LIKE '%@%@%@' ORDER BY POST_CODE", stateString, @"%", keyString, @"%"];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            NSArray *tableStructure = @[@{FieldType:@(INTEGERKind), FieldName: @"AREA_CODE"}, @{FieldType:@(INTEGERKind), FieldName: @"POST_CODE_OLD"}, @{FieldType:@(INTEGERKind), FieldName: @"POST_CODE"}, @{FieldType:@(TEXTKind), FieldName: @"KANA_TODOFUKEN_NAME"}, @{FieldType:@(TEXTKind), FieldName: @"KANA_SIGUCHOSON_NAME"}, @{FieldType:@(TEXTKind), FieldName: @"KANA_CHOIKI_NAME"}, @{FieldType:@(TEXTKind), FieldName: @"KANJI_TODOFUKEN_NAME"}, @{FieldType:@(TEXTKind), FieldName: @"KANJI_SIGUCHOSON_NAME"}, @{FieldType:@(TEXTKind), FieldName: @"KANJI_CHOIKI_NAME"}];
            while (sqlite3_step(statement) == SQLITE_ROW)
                {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                NSInteger index = 0;
                for (NSDictionary *dic in tableStructure)
                    {
                    DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
                    NSString *fieldName = dic[FieldName];
                    if (fieldType == PRIMARYKEYKind || fieldType == INTEGERKind)
                        data[fieldName] = @(sqlite3_column_int(statement, (int)index));
                    else if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
                        data[fieldName] = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, (int)index)];
                    index ++;
                    }
                
                [result addObject:data];
                }
            
            sqlite3_finalize(statement);
            }
        
        sqlite3_close(db);
        }
    else
        {
#ifdef _LOG_
        NSLog(@"Failed to open/create database");
#endif
        }
    
    return result;
}

// 디바이스 OS 버전 조회
+(NSString*) getOsVersion {
    return [[UIDevice currentDevice] systemVersion];
}

// 디바이스 모델 조회
+(NSString*) getModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

// 디바이스 모델명 조회
+(NSString *)getModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    static NSDictionary* model = nil;
    
    if (!model) {
        model = @{
            // Simulator
            @"i386"      : @"Simulator",
            @"x86_64"    : @"Simulator",
            // iPod
            @"iPod1,1"   : @"iPod Touch",           // (Original)
            @"iPod2,1"   : @"iPod Touch",           // (Second Generation)
            @"iPod3,1"   : @"iPod Touch",           // (Third Generation)
            @"iPod4,1"   : @"iPod Touch",           // (Fourth Generation)
            @"iPod5,1"   : @"iPod Touch",           // (Fourth Generation)
            @"iPod7,1"   : @"iPod Touch",           // (6th Generation)
            // iPad
            @"iPad1,1"   : @"iPad",                 // (Original)
            @"iPad2,1"   : @"iPad 2",               //
            @"iPad2,2"   : @"iPad 2",               //
            @"iPad2,3"   : @"iPad 2",               //
            @"iPad2,4"   : @"iPad 2",               //
            @"iPad2,5"   : @"iPad Mini",            // (Original)
            @"iPad2,6"   : @"iPad Mini",            // (Original)
            @"iPad2,7"   : @"iPad Mini",            // (Original)
            @"iPad3,1"   : @"iPad 3",               // (3rd Generation)
            @"iPad3,2"   : @"iPad 3",               // (3rd Generation)
            @"iPad3,3"   : @"iPad 3",               // (3rd Generation)
            @"iPad3,4"   : @"iPad 4",               // (4th Generation)
            @"iPad3,5"   : @"iPad 4",               // (4th Generation)
            @"iPad3,6"   : @"iPad 4",               // (4th Generation)
            @"iPad4,1"   : @"iPad Air",             // 5th Generation iPad (iPad Air) - Wifi
            @"iPad4,2"   : @"iPad Air",             // 5th Generation iPad (iPad Air) - Cellular
            @"iPad4,3"   : @"iPad Air",             //
            @"iPad4,4"   : @"iPad Mini 2",          // (2nd Generation iPad Mini - Wifi)
            @"iPad4,5"   : @"iPad Mini 2",          // (2nd Generation iPad Mini - Cellular)
            @"iPad4,6"   : @"iPad Mini 2",          //
            @"iPad4,7"   : @"iPad Mini 3",          //
            @"iPad4,8"   : @"iPad Mini 3",          //
            @"iPad4,9"   : @"iPad Mini 3",          //
            @"iPad5,1"   : @"iPad Mini 4",          //
            @"iPad5,2"   : @"iPad Mini 4",          //
            @"iPad5,3"   : @"iPad Air 2",           // (3rd Generation iPad Mini - Wifi (model A1599))
            @"iPad5,4"   : @"iPad Air 2",           // (3rd Generation iPad Mini - Wifi (model A1599))
            @"iPad6,3"   : @"iPad Pro 9.7 Inch",    // iPad Pro 9.7 inches - (model A1673)
            @"iPad6,4"   : @"iPad Pro 9.7 Inch",    // iPad Pro 9.7 inches - (models A1674 and A1675)
            @"iPad6,7"   : @"iPad Pro 12.9 Inch",   // iPad Pro 12.9 inches - (model A1584)
            @"iPad6,8"   : @"iPad Pro 12.9 Inch",   // iPad Pro 12.9 inches - (model A1652)
            @"iPad7,1"   : @"iPad Pro 12.9 Inch 2. Generation",
            @"iPad7,2"   : @"iPad Pro 12.9 Inch 2. Generation",
            @"iPad7,3"   : @"iPad Pro 10.5 Inch",
            @"iPad7,4"   : @"iPad Pro 10.5 Inch",
            // iPhone
            @"iPhone1,1" : @"iPhone",            // (Original)
            @"iPhone1,2" : @"iPhone",            // (3G)
            @"iPhone2,1" : @"iPhone",            // (3GS)
            @"iPhone3,1" : @"iPhone 4",          // (GSM)
            @"iPhone3,2" : @"iPhone 4",          //
            @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
            @"iPhone4,1" : @"iPhone 4s",         //
            @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
            @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
            @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
            @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
            @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
            @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
            @"iPhone7,1" : @"iPhone 6 Plus",     //
            @"iPhone7,2" : @"iPhone 6",          //
            @"iPhone8,1" : @"iPhone 6s",         //
            @"iPhone8,2" : @"iPhone 6s Plus",    //
            @"iPhone8,4" : @"iPhone SE",         //
            @"iPhone9,1" : @"iPhone 7",          //
            @"iPhone9,3" : @"iPhone 7",          //
            @"iPhone9,2" : @"iPhone 7 Plus",     //
            @"iPhone9,4" : @"iPhone 7 Plus",     //
            @"iPhone10,1": @"iPhone 8",          // CDMA
            @"iPhone10,4": @"iPhone 8",          // GSM
            @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
            @"iPhone10,5": @"iPhone 8 Plus",     // GSM
            @"iPhone10,3": @"iPhone X",          // iPhone X A1865,A1902
            @"iPhone10,6": @"iPhone X",          // iPhone X A1901
            @"iPhone11,2": @"iPhone XS",         // iPhone XS A2097,A2098
            @"iPhone11,4": @"iPhone XS Max",     // iPhone XS Max A1921,A2103
            @"iPhone11,6": @"iPhone XS Max",     // iPhone XS Max A2104
            @"iPhone11,8": @"iPhone XR",         // iPhone XR ModelNo Unknown
            @"iPhone12,1": @"iPhone 11",
            @"iPhone12,3": @"iPhone 11 Pro",
            @"iPhone12,5": @"iPhone 11 Pro Max",
            @"iPhone12,8": @"iPhone SE 2nd Gen",
            @"iPhone13,1": @"Phone 12 Mini",
            @"iPhone13,2": @"iPhone 12",
            @"iPhone13,3": @"iPhone 12 Pro",
            @"iPhone13,4": @"iPhone 12 Pro Max"
        };
    }
    
    NSString* deviceName = [model objectForKey:code];
    if (!deviceName) {
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}

+ (NSString *)deviceModelName {
    // For Simulator
    NSString *modelName = NSProcessInfo.processInfo.environment[@"SIMULATOR_DEVICE_NAME"];
    if (modelName.length > 0) {
        return modelName;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *selName = [NSString stringWithFormat:@"_%@ForKey:", @"deviceInfo"];
    SEL selector = NSSelectorFromString(selName);
    if ([device respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        modelName = [device performSelector:selector withObject:@"marketing-name"];
#pragma clang diagnostic pop
    }
    return modelName;
}

+ (NSString *)convertNumberToJapaneseString:(NSString *)numberString {
    
    NSString *returnString = @"";
    
    if (numberString.length == 0) {
        
        return returnString;
        
    }
    
    //34560
    
    //삼만사천오백육십
    
    NSArray *unit1 = [[NSArray alloc] initWithObjects:@"",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九", nil];
    
    NSArray *unit2 = [[NSArray alloc] initWithObjects:@"十",@"百",@"千", nil];
    
    NSArray *unit3 = [[NSArray alloc] initWithObjects:@"万", @"億", @"兆", nil];
    
    NSInteger total = numberString.length;
    
    NSMutableString *rs = [NSMutableString new];
    
    
    
    for (int i=0; i < total; i++) {
        
        NSInteger num = [[numberString substringWithRange:NSMakeRange(i, 1)] integerValue];
        
        NSInteger temp1 = total-i;
        
        for (NSInteger j = 0; [unit1 count]; j++) {
            
            if (num == j) {
                
                [rs appendString:unit1[j]];
                
                break;
                
            }
            
        }
        
        
        
        if (num != 0 && (total-1) != i) { //숫자가 '0'보다 클때만
            
            
            
            //십,백,천 단위를 붙힌다.
            
            NSString *_num1 = [numberString substringWithRange:NSMakeRange(i, (total-i))];
            
            if (_num1.length %4 == 0) {
                
                [rs appendString:unit2[2]];
                
            }
            
            
            
            if (_num1.length %4 == 3) {
                
                [rs appendString:unit2[1]];
                
            }
            
            
            
            if (_num1.length %4 == 2) {
                
                [rs appendString:unit2[0]];
                
            }
            
        }
        
        
        
        //만,억,조 단위를 붙인다.
        
        if (temp1 == 5) {
            
            [rs appendString:unit3[0]];
            
        } else if (temp1 == 9) {
            
            [rs appendString:unit3[1]];
            
        } else if (temp1 == 13) {
            
            [rs appendString:unit3[2]];
            
        }
        
    }
    
    
    
    returnString = (NSString *)rs;
    
    return returnString;
    
}
@end


