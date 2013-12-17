///Users/byung-woolee/Desktop/hudy/GoToAction/GoToAction.xcodeproj
//  DBconnect.h
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 5. 22..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface DBconnect : NSObject
{
    sqlite3 *manual;
    NSString *DBtableName, *DBfield1, *DBfield2, *DBfield3, *DBfield4;
    sqlite3_stmt *statment;
    int total;
}

-(NSString*) filePath;
-(void) openDB:(sqlite3*)dbpath;
-(void) createTable:(NSString*) tableName
             field1:(NSString*) img_path
             field2:(NSString*) text_field
             field3:(NSString*) index_n
             field4:(NSString*) f_id;

-(void) saveDBforMain:(int)value1
              imgpath:(NSString*)value2
              content:(NSString*)value3;

-(void) updateDB:(int)value1
           title:(NSString*)value2
         content:(NSString*)value3;
-(void) saveDBforEdit:(NSString*)value2
              content:(NSString*)value3
                 t_id:(int)value4;
-(void) deleteDBinId:(int)key;
-(void) deleteDBinIndex:(int)key;
-(void) deleteDBall;
- (id)dbQuerySelect;
- (id)dbQuerySelectInputbox:(int)num;
-(int) totalRecord;
-(int)maxIdRecord;

- (id)tesrq;
@end
