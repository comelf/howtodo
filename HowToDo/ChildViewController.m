//
//  ChildViewController.m
//  GoToAction
//
//  Created by JungGang on 13. 5. 25..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import "ChildViewController.h"


@implementation ChildViewController{
    NSURL* soundFileURL;
    int dirName;
}
@synthesize textBox,PlayButton,StopButton,RewindButton,exitButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //inputList = [[NSMutableArray alloc]init];
    childView = [[UIImageView alloc]init];
    [self.view addSubview:childView];

    numIndex = 0;
    childView.image = [[UIImage alloc] initWithContentsOfFile:DBarray[numIndex][0]];
    [childView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [childView.layer setBorderWidth:1.0];
    //titleBox.text=DBarray[numIndex][0];
    textBox.text=DBarray[numIndex][1];
    PlayButton.hidden   = YES;
    StopButton.hidden   = YES;
    RewindButton.hidden = YES;
    exitButton.hidden   = YES;
    [self ViewResize];
    
    [self recordFileOpenAndPlay];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view setUserInteractionEnabled:YES];
    // Adding the swipe gesture on image view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    
}
-(void) totalIndexinit:(int)num
{
    totalIdx = num-1;
}
-(void) initDB:(DBconnect*)path array:(NSMutableArray*)array index:(int)dirNum
{
    DBinEV = path;
    DBarray = array;
    dirName = dirNum;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self previousView];
}
-(void) previousView
{
    if(_audioPlayer.playing)
        [_audioPlayer stop];
    childView.hidden = NO;
    if(numIndex==0){
        childView.image = [[UIImage alloc] initWithContentsOfFile:DBarray[numIndex][0]];
        //titleBox.text=DBarray[numIndex][0];
        textBox.text = DBarray[numIndex][1];
        
    }
    else{
        numIndex--;
        childView.image = [[UIImage alloc] initWithContentsOfFile:DBarray[numIndex][0]];
        //titleBox.text=DBarray[numIndex][0];
        textBox.text=DBarray[numIndex][1];
        
        [self recordFileOpenAndPlay];
        
    }
    
}
-(void) NextView
{
    if(_audioPlayer.playing)
        [_audioPlayer stop];
    
    if(totalIdx>numIndex){
        numIndex++;
        childView.image = [[UIImage alloc] initWithContentsOfFile:DBarray[numIndex][0]];
        textBox.text=DBarray[numIndex][1];
        [self recordFileOpenAndPlay];
    }
    else{
        if(totalIdx==numIndex){
            numIndex++;
            childView.hidden = YES;
            textBox.text=@"참 잘했어요!!\n끝~!";
            [self buttonChoice:3];
            
        }else{
            return;
        }
    }
}

-(void)recordFileOpenAndPlay
{
    if ([self soundFileCheck]){
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
        _audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",[error localizedDescription]);
        else{
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
            [_audioPlayer play];
            [self buttonChoice:1];
            
        }
    }
}

-(void)buttonChoice:(int)button
{
    if(button ==1){
        PlayButton.hidden   = YES;
        StopButton.hidden   = NO;
        RewindButton.hidden = YES;
        exitButton.hidden   = YES;
    }else if (button==2){
        PlayButton.hidden   = NO;
        StopButton.hidden   = YES;
        RewindButton.hidden = YES;
        exitButton.hidden   = YES;
    }else{
        PlayButton.hidden   = YES;
        StopButton.hidden   = YES;
        RewindButton.hidden = NO;
        exitButton.hidden   = NO;
    }
}

- (IBAction)nextButton:(id)sender {
    
    [self NextView];
}

- (IBAction)reStartClick:(id)sender {
    childView.hidden = NO;
    numIndex=0;
    childView.image = [[UIImage alloc] initWithContentsOfFile:DBarray[numIndex][0]];
    textBox.text = DBarray[numIndex][1];
    [self buttonChoice:1];
    [self recordFileOpenAndPlay];
}

- (IBAction)playButtonClick:(id)sender {
    [_audioPlayer play];
    [self buttonChoice:1];
}

- (IBAction)stopButtonClick:(id)sender {
    [_audioPlayer stop];
     [self buttonChoice:2];
}

-(BOOL)soundFileCheck{
    NSArray *dirPaths = dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *savesoundFilePath = [dirPaths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"HowToDo%03d",dirName]];
   
    NSFileManager *fm = [NSFileManager defaultManager];
    if(numIndex==0){
        if([fm createDirectoryAtPath:savesoundFilePath withIntermediateDirectories:YES attributes:nil error: NULL] == NO){
            NSLog(@"create Record(temp) Directory Failed");
        }
    }
    
    NSString *path = [savesoundFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"sound_%03d.m4a",numIndex]];


    if([fm fileExistsAtPath:path]==YES){
    
        PlayButton.enabled = YES;
        soundFileURL = [NSURL fileURLWithPath:path];
        return true;
    }
    [self buttonChoice:2];
    PlayButton.enabled = NO;
    soundFileURL = nil;
    return false;
}

- (IBAction)backBarButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self ViewResize];
}

-(void) ViewResize
{
    RightorLeft =  NO;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft||self.interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        RightorLeft = YES;
    
    if(([UIDevice currentDevice].orientation)==UIInterfaceOrientationLandscapeLeft||([UIDevice currentDevice].orientation)==UIInterfaceOrientationLandscapeRight)
        RightorLeft = YES;
    
    if(RightorLeft){
        childView.frame = CGRectMake(307, 100, 400, 400);
        textBox.frame = CGRectMake(257, 520, 500, 240);
        PlayButton.frame = CGRectMake(920, 650, 70, 70);
        StopButton.frame = CGRectMake(920, 650, 70, 70);
        RewindButton.frame = CGRectMake(920, 650, 70, 70);
    }else{
        childView.frame = CGRectMake(135, 150, 500, 500);
        textBox.frame = CGRectMake(152, 660, 465, 320);
        PlayButton.frame = CGRectMake(650, 920, 70, 70);
        StopButton.frame = CGRectMake(650, 920, 70, 70);
        RewindButton.frame = CGRectMake(650, 920, 70, 70);
    }
}

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self buttonChoice:2];
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(totalIdx>=numIndex){
        [self NextView];
        }
        
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self previousView];
        
    }
}

@end
