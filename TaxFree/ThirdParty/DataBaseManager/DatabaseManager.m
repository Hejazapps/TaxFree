
#import "DatabaseManager.h"

@implementation DatabaseManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)openDatabase:(sqlite3**)db
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *dbpath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, DatabaseName];
    
    return (BOOL) (sqlite3_open([dbpath UTF8String], db) == SQLITE_OK);
}
- (BOOL)openExportedDatabase:(sqlite3**)db  vdocsPath:(NSString *) vdocsPath
{


    return (BOOL) (sqlite3_open([vdocsPath UTF8String], db) == SQLITE_OK);
}

// bookings data
- (BOOL)createTable:(TableKind)tableKind
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    // Create the database
    if ([self openDatabase:&db] == YES)
    {
        char* errMsg;
        
        NSString* createSQL = [self generateCreateSql:tableKind];
        
        const char* create_stmt = [createSQL UTF8String];
        
        if (sqlite3_exec(db, create_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
#ifdef _LOG_
            NSLog(@"Failed to create %@ table", BOOKINGS_TABLE_NAME);
#endif
        }
        else
        {
            result = YES;
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

- (NSArray *)readData:(TableKind)tableKind
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@", self.tableNames[tableKind]];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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
- (NSArray *)readExportedData:(TableKind)tableKind vdocsPath:(NSString *) vdocsPath{
    NSMutableArray* result = [[NSMutableArray alloc] init];

    sqlite3* db = nil;

    if ([self openExportedDatabase:&db vdocsPath:vdocsPath] == YES)
    {
        sqlite3_stmt* statement;

        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@", self.tableNames[tableKind]];
        const char* query_stmt = [querySQL UTF8String];

        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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
- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName isASC:(BOOL)isASC
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ %@", self.tableNames[tableKind], fieldName, isASC ? @"ASC" : @"DESC"];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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
- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName count:(NSInteger ) count isASC:(BOOL)isASC{
    NSMutableArray* result = [[NSMutableArray alloc] init];

    sqlite3* db = nil;

    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;

        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ %@ LIMIT  %ld", self.tableNames[tableKind], fieldName,  @"DESC",(long)count];
        const char* query_stmt = [querySQL UTF8String];

        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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

- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", self.tableNames[tableKind], fieldName, fieldValue];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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

- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue fieldName2:(NSString *)fieldName2 fieldValue2:(NSString *)fieldValue2
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
        {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@' AND %@='%@'", self.tableNames[tableKind], fieldName, fieldValue, fieldName2, fieldValue2];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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

- (NSArray *)readData:(TableKind)tableKind conditionData:(NSMutableDictionary *)conditionData
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    NSArray *allKeys = [conditionData.allKeys copy];
    NSArray *allValues = [conditionData.allValues copy];
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
        {
        sqlite3_stmt* statement;
    
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@'", self.tableNames[tableKind], allKeys[0], allValues[0]];
        for (int i = 1; i < allKeys.count; i++) {
            querySQL = [NSString stringWithFormat:@"%@ AND %@='%@'", querySQL, allKeys[i], allValues[i]];
        }
        
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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


- (NSArray *)readData:(TableKind)tableKind fieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue orderField:(NSString *)orderField isASC:(BOOL)isASC
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@='%@' ORDER BY %@ %@", self.tableNames[tableKind], fieldName, fieldValue, orderField, isASC ? @"ASC" : @"DESC"];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
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

- (BOOL)deleteData:(TableKind)tableKind
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
        {
        sqlite3_stmt* statement;
        
        NSString* querySQL = [NSString stringWithFormat:@"DELETE FROM %@", self.tableNames[tableKind]];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            if (sqlite3_step(statement) == SQLITE_DONE)
                {
                result = YES;
                }
            
            sqlite3_finalize(statement);
            }
        
        sqlite3_close(db);
        }
    
    return result;
}

- (BOOL)deleteData:(TableKind)tableKind data:(NSDictionary *)data
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        
        NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
        NSDictionary *firstField = [tableStructure firstObject];
        NSString* querySQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id='%ld'", self.tableNames[tableKind], (long)[data[firstField[FieldName]] integerValue]];
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                result = YES;
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(db);
    }
    
    return result;
}
- (BOOL)deleteData:(TableKind)tableKind  conditionValue :(NSInteger ) conditionValue{
    BOOL result = NO;

    sqlite3* db = nil;

    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;

        NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
        NSDictionary *firstField = [tableStructure firstObject];
        NSString* querySQL = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%ld'", self.tableNames[tableKind], firstField[FieldName], (long) conditionValue];
        const char* query_stmt = [querySQL UTF8String];

        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                result = YES;
            }

            sqlite3_finalize(statement);
        }

        sqlite3_close(db);
    }

    return result;

}

- (BOOL)deleteData:(TableKind)tableKind conditionField:(NSString *) contionField conditionValue :(NSString * ) conditionValue{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
        {
        sqlite3_stmt* statement;
        NSString *querySQL =  [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@='%@'", self.tableNames[tableKind], contionField,conditionValue];
        
        const char* query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(db, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
            if (sqlite3_step(statement) == SQLITE_DONE)
                {
                result = YES;
                }
            
            sqlite3_finalize(statement);
            }
        
        sqlite3_close(db);
        }
    
    return result;
}


- (BOOL)insertData:(TableKind)tableKind data:(NSArray *)dataList
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES) {
    
        sqlite3_stmt* statement;
        NSString *insertSQL = [self generateInsertSql:tableKind data:dataList];
        const char* insert_stmt = [insertSQL UTF8String];
        
        if (sqlite3_prepare_v2(db, insert_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
                result = YES;
            
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Error while insert data(%s)", sqlite3_errmsg(db));
        }
                
        sqlite3_close(db);
    }
    
    return result;
}

- (BOOL)insertDataBulk:(TableKind)tableKind data:(NSArray *)dataList
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES) {
        sqlite3_exec(db, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
        
        for (int i = 0; i < dataList.count; i++) {
            sqlite3_stmt* statement;
            NSString *insertSQL = [self generateInsertSql2:tableKind data:dataList[i]];
            const char* insert_stmt = [insertSQL UTF8String];
            
            if (sqlite3_prepare_v2(db, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE)
                    result = YES;
                
                sqlite3_finalize(statement);
            }
            else {
                NSLog(@"Error while insert data(%s)", sqlite3_errmsg(db));
            }
        }
        
        
        sqlite3_exec(db, "COMMIT TRANSACTION", 0, 0, 0);
        
        sqlite3_close(db);
    }
    
    return result;
}

- (BOOL)updateData:(TableKind)tableKind data:(NSDictionary *)data
{
    BOOL result = NO;
    
    sqlite3* db = nil;
    
    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        NSString *updateSQL = [self generateUpdateSql:tableKind data:data];
        
        const char* update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare_v2(db, update_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
                result = YES;
            
            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Error while update data(%s)", sqlite3_errmsg(db));
        }
        
        sqlite3_close(db);
    }
    
    return result;
}
- (BOOL)updateData:(TableKind)tableKind data:(NSDictionary *)data
   conditionValue :(NSInteger ) conditionValue{
    BOOL result = NO;

    sqlite3* db = nil;

    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        NSString *updateSQL =  [self generateUpdateSql:tableKind data:data conditionValue:conditionValue];

        const char* update_stmt = [updateSQL UTF8String];

        if (sqlite3_prepare_v2(db, update_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
                result = YES;

            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Error while update data(%s)", sqlite3_errmsg(db));
        }

        sqlite3_close(db);
    }

    return result;

}
- (BOOL)updateData:(TableKind)tableKind fieldName:(NSString *) fieldName newValue:(NSString *)newValue
    conditionField:(NSString *) contionField conditionValue :(NSString * ) conditionValue{
    BOOL result = NO;

    sqlite3* db = nil;

    if ([self openDatabase:&db] == YES)
    {
        sqlite3_stmt* statement;
        NSString *updateSQL =  [NSString stringWithFormat:@"UPDATE %@ SET %@= '%@' WHERE %@='%@'", self.tableNames[tableKind],
                                 fieldName,newValue, contionField,conditionValue];

        const char* update_stmt = [updateSQL UTF8String];

        if (sqlite3_prepare_v2(db, update_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
                result = YES;

            sqlite3_finalize(statement);
        }
        else
        {
            NSLog(@"Error while update data(%s)", sqlite3_errmsg(db));
        }

        sqlite3_close(db);
    }
    
    return result;

}
- (NSString *)generateCreateSql:(TableKind)tableKind
{
    NSString *result;
    
    NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
    NSString *fieldNames = @"(";
    NSDictionary *lastDic = [tableStructure lastObject];
    
    for (NSDictionary *dic in tableStructure)
    {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        
        if (fieldType == PRIMARYKEYKind)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER PRIMARY KEY AUTOINCREMENT)", fieldName];
        }
        else if (fieldType == TEXTKind)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ TEXT, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ TEXT)", fieldName];
        }
        else if (fieldType == INTEGERKind)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ INTEGER)", fieldName];
        }
        else if (fieldType == DATETIMEKIND)
        {
            if (![dic isEqual:lastDic])
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ DATETIME, ", fieldName];
            else
                fieldNames = [fieldNames stringByAppendingFormat:@"%@ DATETIME)", fieldName];
        }
    }
    
    result = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ %@", self.tableNames[tableKind], fieldNames];
    
    return result;
}

- (NSString *)generateInsertSql:(TableKind)tableKind data:(NSArray *)dataList
{
    NSString *result;
    
    NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
    NSString *fieldNames = @"(";
    NSString *values = @"(";
    NSDictionary *lastDic = [tableStructure lastObject];
    
    for (NSDictionary *dic in tableStructure) {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        
        if (fieldType == PRIMARYKEYKind)
            continue;
        if (![dic isEqual:lastDic])
            fieldNames = [fieldNames stringByAppendingFormat:@"%@, ", fieldName];
        else
            fieldNames = [fieldNames stringByAppendingFormat:@"%@)", fieldName];
    }
    
    for (int i = 0; i < dataList.count; i++) {
        for (NSDictionary *dic in tableStructure) {
            DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
            NSString *fieldName = dic[FieldName];
            NSString *value = dataList[i][fieldName];
            if (value == nil) {
                value = @"";
            }
            
            if (fieldType == TEXTKind || fieldType == DATETIMEKIND) {
                if (![dic isEqual:lastDic])
                    values = [values stringByAppendingFormat:@"\"%@\", ", value];
                else
                    values = [values stringByAppendingFormat:@"\"%@\")", value];
            }
            else if (fieldType == INTEGERKind) {
                if (![dic isEqual:lastDic])
                    values = [values stringByAppendingFormat:@"%ld, ", (long)[value integerValue]];
                else
                    values = [values stringByAppendingFormat:@"%ld)", (long)[value integerValue]];
            }
        }
        if (i < dataList.count - 1) {
            values = [values stringByAppendingFormat:@",("];
        }
    }
    
    
    result = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@", self.tableNames[tableKind], fieldNames, values];
    
    return result;
}

- (NSString *)generateInsertSql2:(TableKind)tableKind data:(NSDictionary *)data
{
    NSString *result;
    
    NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
    NSString *fieldNames = @"(";
    NSString *values = @"(";
    NSDictionary *lastDic = [tableStructure lastObject];
    
    for (NSDictionary *dic in tableStructure)
        {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        NSString *value = data[fieldName];
        
        
        if (fieldType == PRIMARYKEYKind)
            continue;
        if (![dic isEqual:lastDic])
            fieldNames = [fieldNames stringByAppendingFormat:@"%@, ", fieldName];
        else
            fieldNames = [fieldNames stringByAppendingFormat:@"%@)", fieldName];
        
        if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
            {
            if (![dic isEqual:lastDic])
                values = [values stringByAppendingFormat:@"\"%@\", ", value];
            else
                values = [values stringByAppendingFormat:@"\"%@\")", value];
            }
        else if (fieldType == INTEGERKind)
            {
            if (![dic isEqual:lastDic])
                values = [values stringByAppendingFormat:@"%ld, ", (long)[value integerValue]];
            else
                values = [values stringByAppendingFormat:@"%ld)", (long)[value integerValue]];
            }
        }
    
    result = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@", self.tableNames[tableKind], fieldNames, values];
    
    return result;
}


- (NSString *)generateUpdateSql:(TableKind)tableKind data:(NSDictionary *)data
{
    NSString *result;
    
    NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
    NSString *nameValuePairs = @"";
    NSDictionary *firstDic = [tableStructure firstObject];
    NSDictionary *lastDic = [tableStructure lastObject];
    long firstValue = (long)[data[firstDic[FieldName]] integerValue];
    
    for (NSDictionary *dic in tableStructure)
    {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        NSString *value = data[fieldName];
    if (value == nil) {
        value = @"";
    }
        
        if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
        {
            if (![dic isEqual:lastDic])
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%@', ", fieldName, value];
            else
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%@'", fieldName, value];
        }
        else if (fieldType == INTEGERKind)
        {
            if (![dic isEqual:lastDic])
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%ld', ", fieldName, (long)[value integerValue]];
            else
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%ld'", fieldName, (long)[value integerValue]];
        }
    }
    
    result = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE id='%ld'", self.tableNames[tableKind], nameValuePairs, firstValue];
    
    return result;
}
- (NSString *)generateUpdateSql:(TableKind)tableKind data:(NSDictionary *)data conditionValue:(NSInteger ) conditionValue
{
    NSString *result;

    NSArray *tableStructure = self.fullDatabaseStructure[tableKind];
    NSString *nameValuePairs = @"";
    NSDictionary *firstDic = [tableStructure firstObject];
    NSDictionary *lastDic = [tableStructure lastObject];
    NSString *firstField = firstDic[FieldName];

    for (NSDictionary *dic in tableStructure)
    {
        DatabaseDataTypeKind fieldType = (DatabaseDataTypeKind)[dic[FieldType] integerValue];
        NSString *fieldName = dic[FieldName];
        NSString *value = data[fieldName];
    if (value == nil) {
        value = @"";
    }

        if (fieldType == TEXTKind || fieldType == DATETIMEKIND)
        {
            if (![dic isEqual:lastDic])
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%@', ", fieldName, value];
            else
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%@'", fieldName, value];
        }
        else if (fieldType == INTEGERKind)
        {
            if (![dic isEqual:lastDic])
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%ld', ", fieldName, (long)[value integerValue]];
            else
                nameValuePairs = [nameValuePairs stringByAppendingFormat:@"%@='%ld'", fieldName, (long)[value integerValue]];
        }
    }

    result = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@='%ld'", self.tableNames[tableKind], nameValuePairs,firstField, (long)conditionValue];

    return result;
}

- (void)initBasicVariables
{
    NSMutableArray *tempStructure = [[NSMutableArray alloc] init];
    NSMutableArray *tableStructure = [[NSMutableArray alloc] init];
    NSMutableDictionary *fieldDic = [[NSMutableDictionary alloc] init];

////////////    REFUNDSLIP_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USERID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = BUYER_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PASSPORT_SERIAL_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PERMIT_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = NATIONALITY_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = NATIONALITY_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GENDER_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = BUYER_BIRTH; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PASS_EXPIRYDT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = INPUT_WAY_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = RESIDENCE_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = RESIDENCE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ENTRYDT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PASSPORT_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PASSPORT_TYPE_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SLIP_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MERCHANT_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SHOP_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = OUT_DIV_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REFUND_WAY_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REFUND_WAY_CODE_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SLIP_STATUS_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TML_ID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REFUND_CARDNO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REFUND_CARD_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TOTAL_SLIPSEQ; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_PROC_TIME_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_POINT_PROC_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GOODS_BUY_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GOODS_TAX_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GOODS_REFUND_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CONSUMS_BUY_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CONSUMS_TAX_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CONSUMS_REFUND_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TOTAL_EXCOMM_IN_TAX_SALE_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TOTAL_COMM_IN_TAX_SALE_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = UNIKEY; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SALEDT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REFUNDDT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MERCHANTNO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = DESKID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = COMPANYID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SEND_FLAG; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PRINT_CNT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REG_DTM; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    fieldDic[FieldName] = REFUND_NOTE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = A_ISSUE_DATE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = JP_ADDR1; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = JP_ADDR2; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = AGENCY; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = A_ISSUE_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    fieldDic[FieldName] = S_M_FEE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = S_G_FEE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MERCHANT_FEE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GTF_FEE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = P_INPUT_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MEMO_TEXT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    [tempStructure addObject:tableStructure];


////////////   REFUND_SLIP_SIGN_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USERID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SLIP_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SLIP_SIGN_DATA; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SEND_YN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REG_DTM; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
////////////   SALES_GOODS_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USERID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SHOP_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = RCT_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ITEM_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ITEM_TYPE_TEXT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ITEM_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MAIN_CAT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MAIN_CAT_TEXT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MID_CAT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MID_CAT_TEXT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ITEM_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = QTY; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = UNIT_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = BUY_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REFUND_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_FORMULA; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_TYPE_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_TYPE_TEXT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = FEE_AMT; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SHOP_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SLIP_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = REG_DTM; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
    
////////////   SLIP_PRINT_DOCS_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USERID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SLIP_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = DOCID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = RETAILER; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GOODS; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TOURIST; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PREVIEW; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SIGN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
////////////   CATEGORY_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CATEGORY_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CATEGORY_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = P_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SEQ; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
////////////   CODE_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ACTIVEFLG; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CODEDESC; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CODEDIV; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = CODENAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = COMCODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
//    fieldDic[FieldName] = REMARK; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SEQ; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB01; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB02; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB03; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB04; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB05; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB06; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB07; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB08; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB09; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB10; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB11; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = ATTRIB12; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
    
////////////   CONFIG_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USERID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PASPT_SCANNER; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PRINTER; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = RECEIPT_ADD; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SIGNPAD_USE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PRINT_CHOICE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PASSWORD; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
    
////////////   MERCHANT_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = BIZ_INDUSTRY_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = COMBINED_USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = FEE_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = FEE_POINT_PROC_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = FEE_PRIORITIES; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = FEE_PROC_TIME_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = FEE_RATE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = FEE_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GODDS_DIVISION; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = GOODS_GROUP_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = HANDWRITTEN_USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = INDUSTRY_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = JP_ADDR1; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = JP_ADDR2; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MERCHANT_ENNM; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MERCHANT_JPNM; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = MERCHANT_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = NATIONALITY_MAPPING_USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = OPT_CORP_JPNM; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = OUTPUT_SLIP_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PREVIEW_USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = PRINT_GOODS_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SALEGOODS_USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SALE_MANAGER_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SEND_CUSTOM_FLAG; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAXMASTER_USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAXOFFICE_ADDR; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAXOFFICE_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAXOFFICE_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_ADDR1; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_ADDR2; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_FORMULA; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_POINT_PROC_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_PROC_TIME_CODE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_PROC_TIME_CODE_DESC; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TAX_TYPE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TEL_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = VOID_USEYN; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
////////////   SLIP_NO_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USERID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = SLIP_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
////////////   TERMINAL_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = TML_NO; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
    
////////////   UNIQ_KEY_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USERID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = UNI_KEY; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    
    [tempStructure addObject:tableStructure];
    
////////////   USERINFO_TABLE      //////////////////////////
    tableStructure = [[NSMutableArray alloc] init];
    
    fieldDic[FieldName] = ID; fieldDic[FieldType] = @(PRIMARYKEYKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = merchantNo; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = OPEN_DATE; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USER_ID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = USER_NAME; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];
    fieldDic[FieldName] = DESK_ID; fieldDic[FieldType] = @(TEXTKind); [tableStructure addObject:[fieldDic copy]];

    [tempStructure addObject:tableStructure];
/////////////////////////////////////////////////////////

    [DatabaseManager sharedInstance].fullDatabaseStructure = tempStructure;
    [DatabaseManager sharedInstance].tableNames = [NSArray arrayWithObjects:REFUNDSLIP_TABLE, REFUND_SLIP_SIGN_TABLE, SALES_GOODS_TABLE, SLIP_PRINT_DOCS_TABLE, CATEGORY_TABLE, CODE_TABLE, CONFIG_TABLE, MERCHANT_TABLE, SLIP_NO_TABLE, TERMINAL_TABLE, UNIQ_KEY_TABLE, USERINFO_TABLE, nil];
}

@end
