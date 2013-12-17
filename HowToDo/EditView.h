//
//  EditView.h
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 5. 20..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"
#import "InputBox.h"
#import "DBconnect.h"


@interface EditView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    InputBox* firstInput;
    InputBox* nextInput;
    NSMutableArray* inputList;
    float value_x,value_y;
    int numIndex;
    DBconnect* DBinEV;
    int totalIdx;
    NSString* className;
    NSMutableArray* DBarray;
    NSMutableArray* DelButtonArray;
    NSMutableArray* imgbuttonArray;
    NSMutableArray* insertButtonArray;
    int record_id;
    BOOL RightorLeft;
    
}


@property BOOL loadData;
@property int buttonTag;
@property (nonatomic, retain) IBOutlet UIButton* deleteButton;
@property (nonatomic, retain) IBOutlet UIButton* imgAddButton;
@property (nonatomic, retain) IBOutlet UIButton* AddButton;
@property (nonatomic, retain) IBOutlet UIButton* insertButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollViewPointer;
@property (nonatomic, retain) IBOutlet UIPopoverController *popoverController;
-(void) initDB:(DBconnect*)path array:(NSMutableArray*)array recordid:(int)fid;
-(IBAction)addClick:(id)sender;
-(IBAction)saveDB:(id)sender;
-(void) totalIndexinit:(int)num;
-(void) CreatedeleteButton:(NSString*)filepath;
-(IBAction)deleteInputBox:(id)sender;;
-(id) saveImage:(UIImage *)img :(NSString *)path :(NSString *)title;
-(void) scrollViewResize:(int)i;
@end
