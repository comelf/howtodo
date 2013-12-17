//
//  ViewController.h
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 5. 20..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBconnect.h"
#import "ChildViewController.h"
#import "makeNewController.h"
#import "sqlite3.h"


@interface ViewController : UIViewController <UIAlertViewDelegate>
{
    DBconnect *DB1, *DB2;
    NSMutableArray* editDB,*mainDB;
    int maxRecord, totalnum_linkButton;
    int del_i;
    UILabel* titleLabel;
    NSMutableArray* linkButtonArray,*delButtonArray,*titleLabelArray,*editButtonArray;
    int max_x,max_y,button_w,button_h;
    int max_count_x, max_count_y,max_id;
    float buttonSpace;
    UIScrollView* scrollViewInIndex;
    bool editMode,plusMode;
    UIButton* addButton,*delButton, *linkButton, *editButton;
    sqlite3* manual;
}


@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *bg;


- (NSString*)filePath;
- (void) createLinkButton:(int)arrNum;
- (IBAction) editClick:(id)sender;

- (IBAction) Newlinkbutton:(id)sender;
- (IBAction) deleteButtonClick:(id)sender;
- (IBAction) editButtonClick:(id)sender;
- (void) returnToMain:(BOOL)NewOrLoad DBid:(int)num;
- (void) scrollViewResize;
- (void) ButtonRelocation;
- (void) interfaceStatus;
@end
