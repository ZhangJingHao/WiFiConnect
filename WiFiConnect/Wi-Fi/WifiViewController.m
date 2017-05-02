
//
//  WifiViewController.m
//  Eleven
//
//  Created by coderyi on 15/8/24.
//  Copyright (c) 2015年 coderyi. All rights reserved.
//

#import "WifiViewController.h"
#import "HTTPServer.h"
#import "WifiManager.h"
#import "Track.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define YiTextGray [UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:1.00f]


@interface WifiViewController ()<WebFileResourceDelegate> {
    UILabel *urlLabel;
    HTTPServer *httpServer;
    NSMutableArray *fileList;
}
@end

@implementation WifiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = [Track localWithStr:@"LOC_Music_WifiTransfer"];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 50)];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.numberOfLines=0;
    titleLabel.font=[UIFont systemFontOfSize:13];
    titleLabel.textColor=YiTextGray;
    titleLabel.text = [Track localWithStr:@"LOC_Music_OpenButton"];
    [self.view addSubview:titleLabel];
    self.view.backgroundColor = [UIColor whiteColor];

    UISwitch *serviceSwitch=[[UISwitch alloc] initWithFrame:CGRectMake((ScreenWidth-60)/2, 150, 60, 40)];
    [self.view addSubview:serviceSwitch];
    
    serviceSwitch.on=[WifiManager sharedInstance].serverStatus;
    
    [serviceSwitch addTarget:self action:@selector(toggleService:) forControlEvents:UIControlEventValueChanged];
    
    urlLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, 40)];
    [self.view addSubview:urlLabel];
    urlLabel.textAlignment=NSTextAlignmentCenter;
    urlLabel.textColor=[UIColor blueColor];
    
    if (serviceSwitch.on) {
        [urlLabel setText:[NSString stringWithFormat:@"http://%@:%d", [[WifiManager sharedInstance].httpServer hostName], [[WifiManager sharedInstance].httpServer port]]];
    }else{
        [urlLabel setText:@""];
    }
    
    [self.navigationItem.backBarButtonItem setTitle:@"back3"];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"music_icon_back"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(clickLeftBtn)];
}

- (void)clickLeftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    httpServer.fileResourceDelegate = nil;
    
}

- (void)toggleService:(id)sender
{
    NSError *error;
    if ([(UISwitch*)sender isOn])
    {
        BOOL serverIsRunning ;
        [[WifiManager sharedInstance] operateServer:YES];
        [WifiManager sharedInstance].serverStatus=YES;
        if(!serverIsRunning)
        {
            NSLog(@"Error starting HTTP Server: %@", error);
        }
        [urlLabel setText:[NSString stringWithFormat:@"http://%@:%d", [[WifiManager sharedInstance].httpServer hostName], [[WifiManager sharedInstance].httpServer port]]];
    }
    else
    {
        [[WifiManager sharedInstance] operateServer:NO];
        [WifiManager sharedInstance].serverStatus=NO;
        [urlLabel setText:@""];
    }
}

// load file list
- (void)loadFileList
{
    [fileList removeAllObjects];
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
                                      enumeratorAtPath:docDir];
    NSString *pname;
    while (pname = [direnum nextObject])
    {
        [fileList addObject:pname];
    }
}

#pragma mark WebFileResourceDelegate
// number of the files
- (NSInteger)numberOfFiles
{
    return [fileList count];
}

// the file name by the index
- (NSString*)fileNameAtIndex:(NSInteger)index
{
    return [fileList objectAtIndex:index];
}

// provide full file path by given file name
- (NSString*)filePathForFileName:(NSString*)filename
{
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSLog(@"docDir : %@", docDir);
    return [NSString stringWithFormat:@"%@/%@", docDir, filename];
}

// handle newly uploaded file. After uploading, the file is stored in
// the temparory directory, you need to implement this method to move
// it to proper location and update the file list.
- (void)newFileDidUpload:(NSString*)name inTempPath:(NSString*)tmpPath
{
    if (name == nil || tmpPath == nil)
        return;
    NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
    NSString *path = [NSString stringWithFormat:@"%@/%@", docDir, name];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if (![fm moveItemAtPath:tmpPath toPath:path error:&error])
    {
        NSLog(@"can not move %@ to %@ because: %@", tmpPath, path, error );
    }
    
    [self loadFileList];
    
}

// implement this method to delete requested file and update the file list
- (void)fileShouldDelete:(NSString*)fileName
{
    NSString *path = [self filePathForFileName:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if(![fm removeItemAtPath:path error:&error])
    {
        NSLog(@"%@ can not be removed because:%@", path, error);
    }
    [self loadFileList];
}

@end
