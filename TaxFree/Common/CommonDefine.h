//
//  CommonDefine.h
//  CloudWings
//
//  Created by Admin on 7/21/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"

#import "MJRefresh.h"
#import "KCNetwork.h"
#import "YCMenuView.h"
#import "ePOS2.h"
//#import "ePOSEasySelect.h"
#import "TCCodeGenerator.h"
#import "ChooseDatePickerView.h"
#import "CommonFunc.h"
#import "DatabaseManager.h"
#import "ZRQRCodeViewController.h"

#import <LGSideMenuController/LGSideMenuController.h>
#import <LGSideMenuController/UIViewController+LGSideMenuController.h>

#import "MainViewController.h"
#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import "IssueViewController.h"
#import "AddItemViewController.h"
#import "IssueCell.h"
#import "BuyHistoryCell.h"
#import "AddItemCell.h"
#import "SearchViewController.h"
#import "SearchDetailViewController.h"
#import "OnlineSearchViewController.h"
#import "PurchaseLimitViewController.h"
#import "ConfigViewController.h"
#import "AdvancedSettingsViewController.h"
#import "SearchCell.h"
#import "SearchDetailCell.h"
#import "OnlineSearchCell.h"
#import "PrintView.h"
#import "RTRViewController.h"
#import "AddInfoViewController.h"
#import "AddressViewController.h"
#import "AddressCell.h"



#ifndef CloudWings_CommonDefine_h
#define CloudWings_CommonDefine_h

#define kAppDelegate                            ((AppDelegate *)[UIApplication sharedApplication].delegate)


//--------  실서버 URL  ----------//
//#define API_URL                        @"https://jpadmin.gtfetrs.com/service/jtc/"
//#define URL_LOGIN                      @"https://jpadmin.gtfetrs.com/service/jtc/offLogin"     //  로그인
//#define URL_INFO                       @"https://jpadmin.gtfetrs.com/service/jtc/getOffInfo"   //  로그인이후 각종 정보 얻기
//#define URL_SLIP                       @"https://jpadmin.gtfetrs.com/service/jtc/addOffSlipIssue" // 서버에 발행정보 업로드
//#define URL_CLOSING                    @"https://jpadmin.gtfetrs.com/service/jtc/offClosing"
//#define URL_CLOSING_CANCEL             @"https://jpadmin.gtfetrs.com/service/jtc/offClosingCancel"
//#define URL_SIGN                       @"https://jpadmin.gtfetrs.com/service/jtc/addSlipSign"       // 서버에 사인이미지 업로드
//#define URL_SERVER_SLIP                @"https://jpadmin.gtfetrs.com/service/jtc/onlineSearch"   //  온라인 조회
//#define URL_SERVER_SLIP_COUNT          @"https://jpadmin.gtfetrs.com/service/jtc/onlineSearchCount"   //  온라인 조회시 항목 총갯수
//#define URL_SERVER_SLIP_DETAIL         @"https://jpadmin.gtfetrs.com/service/jtc/onlineSearchDetail"    // 온라인 조회된 항목 상세정보 얻기
//#define URL_SERVER_SLIP_GOODS_DETAIL   @"https://jpadmin.gtfetrs.com/service/jtc/onlineSearchGoodsDetail"   //  온라인 조회된 항목 상품목록 얻기
//#define URL_CANCEL_ALL                 @"https://jpadmin.gtfetrs.com/service/jtc/cancelSlipAll"        // 온라인 조회스크린에서 총항목 취소
//#define URL_CANCEL                     @"https://jpadmin.gtfetrs.com/service/jtc/cancelSlip"            // 온라인 조회스크린에서 1개 항목 취소
//#define URL_PRINT_SLIP_INFO            @"https://jpadmin.gtfetrs.com/service/jtc/printSlipServerInfo"   // 온라인 조회상세스크린에서 프린트정보 얻기
//#define URL_MERCHANT_FEE               @"https://jpadmin.gtfetrs.com/service/jtc/merchantFee"            // 수수료 정보 요청
//#define URL_INFO_MSG_CHECK             @"https://jpadmin.gtfetrs.com/service/jtc/InfoMsgCheck"            // 거래제한 메시지 정보 요청
//-------------------------------//

//--------  테스트서버 URL  ----------//
#define API_URL                        @"http://jp2admin.gtfetrs.com/service/jtc/"
#define URL_LOGIN                      @"http://jp2admin.gtfetrs.com/service/jtc/offLogin"     //  로그인
#define URL_INFO                       @"http://jp2admin.gtfetrs.com/service/jtc/getOffInfo"  //  로그인이후 각종 정보 얻기
#define URL_SLIP                       @"http://jp2admin.gtfetrs.com/service/jtc/addOffSlipIssue" // 서버에 발행정보 업로드
#define URL_CLOSING                    @"http://jp2admin.gtfetrs.com/service/jtc/offClosing"
#define URL_CLOSING_CANCEL             @"http://jp2admin.gtfetrs.com/service/jtc/offClosingCancel"
#define URL_SIGN                       @"http://jp2admin.gtfetrs.com/service/jtc/addSlipSign"       // 서버에 사인이미지 업로드
#define URL_SERVER_SLIP                @"http://jp2admin.gtfetrs.com/service/jtc/onlineSearch"   //  온라인 조회
#define URL_SERVER_SLIP_COUNT          @"http://jp2admin.gtfetrs.com/service/jtc/onlineSearchCount"   //  온라인 조회시 항목 총갯수
#define URL_SERVER_SLIP_DETAIL         @"http://jp2admin.gtfetrs.com/service/jtc/onlineSearchDetail"    // 온라인 조회된 항목 상세정보 얻기
#define URL_SERVER_SLIP_GOODS_DETAIL   @"http://jp2admin.gtfetrs.com/service/jtc/onlineSearchGoodsDetail"   //  온라인 조회된 항목 상품목록 얻기
#define URL_CANCEL_ALL                 @"http://jp2admin.gtfetrs.com/service/jtc/cancelSlipAll"        // 온라인 조회스크린에서 총항목 취소
#define URL_CANCEL                     @"http://jp2admin.gtfetrs.com/service/jtc/cancelSlip"            // 온라인 조회스크린에서 1개 항목 취소
#define URL_PRINT_SLIP_INFO            @"http://jp2admin.gtfetrs.com/service/jtc/printSlipServerInfo"   // 온라인 조회상세스크린에서 프린트정보 얻기
#define URL_MERCHANT_FEE               @"http://jp2admin.gtfetrs.com/service/jtc/merchantFee"            // 수수료 정보 요청
#define URL_INFO_MSG_CHECK             @"http://jp2admin.gtfetrs.com/service/jtc/InfoMsgCheck"            // 거래제한 메시지 정보 요청
 

//--------  오라클 클라우드서버 URL  ----------//
//#define API_URL                        @"https://jp3admin.gtfetrs.com/service/jtc/"
//#define URL_LOGIN                      @"https://jp3admin.gtfetrs.com/service/jtc/offLogin"     //  로그인
//#define URL_INFO                       @"https://jp3admin.gtfetrs.com/service/jtc/getOffInfo"   //  로그인이후 각종 정보 얻기
//#define URL_SLIP                       @"https://jp3admin.gtfetrs.com/service/jtc/addOffSlipIssue" // 서버에 발행정보 업로드
//#define URL_CLOSING                    @"https://jp3admin.gtfetrs.com/service/jtc/offClosing"
//#define URL_CLOSING_CANCEL             @"https://jp3admin.gtfetrs.com/service/jtc/offClosingCancel"
//#define URL_SIGN                       @"https://jp3admin.gtfetrs.com/service/jtc/addSlipSign"       // 서버에 사인이미지 업로드
//#define URL_SERVER_SLIP                @"https://jp3admin.gtfetrs.com/service/jtc/onlineSearch"   //  온라인 조회
//#define URL_SERVER_SLIP_COUNT          @"https://jp3admin.gtfetrs.com/service/jtc/onlineSearchCount"   //  온라인 조회시 항목 총갯수
//#define URL_SERVER_SLIP_DETAIL         @"https://jp3admin.gtfetrs.com/service/jtc/onlineSearchDetail"    // 온라인 조회된 항목 상세정보 얻기
//#define URL_SERVER_SLIP_GOODS_DETAIL   @"https://jp3admin.gtfetrs.com/service/jtc/onlineSearchGoodsDetail"   //  온라인 조회된 항목 상품목록 얻기
//#define URL_CANCEL_ALL                 @"https://jp3admin.gtfetrs.com/service/jtc/cancelSlipAll"        // 온라인 조회스크린에서 총항목 취소
//#define URL_CANCEL                     @"https://jp3admin.gtfetrs.com/service/jtc/cancelSlip"            // 온라인 조회스크린에서 1개 항목 취소
//#define URL_PRINT_SLIP_INFO            @"https://jp3admin.gtfetrs.com/service/jtc/printSlipServerInfo"   // 온라인 조회상세스크린에서 프린트정보 얻기
//#define URL_MERCHANT_FEE               @"https://jp3admin.gtfetrs.com/service/jtc/merchantFee"            // 수수료 정보 요청
//#define URL_INFO_MSG_CHECK             @"https://jp3admin.gtfetrs.com/service/jtc/InfoMsgCheck"            // 거래제한 메시지 정보 요청
//-------------------------------//

#define PRINT_LIST                 @"print_list"

#define LOGIN_SUCCESS              @"login_ok"
#define MEMBER_INFO                @"memberInfo"
#define MERCHANT_LIST              @"merchant_list"
#define TERMINAL_LIST              @"terminal_list"
#define CATEGORY_LIST              @"category_list"
#define CODE_LIST                  @"code_list"


#define PHONE_UUID                 @"iphone_uuid"

#define GUIDE_SHOWN                @"guide_shown"

#define USERINFO                   @"userInfo"

#define USER_LIST                  @"userList"
#define BIN_LIST                   @"binList"
#define COMPANY_ID                 @"000001"

#define TOTAL_ITEM_LIST            @"Total_item_list"
#define PASSPORT_INFO              @"passportInfo"

#define LANGUAGE                   @"jp"

#define KEY_RESULT                  @"Result"
#define KEY_METHOD                  @"Method"

#define PRINTER_TARGET             @"printer_target"

#define CONFIG_INFO                [NSString stringWithFormat:@"new_config%@", kAppDelegate.LoginID] //@"config"
#define UNIQ_KEY                   [NSString stringWithFormat:@"uniq_key%@", kAppDelegate.LoginID]
#define SLIP_NUMBER                [NSString stringWithFormat:@"slip_no%@", kAppDelegate.LoginID]

#define FEE_SETTING_INFO            @"fee_setting_info"
#define LIMIT_SETTING_INFO          @"limit_setting_inf"

#define SETTING_PASSWORD            @"gtf"

//#define REFUNDSLIP                 [NSString stringWithFormat:@"REFUNDSLIP%@", kAppDelegate.LoginID]
//#define SALES_GOODS                [NSString stringWithFormat:@"SALES_GOODS%@", kAppDelegate.LoginID]
//#define SLIP_PRINT_DOCS            [NSString stringWithFormat:@"SLIP_PRINT_DOCS%@", kAppDelegate.LoginID]
//#define REFUND_SLIP_SIGN           [NSString stringWithFormat:@"REFUND_SLIP_SIGN%@", kAppDelegate.LoginID]


/***************************    Colors    ***************************/
#define OrangeColor                  [UIColor colorWithRed:244.0/255.0 green:125.0/255.0 blue:48.0/255.0 alpha:1]
#define LightOrangeColor             [UIColor colorWithRed:1 green:215.0/255.0 blue:188.0/255.0 alpha:1]

#define BlueColor                    [UIColor colorWithRed:0 green:191.0/255.0 blue:1 alpha:1]
#define LightBlueColor               [UIColor colorWithRed:143.0/255.0 green:227.0/255.0 blue:1 alpha:1]

#define dark_greenColor              [UIColor colorWithRed:26.0/255.0 green:75.0/255.0 blue:108.0/255.0 alpha:1]

#define light_backgroundColor        [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1]



/***************************** SCREEN SIZE VARIABLE ************************************/
#define SCREEN_BOUND                        [[UIScreen mainScreen] bounds]
#define SCREEN_SIZE                         SCREEN_BOUND.size
#define SCREEN_WIDTH                        SCREEN_BOUND.size.width
#define SCREEN_HEIGHT                       SCREEN_BOUND.size.height

// iPhone X/XS: 375*812 (@3x)
// iPhone XS Max: 414*896 (@3x)
// iPhone XR: 414*896 (@2x)
#define kYNPAGE_IS_IPHONE_X  !((SCREEN_WIDTH == 320.f && SCREEN_HEIGHT == 480.f) || (SCREEN_WIDTH == 320.f && SCREEN_HEIGHT == 568.f) || (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 667.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 736.f) || (SCREEN_HEIGHT == 320.f && SCREEN_WIDTH == 480.f) || (SCREEN_HEIGHT == 320.f && SCREEN_WIDTH == 568.f) || (SCREEN_HEIGHT == 375.f && SCREEN_WIDTH == 667.f) || (SCREEN_HEIGHT == 414.f && SCREEN_WIDTH == 736.f))

#define kYNPAGE_NAVHEIGHT (kYNPAGE_IS_IPHONE_X ? 88 : 64)

#define kYNPAGE_TABBARHEIGHT (kYNPAGE_IS_IPHONE_X ? 83 : 49)



/************************  Message Text   **********************/

//!--매장명을 입력하세요.--
#define TXT_SHOP_NAME                  @"輸出物品販売場を最初に選択してください。"

// !--여권이름을 입력하세요.--
#define TXT_PASSPORT_NAME              @"パスポートの名前を入力してください。"
// !--여권번호를 입력하세요.--
#define TXT_PASSPORT_NO                @"パスポート番号を入力してください。"


// !--터미널 번호를 입력하세요.--
#define TXT_TML_ID                     @"端子番号（5桁）を入力してください。"
// !--프린터를 선택하세요.--
#define COM_PRINTER                    @"プリンタを選択してください。"

// !--Message --

// !--구매물품정보가 없습니다.--
#define NO_ITEM                        @"購入物品情報データがありません。"
// !--조회된 데이터가 없습니다.--
#define NO_SERACH_DATA                 @"照会された伝票がありません。"

// !--전표를 발행 하시겠습니까?--
#define REFUND_CONFIRM                 @"伝票を発行しますか？"

// !--환경설정이 저장되었습니다.--
#define CONFIG_SAVE_SUCCESS            @"環境設定が保存されました。"

#define SYSTEM_INIT                    @"環境設定をしてください。"
// !--여권스캐너 설정을 하시기 바랍니다.--
#define PASSPORT_NOTHING               @"パスポートスキャナの設定をしてください。"
// !--프린터 설정을 하시기 바랍니다.--
#define PRINTER_NOTHING                @"プリンタの設定をしてください。"
// !--여권스캐너에 여권이 정상적으로 삽입되어 있는지 확인하세요.--
#define PASSPORT_REMOVE                @"パスポートスキャナにパスポートが正常に挿入されていることを確認します。"
// !--여권스캐너 연결을 확인하세요.--
#define PASSPORT_ERROR                 @"パスポートスキャナの接続を確認してください。"
// !--영수증 번호가 없습니다. 계속진행하시겠습니까?--
#define RCT_CONFIRM                    @"レシート番号が未入力です。取引を続行しますか。"

#define PASSPORT_SCANNER               @"旅券 スキャン"
#define PASSPORT_HANDWRITE             @"手記入力"

#define LOGIN_BEFORE                   @"ログイン前。"
#define LOGIN_ID                       @"IDの確認中。"
#define LOGIN_SHOP                     @"加盟店情報の読み込み中。"
#define LOGIN_ITEM                     @"商品情報の読み込み中。"
#define LOGIN_CODE                     @"国家情報ロード中。"
#define LOGIN_CUSTOMS                  @"税関情報ロード中。"
#define LOGIN_ADS                      @"広告情報の読み込み中。"
#define LOGIN_END                      @"ログイン仕上げ中。"

// !--초기화 오류. 프로그램을 재 시작해 주시기 바랍니다.--
#define ERROR_INIT                     @"初期化エラーです。プログラムを再起動してください。"
// !--전표가 정상적으로 출력되었는지 확인하세요.--
#define SLIP_CONFIRM                   @"伝票が正常に出力されたことを確認してください。"
#define PRINT_FAILED                   @"印刷が失敗しました"

#define REFUND_COMPLETE                @"還付処理されます"
#define REFUND_CASH                    @"返金額"
#define REFUND_CARD                    @"※注意※\n本取引は、UPI取引です。\nお客様への返金は、絶対に行わないでください！\n還金額"
#define REFUND_QQ                      @"※注意※\n本取引は、QQ取引です。\nお客様への返金は、絶対に行わないでください！\n還金額"
// !--매장정보가 없습니다. 다른 사용자로 로그인 해주시기 바랍니다.--
#define ERROR_SHOP_CNT                 @"店頭情報がありません。別のユーザーとしてログインしてください。"
#define ERROR_QTY_CNT                  @"数量を超えています。再入力してください。"

// !--에러가 발생했습니다. 거래를 다시 진행해주시기 바랍니다.--
#define ERROR_ISSUE                    @"取引の登録に失敗しました。"
#define ERROR_SUM                      @"合計が不可能な輸出物品販売場です。"

// !--환급이 불가능한 카드번호입니다.\n카드번호를 확인해주시기 바랍니다.--
#define ERROR_BIN                      @"還付が不可能なカード番号です。\nカード番号をご確認ください。"
#define ERROR_CARD_EMPTY               @"カード番号 登録してください。"
#define ERROR_QQ_EMPTY                 @"QQ ID 登録してください。"
#define ERROR_QQ_ID                    @"QQ ID 10000 〜 4294967295間の数字を入力してください。"

// !--여권정보 입력요망--
#define ERROR_PASSPORT                 @"旅券情報が存在しません。"
#define ERROR_PASSPORT_INFO            @"旅券情報を再入力してください。"

// !--상륙일은 현재 날짜보다 이전이어야 합니다.\n날짜를 다시 입력해주시기 바랍니다.--
#define ERROR_DATE                     @"入力された上陸年月日に誤りがあります。\n正しい日付を入力してください。"
// !--상륙일이 6개월 이전이면 전표발행이 불가합니다.\n날짜를 다시 입력해주시기 바랍니다.--
#define ERROR_SIX_MONTH                @"上陸年月日から６ヶ月が過ぎているため還付登録ができません。"

#define ERROR_GOODS_AMT                @"同日、一般品最小還付可能金額は5,000円以上です。"
#define ERROR_COMSUMS_AMT              @"同日、消耗品最小還付可能金額は5,000円以上です。"

// !--물품의 수량을 모두 입력하세요.--
#define ERROR_QTY                      @"物品の数量をすべて入力してください。"
// !--물품의 수량은 9999개를 초과할 수 없습니다.--
#define ERROR_QTY_LIMIT                @"商品の数量は9999を超えることはできません"

// !-- 물품의 단가를 모두 입력하세요.--
#define ERROR_ITEM_AMT                 @"物品の単価をすべて入力してください。"
// !--물품의 판매금액을 모두 입력하세요.--
#define ERROR_BUY_AMT               @"物品の販売金額をすべて入力してください。"
// !--물품의 세금을 모두 입력하세요.--
#define ERROR_TAX_AMT               @"物品の税金をすべて入力してください。"
#define ERROR_CONSUMS_MAX_AMT       @"同日、同一店舗における消耗品購入上限は50万円です。"

#define ITEM_MAX               @"一度に50件を超える物品数を登録できません。物品数を50個未満になるよう、分けて決済・免税登録をしてください。"

#define ERROR_DB_FAILED         @"データベースに取引情報が保存されませんでした。再度、最初から取引登録を行ってください。"

#define ERROR_PRINT_DATE               @"本日発行された伝票のみ再出力が可能です。"
// !--로그인을 하지 못했습니다.\n로그인 정보를 확인해주시기 바랍니다.--
#define ERROR_LOGIN               @"ログインをしていませんでした。\n入力情報を確認してください。"
#define ERROR_LOGIN_CRITICAL      @"ログイン中にエラーが発生しました。\nログイン情報を再確認してください。\nプログラムを終了します。"
// !--프로그램을 종료하시겠습니까?--
#define SYSTEM_EXIT_CONFIRM               @"プログラムを終了しますか？"

// !--프로그램을 종료하시겠습니까?--

#define CLOSING               @"本日のオフライン業務を終了しますか。"
#define CLOSING_CANCEL               @"オフライン業務終了をキャンセルしますか。"

// !-- 업무마감을 취소하였습니다--
#define CLOSING_CANCEL_SUCCESS               @"オフライン業務終了をキャンセルしました。"
// !--업무마감을 취소하지 못했습니다.--
#define CLOSING_CANCEL_FAIL               @"終業をキャンセルしていました。"

// !--서버 미 전송 거래가 존재합니다.\n서버전송 되었는지 확인해 주시기 바랍니다.--
#define CLOSING_FAIL               @"オフライン業務を終了してから再度締め切りを行ってください。"
// !--업무마감 하였습니다. 프로그램을 종료합니다.--
#define CLOSING_YES               @"オフライン業務終了しました。プログラムを終了します。"
// !--업무마감 하지 못했습니다. 관리자 확인이 필요합니다.--
#define CLOSING_NO               @"終業ませんでした。管理者の確認が必要です。"
#define CLOSING_BLOCK               @"終業状態です。払い戻し伝票発行を行うことができません。"
// !--프로그램을 종료하시겠습니까?--
#define EXIT_CONFIRM               @"プログラムを終了しますか？"
#define ASK_IT               @"本社にお問い合わせください"

#define EMPTY_ID               @"IDを入力してください。"
#define EMPTY_PASSWORD               @"パスワードを入力してください。"
// !-- 합산 발행된 전표 입니다.--
#define TOTAL_SLIP_ISSUED               @"合計発行された伝票です。"
// !-- 취소할 항목을 선택 하세요--
#define SELECTCANCELSLIP               @"キャンセルする項目を選択してください。"
// !-- 송금 전송전 거래입니다.--
#define REMMITYETSEND               @"送金転送前の取引です。"
// !-- 송금 완료된 거래입니다.--
#define REMMITSENDCOM               @"送金が完了取引です。。"
// !-- 합산 발행된 모든 전표를 취소 합니다--
#define TOTALSLIPALLCANCEL               @"合計発行されたすべての伝票が還付取り消されます。"
// !-- 발행 취소를 합니까?--
#define CANCELREQUEST               @"発行解除しますか。"
// !-- 이미 환급취소된 거래내역 입니다.--
#define ALREADYCANCELREFUND               @"既に還付キャンセルされた取引です。"
// !-- 취소처리가 완료되었습니다.--
#define REFUNDCANCELCOM               @"還付キャンセル完了です。"
// !-- 취소하였습니다.--
#define CONFIRMCANCEL               @"キャンセル完了です。"
// !-- 취소처리에 실패 했습니다.--
#define REFUNDCANCELFAIL               @"還付のキャンセルに失敗しました。"


///////////    Printer   //////////////
#define StringEndMark                @"-- END --"
#define StringErrLandingDate         @"有効でない日付形式です。"
#define StringGoodsDetails           @"GOODS DETAILS"
#define StringGoodsDetails01         @[@"購入年月日", @"Date of Purchase", @"购买日期", @"구입년월일"]    //구입년월일
#define StringGoodsDetails02         @[@"消耗品", @"Commodities", @"消耗品", @"소모품"]    //소모품
#define StringGoodsDetails03         @[@"一般品", @"Commodities except consumables", @"一般品", @"일반품목"]    //일반품목
#define StringGoodsDetails04         @[@"品名", @"Name of Commodity", @"品名", @"품명"]    //품명
#define StringGoodsDetails05         @[@"単価", @"Unit Price", @"单价", @"단가"]    //단가
#define StringGoodsDetails06         @[@"数量", @"Q-ty", @"数量", @"수량"]    //수량
#define StringGoodsDetails07         @[@"販売価格", @"Price", @"销售金额", @"판매가격"]    //판매가격
#define StringGoodsDetails08         @[@"免税額", @"Tax Amount", @"免税金额", @"면세금액"]    //세금금액
#define StringGoodsDetails09         @[@"合計価額", @"Total Amount", @"销售总额", @"합계금액"]    //합계금액
#define StringGoodsDetails10         @[@"返金額", @"Refund Amount", @"退税金额", @"반환금액"]    //환급금액
#define StringGoodsDetails11         @[@"総合計価額", @"Total Sales Amount", @"销售总额", @"총합계금액"]    //총판매금액
#define StringGoodsDetails12         @[@"総返金額", @"Total Payable Amount", @"退税总额", @"총반환액"]    //총환급금액
#define StringGoodsDetails13         @[@"総手数料", @"Total Service Fee", @"手续费总额", @"총수수료"]    //총수수료
#define StringGoodsDetails14         @[@"総免税額", @"Total Refund Amount", @"免税总额", @"총면세금액"]    //총면세액
#define StringGoodsDetails15         @[@"全店合計消耗品販売額", @"All Stores Total Amount", @"전 점포 소모품 판매액", @"전 점포 소모품 판매액"]    //소모품 전 점포 합산금액
#define StringGoodsDetails16         @[@"全店合計一般品販売額", @"All Stores Total Amount", @"전 점포 일반물품 판매액", @"전 점포 일반물품 판매액"]    //일반물품 전 점포 합산금액
#define StringGoodsDetails17         @[@"品目大分類", @"品目大分類", @"品目大分類", @"품목 대분류"]    //품목 대분류
#define StringGoodsDetails18         @[@"品目中分類", @"品目中分類", @"品目中分類", @"품목 중분류"]    //품목 중분류


#define StringLine         @"---------------------------------------------------------------\n"    //태그 라인
#define StringOperationName         @"運営会社"

#define StringPassPortEtc01         @[@"旅券", @"", @"", @""]
#define StringPassPortEtc02         @[@"外交官", @"", @"", @""]
#define StringPassPortEtc03         @[@"乗組員上陸許可書", @"", @"", @""]
#define StringPassPortEtc04         @[@"緊急上陸許可書", @"", @"", @""]
#define StringPassPortEtc05         @[@"遭難上陸許可書", @"", @"", @""]

#define StringRefundSerial          @"Unique ID"
#define StringRefundway             @"REFUND DETAIL"
#define StringRefundWayDesc         @"還付方法"                     //환급방법
#define StringRefundWayName         @"還付方法"                     //환급방법
#define StringRefundWayQQ           @"/ QQID "    //QQID
#define StringRefundWayUPI          @"/ UPI No. "    //UPI No.


#define StringRePublish         @[@"再発行", @"REPRINT", @"补发单据", @"재발행"]    //재발행
#define StringRetailer         @"RETAILER"
#define StringRetailer01         @[@"所轄税務署", @"Tax office concerned", @"所在税务局", @"소속세무서"]    //소속세무서
#define StringRetailer02         @[@"納税地", @"Place for Tax Payment", @"纳税地点", @"납세지"]    //납세지
#define StringRetailer03         @[@"販売者氏名・名称", @"Seller's Name", @"销售处或商号", @"판매지성명혹은상호"]    //판매자성명
#define StringRetailer04         @[@"販売場所在地", @"Seller's Place", @"销售处地址", @"판매장주소"]    //판매장주소
#define StringSlipNo         @[@"伝票番号", @"Refund No", @"文件号码", @"전표번호"]    //전표번호
#define StringSlipType01         @[@"輸出免税物品購入記録票", @"Record of Purchase of Consumption \nTax-Exempt for Export", @"出口免税物品购买记录单", @"수출면세물품구입기록표"]    //수출면세물품구입기록표
#define StringSlipType01AddText01         @"パスポート添付用"         //여권첨부용

#define StringSlipType01Desc01         @[@"① 本邦から出国する際又は居住者となる際に、その出港地を所轄する税関長又はその住所若しくは居所の所在地を所轄する税務署長に購入記録票を提出しなければなりません。", @"① When departing Japan, or if becoming a resident of Japan, you are required to submit your 'Record of Purchase Card' to either the Direct of Customs that has jurisdiction over your departure location or the head of the tax office that has jurisdiction over your place or residence or address.", @"① 从日本出境时或者成为居住者时，需要给管辖其出境港的税官长或者管辖其住所或居住所在地的税务署长提交购买记录表。", @"① 일본에서 출국할 때 또는 거주자가 될 때 그 출항지를 관할하는 세관장 또는 그 주소 혹은 거소 소재지를 관할하는 세무서장에게 구입기록표를 제출해야 합니다."]
#define StringSlipType01Desc02         @[@"② 本邦から出国するまでは購入記録票を旅券等から切り離してはいけません。", @"② You must not remove the 'Record of Purchase Card' from your passport etc. until after you have departed Japan.", @"② 从日本出境为止，购买记录表不能从护照等上面摘下来。", @"② 일본에서 출국할 때까지는 구입기록표를 여권 등에서 떼어내면안됩니다."]
#define StringSlipType01Desc03         @[@"③ 免税で購入した物品を本邦からの出国の際に所持していなかった場合には、その購入した物品について免除された消費税額（地方消費税を含む。）に相当する額を徴収されます。", @"③ If you are not in possession of item(s) purchase tax free, that are listed on the 'Record of Purchase Card', at the time of departure from Japan, an amount equivalent to the consumption tax amount(including local consumption tax) that was exempted at the time of purchase will be collected before your departure from Japan.", @"③ 从日本出境时，如果没有携带以免税价购买的物品，将收取购买时所免除的消费税额（包含地方消费税）", @"③ 면세로 구입한 물품을 일본 출국시 소지하지 않은 경우에는 그 구입한 물품에 대해 면제된 소비세액(지방 소비세를 포함)에 상당하는 액수가 징수됩니다."]
#define StringSlipType01Desc04         @[@"④ ③の場合において、災害その他やむを得ない事情により免税で購入した物品を亡失したため輸出しないことにつき税関長の承認を受けたとき、又は既に輸出したことを証する書類を出港地を所轄する税関長に提出したときは、消費税額（地方消費税を含む。）に相当する額を徴収されません。", @"④ In the case of ③ if you do not possess listed item(s) at the time of departure, if the Director of Customs has acknowledged that item(s) you purchased tax free will not be exported as a result of being lost in the disaster or due to other unavoidable circumstances, or alternatively, if you have submitted documents to the Director of curstoms that has jurisdiction over your departure location that verifies the item(s) has already been exported an amount equivalent till the consumption tax amount (including local consumption tax) will not be collected.", @"④ 如同③的情况，因灾害及其他不得已的情况导致免税价购买的物品丢失而无法搬出的情况时，得到税官长的许可或者向税官长出示已确认搬出的相关证明资料的话，不会收取购买时所免除的消费税额（包含地方消费税）。", @"④ ③의 경우에서 재해 및 기타 부득이한 사정으로 인해 면세로 구입한 물품을 분실한 관계로 반출하지 않는 것에 대해 세관장의 승인을 받았을 때, 또는 이미 반출했음을 증명하는 서류를 출항지를 관할하는 세관장에게 제출했을 때는 소비세(지방 소비세를 포함)에 상당하는 액수가 징수되지 않습니다."]
#define StringSlipType02         @[@"最終的に輸出となる物品の\n消費税免税購入についての購入者誓約書", @"Covenant of Purchaser of Consumption \nTax-Exempt of Ultimate Export", @"免税物品購入者誓約書", @"면세물품구입자확약서"]    //면세물품구입자확약서
#define StringSlipType02AddText01         @"店舗控用"    //점포공용

#define StringSlipType02Desc01         @[@"当該消耗品を、購入した日から３０日以内に輸出されるものとして購入し、日本で処分しないことを誓約します。", @"I certify that the goods listed as 'consumable commodities' on this card were purchased by me for export from Japan within 30days from the purchase date and will not be disposed of within Japan.", @"从购买日起30天内搬出为前提购买的消耗品，誓约日方将不给予处分。", @"해당 소모품을 구입한 날로부터 30일 이내에 수출하는 것으로 구입해 일본에서 처분하지 않는 것을 서약합니다."]
#define StringSlipType02Desc02         @[@"当該一般品を、日本から最終的には輸出されるものとして購入し、日本で処分しないことを誓約します。", @"I certify that the goods listed as 'commodities except consumable' on this card were purchased by me for ultimate export from Japan and will not be disposed of within Japan.", @"购买的一般商品最终从日本搬出，誓约日方不会给予处分。", @"해당 일반 물품을 일본에서 최종적으로는 수출하는 것으로 구입해 일본에서 처분하지 않기로 서약합니다."]
#define StringSlipType02Signature      @"署名　Signature"
#define StringSlipType03               @[@"輸出免税物品購入記録票(控え)", @"Record of Purchase of Consumption Tax-Exempt for Export (For Copy)", @"出口免税物品购买记录单(保管用)", @"수출면세물품구입기록표(보관용)"]    //수출면세물품구입기록표(보관용)
#define StringSlipType04               @[@"購入者控え", @"Customer Copy", @"顾客保管用", @"구입자보관용"]    //구입자보관용
#define StringSlipType05               @[@"輸出免税物品販売者控え", @"Record of Purchase of Consumption Tax-Exempt for Export (Keep Sellers)", @"销售处保管用", @"수출물품판매자보관용"]    //수출물품판매자보관용
#define StringSlipType06               @[@"合算発行伝票", @"합산발행전표", @"합산발행전표", @"합산발행전표"]    //합산발행전표
#define StringSlipType06No             @[@"合算伝票番号", @"합산발행전표", @"합산발행전표", @"합산발행전표"]    //합산발행순번
#define StringTouristDetails           @"TOURIST'S DETAILS"
#define StringTouristDetails01         @[@"旅券等の種類", @"Passport etc.", @"护照种类", @"여권 등 종류"]    //여권종류
#define StringTouristDetails02         @[@"番号", @"No.", @"护照号码", @"여권번호"]    //여권번호
#define StringTouristDetails03         @[@"購入者氏名", @"Name in Full(in Block Letters)", @"购买者姓名", @"구매자성명"]    //구매자성명
#define StringTouristDetails04         @[@"国籍", @"Nationality", @"国籍", @"국적"]    //국적
#define StringTouristDetails05         @[@"生年月日", @"Date of Birth", @"出生日期", @"생년월일"]    //생년월일
#define StringTouristDetails06         @[@"在留資格", @"Status of Residence", @"滞留资格", @"체류자격"]    //체류자격
#define StringTouristDetails07         @[@"上陸地", @"Place of Landing", @"着陆", @"상륙지"]    //상륙지
#define StringTouristDetails08         @[@"上陸年月日", @"Date of Landing", @"上陆日期", @"상륙년월일"]    //상륙년월일

/// alias="System.Drawing" name="System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"

#define toolStripButton_Print      @"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADr8AAA6/ATgFUyQAAAIDSURBVDhPpZLrS5NhGMb3j4SWh0oRQVExD4gonkDpg4hGYKxG6WBogkMZKgPNCEVJFBGdGETEvgwyO9DJE5syZw3PIlPEE9pgBCLZ5XvdMB8Ew8gXbl54nuf63dd90OGSnwCahxbPRNPAPMw9Xpg6ZmF46kZZ0xSKzJPIrhpDWsVnpBhGkKx3nAX8Pv7z1zg8OoY/cITdn4fwbf/C0kYAN3Ma/w3gWfZL5kzTKBxjWyK2DftwI9tyMYCZKXbNHaD91bLYJrDXsYbrWfUKwJrPE9M2M1OcVzOOpHI7Jr376Hi9ogHqFIANO0/MmmmbmSmm9a8ze+I4MrNWAdjtoJgWcx+PSzg166yZZ8xM8XvXDix9c4jIqFYAjoriBV9AhEPv1mH/sonogha0afbZMMZz+yreTGyhpusHwtNNCsA5U1zS4BLxzJIfg299qO32Ir7UJtZfftyATqeT+8o2D8JSjQrAJblrncYL7ZJ2+bfaFnC/1S1NjL3diRat7qrO7wLRP3HjWsojBeComDEo5mNjuweFGvjWg2EBhCbpkW78htSHHwRyNdmgAFzPEee2iFkzayy2OLXzT4gr6UdUnlXrullsxxQ+kx0g8BTA3aZlButjSTyjODq/WcQcW/B/Je4OQhLvKQDnzN1mp0nnkvAhR8VuMzNrpm1mpjgkoVwB/v8DTgDQASA1MVpwzwAAAABJRU5ErkJggg=="

#define toolStripButton_Close     @"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADr8AAA6/ATgFUyQAAAIDSURBVDhPpZLrS5NhGMb3j4SWh0oRQVExD4gonkDpg4hGYKxG6WBogkMZKgPNCEVJFBGdGETEvgwyO9DJE5syZw3PIlPEE9pgBCLZ5XvdMB8Ew8gXbl54nuf63dd90OGSnwCahxbPRNPAPMw9Xpg6ZmF46kZZ0xSKzJPIrhpDWsVnpBhGkKx3nAX8Pv7z1zg8OoY/cITdn4fwbf/C0kYAN3Ma/w3gWfZL5kzTKBxjWyK2DftwI9tyMYCZKXbNHaD91bLYJrDXsYbrWfUKwJrPE9M2M1OcVzOOpHI7Jr376Hi9ogHqFIANO0/MmmmbmSmm9a8ze+I4MrNWAdjtoJgWcx+PSzg166yZZ8xM8XvXDix9c4jIqFYAjoriBV9AhEPv1mH/sonogha0afbZMMZz+yreTGyhpusHwtNNCsA5U1zS4BLxzJIfg299qO32Ir7UJtZfftyATqeT+8o2D8JSjQrAJblrncYL7ZJ2+bfaFnC/1S1NjL3diRat7qrO7wLRP3HjWsojBeComDEo5mNjuweFGvjWg2EBhCbpkW78htSHHwRyNdmgAFzPEee2iFkzayy2OLXzT4gr6UdUnlXrullsxxQ+kx0g8BTA3aZlButjSTyjODq/WcQcW/B/Je4OQhLvKQDnzN1mp0nnkvAhR8VuMzNrpm1mpjgkoVwB/v8DTgDQASA1MVpwzwAAAABJRU5ErkJggg=="

#define ImageAdsPrint     @"iVBORw0KGgoAAAANSUhEUgAAAMgAAACWAQMAAAChElVaAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURQAA/////3vcmSwAAAAJcEhZcwAACPAAAAjwAda38d8AAAKaSURBVFjD7dYxbtswFAZgCiqgJQjXDgWYI6QnYIBexEfwmCEAZaiIO9VH6FXkesg1aHjoSndiAZav75GiTNMmumS0BsHgp1B8P6mHMKhdN7nJTd5RjlUZRU16XpWuJuuqvO1qAjvoKnLwbU1cU5WnqixUKXaSpSzFhGcP9llodV1eRC+L2WQUf8/ENdHP8OG+ECeSyGIFnk/Sq6uysjBeVBqibCxsL2Sgl6HsC7GCtsZ+tlIXojnNYpa2K2UMI9q4RtvzDIaW4tkZz/QyVGqT8JVF2RqllwtOEnPES2xpEryZx59dEDnVKTXFc7DSybdCjKfgnHByPeTilAnxeO7FZkeSDr9TVlE8vvUfqbJzWdOP3j/yfZgtkyFUfPcgCnEyhKxZI0wuFiWEbNmXQsDFkGH1GsXOghXFn9/lJF7NoiaxUVwSYaO8FqJQZE1clK9XREwSV4B1gKBKvfBRRokxT4IhO4njsU2MSs/SFYLnl8RLOoOO5gphg1YNJMEofSYv7SSC5LfAJ2ID0cvuVxKMcuDxb/EyC75LYpTrOlwJbsMPlCexToKHjA8oWCGWZJjcJHFyVFvM02DgtHdKBMHHnGhgfAD4AxTdX+o8tDYUf9eBbmJ8eOMnoc/Zhu6VNn8WjCN+wMdcaKhPA/tcHMqYBg5ngknrNPB29p4GTt/XOhO8qdiN7IVgx7diWvEmkxa+tUCrCMIzYfw7i8WQiFzYphehG1EyuSxYhy8aovhMDPTsUxt2E3P2MhfLcA+oVDyi54JxjoJKdQLcuazBhM8AF+hUIdhSaNndpUztdQB7KXSaYHXqaVHm5MfTZhei1bEiRu4zOWYSG/M1cV1NfNNVBBivyfw/wNTJTzIfoQvJrv8I3OQmN3lPAfgH0b9+8a7FZJEAAAAASUVORK5CYII="


#define StringReceip         @"RECEIPT"    //영수증
#define StringReceiptAdd         @"レシート貼付"   //영수증 첨부


//////==============  Screen Text  =================//
///IssuePanel

#define BTN_CLEAR                     @"初期化"

#define BTN_SCAN                      @"旅券 スキャン"
#define BTN_PASSPORT_MANUAL           @"旅券 手入力"
#define BTN_SHOP_SEARCH               @"検索"

#define LBL_REFUND_DATE               @"取引日"
#define LBL_REFUND_TYPE               @"還付方法"

#define LBL_PASSPORT_NAME             @"購入者氏名"
#define LBL_PASSPORT_NO               @"番号"
#define LBL_PASSPORT_NAT              @"国籍"
#define LBL_PASSPORT_SEX              @"性別"
#define LBL_PASSPORT_BIRTH            @"生年月日"
#define LBL_PASSPORT_EXP              @"有効期限"
#define LBL_PASSPORT_TYPE             @"旅券等の種類"
#define LBL_PASSPORT_RES              @"在留資格"
#define LBL_PASSPORT_LAND             @"上陸年月日"

#define LBL_SHOP_PARTNER              @"パートナー名"
#define LBL_SHOP_GROUP                @"商業施設名"

#define LBL_SHOP_NAME                 @"輸出物品販売場名"
#define LBL_SHOP_TYPE                 @"業種"
#define LBL_SHOP_ADDR                 @"販売場所在地"
#define LBL_SHOP_PHONE                @"電話番号"
#define LBL_TAX_OFFICE                @"管轄税務署"

#define BTN_ITEM_ADD                  @"物品情報"

#define BTN_SUBMIT                    @"登録"
#define LBL_CHECKSUM                  @"合算伝票発行"
#define LBL_SHOP_MANAGER              @"担当者"


#define LBL_SHOP_NAME                 @"輸出物品販売場名"

// ItemForm
#define BTN_INIT                      @"初期化"
#define BTN_SAVE                      @"保存"
#define BTN_CLOSE                     @"閉じる"
#define LBL_SHOP_NAME                 @"輸出物品販売場名"

#define LBL_GOODS_AMT                 @"一般品"
#define LBL_CONSUMS_AMT               @"消耗品"

#define LBL_GOODS_BUY_AMT             @"販売価格"
#define LBL_CONSUMS_BUY_AMT           @"販売価格"

#define LBL_GOODS_TAX_AMT             @"免税額"
#define LBL_CONSUMS_TAX_AMT           @"免税額"

#define LBL_TOTAL_AMT                 @"合計"
#define LBL_TOTAL_BUY_AMT             @"販売価格"
#define LBL_TOTAL_REFUND_AMT          @"予想返金額"
#define LBL_TOTAL_TAX_AMT             @"免税額"

#define BTN_ADD_GOODS                 @"行追加"
#define BTN_ADD_CONSUM                @"行追加"

#define LBL_GOODS                     @"● 一般品"
#define LBL_CONSUMS                   @"● 消耗品"

#define GRD_GOODS                     @"番号;品目大分類;品目中分類;品目名;数量;単価;免税額;販売価格;免税形態;;削除"
#define GRD_CONSUM                    @"番号;品目大分類;品目中分類;品目名;数量;単価;免税額;販売価格;免税形態;;削除"


//PassportInfoForm
#define LBL_PASSPORT_NAME             @"購入者氏名"
#define LBL_PASSPORT_NO               @"番号"
#define LBL_PASSPORT_NAT              @"国籍"
#define LBL_PASSPORT_SEX              @"性別"
#define LBL_PASSPORT_BIRTH            @"生年月日"
#define LBL_PASSPORT_EXP              @"有効期限"
#define LBL_PASSPORT_TYPE             @"旅券等の種類"
#define LBL_PASSPORT_RES              @"在留資格"
#define LBL_PASSPORT_LAND             @"上陸年月日"

#define BTN_OK                        @"保存"
#define BTN_CLOSE                     @"閉じる"


// PreferencesPanel
#define BTN_SAVE                      @"保存"

// SlipDetailInfo
#define BTN_CLOSE                     @"閉じる"

#define LBL_PASSPORT_NAME                 @"購入者氏名"
#define LBL_PASSPORT_NO                 @"番号"
#define LBL_PASSPORT_NAT                 @"国籍"
#define LBL_PASSPORT_SEX                 @"性別"
#define LBL_PASSPORT_BIRTH                 @"生年月日"
#define LBL_PASSPORT_EXP                 @"有効期限"
#define LBL_PASSPORT_RES                 @"在留資格"
#define LBL_PASSPORT_TYPE                 @"旅券等の種類"
#define LBL_PASSPORT_LAND                 @"上陸年月日"
#define LBL_BUYER_INFO                 @"● 顧客基本情報"
#define LBL_SHOP_INFO                 @"● 輸出物品販売場基本情報"
#define LBL_SHOP_PARTNER                 @"パートナー名"
#define LBL_SHOP_GROUP                 @"商業施設名"
#define LBL_SHOP_NAME                 @"輸出物品販売場名"

#define LBL_SLIP_INFO                 @"● 伝票情報閉じる"
#define LBL_SLIP_NO                 @"伝票番号"


#define LBL_SLIP_STATUS                 @"発行状態"
#define LBL_SLIP_REFUND_DATE                 @"発行日"
#define LBL_SLIP_REFUND_STATUS                 @"還付状態"
#define LBL_SLIP_REFUND                 @"還付日"
#define BTN_REFUND                 @"還付処理"
#define LBL_REFUND_PAYMENT                 @"還付方法"
#define LBL_REFUND_USER                 @"還付作業者"
#define LBL_TOTAL_INFO                 @"● 合計情報"
#define LBL_ITEM_TYPE                 @"品目分類"
#define LBL_ITEM_BUY_AMT                 @"総販売価格"
#define LBL_ITEM_TAX_AMT                 @"総免税額"
#define LBL_ITEM_FEE_AMT                 @"総手数料"
#define LBL_ITEM_REFUND_AMT                 @"総返金額"
#define LBL_ITEM_GOODS_AMT                 @"一般品"
#define LBL_ITEM_CONSUMS_AMT                 @"消耗品"
#define LBL_ITEM_TOTAL_AMT                 @"合計"
#define LBL_NOTE                 @"● メモ"


// SearchPanel
#define BTN_SEND                 @"サーバー送信"
#define BTN_SEARCH                 @"照会"
#define BTN_CLOSING                 @"業務終了"
#define BTN_CLOSING_CANCEL                 @"業務終了キャンセル"

#define BTN_QR_SCAN                 @"QRスキャン"

#define LBL_REFUND_STATUS                 @"還付状態"
#define LBL_REFUND_SEND                 @"サーバー送信"
#define LBL_SLIP_NO                 @"伝票番号"

////  Online Search
#define BTN_SEARCH                 @"照会"
#define BTN_CANCEL                 @"還付解除"
#define BTN_QR_SCAN                 @"QRスキャン"

#define LBL_REFUND_STATUS                 @"還付状態"
#define LBL_REFUND_SEND                 @"サーバー送信"
#define LBL_SLIP_NO                 @"伝票番号"
#define LBL_TOTAL_SLIPSEQ                 @"合算レシート番号"

// TrxnDetailInfo
#define BTN_CLOSE                 @"閉じる"
#define BTN_PRINT                 @"再印刷"
#define LBL_PASSPORT_NAME                 @"購入者氏名"
#define LBL_PASSPORT_NO                 @"番号"
#define LBL_PASSPORT_NAT                 @"国籍"
#define LBL_PASSPORT_SEX                 @"性別"
#define LBL_PASSPORT_BIRTH                 @"生年月日"
#define LBL_PASSPORT_EXP                 @"有効期限"
#define LBL_PASSPORT_RES                 @"在留資格"
#define LBL_PASSPORT_TYPE                 @"旅券等の種類"
#define LBL_PASSPORT_LAND                 @"上陸年月日"

#define LBL_BUYER_INFO                 @"● 顧客基本情報"
#define LBL_SHOP_INFO                 @"● 輸出物品販売場基本情報"
#define LBL_SHOP_PARTNER                 @"パートナー名"
#define LBL_SHOP_GROUP                 @"商業施設名"
#define LBL_SHOP_NAME                 @"輸出物品販売場名"

#define LBL_SLIP_INFO                 @"● 伝票情報閉じる"
#define LBL_SLIP_NO                 @"伝票番号"
#define LBL_RCT_NO                 @"レシート番号"
#define LBL_SLIP_STATUS                 @"発行状態"
#define LBL_SLIP_REFUND_DATE                 @"発行日"
#define LBL_SLIP_REFUND_STATUS                 @"還付状態"
#define LBL_SLIP_REFUND                 @"還付日"
#define BTN_REFUND                 @"還付処理"
#define LBL_REFUND_PAYMENT                 @"還付方法"
#define LBL_REFUND_USER                 @"還付作業者"

#define LBL_TOTAL_INFO                 @"● 合計情報"
#define LBL_ITEM_TYPE                 @"品目分類"
#define LBL_ITEM_BUY_AMT                 @"総販売価格"
#define LBL_ITEM_TAX_AMT                 @"総免税額"
#define LBL_ITEM_FEE_AMT                 @"総手数料"
#define LBL_ITEM_REFUND_AMT                 @"総返金額"
#define LBL_ITEM_GOODS_AMT                 @"一般品"
#define LBL_ITEM_CONSUMS_AMT                 @"消耗品"
#define LBL_ITEM_TOTAL_AMT                 @"合計"
#define LBL_NOTE                 @"● メモ"


#define SEARCHSHOP                 @"店舗内検索"
#define PRINTSLIPLANG_FORM                 @"伝票出力言語選択"
#define PASSPORTINFO_FORM                 @"パスポート手記入力"
#define ITMES_FORM                 @"物品情報 登錄"
#define SLIPDETAILINFO                 @"伝票内訳詳細情報"


#define COMBO_ITEM_GOODS                 @"一般品"
#define COMBO_ITEM_CONSUMS                 @"消耗品"

#define COMBO_ITEM_CASH                 @"現金"
#define COMBO_ITEM_CARD                 @"UPI"
#define COMBO_ITEM_CARD_NO                 @"カード番号"

#define COMBO_ITEM_QQ                 @"QQ"


#define COMBO_ITEM_CN                 @"中国語"
#define COMBO_ITEM_EN                 @"英語"
#define COMBO_ITEM_KO                 @"韓国語"

#define COMBO_ITEM_ALL                 @"全体"

#define COMBO_ITEM_PRINT                 @"発行完了"
#define COMBO_ITEM_NO_PRINT                 @"発行前"

#define COMBO_ITEM_REFUND                 @"還付完了"
#define COMBO_ITEM_UNREFUND                 @"還付前"

#define COMBO_ITEM_SEND                 @"転送完了"
#define COMBO_ITEM_NO_SEND                 @"送信前"

#define COMBO_ITEM_IN_TAX                 @"内税"
#define COMBO_ITEM_OUT_TAX                 @"外税"

#define COMBO_ITEM_MALE                 @"男性"
#define COMBO_ITEM_FEMALE                 @"女性"

#define COMBO_DATE_SALE                 @"購入日"
#define COMBO_DATE_PRINT                 @"伝票発行日"
#define COMBO_DATE_REFUND                 @"還付日"
#define COMBO_DATE_REG                 @"登録日"


#define ALERT_YES     @"はい"
#define ALERT_NO      @"いいえ"

#define ALERT_OK      @"OK"
#define ALERT_CANCEL  @"キャンセル"

//1. 이미 등록한 거래입니다
#define ERROR_MSG_ALREADY_ADDED    @"登録済みの取引です。"

//2. 시퀀스의 순서가 다릅니다
#define ERROR_MSG_SEQ_NO    @"シーケンスの順番にエラーがあります。"

//3. 면세상품의 종류 개수가 실제 물품리스트와 일치하지 않습니다.

#define ERROR_MSG_PRODUCT_KIND    @"免税物品の種類数が登録された物品リストと一致しません。"

//4. 면세상품의 전체 수량이 실제 물품리스트의 수량과 일치하지 않습니다.

#define ERROR_MSG_PRODUCT_COUNT    @"免税物品の物品数が登録された物品リストと一致しません。"

//5. 필수값 「00」가 비어있습니다. 정보를 다시 확인하여 주시기 바랍니다.

#define ERROR_MSG_INVALID_FIELD    @"必須項目「OO」の入力がありません。もう一度データをご確認ください。"

#define ERROR_MSG_WRONG_NUMBER     @"桁数エラー：送信データの桁数をチェックしてください"

//거래 리스트가 일부 입력되지 않았습니다. QR코드를 모두 스캔했는지 확인해주십시오
#define ERROR_MSG_SCAN_OTHERQR     @"取引の一部が入力されていません。すべてのQRコードが登録出来たのかご確認ください。"

//거래 리스트를 스캔하는 중입니다. 이 거래에 해당하는 QR코드를 모두 스캔할 때까지 다른 거래 건은 입력할 수 없습니다
#define ERROR_MSG_SCAN_OTHERQR2     @"QRコードで入力途中の取引があります。 該当する取引のQRコードをすべてスキャンするまで新しいQRコードの入力はできません。"

#define REPLACEMENT       @"OO"

#define NETWORK_ERROR      @"ネットワークの接続エラーです"
#define NETWORK_FAILED     @"ネットワークの接続に失敗しました"
#define RESPONSE_ERROR     @"応答エラー もう一度お試しください"

#endif
