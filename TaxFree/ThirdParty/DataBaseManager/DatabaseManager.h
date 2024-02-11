
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define FieldName                               @"FieldName"
#define FieldType                               @"FieldType"
#define InvalidNumber                           -1
#define ValidNumber                             0


// Database
#define DatabaseName                            @"LocalDatabase.db"


//  Tables
#define REFUNDSLIP_TABLE                   @"REFUNDSLIP"
#define REFUND_SLIP_SIGN_TABLE             @"REFUND_SLIP_SIGN"
#define SALES_GOODS_TABLE                  @"SALES_GOODS"
#define SLIP_PRINT_DOCS_TABLE              @"SLIP_PRINT_DOCS"
#define CATEGORY_TABLE                     @"category"
#define CODE_TABLE                         @"code"
#define CONFIG_TABLE                       @"config"
#define MERCHANT_TABLE                     @"merchant"
#define SLIP_NO_TABLE                      @"slip_no"
#define TERMINAL_TABLE                     @"terminal"
#define UNIQ_KEY_TABLE                     @"uniq_key"
#define USERINFO_TABLE                     @"user_info"

//REFUNDSLIP_TABLE
#define ID                                       @"id"
#define USERID                                   @"USERID"
#define BUYER_NAME                               @"BUYER_NAME"
#define MEMO_TEXT                                @"MEMO_TEXT"
#define PASSPORT_SERIAL_NO                       @"PASSPORT_SERIAL_NO"
#define PERMIT_NO                                @"PERMIT_NO"
#define NATIONALITY_CODE                         @"NATIONALITY_CODE"
#define NATIONALITY_NAME                         @"NATIONALITY_NAME"
#define GENDER_CODE                              @"GENDER_CODE"
#define BUYER_BIRTH                              @"BUYER_BIRTH"
#define PASS_EXPIRYDT                            @"PASS_EXPIRYDT"
#define INPUT_WAY_CODE                           @"INPUT_WAY_CODE"
#define RESIDENCE_NO                             @"RESIDENCE_NO"
#define RESIDENCE                                @"RESIDENCE"
#define ENTRYDT                                  @"ENTRYDT"
#define PASSPORT_TYPE                            @"PASSPORT_TYPE"
#define PASSPORT_TYPE_NAME                       @"PASSPORT_TYPE_NAME"
#define SLIP_NO                                  @"SLIP_NO"
#define MERCHANT_NO                              @"MERCHANT_NO"
#define SHOP_NAME                                @"SHOP_NAME"
#define OUT_DIV_CODE                             @"OUT_DIV_CODE"
#define REFUND_WAY_CODE                          @"REFUND_WAY_CODE"
#define REFUND_WAY_CODE_NAME                     @"REFUND_WAY_CODE_NAME"
#define SLIP_STATUS_CODE                         @"SLIP_STATUS_CODE"
#define TML_ID                                   @"TML_ID"
#define REFUND_CARDNO                            @"REFUND_CARDNO"
#define REFUND_CARD_CODE                         @"REFUND_CARD_CODE"
#define TOTAL_SLIPSEQ                            @"TOTAL_SLIPSEQ"
#define TAX_PROC_TIME_CODE                       @"TAX_PROC_TIME_CODE"
#define TAX_POINT_PROC_CODE                      @"TAX_POINT_PROC_CODE"
#define GOODS_BUY_AMT                            @"GOODS_BUY_AMT"
#define GOODS_TAX_AMT                            @"GOODS_TAX_AMT"
#define GOODS_REFUND_AMT                         @"GOODS_REFUND_AMT"
#define CONSUMS_BUY_AMT                          @"CONSUMS_BUY_AMT"
#define CONSUMS_TAX_AMT                          @"CONSUMS_TAX_AMT"
#define CONSUMS_REFUND_AMT                       @"CONSUMS_REFUND_AMT"
#define TOTAL_EXCOMM_IN_TAX_SALE_AMT             @"TOTAL_EXCOMM_IN_TAX_SALE_AMT"
#define TOTAL_COMM_IN_TAX_SALE_AMT               @"TOTAL_COMM_IN_TAX_SALE_AMT"
#define UNIKEY                                   @"UNIKEY"
#define SALEDT                                   @"SALEDT"
#define REFUNDDT                                 @"REFUNDDT"
#define MERCHANTNO                               @"MERCHANTNO"
#define DESKID                                   @"DESKID"
#define COMPANYID                                @"COMPANYID"
#define SEND_FLAG                                @"SEND_FLAG"
#define PRINT_CNT                                @"PRINT_CNT"
#define REG_DTM                                  @"REG_DTM"


#define REFUND_NOTE                              @"REFUND_NOTE"
#define TYPE                                     @"TYPE"
#define A_ISSUE_DATE                             @"A_ISSUE_DATE"
#define JP_ADDR1                                 @"JP_ADDR1"
#define JP_ADDR2                                 @"JP_ADDR2"
#define AGENCY                                   @"AGENCY"
#define A_ISSUE_NO                               @"A_ISSUE_NO"

#define S_M_FEE                                   @"S_M_FEE"
#define S_G_FEE                                   @"S_G_FEE"
#define MERCHANT_FEE                              @"MERCHANT_FEE"
#define GTF_FEE                                   @"GTF_FEE"
#define P_INPUT_TYPE                              @"P_INPUT_TYPE"

//REFUND_SLIP_SIGN_TABLE
#define SLIP_SIGN_DATA                           @"SLIP_SIGN_DATA"
#define SEND_YN                                  @"SEND_YN"

//SALES_GOODS_TABLE
#define SHOP_NAME                                @"SHOP_NAME"
#define RCT_NO                                   @"RCT_NO"
#define ITEM_TYPE                                @"ITEM_TYPE"
#define ITEM_TYPE_TEXT                           @"ITEM_TYPE_TEXT"
#define ITEM_NO                                  @"ITEM_NO"
#define MAIN_CAT                                 @"MAIN_CAT"
#define MAIN_CAT_TEXT                            @"MAIN_CAT_TEXT"
#define MID_CAT                                  @"MID_CAT"
#define MID_CAT_TEXT                             @"MID_CAT_TEXT"
#define ITEM_NAME                                @"ITEM_NAME"
#define QTY                                      @"QTY"
#define UNIT_AMT                                 @"UNIT_AMT"
#define TAX_AMT                                  @"TAX_AMT"
#define BUY_AMT                                  @"BUY_AMT"
#define REFUND_AMT                               @"REFUND_AMT"
#define TAX_TYPE                                 @"TAX_TYPE"
#define TAX_FORMULA                              @"TAX_FORMULA"
#define TAX_TYPE_CODE                            @"TAX_TYPE_CODE"
#define TAX_TYPE_TEXT                            @"TAX_TYPE_TEXT"
#define FEE_AMT                                  @"FEE_AMT"
#define SHOP_NO                                  @"SHOP_NO"


//SLIP_PRINT_DOCS_TABLE
#define DOCID                                    @"DOCID"
#define RETAILER                                 @"RETAILER"
#define GOODS                                    @"GOODS"
#define TOURIST                                  @"TOURIST"
#define PREVIEW                                  @"PREVIEW"
#define SIGN                                     @"SIGN"

//CATEGORY_TABLE
#define CATEGORY_CODE                            @"CATEGORY_CODE"
#define CATEGORY_NAME                            @"CATEGORY_NAME"
#define P_CODE                                   @"P_CODE"
#define SEQ                                      @"SEQ"

//CODE_TABLE
#define ACTIVEFLG                           @"ACTIVEFLG"
#define CODEDESC                            @"CODEDESC"
#define CODEDIV                             @"CODEDIV"
#define CODENAME                            @"CODENAME"
#define COMCODE                             @"COMCODE"
//#define REMARK                              @"REMARK"
#define SEQ                                 @"SEQ"
#define USEYN                               @"USEYN"
#define ATTRIB01                            @"ATTRIB01"
#define ATTRIB02                            @"ATTRIB02"
#define ATTRIB03                            @"ATTRIB03"
#define ATTRIB04                            @"ATTRIB04"
#define ATTRIB05                            @"ATTRIB05"
#define ATTRIB06                            @"ATTRIB06"
#define ATTRIB07                            @"ATTRIB07"
#define ATTRIB08                            @"ATTRIB08"
#define ATTRIB09                            @"ATTRIB09"
#define ATTRIB10                            @"ATTRIB10"
#define ATTRIB11                            @"ATTRIB11"
#define ATTRIB12                            @"ATTRIB12"


//CONFIG_TABLE
#define TERMINAL_ID                         @"terminal_id"
#define PASPT_SCANNER                       @"passport_scanner"
#define PRINTER                             @"printer"
#define RECEIPT_ADD                         @"receipt_add"
#define SIGNPAD_USE                         @"signpad_use"
#define PRINT_CHOICE                        @"print_choice"
#define PASSWORD                            @"password"


// MERCHANT_TABLE
#define BIZ_INDUSTRY_CODE                         @"BIZ_INDUSTRY_CODE"
#define COMBINED_USEYN                            @"COMBINED_USEYN"
#define FEE_NO                                    @"FEE_NO"
#define FEE_POINT_PROC_CODE                       @"FEE_POINT_PROC_CODE"
#define FEE_PRIORITIES                            @"FEE_PRIORITIES"
#define FEE_PROC_TIME_CODE                        @"FEE_PROC_TIME_CODE"
#define FEE_RATE                                  @"FEE_RATE"
#define FEE_TYPE                                  @"FEE_TYPE"
#define GODDS_DIVISION                            @"GODDS_DIVISION"
#define GOODS_GROUP_CODE                          @"GOODS_GROUP_CODE"
#define HANDWRITTEN_USEYN                         @"HANDWRITTEN_USEYN"
#define INDUSTRY_CODE                             @"INDUSTRY_CODE"
#define JP_ADDR1                                  @"JP_ADDR1"
#define JP_ADDR2                                  @"JP_ADDR2"
#define MERCHANT_ENNM                             @"MERCHANT_ENNM"
#define MERCHANT_JPNM                             @"MERCHANT_JPNM"
#define NATIONALITY_MAPPING_USEYN                 @"NATIONALITY_MAPPING_USEYN"
#define OPT_CORP_JPNM                             @"OPT_CORP_JPNM"
#define OUTPUT_SLIP_TYPE                          @"OUTPUT_SLIP_TYPE"
#define PREVIEW_USEYN                             @"PREVIEW_USEYN"
#define PRINT_GOODS_TYPE                          @"PRINT_GOODS_TYPE"
#define SALEGOODS_USEYN                           @"SALEGOODS_USEYN"
#define SALE_MANAGER_CODE                         @"SALE_MANAGER_CODE"
#define SEND_CUSTOM_FLAG                          @"SEND_CUSTOM_FLAG"
#define TAXMASTER_USEYN                           @"TAXMASTER_USEYN"
#define TAXOFFICE_ADDR                            @"TAXOFFICE_ADDR"
#define TAXOFFICE_NAME                            @"TAXOFFICE_NAME"
#define TAXOFFICE_NO                              @"TAXOFFICE_NO"
#define TAX_ADDR1                                 @"TAX_ADDR1"
#define TAX_ADDR2                                 @"TAX_ADDR2"
#define TAX_FORMULA                               @"TAX_FORMULA"
#define TAX_POINT_PROC_CODE                       @"TAX_POINT_PROC_CODE"
#define TAX_PROC_TIME_CODE                        @"TAX_PROC_TIME_CODE"
#define TAX_PROC_TIME_CODE_DESC                   @"TAX_PROC_TIME_CODE_DESC"
#define TAX_TYPE                                  @"TAX_TYPE"
#define TEL_NO                   @"TEL_NO"
#define VOID_USEYN                                  @"VOID_USEYN"

//TERMINAL_TABLE
#define TML_NO                                    @"TML_NO"

//UNIQ_KEY_TABLE
#define UNI_KEY                                    @"UNIQ_KEY"


//USERINFO_TABLE
#define ID                                   @"id"
#define merchantNo                           @"merchantNo"
#define OPEN_DATE                            @"openDate"
#define USER_ID                              @"userId"
#define USER_NAME                            @"userName"
#define DESK_ID                              @"deskId"


typedef enum DatabaseDataTypeKind
{
    PRIMARYKEYKind = 0,
    TEXTKind = 1,
    INTEGERKind = 2,
    DATETIMEKIND = 3
} DatabaseDataTypeKind;

typedef enum TableKind
{
    REFUNDSLIP_TABLE_KIND = 0,
    REFUND_SLIP_SIGN_TABLE_KIND = 1,
    SALES_GOODS_TABLE_KIND = 2,
    SLIP_PRINT_DOCS_TABLE_KIND = 3,
    CATEGORY_TABLE_KIND = 4,
    CODE_TABLE_KIND = 5,
    CONFIG_TABLE_KIND = 6,
    MERCHANT_TABLE_KIND = 7,
    SLIP_NO_TABLE_KIND = 8,
    TERMINAL_TABLE_KIND = 9,
    UNIQ_KEY_TABLE_KIND = 10,
    USERINFO_TABLE_KIND = 11
}TableKind;

@interface DatabaseManager : NSObject

// database
@property (nonatomic, strong) NSArray *fullDatabaseStructure;
@property (nonatomic, strong) NSArray *tableNames;

+ (instancetype)sharedInstance;
- (BOOL)openExportedDatabase:(sqlite3**)db  vdocsPath:(NSString *) vdocsPath;
- (NSArray *)readExportedData:(TableKind)tableKind vdocsPath:(NSString *) vdocsPath;
- (BOOL)createTable:(TableKind)tableKind;

- (NSArray *)readData:(TableKind)tableKind;
- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName isASC:(BOOL)isASC;
- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue;
- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue fieldName2:(NSString *)fieldName2 fieldValue2:(NSString *)fieldValue2;
- (NSArray *)readData:(TableKind)tableKind conditionData:(NSMutableDictionary *)conditionData;
- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName count:(NSInteger ) count isASC:(BOOL)isASC;
- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue orderField:(NSString *)orderField isASC:(BOOL)isASC;

- (BOOL)deleteData:(TableKind)tableKind;
- (BOOL)deleteData:(TableKind)tableKind data:(NSDictionary *)data;
- (BOOL)deleteData:(TableKind)tableKind  conditionValue :(NSInteger ) conditionValue;
- (BOOL)deleteData:(TableKind)tableKind conditionField:(NSString *) contionField conditionValue :(NSString * ) conditionValue;

- (BOOL)insertData:(TableKind)tableKind data:(NSArray *)dataList;
- (BOOL)insertDataBulk:(TableKind)tableKind data:(NSArray *)dataList;

- (BOOL)updateData:(TableKind)tableKind data:(NSDictionary *)data;
- (BOOL)updateData:(TableKind)tableKind data:(NSDictionary *)data conditionValue :(NSInteger ) conditionValue;
- (BOOL)updateData:(TableKind)tableKind fieldName:(NSString *) fieldName newValue:(NSString *)newValue
    conditionField:(NSString *) contionField conditionValue :(NSString *) conditionValue;

- (void)initBasicVariables;

@end
