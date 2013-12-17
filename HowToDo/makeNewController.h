//
//  makeNewController.h
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 6. 2..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBconnect.h"
#import "EditView.h"

@protocol makeNewControllerDelegate <NSObject>
-(void)returnToMain:(BOOL)NewOrLoad DBid:(int)num;

@end

@interface makeNewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    int num_id,fix_idx;
    DBconnect *mainDBinMN,*editDBinMV;
    UIImage *coverImg;
    UIPopoverController* popoverController;
    bool editMode,saveClick,trueEdit;
    NSString* number;
    NSString* directory;
    NSString* path;
    NSString* titleText;
}

@property (weak, nonatomic) IBOutlet UIButton *CoverButton;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (void) initMNforNew:(int)num mainDB:(DBconnect*)db1 editDB:(DBconnect*)db2;
- (void) initMNforEdit:(int)num mainDB:(DBconnect*)db1 editDB:(DBconnect*)db2 field1:(UIImage*)f1 field2:(NSString*)f2 fixNum:(int)FN;
- (IBAction)saveCoverClick:(id)sender;
- (IBAction)coverAddClick:(id)sender;
- (IBAction)cancelClick:(id)sender;
- (id) saveImage:(UIImage *)img :(NSString *)path :(NSString *)title;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@property (weak, nonatomic) id <makeNewControllerDelegate> delegate;
@end
