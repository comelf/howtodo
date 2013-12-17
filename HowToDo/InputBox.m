//
//  InputBox.m
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 5. 21..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import "InputBox.h"

@implementation InputBox{
    NSFileManager *fm;
    NSURL *soundFileURL;
}

@synthesize textTitle,textContent;

-(void) initCoordinate:(int)numidx
                     x:(float)_x
                     y:(float)_y
                scroll:(UIScrollView*)mainScrollView
                DBinit:(DBconnect*)db
{
    numIndex = numidx;
    value_x = _x;
    value_y = _y;
    scrollViewPointer = mainScrollView;
    DBinIB = db;

    //title 설정
    //textTitle = [[UITextField alloc] initWithFrame:CGRectMake(value_x+10, value_y+255,200,30)];
    //textTitle.borderStyle = UITextBorderStyleRoundedRect;
    
    //background_view 설정
    bg = [[UIView alloc] initWithFrame:CGRectMake(value_x,value_y,220,580)];
    bg.backgroundColor =[UIColor colorWithRed:0.4705f green:0.4705f blue:0.4705f alpha:1.0f];
    
    //textContent 설정
    textContent = [[UITextView alloc] initWithFrame:CGRectMake(value_x+10,value_y+270,200,150)];
    textContent.backgroundColor=[UIColor colorWithRed:100.0 green:100.0 blue:100.0 alpha:1.0];
    [textContent setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    
    recordDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(value_x+20, value_y+450, 180, 30)];
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(value_x+20, value_y+490, 50, 50)];
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(value_x+87, value_y+490, 50, 50)];
    stopButton = [[UIButton alloc] initWithFrame:CGRectMake(value_x+150, value_y+490, 50, 50)];
    
    [recordDeleteButton addTarget:self action:@selector(recordDel:) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(recordAudio:) forControlEvents:UIControlEventTouchUpInside];
    [playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    [stopButton addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];

    //playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *btnimg=;
    [recordDeleteButton setTitle:@"음성파일 삭제" forState:UIControlStateNormal];
    [recordDeleteButton setTitle:@"음성파일 없음" forState:UIControlStateDisabled];
    [recordButton setImage:[UIImage imageNamed:@"btn_record_able"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"btn_record_enabled"] forState:UIControlStateDisabled];
    [playButton setImage:[UIImage imageNamed:@"btn_play_able.png"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"btn_play_enabled.png"] forState:UIControlStateDisabled];
    [stopButton setImage:[UIImage imageNamed:@"btn_stop_able.png"] forState:UIControlStateNormal];
    [stopButton setImage:[UIImage imageNamed:@"btn_stop_enabled.png"] forState:UIControlStateDisabled];
    
    playButton.enabled = NO;
    stopButton.enabled = NO;
    recordDeleteButton.enabled=NO;
    
    //temp record 파일 초기화
    fm = [NSFileManager defaultManager];
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *newDir = [tmpDir stringByAppendingPathComponent:@"temp_record"];
    
    soundFilePath = [newDir
                     stringByAppendingPathComponent:[NSString stringWithFormat:@"recordsound_%d.m4a",numIndex]];
    
    
    
    /*
     NSArray *dirPaths =dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    soundFilePath = [docsDir
                               stringByAppendingPathComponent:[NSString stringWithFormat:@"sound_%d.caf",numIndex]];
    */
    
    
    
}

-(void) createBox
{
    //화면 출력
    [scrollViewPointer addSubview:bg];
    //[scrollViewPointer addSubview:textTitle];
    [scrollViewPointer addSubview:textContent];
    [scrollViewPointer addSubview:recordDeleteButton];
    [scrollViewPointer addSubview:recordButton];
    [scrollViewPointer addSubview:playButton];
    [scrollViewPointer addSubview:stopButton];

    textContent.textColor = [UIColor darkGrayColor];
    
    if([fm fileExistsAtPath:soundFilePath]==YES){
        playButton.enabled = YES;
        recordDeleteButton.enabled=YES;
    }

}
-(void) replaceFileCheck
{
    playButton.enabled = NO;
    stopButton.enabled = NO;
    recordDeleteButton.enabled=NO;
}
-(BOOL) textViewShouldBeginEditing:(UITextView *)_textContent
{
    _textContent.text = @"";
    _textContent.textColor = [UIColor blackColor];
    return YES;
}
-(void) textViewDidChange:(UITextView *)_textContent
{
    
    if(_textContent.text.length == 0){
        _textContent.textColor = [UIColor lightGrayColor];
        _textContent.text = @"상세한 설명을 넣어주세요.";
        [_textContent resignFirstResponder];
    }
}
-(void) dataSave:(NSString*)imgPath dbId:(int)dbid
{
    NSArray *dirPaths = dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *savesoundFilePath = [dirPaths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"HowToDo%03d",dbid]];
    if(numIndex==0){
        if([fm createDirectoryAtPath:savesoundFilePath withIntermediateDirectories:YES attributes:nil error: NULL] == NO){
            NSLog(@"create Record(temp) Directory Failed");
        }
    }
    savesoundFilePath =[savesoundFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"sound_%03d.m4a",numIndex]];
    if([fm fileExistsAtPath: savesoundFilePath] == YES){
        [fm removeItemAtPath: savesoundFilePath error:NULL];
    }

    //녹음된 파일이 존재하면 파일 이동
    if([fm fileExistsAtPath:soundFilePath]==YES){
        [fm moveItemAtPath:soundFilePath toPath:savesoundFilePath error:NULL];
    }
    
    
    if([textContent.text isEqual:@"상세한 설명을 넣어주세요."]){
        [DBinIB saveDBforEdit:imgPath content:@"" t_id:dbid];
    }else{
        [DBinIB saveDBforEdit:imgPath content:textContent.text t_id:dbid];
    }
    
    
    //}
    //NSLog(@"save %d, %@, %@",numIndex,imgPath,textContent.text);
}

-(void) deleteBox
{
    [textContent removeFromSuperview];
    [bg removeFromSuperview];
    [recordDeleteButton removeFromSuperview];
    [recordDeleteButton removeFromSuperview];
    [recordButton removeFromSuperview];
    [playButton removeFromSuperview];
    [stopButton removeFromSuperview];
    
}
-(void) relocation:(int)num
{
    numIndex = num;
    value_x = 30+(240*(numIndex));
    bg.frame = CGRectMake(value_x,value_y,220,580);
    textContent.frame = CGRectMake(value_x+10,value_y+270,200,150);
    recordDeleteButton.frame = CGRectMake(value_x+20, value_y+450, 180, 30);
    recordButton.frame = CGRectMake(value_x+20, value_y+490, 50, 50);
    playButton.frame = CGRectMake(value_x+87, value_y+490, 50, 50);
    stopButton.frame = CGRectMake(value_x+150, value_y+490, 50, 50);
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *newDir = [tmpDir stringByAppendingPathComponent:@"temp_record"];

    NSString *copyPath = [newDir
                     stringByAppendingPathComponent:[NSString stringWithFormat:@"recordsound_%d.m4a",numIndex]];
    
    
    //기존의 파일을 지우고
    if([fm fileExistsAtPath:soundFilePath]!=NO) {
        [fm removeItemAtPath:copyPath error:NULL];
        
        //복사
        if([fm moveItemAtPath:soundFilePath toPath: copyPath error: NULL]  == YES){
            
            playButton.enabled = YES;
        }
        else{
            NSLog (@"Sound File Move failed");
        }
        
    }
    
    soundFilePath = copyPath;
    soundFileURL = [NSURL fileURLWithPath:copyPath];
    
}

- (IBAction)recordDel:(id)sender {

    UIAlertView *Notice = [[UIAlertView alloc]initWithTitle:@"녹음된 파일이 있습니다."
                                                    message:@"기존의 녹음파일을 삭제하시겠습니까?"
                                                   delegate:self
                                          cancelButtonTitle:@"아니요"
                                          otherButtonTitles:@"예", nil];
    [Notice show];
    
    
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //아니요를 눌렀으면 메소드 종료
    if(!(buttonIndex == [alertView firstOtherButtonIndex])){
        return;
    }
    
    if(_audioPlayer.playing){
        [_audioPlayer stop];
    }
    [fm removeItemAtPath:soundFilePath error:NULL];
    recordButton.enabled = YES;
    playButton.enabled = NO;
    stopButton.enabled = NO;
    recordDeleteButton.enabled=NO;
}

- (IBAction)recordAudio:(id)sender {


    soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                    nil];
    
    NSError *error = nil;
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
        _audioRecorder.delegate = self;
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:nil];
    [session setActive:YES error:nil];
    
    
    
    
    if (!_audioRecorder.recording)
    {

        playButton.enabled = NO;
        stopButton.enabled = YES;
        [_audioRecorder record];
        
        //버튼 깜빡임
        [UIView animateWithDuration:1200.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             recordButton.alpha = 0.3f;
                         }
                         completion:^(BOOL finished){
                         }];
    }


}
-(void) loadRecord:(int)num{
    NSArray *dirPaths = dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *FilePath = [dirPaths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"HowToDo%03d",num]];
    
    NSString *loadPath = [FilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"sound_%03d.m4a",numIndex]];
    //NSLog(@"%@",loadPath);
    if([fm fileExistsAtPath:soundFilePath]==YES) {
        [fm removeItemAtPath:soundFilePath error:NULL];
    }
    

    if([fm fileExistsAtPath:loadPath])
        [fm copyItemAtPath:loadPath toPath:soundFilePath error:nil];

    
}
- (IBAction)playAudio:(id)sender {
    if (!_audioRecorder.recording)
    {
        stopButton.enabled = YES;
        recordButton.enabled = NO;
        soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithContentsOfURL:soundFileURL
                        error:&error];
        
        _audioPlayer.delegate = self;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [_audioPlayer play];
    }
}

- (IBAction)stop:(id)sender {
    stopButton.enabled = NO;
    playButton.enabled = YES;
    recordButton.enabled = YES;
    
    if (_audioRecorder.recording)
    {
        [_audioRecorder stop];
        recordDeleteButton.enabled=YES;
    } else if (_audioPlayer.playing) {
        [_audioPlayer stop];
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    int flags = AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation;
    [session setActive:NO withOptions:flags error:nil];
}
-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    recordButton.enabled = YES;
    stopButton.enabled = NO;
    
    
    
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    recordButton.alpha = 1.0f;
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}
@end
