//
//  databaseFile.m
//  What'sThat
//
//  Created by Anjani Trivedi on 13/05/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import "databaseFile.h"

@implementation databaseFile
-(void)openDatabase
{	
    BOOL success;
    NSError *error;
	NSFileManager *fileManager=[NSFileManager defaultManager];

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);  
	
	NSString *documentsDirectory = [paths objectAtIndex:0];  
	
	NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"GuessWhat.sqlite"];  
    success = [fileManager fileExistsAtPath:databasePath];
	if(success)
    {	
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) 
        {
            // NSLog(@"Database Successfully Opened ");  
        }
        else 
        {   
            // NSLog(@"Error in opening database ");  
        }
    }
    else
    {
        success=[fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"GuessWhat.sqlite"] toPath:databasePath error:&error];
        if(!success)
        {
            // NSLog(@"Error in database");
        }
        else//First Time Loaded Application....
        {
            if(sqlite3_open([databasePath UTF8String],&database)!=SQLITE_OK)
            {
                
            }
        }
    }
    [self alterTable];
}

-(void) alterTable
{
    BOOL alterTable = FALSE;
    
    NSString *sqlStatementCheckColumn = [NSString stringWithFormat:@"select %@ from %@",DB_LEVEL_SET,DB_TABLE_LEVEL];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare_v2(database, [sqlStatementCheckColumn UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        
    }
    else
    {
        alterTable = TRUE;
    }
    // Release the compiled statement from memory
    sqlite3_finalize(sqlStatement);
    
    if(alterTable)
    {
        NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE %@ ADD COLUMN %@ integer",DB_TABLE_LEVEL,DB_LEVEL_SET];
        const char *update_stmt = [updateSQL UTF8String];
        sqlStatement = nil;
        sqlite3_prepare_v2(database, update_stmt, -1, &sqlStatement, NULL);
        
        if(sqlite3_step(sqlStatement)==SQLITE_DONE)
        {
            NSLog(@"level table altered");
        }
        else
        {
            NSLog(@"level table not altered");
        }
        // Release the compiled statement from memory
        sqlite3_finalize(sqlStatement);
        
        
        sqlStatement = nil;
        NSString *strLevelSetTable = [NSString stringWithFormat:@"CREATE TABLE \"%@\" (\"%@\" nvarchar(50), \"%@\" nvarchar(50))",DB_TABLE_LEVELSET,DB_LEVEL_SET,DB_LEVEL_SET_BOUGHT];
        
        if(sqlite3_prepare_v2(database, [strLevelSetTable UTF8String], -1, &sqlStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            if(sqlite3_step(sqlStatement) == SQLITE_ROW)
            {
                // Read the data from the result row
                
            }
        }
        else
        {
            
        }
        // Release the compiled statement from memory
        sqlite3_finalize(sqlStatement);
        
        [self insertLevelSetData];
    }
}
-(void)insertLevelSetData//currently it is by static 4 level sets
{
    for(int i=0;i<4;i++)
    {
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]init];
        [dictTemp setObject:[NSString stringWithFormat:@"%d",i+1] forKey:DB_LEVEL_SET];
        if(i==0)
            [dictTemp setObject:LEVEL_BOUGHT forKey:DB_LEVEL_SET_BOUGHT];
        else
            [dictTemp setObject:LEVEL_UNBOUGHT forKey:DB_LEVEL_SET_BOUGHT];
        
        [self insertData:dictTemp tableName:DB_TABLE_LEVELSET];
        
        dictTemp = nil;
    }
}


-(void)insertData:(NSDictionary*)dict tableName:(NSString*)tblName
{
	NSString *query =[NSString stringWithFormat:@"insert into %@(",tblName];
	
	NSString *values = @"(";
	int ctr = 1;
	int totalkeys = [[dict allKeys]count];
	for (NSString *key in [dict allKeys])
    {
		NSObject *object = [dict objectForKey:key];
		NSString *strValue = [self getValueOfObject:object];
		query = [query stringByAppendingFormat:@"%@",key];
		values = [values stringByAppendingFormat:@"%@",strValue];
		
		if (ctr != totalkeys) 
        {
			query = [query stringByAppendingString:@","];
			values = [values stringByAppendingString:@","];
		}
		else 
        {
			query = [query stringByAppendingString:@")VALUES"];
			values = [values stringByAppendingString:@")"];
		}
		ctr++;
	}
	query = [query stringByAppendingString:values];
    // NSLog(@"\n query::%@",query);
	[self executeQuery:query];
}

-(int)executeQuery:(NSString*)strQuery
{
	int result = -1;
	const char *query = [strQuery UTF8String];
	sqlite3_stmt *sqlStatement;
	
	int returnValue = sqlite3_prepare_v2(database, query, -1, &sqlStatement, NULL);
	if (returnValue == SQLITE_OK) {
		returnValue = sqlite3_step(sqlStatement);
		if (returnValue == SQLITE_DONE) {
			result = 0;
		}
	}
	sqlite3_reset(sqlStatement);
	return result;
}

-(NSString*)getValueOfObject:(NSObject*)object
{
	NSString *value = nil;
	if ([object isKindOfClass:[NSString class]]) 
    {
        NSString *formateString = [self validateSqlCharacters:(NSString*)object];
		value = [NSString stringWithFormat:@"'%@'",formateString];
	}
	else if([object isKindOfClass:[NSNumber class]])
    {
		NSNumber *num = (NSNumber*)object;
		const char *objCtype = [num objCType];
		if (strcmp(objCtype, "i")==0) {
			value = [NSString stringWithFormat:@"%d",[num intValue]];
		}
		else if (strcmp(objCtype, "f")==0) {
			value = [NSString stringWithFormat:@"%f",[num floatValue]];
		}
		else if (strcmp(objCtype, "d")==0) {
			value = [NSString stringWithFormat:@"%lf",[num doubleValue]];
		}
		else if (strcmp(objCtype, "s")==0) {
			value = [NSString stringWithFormat:@"%d",[num shortValue]];
		}
		else if (strcmp(objCtype, "c")==0) {
			value = [NSString stringWithFormat:@"%d",[num intValue]];
		}
	}
	else 
    {
        NSString *formateString = [self validateSqlCharacters:(NSString*)object];
		value = [NSString stringWithFormat:@"'%@'",formateString];
	}
	return value;
}

-(NSString *)validateSqlCharacters:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    return str;
}

-(NSMutableArray*)selectDataFromTable:(NSString*)strQuery{
	NSMutableArray *arrayResult = [[NSMutableArray alloc]initWithCapacity:0];
	const char *query = [strQuery UTF8String];
	sqlite3_stmt *sqlStatement;
	
	int returnValue = sqlite3_prepare_v2(database, query, -1, &sqlStatement, NULL);
	if (returnValue == SQLITE_OK) {
		sqlite3_bind_text(sqlStatement, 1, query, -1, SQLITE_TRANSIENT);
		NSMutableArray *arrColumn = [[NSMutableArray alloc]initWithCapacity:0];
		for (int i =0 ; i< sqlite3_column_count(sqlStatement) ; i++) {
			const char *stmt = sqlite3_column_name(sqlStatement, i);
			[arrColumn addObject:[NSString stringWithCString:stmt encoding:NSUTF8StringEncoding]]; 
		}	
		int intRow = 1;
		while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
			NSMutableDictionary *dictResult = [[NSMutableDictionary alloc]initWithCapacity:0];
			for (int i =0 ; i<  sqlite3_column_count(sqlStatement); i++) {
				int intValue = 0;
				double dbValue = 0 ;
				const char *strValue;
				switch (sqlite3_column_type(sqlStatement, i)) {
					case SQLITE_INTEGER:
						intValue  = (int)sqlite3_column_int(sqlStatement, i);
						[dictResult setObject:[NSNumber numberWithInt:intValue] forKey:[arrColumn objectAtIndex:i]];				  
						break;
					case SQLITE_FLOAT:
						dbValue  = (double)sqlite3_column_double(sqlStatement, i);
						[dictResult setObject:[NSNumber numberWithDouble:dbValue] forKey:[arrColumn objectAtIndex:i]];
						break;
					case SQLITE_TEXT:
						strValue  = (const char *)sqlite3_column_text(sqlStatement, i);
						[dictResult setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumn objectAtIndex:i]];
						break;
					case SQLITE_BLOB:
						strValue  = (const char *)sqlite3_column_text(sqlStatement, i);
						[dictResult setObject:[NSString stringWithCString:strValue encoding:NSUTF8StringEncoding] forKey:[arrColumn objectAtIndex:i]];
						break;	
						
					case SQLITE_NULL:
						strValue  = (const char *)sqlite3_column_text(sqlStatement, i);
						[dictResult setObject:@"" forKey:[arrColumn objectAtIndex:i]];
						break;	
						
					default:
						break;
				}
			}
			[arrayResult addObject:dictResult];
			intRow ++;
		}
	}
	sqlite3_reset(sqlStatement);
	return arrayResult;
	
}

-(void)updateRecord:(NSDictionary*)dict :(NSString*)keyId :(NSString*)tableName
{
	// NSLog(@"updateRecord");
	NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET",tableName];
	
	int cnt = 1;
	BOOL isKeyFound= NO;
	int totalKeysCount = [[dict allKeys]count];
	
	for (NSString* key in [dict allKeys]) {
		if ([key isEqualToString:keyId]) {
			isKeyFound = YES;
			//cnt++;
			//continue;
		}
		NSObject *object = [dict objectForKey:key];
		NSString *strValue = [self getValueOfObject:object];
		query = [query stringByAppendingFormat:@" %@ = %@",key,strValue];
		
		//if (isKeyFound == YES && cnt != totalKeysCount) {
        //			query = [query stringByAppendingString:@","];
        //		}
        //		else if(isKeyFound == NO && cnt != totalKeysCount-1){
        //			query = [query stringByAppendingString:@","];
        //		}
		if (cnt != totalKeysCount) {
			query = [query stringByAppendingString:@","];
		}
		cnt++;
	}
    
	NSObject *object = [dict objectForKey:keyId];
	NSString *value = [self getValueOfObject:object];
	query = [query stringByAppendingFormat:@" WHERE %@=%@",keyId,value];
	[self executeQuery:query];
	
}

-(void)updateRecordWithMoreConditions:(NSDictionary*)dict :(NSDictionary*)whereDict :(NSString*)tableName
{
	// NSLog(@"updateRecord");
	NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET",tableName];
	
	int cnt = 1;
	int totalKeysCount = [[dict allKeys]count];
	
	for (NSString* key in [dict allKeys]) 
    {
		NSObject *object = [dict objectForKey:key];
		NSString *strValue = [self getValueOfObject:object];
		query = [query stringByAppendingFormat:@" %@ = %@",key,strValue];
		
		if (cnt != totalKeysCount) 
        {
			query = [query stringByAppendingString:@","];
		}
		cnt++;
	}
    
    int intTotalWhereKeyCount = [[whereDict allKeys] count]; 
    if(intTotalWhereKeyCount >0)
    {
        int cntWhere = 1;

        query = [query stringByAppendingString:@" WHERE "];
        for (NSString* key in [whereDict allKeys]) 
        {
            NSObject *object = [whereDict objectForKey:key];
            NSString *value = [self getValueOfObject:object];
            query = [query stringByAppendingFormat:@"%@=%@",key,value];        
            
            if (cntWhere != intTotalWhereKeyCount) {
                query = [query stringByAppendingString:@" and "];
            }
            cntWhere++;
            
        }        
    }
    
	[self executeQuery:query];
}


-(void)dealloc
{
	sqlite3_close(database);
}


@end
