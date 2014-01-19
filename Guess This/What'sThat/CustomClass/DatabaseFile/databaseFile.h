//
//  databaseFile.h
//  What'sThat
//
//  Created by Anjani Trivedi on 13/05/13.
//  Copyright (c) 2013 Vibhooti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface databaseFile : NSObject
{
    sqlite3* database;//Database
}

-(void)openDatabase;
-(void)insertData:(NSDictionary*)dict tableName:(NSString*)tblName;
-(int)executeQuery:(NSString*)strQuery;
-(NSString*)getValueOfObject:(NSObject*)object;
-(NSMutableArray*)selectDataFromTable:(NSString*)strQuery;
-(void)updateRecord:(NSDictionary*)dict :(NSString*)keyId :(NSString*)tableName;
-(NSString *)validateSqlCharacters:(NSString *)str;
-(void)updateRecordWithMoreConditions:(NSDictionary*)dict :(NSDictionary*)keyId :(NSString*)tableName;
-(void)updateLevelFirstSetFirstTime;
-(void)updateLevelOtherSetsFirstTime;
@end
