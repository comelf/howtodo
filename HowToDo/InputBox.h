//
//  InputBox.h
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 5. 21..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBconnect.h"
#import <AVFoundation/AVFoundation.h>
@interface InputBox : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate,UIAlertViewDelegate>
{
    UIView *bg;
    UIScrollView *scrollViewPointer;
    int numIndex;
    float value_x,value_y;
    DBconnect* DBinIB;
    
    UIButton *recordDeleteButton;
    UIButton *recordButton;
    UIButton *playButton;
    UIButton *stopButton;
    
    NSString *soundFilePath;

}

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property UITextField *textTitle;
@property UITextView *textContent;

-(void) initCoordinate:(int)numidx
                     x:(float)_x
                     y:(float)_y
                scroll:(UIScrollView*)mainScrollView
                DBinit:(DBconnect*)db;
-(void) createBox;
-(void) dataSave:(NSString*)imgPath dbId:(int)dbid;
-(void) deleteBox;
-(void) relocation:(int)num;
-(void) loadRecord:(int)num;
-(void) replaceFileCheck;
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView;
- (void) textViewDidChange:(UITextView *)textView;
- (IBAction)recordAudio:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)stop:(id)sender;
@end
