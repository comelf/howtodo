//
//  makeNewController.m
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 6. 2..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import "makeNewController.h"


@implementation makeNewController
{
    BOOL RightorLeft;
}
@synthesize Title,CoverButton,delegate,confirmButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0,0,58,65);
    [nextButton addTarget:self action:@selector(saveCoverClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"btn_done.png"]  forState:UIControlStateNormal];
    nextButton.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 10, -10);
    UIButton * cencelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cencelButton.frame = CGRectMake(0,0,58,65);
    [cencelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [cencelButton setImage:[UIImage imageNamed:@"btn_back.png"]  forState:UIControlStateNormal];
    cencelButton.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 10, -10);
    
    [nextButton setTitle:@"다음" forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:24.f]];
    [nextButton setTitleEdgeInsets:UIEdgeInsetsMake(-15, -250, 0, 0)];
//    [cencelButton setTitle:@"취소qwer" forState:UIControlStateNormal];
//    [cencelButton.titleLabel setFont:[UIFont systemFontOfSize:24.f]];
//    [cencelButton setTitleEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
    
    UIBarButtonItem *Bar_nextButton = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    //[toolBar]
    UIBarButtonItem *Bar_cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cencelButton];

    
    self.navigationItem.rightBarButtonItem = Bar_nextButton;
    self.navigationItem.title = @"첫화면 만들기";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationItem.leftBarButtonItem = Bar_cancelButton;
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_topnavi.png"] forBarMetrics:UIBarMetricsDefault];
    //[self.na
    if(editMode){
        Title.text = titleText;
        [CoverButton setImage:coverImg forState:UIControlStateNormal];
    }else{
        Title.text = @"";
    }
    [CoverButton.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [CoverButton.layer setBorderWidth:1.0];
    // Do any additional setup after loading the view from its nib.
    
    //키보드 가리기
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
    [self ViewResize];
    
}
- (void) didTap:(UITapGestureRecognizer*) rec
{
    [self.Title resignFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated
{
    if(saveClick){
        if(trueEdit){
            [delegate returnToMain:YES DBid:fix_idx];
        }else{
            [delegate returnToMain:NO DBid:num_id];
            trueEdit = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initMNforNew:(int)num mainDB:(DBconnect*)db1 editDB:(DBconnect*)db2;
{
    num_id = num;
    mainDBinMN = db1;
    editDBinMV = db2;
    trueEdit = editMode = NO;
}

- (void) initMNforEdit:(int)num mainDB:(DBconnect*)db1 editDB:(DBconnect*)db2 field1:(UIImage*)f1 field2:(NSString*)f2 fixNum:(int)FN
{
    num_id = num;
    mainDBinMN = db1;
    editDBinMV = db2;
    trueEdit = editMode = YES;
    coverImg = f1;
    titleText = f2;
    fix_idx = FN;
}

- (IBAction)cancelClick:(id)sender {
    saveClick= NO;
    [self dismissViewControllerAnimated:NO completion:^{}];
}
- (IBAction)saveCoverClick:(id)sender {
    
    //NSLog(@"%d",num_id);
    UIImage* img = [CoverButton imageForState:UIControlStateNormal];
    number = [NSString stringWithFormat:@"gotoaction%03dcover",num_id];     //숫자 변환
    directory =[NSString stringWithFormat:@"HowToDo%03d",num_id];
    path = [self saveImage:img :directory :number];
    [mainDBinMN deleteDBinIndex:num_id];
    [mainDBinMN saveDBforMain:num_id imgpath:path content:Title.text];
    
    EditView* makeEdit = [[EditView alloc]initWithNibName:@"EditView" bundle:nil];
    
    if(!editMode){
        [makeEdit initDB:editDBinMV array:nil recordid:num_id];
    }else{
        NSMutableArray* passArr = [editDBinMV dbQuerySelectInputbox:num_id];
        int max=[editDBinMV totalRecord];
        [makeEdit totalIndexinit:max];
        [makeEdit initDB:editDBinMV array:passArr recordid:num_id];
    }
    makeEdit.loadData = editMode;
    saveClick = YES;
    editMode = YES;
    //[number release];
    
    [[self navigationController]pushViewController:makeEdit animated:YES];
    
    //[self dismissViewControllerAnimated:YES completion:^{}];
    
}
- (IBAction)coverAddClick:(id)sender 
{
    UIActionSheet *myActionSheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        myActionSheet = [[UIActionSheet alloc]initWithTitle:@"선택"
                                                   delegate:self
                                          cancelButtonTitle:@"취소"
                                     destructiveButtonTitle:@"사진찍기"
                                          otherButtonTitles:@"사진첩에서 고르기", nil];
    }
    
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]&&[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        myActionSheet = [[UIActionSheet alloc]initWithTitle:@"선택" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진첩에서 고르기", nil ];
    }
    
    UIView *keyView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
    [myActionSheet showInView:keyView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    else if (buttonIndex == [actionSheet firstOtherButtonIndex]) {
        
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePickerController setAllowsEditing:YES];
    
    UIView* newView = [[UIView alloc]init];
    [self.view addSubview:newView];
    popoverController = [[UIPopoverController alloc]initWithContentViewController:imagePickerController];
    popoverController.delegate = self;
    [popoverController presentPopoverFromRect:CGRectMake(384, 100, 100, 100) inView:newView permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    //[popoverController setPopoverContentSize:CGSizeMake(200, 200)];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *rectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [CoverButton setImage:rectImage forState:UIControlStateNormal];
    
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)_popoverController
{
    //popoverController 제거
    //imagePickerController = nil;
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
}

- (id) saveImage:(UIImage *)img :(NSString *)_path :(NSString *)title
{

    NSString *docDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask,YES)objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@/%@.png",
                             docDir,_path,title];
    
    // 디렉토리 생성
    NSString *pngDirectoryPath = [NSString stringWithFormat:@"%@/%@",docDir,_path];
    NSFileManager* fm = [NSFileManager defaultManager];
    
    BOOL result = [fm createDirectoryAtPath:pngDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    //디렉토리 생성 확인용
    if (result)NSLog(@"dir(%@) create success",pngDirectoryPath);
    else NSLog(@"idr(%@) create fail",pngDirectoryPath);
    
    // 이미지 데이터 저장
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
    BOOL result2 = [imageData writeToFile:pngFilePath atomically:YES];
    // 저장 확인용
    if (result2) NSLog(@"img(%@) save success",pngFilePath);
    else NSLog(@"img(%@) save fail",pngFilePath);
    
    return pngFilePath;
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
        
        CoverButton.frame = CGRectMake(304, 100, 400, 400);
        Title.frame = CGRectMake(304, 570, 300, 50);
        confirmButton.frame = CGRectMake(610, 570, 94, 50);
    }else{
        CoverButton.frame = CGRectMake(184, 100, 400, 400);
        Title.frame = CGRectMake(184, 570, 300, 50);
        confirmButton.frame = CGRectMake(490, 570, 94, 50);
    }
}
@end
