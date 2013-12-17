//
//  DBconnect.m
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 5. 22..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import "DBconnect.h"

@implementation DBconnect
-(int) totalRecord
{
    return total;
}

-(NSString*)filePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"manual.sqlite"];
}

-(void)openDB:(sqlite3*)dbpath
{
    manual = dbpath;
}

-(void) createTable:(NSString*) tableName
             field1:(NSString*) img_path
             field2:(NSString*) text_field
             field3:(NSString*) index_n
             field4:(NSString*) f_id
{
    DBtableName=tableName;
    DBfield1=index_n;
    DBfield2=img_path;
    DBfield3=text_field;
    DBfield4=f_id;
    
    NSString *sql;
    if([DBfield4 isEqual:@"NULL"]){
        sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT);",DBtableName,DBfield1,DBfield2,DBfield3];
    }else{
        DBfield4=f_id;
        sql = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY, '%@' TEXT,'%@' TEXT,'%@' INTEGER);",DBtableName,DBfield1,DBfield2,DBfield3,DBfield4];
        //NSLog(@"%@",sql);
    }
    char *err;
    if(sqlite3_exec(manual,[sql UTF8String], NULL, NULL,&err)!= SQLITE_OK){
        sqlite3_close(manual);
        NSAssert(0, @"could not create table");
    }else{
        NSLog(@"table created");
    }
}

-(void) saveDBforMain:(int)value1
              imgpath:(NSString*)value2
              content:(NSString*)value3
{
    NSString *sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES (%d,'%@','%@')",DBtableName,DBfield1,DBfield2,DBfield3,value1,value2,value3];
    char *err;
    if (sqlite3_exec(manual,[sql UTF8String],NULL,NULL,&err)!=SQLITE_OK){sqlite3_close(manual);
        NSAssert(0,@"Could not save to table");
    }else{
        NSLog(@"table saved");
    }
}
-(void) saveDBforEdit:(NSString*)value2
              content:(NSString*)value3
                 t_id:(int)value4
{
    NSString *sql= [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@') VALUES ('%@','%@',%d)",DBtableName,DBfield2,DBfield3,DBfield4,value2,value3,value4];
    char *err;
    if (sqlite3_exec(manual,[sql UTF8String],NULL,NULL,&err)!=SQLITE_OK){sqlite3_close(manual);
        NSAssert(0,@"Could not save to table");
    }else{
        NSLog(@"table saved");
    }
}




-(void) updateDB:(int)value1
           title:(NSString*)value2
         content:(NSString*)value3
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE '%@' SET '%@'='%@','%@'='%@' where '%@'='%d'",DBtableName,DBfield2,value2,DBfield3,value3,DBfield1,value1];
    
    char *err;
    if (sqlite3_exec(manual,[sql UTF8String],NULL,NULL,&err)!=SQLITE_OK){sqlite3_close(manual);
        NSAssert(0,@"Could not update table");
    }else{
        NSLog(@"table updated");
    }
}
-(void) deleteDBinId:(int)key
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ =%d",DBtableName,DBfield4,key];
    
    char *err;
    if (sqlite3_exec(manual,[sql UTF8String],NULL,NULL,&err)!=SQLITE_OK){sqlite3_close(manual);
        NSAssert(0,@"Could not Delete one data");
    }else{
        NSLog(@"Delete one data");
    }
}
-(void) deleteDBinIndex:(int)key
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE %@ =%d",DBtableName,DBfield1,key];
    
    //sqlite3_stmt *delstatement;

    
    char *err;
    if (sqlite3_exec(manual,[sql UTF8String],NULL,NULL,&err)!=SQLITE_OK){sqlite3_close(manual);
        NSAssert(0,@"Could not Delete one data");
    }else{
        NSLog(@"Delete data");
    }
    
}
-(void) deleteDBall
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'",DBtableName];
    
    char *err;
    if (sqlite3_exec(manual,[sql UTF8String],NULL,NULL,&err)!=SQLITE_OK){sqlite3_close(manual);
        NSAssert(0,@"Could not Delete all data ");
    }else{
        NSLog(@"Delete all data");
    }
}


- (id)dbQuerySelect
{
    NSString *querytring= [NSString stringWithFormat:@"SELECT * FROM '%@'",DBtableName];
    
    sqlite3_prepare(manual, [querytring cStringUsingEncoding:NSUTF8StringEncoding], querytring.length, &statment, nil);
    NSMutableArray *array = [[NSMutableArray alloc]init];
    total=0;
    while (sqlite3_step(statment)==SQLITE_ROW) {
        int Index = sqlite3_column_int(statment, 0);
        char* aField1 = sqlite3_column_text(statment, 1);
        char* aField2 = sqlite3_column_text(statment, 2);
        //int aField3 = sqlite3_column_int(statment, 3);
        
        NSNumber *DBIndex = [NSNumber numberWithInt:Index];
        NSString *Field1Text = [NSString stringWithCString:aField1 encoding:NSUTF8StringEncoding];
        NSString *Field2Text = [NSString stringWithCString:aField2 encoding:NSUTF8StringEncoding];
        //NSNumber *DBId = [NSNumber numberWithInt:aField3];
        NSArray *record = [NSArray arrayWithObjects:DBIndex,Field1Text,Field2Text, nil] ;
        [array addObject:record];
        total+=1;
    }
    return array;
}
- (id)dbQuerySelectInputbox:(int)num
{
    NSString *querytring= [NSString stringWithFormat:@"SELECT  %@,%@ FROM %@ WHERE %@ = %d",DBfield2,DBfield3,DBtableName,DBfield4,num];
    //NSLog(@"%@",querytring);
    sqlite3_prepare_v2(manual, [querytring cStringUsingEncoding:NSUTF8StringEncoding], -1, &statment, NULL);
    //sqlite3_prepare(manual, [querytring cStringUsingEncoding:NSUTF8StringEncoding], -1, &statment, nil);
    NSMutableArray *array = [[NSMutableArray alloc]init];
    total=0;
    
    while (sqlite3_step(statment)==SQLITE_ROW) {
        //int Index = sqlite3_column_int(statment, 0);
        char* aField1 = sqlite3_column_text(statment, 0);
        char* aField2 = sqlite3_column_text(statment, 1);
        
        
        //NSNumber *DBIndex = [NSNumber numberWithInt:Index];
        NSString *Field1Text = [NSString stringWithCString:aField1 encoding:NSUTF8StringEncoding];
        NSString *Field2Text = [NSString stringWithCString:aField2 encoding:NSUTF8StringEncoding];
        
        NSArray *record = [NSArray arrayWithObjects:Field1Text,Field2Text, nil] ;
        [array addObject:record];
        total+=1;
    }
    return array;
}
- (id)tesrq
{
    NSString *querytring= [NSString stringWithFormat:@"SELECT * FROM '%@'",DBtableName];
    
    sqlite3_prepare(manual, [querytring cStringUsingEncoding:NSUTF8StringEncoding], querytring.length, &statment, nil);
    NSMutableArray *array = [[NSMutableArray alloc]init];
    total=0;
    while (sqlite3_step(statment)==SQLITE_ROW) {
        int Index = sqlite3_column_int(statment, 0);
        char* aField1 = sqlite3_column_text(statment, 1);
        char* aField2 = sqlite3_column_text(statment, 2);
        int iidd = sqlite3_column_int(statment, 3);
        
        
        NSNumber *DBIndex = [NSNumber numberWithInt:Index];
        NSString *Field1Text = [NSString stringWithCString:aField1 encoding:NSUTF8StringEncoding];
        NSString *Field2Text = [NSString stringWithCString:aField2 encoding:NSUTF8StringEncoding];
        NSNumber *DBid = [NSNumber numberWithInt:iidd];
        NSArray *record = [NSArray arrayWithObjects:DBIndex,Field1Text,Field2Text,DBid, nil] ;
        [array addObject:record];
        total+=1;
    }
    return array;
}


-(int)maxIdRecord
{
    NSString *sql= [NSString stringWithFormat:@"SELECT MAX(%@) FROM '%@'",DBfield1,DBtableName];
    sqlite3_prepare(manual, [sql cStringUsingEncoding:NSUTF8StringEncoding], sql.length, &statment, nil);
    sqlite3_step(statment);
    int num = sqlite3_column_int(statment, 0);
    
    return num;
}
@end
