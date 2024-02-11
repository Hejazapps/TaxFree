//
//  AppDelegate.m
//  TaxFree
//
//  Created by Smile on 24/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
{
    int count_num;
    int count_num_2;
    NSInteger slip_count;
    NSInteger slip_sign_count;
    NSString *customURLstr;
    BOOL isBin;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [IQKeyboardManager sharedManager].enable = YES;
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];
    
    [SoundManager sharedManager].soundVolume = 0;
    [SoundManager sharedManager].musicVolume = 0;
    
    [[DatabaseManager sharedInstance] initBasicVariables];
    [CommonFunc copyBundleDBToAppDocument];
    
//    [CommonFunc saveUserDefaults:LOGIN_SUCCESS value:nil];
    
    if ([CommonFunc getValuesForKey:LOGIN_SUCCESS]) {
        _LoginID = [[DatabaseManager sharedInstance] readData:USERINFO_TABLE_KIND][0][@"userId"];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
   
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    if (![CommonFunc getValuesForKey:PHONE_UUID]) {
        [CommonFunc saveUserDefaults:PHONE_UUID value:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    }

    _call_by_url_scheme = false;
    _call_by_url_issued = false;
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    customURLstr = [url absoluteString];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSDictionary *urlParameters = [self parseUrlComponents:urlComponents.queryItems];
    NSMutableString *param_string = [url.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"OpenURL부분이 실행되고 있습니다...");
    NSLog(@"%@", param_string);
    
    _call_by_url_scheme         = TRUE;                                         //현재 앱이 외부 앱 호출로 실행되었는지 여부
    _url_goods_param_str        = param_string;
    _url_gtf_slip_no            = nil;
    _url_rec_no                 = [urlParameters objectForKey:@"Rec_no"];       //외부 앱으로부터 전달받은 영수증 번호
    _url_issue_status           = [urlParameters objectForKey:@"Issue_status"]; //외부 앱으로부터 전달받은 거래유형 (발행,취소)
    _url_scheme_addr            = [urlParameters objectForKey:@"URL_scheme"];   //외부 앱의 CustomURL주소 (발행완료, 취소완료 후에 호출한 앱으로 돌아가기 위해)
    NSLog(@"전달받은 URL주소는 %@", _url_scheme_addr);
    if([_url_issue_status isEqualToString:@"I"]) {                              //발행 요청 건인 경우
        NSNumber* param_cnt     = [urlParameters objectForKey:@"Trxn_cnt"];
        _url_goods_cnt          = [param_cnt intValue];
        _call_by_url_issued     = FALSE;
    }   else {                                                                  //취소 요청 건인 경우
        _url_gtf_slip_no        = [urlParameters objectForKey:@"GTF_Rec_no"];
        _call_by_url_canceled   = FALSE;
    }
    [self.window.rootViewController.parentViewController viewDidLoad];
    return YES;
}

- (void) StartAutoRefresh {
    _newTaskId = UIBackgroundTaskInvalid;
    [[SoundManager sharedManager] playMusic:@"track1" looping:YES];
    _newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    
    _queue = dispatch_queue_create("myTimer", nil);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(_timer, ^{
        int period_upload = 10;
        ////////////////아래 부분을 새로 추가 함.... 체크 간격을 좁히기 위해서...
        if(kAppDelegate.call_by_url_scheme) { period_upload = 2;}
        self->count_num++;
        if (self->count_num > period_upload) {
            self->count_num = 0;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self->_is_refreshing) {
                        return;
                    }
                    if ([CommonFunc getValuesForKey:LOGIN_SUCCESS]) {
                        NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[CommonFunc SearchSlips:@"20170101" strEndDate:@"29990101" strSendFlag:@"N" strSlipStatus:@"02" strSlipNo:nil]];
                        if (arrData.count > 0) {
                            self->slip_count = 0;
                            [self UploadSlipList:arrData];
                        }
                    }
                    if (![CommonFunc getArrayToLocal:BIN_LIST] && [CommonFunc getValuesForKey:LOGIN_SUCCESS]){
                        [self getBinInfo];
                    }
                });
            });
        }
        
        int period_get_fee = 3600;
        self->count_num_2++;
        if (self->count_num_2 > period_get_fee) {
            self->count_num_2 = 0;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([CommonFunc getValuesForKey:LOGIN_SUCCESS]){
                        [self getFeeInfo];
                    }
                });
            });
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->_is_refreshing) {
                    return;
                }
                if ([CommonFunc getValuesForKey:LOGIN_SUCCESS]) {
                    NSMutableArray *arrSlipSign = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:REFUND_SLIP_SIGN_TABLE_KIND fieldName:USERID fieldValue:self->_LoginID fieldName2:SEND_YN fieldValue2:@"N"]];
                    
                    NSMutableDictionary *conditionData = [[NSMutableDictionary alloc] init];
                    conditionData[USERID] = kAppDelegate.LoginID;
                    conditionData[SLIP_STATUS_CODE] = @"02";
                    NSMutableArray *completedSlipList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:REFUNDSLIP_TABLE_KIND conditionData:conditionData]];
                    
                    NSMutableArray *uploadableSignList = [[NSMutableArray alloc] init];
                    for (int i = 0; i < arrSlipSign.count; i++) {
                        for (int k = 0; k < completedSlipList.count; k++) {
                            if ([arrSlipSign[i][SLIP_NO] isEqualToString:completedSlipList[k][SLIP_NO]]) {
                                [uploadableSignList addObject:arrSlipSign[i]];
                            }
                        }
                    }
                    
                    if (uploadableSignList.count > 0) {
                        self->slip_sign_count = 0;
                        [self UploadSignList:uploadableSignList];
                    }
                }
            });
        });
    });
    
    dispatch_resume(_timer);
}

- (void) UploadSlipList:(NSMutableArray *)slipList {    
    NSString *slipNo = slipList[slip_count][SLIP_NO];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[CommonFunc BuildSlipDoc:slipNo]];
    /*if([@"GTFMobileRefund://" isEqualToString:self->customURLstr]) {
        customURLstr = nil;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"cpaypro://"]];
    }*/
    NSLog(@"UpdateSlipList_appdelegate______Line 163");
    if((kAppDelegate.call_by_url_scheme) && (kAppDelegate.call_by_url_issued)) {
        if([kAppDelegate.url_issue_status isEqualToString:@"I"]) {
            NSString *parameter_str;
            //parameter_str = [NSString stringWithFormat:@"TestCustomURL://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
            parameter_str = [NSString stringWithFormat:@"%@://?Request_result=%@&Issue_status=%@&Rec_no=%@&GTF_Rec_no=%@"
                             , _url_scheme_addr, @"S",_url_issue_status, _url_rec_no, _url_gtf_slip_no];
            kAppDelegate.call_by_url_scheme = FALSE;
            kAppDelegate.call_by_url_issued = FALSE;
            kAppDelegate.url_rec_no = nil;
            NSLog(@"UploadSlipList입니다....111%@", parameter_str);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:parameter_str]];
        }
    }
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        _is_refreshing = YES;
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_SLIP] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            self->_is_refreshing = NO;
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString *resultString = [responseObject objectForKey:@"result"];
                    if ([resultString isEqualToString:@"S"] || [resultString isEqualToString:@"D"] || [resultString isEqualToString:@"F"]) {
                        [self UpdateLocalSlip:slipNo];
                    }
//                    else {
//                        [self DeleteLocalSlip:slipNo];
//                    }
                    self->slip_count ++;
                    if (self->slip_count < slipList.count) {
                        [self UploadSlipList:slipList];
                    }
                    else {
                        self->slip_count = 0;
                    }
                }
            }
        }];
    }
    else {
        kAppDelegate.isOnline = nil;
    }
}

- (void) UpdateLocalSlip:(NSString *)slipNo {
    [[DatabaseManager sharedInstance] updateData:REFUNDSLIP_TABLE_KIND fieldName:SEND_FLAG newValue:@"Y" conditionField:SLIP_NO conditionValue:slipNo];
}

- (void) DeleteLocalSlip:(NSString *)slipNo {
    [[DatabaseManager sharedInstance] deleteData:REFUNDSLIP_TABLE_KIND conditionField:SLIP_NO conditionValue:slipNo];
}

- (void) getBinInfo {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userId"] = _LoginID;
    params[@"merchantNo"] = [CommonFunc getValuesForKey:MERCHANT_NO];
    params[@"deskId"] = [CommonFunc getValuesForKey:DESK_ID];
    params[@"code_type"] = @"bin";
    params[@"languageCD"] = LANGUAGE;
    params[@"companyID"] = COMPANY_ID;
    params[@"openDate"] = [CommonFunc getDateStringWithFormat:[NSDate date] format:@"yyyyMMdd"];
    
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        _is_refreshing = YES;
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_INFO] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            self->_is_refreshing = NO;
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* resultStatus = [responseObject objectForKey:@"result"];
                    if([resultStatus isEqualToString:@"S"]){
                        self->isBin = YES;
                        NSMutableArray *binList = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"binList"]];
                        [CommonFunc saveArrayToLocal:binList key:BIN_LIST];
                    }
                }
            }
        }];
    }
    else {
        kAppDelegate.isOnline = nil;
    }
}

- (void) getFeeInfo {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userId"] = _LoginID;
    params[@"merchant_no"] =  [CommonFunc getValuesForKey:MERCHANT_NO];

    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        _is_refreshing = YES;
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_MERCHANT_FEE] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            self->_is_refreshing = NO;
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* resultStatus = [responseObject objectForKey:@"result"];
                    if([resultStatus isEqualToString:@"S"]){
                        [CommonFunc saveUserDefaults:FEE_SETTING_INFO value:responseObject];
                    }
                }
            }
        }];
    }
    else {
        kAppDelegate.isOnline = nil;
    }
}


- (void) UploadSignList:(NSMutableArray *)slipSignList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userId"] = _LoginID;
    params[@"slip_no"] = slipSignList[slip_sign_count][@"SLIP_NO"];
    params[@"sign_data"] = slipSignList[slip_sign_count][@"SLIP_SIGN_DATA"];
    if ([CommonFunc isNetworkAvailable]) {
        kAppDelegate.isOnline = @"1";
        _is_refreshing = YES;
        [ConnectionMethods requestWithURL:[NSURL URLWithString:URL_SIGN] forType:RequestTypeJSON httpMethod:kHTTPMethodPost data:[ConnectionMethods dataFromJSONObject:params] callback:^(ResponseStatus status, id responseObject){
            self->_is_refreshing = NO;
            if(status == ResponseStatusOK) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString* resultStatus = [responseObject objectForKey:@"result"];
//                    if([resultStatus isEqualToString:@"S"]){
                    [[DatabaseManager sharedInstance] updateData:REFUND_SLIP_SIGN_TABLE_KIND fieldName:SEND_YN newValue:@"Y" conditionField:SLIP_NO conditionValue:params[@"slip_no"]];
//                    }
                    self->slip_sign_count ++;
                    if (self->slip_sign_count < slipSignList.count) {
                        [self UploadSignList:slipSignList];
                    }
                    else {
                        self->slip_sign_count = 0;
                    }
                }
            }
        }];
    }
    else {
        kAppDelegate.isOnline = nil;
    }
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    _newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    [[SoundManager sharedManager] playMusic:@"track1" looping:YES];
    
    __block UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
    UIApplication *app = [UIApplication sharedApplication];
    
    // Request permission to run in the background. Provide an
    // expiration handler in case the task runs long.
    NSAssert(bgTask == UIBackgroundTaskInvalid, nil);
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        // Synchronize the cleanup call on the main thread in case
        // the task actually finishes at around the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bgTask != UIBackgroundTaskInvalid)
            {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"App staus: applicationDidEnterBackground");
        // Synchronize the cleanup call on the main thread in case
        // the expiration handler is fired at the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void) onAudioSessionEvent: (NSNotification *) notification
{
    [[SoundManager sharedManager] playMusic:@"track1" looping:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"앱이 다시 실행되고 있습니다...");
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self StartAutoRefresh];
    [self Erase15DaysBefore];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void) Erase15DaysBefore {
    if (![CommonFunc getValuesForKey:LOGIN_SUCCESS]) {
        return;
    }
    NSMutableArray *RefundSlip = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:REFUNDSLIP_TABLE_KIND fieldName:USERID fieldValue:self->_LoginID fieldName2:SEND_FLAG fieldValue2:@"Y"]];
    for (int i = 0; i < RefundSlip.count; i++) {
        NSDate *refundDate = [CommonFunc getDateFromString:RefundSlip[i][@"SALEDT"]];
        NSString *slipNo = RefundSlip[i][SLIP_NO];
        if ([refundDate timeIntervalSinceNow] > 15*24*3600) {
            [[DatabaseManager sharedInstance] deleteData:REFUNDSLIP_TABLE_KIND conditionValue:[RefundSlip[i][ID] intValue]];
            [[DatabaseManager sharedInstance] deleteData:SLIP_PRINT_DOCS_TABLE_KIND conditionField:SLIP_NO conditionValue:slipNo];
            [[DatabaseManager sharedInstance] deleteData:SALES_GOODS_TABLE_KIND conditionField:SLIP_NO conditionValue:slipNo];
        }
    }
    
    NSMutableArray *SignList = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] readData:REFUND_SLIP_SIGN_TABLE_KIND fieldName:USERID fieldValue:self->_LoginID fieldName2:SEND_YN fieldValue2:@"Y"]];
    for (int i = 0; i < SignList.count; i++) {
        NSDate *refundDate = [CommonFunc getDateFromString:SignList[i][@"REG_DTM"] format:@"yyyyMMdd"];
        if ([refundDate timeIntervalSinceNow] > 15*24*3600) {
            [[DatabaseManager sharedInstance] deleteData:REFUND_SLIP_SIGN_TABLE_KIND conditionValue:[SignList[i][ID] intValue]];
        }
    }
}

-(NSDictionary *) parseUrlComponents:(NSArray *) queryItems {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for(NSURLQueryItem *item in queryItems) {
        [dict setValue:item.value forKey:item.name];
    }
    return dict;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TaxFree"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
