//
//  ChildViewController.h
//  GoToAction
//
//  Created by JungGang on 13. 5. 25..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DBconnect.h"
#import <AVFoundation/AVFoundation.h>



@class ChildViewController;
@protocol ChildViewControllerDelegate
- (void)childViewControllerDidFinish:(ChildViewController *)controller;
@end

@interface ChildViewController : UIViewController < AVAudioPlayerDelegate>
{
    int numIndex;
    DBconnect* DBinEV;
    int totalIdx;
    NSString* className;
    NSMutableArray *DBarray;
    BOOL RightorLeft;
    UIImageView *childView;
}
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *RewindButton;
@property (weak, nonatomic) IBOutlet UIButton *StopButton;
@property (weak, nonatomic) IBOutlet UIButton *PlayButton;
@property (weak, nonatomic) IBOutlet UILabel *textBox;
@property (weak, nonatomic) id <ChildViewControllerDelegate> delegate;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property UITextField *titleBox;
- (IBAction)backButton:(id)sender;
- (IBAction)nextButton:(id)sender;
- (IBAction)playButtonClick:(id)sender;
- (IBAction)stopButtonClick:(id)sender;

-(void) initDB:(DBconnect*)path array:(NSMutableArray*)array index:(int)dirNum;
-(void) totalIndexinit:(int)num;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
- (IBAction)backBarButton:(id)sender;
-(void) ViewResize;
@end
