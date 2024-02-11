//
//  AppDelegate.h
//  TaxFree
//
//  Created by Smile on 24/10/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CommonFunc.h"
#import "SoundManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) NSString *isOnline;
@property (strong, nonatomic) NSString *isPassOn;

@property (strong, nonatomic) NSString *LoginID;

@property (strong, nonatomic) NSString *ScreenName;
@property (strong, nonatomic) NSMutableDictionary *AdditionalInfo;

- (void)saveContext;


@property (assign, nonatomic) BOOL is_refreshing;
@property (assign, nonatomic) BOOL executed_by_URL_call;
@property (assign, nonatomic) BOOL call_by_url_issued;
@property (assign, nonatomic) BOOL call_by_url_canceled;
@property (assign, nonatomic) BOOL call_by_url_scheme;
@property (assign, nonatomic) int url_goods_cnt;
@property (strong, nonatomic) NSMutableArray *url_goods_param;
@property (strong, nonatomic) NSMutableString *url_goods_param_str;
@property (strong, nonatomic) NSMutableString *url_rec_no;
@property (strong, nonatomic) NSMutableString *url_issue_status;
@property (strong, nonatomic) NSMutableString *url_scheme_addr;
@property (strong, nonatomic) NSMutableString *url_gtf_slip_no;

@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;
@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic) UIBackgroundTaskIdentifier newTaskId;


- (void) StartAutoRefresh;
- (void) getFeeInfo;

@end

