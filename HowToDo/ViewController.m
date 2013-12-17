//
//  ViewController.m
//  GoToAction
//
//  Created by  byung-woo Lee on 13. 5. 20..
//  Copyright (c) 2013년  byung-woo Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <makeNewControllerDelegate>

@end
@implementation UINavigationBar (CustomImage)


- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"NavigationBar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
@implementation ViewController
@synthesize doneButton;
	
-(NSString*)filePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"manual.sqlite"];
}


- (void)returnToMain:(BOOL)NewOrLoad DBid:(int)num
{
    mainDB = [DB1 dbQuerySelect];
    if(NewOrLoad){
        NSLog(@"load");
        //배열에서 꺼내서 이미지 변경
        //UIButton* tempLink = linkButtonArray[num];
        UIButton* templink = linkButtonArray[num];
        NSString *filepath = mainDB[num][1];
        UIImage * buttonimg = [[UIImage alloc] initWithContentsOfFile:filepath];
        [templink setImage:buttonimg forState:UIControlStateNormal];
        UILabel* tempLabel = titleLabelArray[num];
        tempLabel.text = mainDB[num][2];

    }else{
        
        editMode= NO;
        int k = totalnum_linkButton;
        for (int i=0;i<k;i++){
            UIButton *tempDel = delButtonArray[i];
            UIButton *tempEdit = editButtonArray[i];
            tempDel.hidden = YES;
            tempDel.alpha = 0.0;
            tempEdit.hidden = YES;
        }
        addButton.hidden = YES;
        doneButton.hidden = YES;
        addButton.alpha = 0.0;
        [self createLinkButton:totalnum_linkButton];
    }
    [self interfaceStatus];
    [self scrollViewResize];
    [self ButtonRelocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImageView* bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
//    [self.view insertSubview:bg atIndex:0];
    
    
    linkButtonArray = [[NSMutableArray alloc]init];
    delButtonArray  = [[NSMutableArray alloc]init];
    titleLabelArray = [[NSMutableArray alloc]init];
    editButtonArray = [[NSMutableArray alloc]init];
    mainDB          = [[NSMutableArray alloc]init];

    
    //화면에 보여질수 있는 버튼 수 계산
    button_w    = 200;
    button_h    = 240;
    [self interfaceStatus];
    
    scrollViewInIndex = [[UIScrollView alloc] init];
    [self.view insertSubview:scrollViewInIndex atIndex:0];
    [self scrollViewResize];
    
    //DB불러오기 및 초기화
    if(sqlite3_open([[self filePath] UTF8String],&manual)!= SQLITE_OK){
        sqlite3_close(manual);
        NSAssert(0, @"Database failed to open");
    }else{
        NSLog(@"database OK");
    }
    
    DB1 = [[DBconnect alloc]init];
    [DB1 openDB:manual];
    [DB1 createTable:@"main" field1:@"imgPath" field2:@"title" field3:@"id" field4:@"NULL"];
    mainDB = [DB1 dbQuerySelect];
    //NSLog(@"%@",mainDB);
    int max_totalnum_linkButton = [DB1 totalRecord];
    max_id =[DB1 maxIdRecord];
    
    DB2 = [[DBconnect alloc]init];
    [DB2 openDB:manual];
    [DB2 createTable:@"edit" field1:@"imgPath" field2:@"textField" field3:@"index" field4:@"id"];
    
    //DB초기화
    //[DB1 deleteDBall];
    //[DB2 deleteDBall];
    
    //버튼 생성
    plusMode = NO;
    for (int i=0;i<max_totalnum_linkButton;i++){
        [self createLinkButton:i];
    }
    
    //추가 버튼 생성
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* addimg = [UIImage imageNamed:@"box_addnew.png"];
    [addButton setImage:addimg forState:UIControlStateNormal];
    float x = ((buttonSpace*((totalnum_linkButton % 3)+1))+(button_w* ((totalnum_linkButton%3))));
    float y = 120 + buttonSpace * (totalnum_linkButton / 3) + (button_h * (totalnum_linkButton/3));
    addButton.frame = CGRectMake(x,y,200,200);
    [addButton addTarget:self action:@selector(Newlinkbutton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewInIndex addSubview:addButton];
    addButton.hidden = YES;
    addButton.alpha = 0.0;
    doneButton.hidden = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)linkbuttonClick:(id)sender
{
    if(!editMode){
        ChildViewController *childViewController;
        
        childViewController =[[ChildViewController alloc]initWithNibName:@"ChildViewController" bundle:nil];
        childViewController.modalTransitionStyle = UIModalPresentationFullScreen;
        
        editDB = [DB2 dbQuerySelectInputbox:[sender tag]];
        maxRecord = [DB2 totalRecord];
        
        [childViewController totalIndexinit:maxRecord];
        [childViewController initDB:DB2 array:editDB index:[sender tag]];
        //childViewController.loadData = YES;
        [self presentViewController:childViewController animated:YES completion:nil];
    }
    
}

- (IBAction) editButtonClick:(id)sender
{
    int i = [sender tag];
    UIButton* tempLink = linkButtonArray[i];
    UILabel* tempLabel = titleLabelArray[i];
    int k = tempLink.tag;
    
    makeNewController * makeEdit = [[makeNewController alloc]initWithNibName:@"makeNewController" bundle:nil];
    [makeEdit setDelegate:self];
    UIImage* img = [tempLink imageForState:UIControlStateNormal];
    [makeEdit initMNforEdit:k mainDB:DB1 editDB:DB2 field1:img field2:tempLabel.text fixNum:i];
    UINavigationController *myNaviViewController = [[UINavigationController alloc]initWithRootViewController:makeEdit];
    [myNaviViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_topnavi.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:myNaviViewController animated:NO completion:^{}];
    
    //편집모드 나가기
    editMode = NO;
    for (int i=0;i<totalnum_linkButton;i++){
        UIButton *tempDel = delButtonArray[i];
        UIButton *tempEdit = editButtonArray[i];
        tempDel.hidden = YES;
        tempDel.alpha = 0.0;
        tempEdit.hidden = YES;
    }
    addButton.hidden = YES;
    addButton.alpha = 0.0;
    doneButton.hidden = YES;
}

- (IBAction) Newlinkbutton:(id)sender
{
    makeNewController * makeNew = [[makeNewController alloc]initWithNibName:@"makeNewController" bundle:nil];
    [makeNew setDelegate:self];
    [makeNew initMNforNew:++max_id mainDB:DB1 editDB:DB2];
    UINavigationController *myNaviViewController = [[UINavigationController alloc]initWithRootViewController:makeNew];
    [myNaviViewController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_topnavi.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:myNaviViewController animated:NO completion:^{}];
}

- (void) createLinkButton:(int)arrNum
{
    linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *filepath = mainDB[arrNum][1];
    UIImage * buttonimg = [[UIImage alloc] initWithContentsOfFile:filepath];
    [linkButton setImage:buttonimg forState:UIControlStateNormal];
    //linkButton.layer.cornerRadius = 18.0f;
    linkButton.layer.masksToBounds = NO;
    linkButton.layer.shadowColor = [UIColor blackColor].CGColor;
    linkButton.layer.shadowOpacity = 0.3;
    linkButton.layer.shadowRadius = 10;
    linkButton.layer.shadowOffset = CGSizeMake(12.0f, 12.0f);
    
    int k = [mainDB[arrNum][0] intValue];
    linkButton.tag = (int)k;
    
    float x = ((buttonSpace*((totalnum_linkButton % max_count_x)+1))+(button_w* ((totalnum_linkButton%max_count_x))));
    float y = 120 + buttonSpace * (totalnum_linkButton / max_count_x) + (button_h * (totalnum_linkButton/max_count_x));
    [linkButton addTarget:self action:@selector(linkbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    linkButton.frame = CGRectMake(x,y,button_w, button_h-40);
    [linkButton.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [linkButton.layer setBorderWidth:1.0];
    
    //UIImage *rectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //[CoverButton setImage:rectImage forState:UIControlStateNormal];
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.tag = totalnum_linkButton;
    editButton.frame = CGRectMake(x,y,button_w, button_h-40);
    [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    editButton.hidden = YES;
    [editButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
    [editButton setTitle:@"편집" forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:30.f]];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.text = mainDB[arrNum][2];
    titleLabel.frame = CGRectMake(x,y+button_h-35,button_w,20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    titleLabel.textColor = [UIColor colorWithRed:100.0 green:100.0 blue:100.0 alpha:1.0];
    
    delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* delimg = [UIImage imageNamed:@"btn_erase.png"];
    [delButton setImage:delimg forState:UIControlStateNormal];
    delButton.frame = CGRectMake(x-20,y-20,40,40);
    delButton.tag = totalnum_linkButton;
    [delButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    delButton.hidden = YES;
    delButton.alpha = 0.0;
    [linkButtonArray addObject:linkButton];
    [editButtonArray addObject:editButton];
    [titleLabelArray addObject:titleLabel];
    [delButtonArray  addObject:delButton];
    
    
    totalnum_linkButton +=1;
    
    [self scrollViewResize];
    /*
    if((totalnum_linkButton/max_count_x) >= max_count_y)
    {
        scrollViewInIndex.contentSize = CGSizeMake (max_x, (100+(button_h + buttonSpace)*((totalnum_linkButton / max_count_x)+1)));
    }
    */
    x = ((buttonSpace*((totalnum_linkButton % max_count_x)+1))+(button_w* ((totalnum_linkButton%max_count_x))));
    y = 120 + buttonSpace * (totalnum_linkButton / max_count_x) + (button_h * (totalnum_linkButton/max_count_x));

    addButton.frame = CGRectMake(x,y,200,200);
    
    [scrollViewInIndex addSubview:linkButton];
    [scrollViewInIndex addSubview:editButton];
    [scrollViewInIndex addSubview:delButton];
    [scrollViewInIndex addSubview:titleLabel];

}
- (IBAction)deleteButtonClick:(id)sender
{
    UIAlertView *Notice = [[UIAlertView alloc]initWithTitle:@"경고"
                                                    message:@"정말 삭제하시겠습니까?"
                                                   delegate:self
                                          cancelButtonTitle:@"아니요"
                                          otherButtonTitles:@"예", nil];
    [Notice show];
    del_i = [sender tag];

    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //아니요를 눌렀으면 메소드 종료
    if(!(buttonIndex == [alertView firstOtherButtonIndex])){
        return;
    }
    //예를 눌렀을시 삭제
    int i = del_i;
    int k =[[linkButtonArray objectAtIndex:i] tag];
    [[linkButtonArray objectAtIndex:i] removeFromSuperview];
    [[titleLabelArray objectAtIndex:i] removeFromSuperview];
    [[editButtonArray objectAtIndex:i] removeFromSuperview];
    [[delButtonArray  objectAtIndex:i] removeFromSuperview];
    [linkButtonArray removeObjectAtIndex:i];
    [titleLabelArray removeObjectAtIndex:i];
    [editButtonArray removeObjectAtIndex:i];
    [delButtonArray  removeObjectAtIndex:i];
    
    [DB1 deleteDBinIndex:k];
    [DB2 deleteDBinId:k];
    totalnum_linkButton--;
    
    for(;i<totalnum_linkButton; i++){
        UIButton *deltemp = [delButtonArray  objectAtIndex:i];
        deltemp.tag = i;
        UIButton *tempEdit = [editButtonArray objectAtIndex:i];
        tempEdit.tag = i;
    }
    [self ButtonRelocation];
}

- (IBAction) editClick:(id)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    
    if(editMode){
        editMode = NO;
        for (int i=0;i<totalnum_linkButton;i++){
            UIButton *tempDel = delButtonArray[i];
            UIButton *tempEdit = editButtonArray[i];
            tempDel.hidden = YES;
            tempDel.alpha =0.0;
            tempEdit.hidden = YES;
            
        }
        addButton.hidden = YES;
        addButton.alpha = 0.0;
        doneButton.hidden = YES;
    }else{
        editMode = YES;
        for (int i=0;i<totalnum_linkButton;i++){
            UIButton *tempDel = delButtonArray[i];
            UIButton *tempEdit = editButtonArray[i];
            tempDel.hidden = NO;
            tempDel.alpha = 1.0;
            tempEdit.hidden = NO;
        }
        addButton.hidden = NO;
        addButton.alpha =1.0;
        doneButton.hidden = NO;
    }
    [UIView setAnimationDuration:0.0f];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self interfaceStatus];
    [self scrollViewResize];
    [self ButtonRelocation];

}

-(void) ButtonRelocation;
{
    float x,y;
    int i;
                    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    for(i= 0; i<totalnum_linkButton; i++){
        UIButton *tempDel  = delButtonArray[i];
        UIButton *tempEdit = editButtonArray[i];
        UIButton *tempLink = linkButtonArray[i];
        UILabel *tempLabel = titleLabelArray[i];
        x = ((buttonSpace*((i % max_count_x)+1))+(button_w* ((i%max_count_x))));
        y = 120 + buttonSpace * (i / max_count_x) + (button_h * (i/max_count_x));
        tempEdit.frame = CGRectMake(x,y,button_w, button_h-40);
        tempDel.frame = CGRectMake(x-20,y-20,40,40);
        tempLink.frame = CGRectMake(x,y,button_w, button_h-40);
        tempLabel.frame = CGRectMake(x,y+button_h-35,button_w,20);
        
    }
    x = ((buttonSpace*((i % max_count_x)+1))+(button_w* ((i%max_count_x))));
    y = 120 + buttonSpace * (i / max_count_x) + (button_h * (i/max_count_x));
    addButton.frame = CGRectMake(x,y,200,200);
    [UIView setAnimationDuration:0.0f];
}

-(void) scrollViewResize
{
    scrollViewInIndex.frame = CGRectMake(0, 0, max_x, max_y);
    if((totalnum_linkButton/max_count_x) >= max_count_y)
    {
        scrollViewInIndex.contentSize = CGSizeMake (max_x, (100+(button_h + buttonSpace)*((totalnum_linkButton / max_count_x)+1)));
    }
}

- (void) interfaceStatus
{
    BOOL RightorLeft =  NO;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft||self.interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        RightorLeft = YES;
    
    if(([UIDevice currentDevice].orientation)==UIInterfaceOrientationLandscapeLeft||([UIDevice currentDevice].orientation)==UIInterfaceOrientationLandscapeRight)
        RightorLeft = YES;
    
    if(RightorLeft){
        max_x       = 1024;
        max_y       = 768;
        if(max_x% button_w<100){
            max_count_x = max_x / button_w;
            max_count_x--;
        }else{
            max_count_x = max_x / button_w;
        }
        buttonSpace = (max_x % (button_w*max_count_x))/(max_count_x+1);
        max_count_y = max_y / (button_h + buttonSpace);
    }else{
        max_x       = 768;
        max_y       = 1004;
        if(max_x% button_w<100){
            max_count_x = max_x / button_w;
            max_count_x--;
        }else{
            max_count_x = max_x / button_w;
        }
        buttonSpace = (max_x % (button_w*max_count_x))/(max_count_x+1);
        max_count_y = max_y / (button_h + buttonSpace);
    }
}

@end
