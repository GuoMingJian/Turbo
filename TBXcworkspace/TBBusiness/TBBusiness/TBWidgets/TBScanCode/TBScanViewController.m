//
//  TBScanViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/10/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TBScanView.h"

@interface TBScanViewController ()<UIAlertViewDelegate, AVCaptureMetadataOutputObjectsDelegate>

// 二维码生成的会话
@property (nonatomic, strong) AVCaptureSession *mySession;
// 二维码生成的图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *myPreviewLayer;
// 扫描view
@property (nonatomic, strong) TBScanView *scanView;
// 扫描框的区域
@property (nonatomic, assign) CGRect cameraImageViewRect;
// 闪光灯设备
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureDevice *captureDevice;

@end

@implementation TBScanViewController

#pragma mark - 懒加载

-(AVCaptureSession *)captureSesion
{
    if(_captureSession == nil)
    {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

-(AVCaptureDevice *)captureDevice
{
    if(_captureDevice == nil)
    {
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationItemTitleColor:[UIColor whiteColor]];
    [self createLeftItem];
    // 创建闪光灯按钮
    [self createRightItem];
    
    [self readQRCode];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //显示分栏控制器
    self.tabBarController.tabBar.hidden = NO;
    
    //=================================//
    /* iOS9.0 以下不停止会话会出现bug */
    // 1. 停止会话
    [self.mySession stopRunning];
    // 2. 删除预览图层
    [self.myPreviewLayer removeFromSuperlayer];
    //=================================//
    
    NSTimer *timer = self.scanView.myTimer;
    //取消定时器
    [timer invalidate];
    timer = nil;
}

#pragma mark - 初始化扫码
-(void)readQRCode {
    //1、获取摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2、设置输入
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        /**
         *  如果没有检查出摄像头,弹出警示
         */
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到设置隐私中开启本程序相机权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    /**
     *  如果检查出摄像头,初始化myScanView
     */
    _scanView = [[TBScanView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    
    // 给定扫描区域
    if (MAIN_SCREEN_WIDTH <= 320) {
        _scanView.scanAreaSize = CGSizeMake(200, 200);
    } else if(MAIN_SCREEN_WIDTH < 375) {
        _scanView.scanAreaSize = CGSizeMake(250, 250);
    } else {
        _scanView.scanAreaSize = CGSizeMake(300, 300);
    }
    
    // 设置扫描框的区域
    CGFloat cameraImageViewOriginX = (_scanView.bounds.size.width - _scanView.scanAreaSize.width) / 2.0;
    CGFloat cameraImageViewOriginY = (_scanView.bounds.size.height - _scanView.scanAreaSize.height) / 2.0;
    self.cameraImageViewRect = CGRectMake(cameraImageViewOriginX,
                                          cameraImageViewOriginY,
                                          _scanView.scanAreaSize.width,
                                          _scanView.scanAreaSize.height);
    _scanView.cameraImageViewRect = self.cameraImageViewRect;
    
    _scanView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scanView];
    
    // 设置输出（metadata 元数据）
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    /*
     *  把扫描框的区域设置成有效区域范围，不设置则全屏有效！
     */
    CGRect validRect = CGRectMake(self.cameraImageViewRect.origin.y / MAIN_SCREEN_HEIGHT,
                                  self.cameraImageViewRect.origin.x / MAIN_SCREEN_WIDTH,
                                  self.cameraImageViewRect.size.height / MAIN_SCREEN_HEIGHT,
                                  self.cameraImageViewRect.size.width / MAIN_SCREEN_WIDTH);
    [output setRectOfInterest:validRect];
    
    // 创建拍摄会话
    _mySession = [[AVCaptureSession alloc] init];
    
    // 设置视频输出的质量(默认是AVCaptureSessionPresetHigh)
    _mySession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //添加session的输入和输出
    [_mySession addInput:input];
    [_mySession addOutput:output];
    
    // 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    //[output setMetadataObjectTypes:output.availableMetadataObjectTypes];//二维码+条形码
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];//二维码
    
    // 设置预览图层（用来让用户能够看到扫描情况）
    _myPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_mySession];
    
    // 设置preview图层的属性
    [_myPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    // 设置preview图层的大小
    _myPreviewLayer.frame = self.view.bounds;
    
    // 将图层添加到视图的图层
    [self.view.layer insertSublayer:_myPreviewLayer atIndex:0];
    
    // 启动会话
    [_mySession startRunning];
}

#pragma  mark - AVCaptureMetadataOutputObjectsDelegate [扫描结果]
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 3. 设置界面显示扫描结果
    if (metadataObjects.count > 0) {
        
        // 震动效果
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // 获取扫描结果
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *resultStr = obj.stringValue;
        
        if (resultStr == nil || resultStr.length == 0) {
            [self showErrorMessage];
            return;
        }
        
        // 停止会话
        [self.mySession stopRunning];
        
        // 删除预览图层
        [self.myPreviewLayer removeFromSuperlayer];
        
        [self backAction];
        // 回调结果
        self.resultBlock(resultStr);
    }
}

#pragma mark - 弹出错误信息
- (void)showErrorMessage {
    // 先停止会话
    [self.mySession stopRunning];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"二维码有误，请重新扫描" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 点击确定后再启动会话
        [self.mySession startRunning];
    }];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 导航栏按钮
- (void)createLeftItem {
    // 1、创建按钮
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 40, 44);
    leftItem.backgroundColor = [UIColor clearColor];
    [leftItem addTarget:self action:@selector(leftItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftItem setImage:[UIImage imageNamed:@"TBScanCode.bundle/whiteLeft"] forState:UIControlStateNormal];
    [leftItem setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
}

- (void)leftItemClick:(UIButton *)leftBtn {
    [self backAction];
}

- (void)backAction {
    if ([self.navigationController respondsToSelector:@selector(pushViewController:animated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)createRightItem {
    UIButton *rightButtoItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    rightButtoItem.selected = NO;
    [rightButtoItem setImage:[UIImage imageNamed:@"TBScanCode.bundle/flash_open"] forState:UIControlStateNormal];
    [rightButtoItem setImage:[UIImage imageNamed:@"TBScanCode.bundle/flash_close"] forState:UIControlStateSelected];
    [rightButtoItem addTarget:self action:@selector(controlTheFlaslight:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtoItem];
}

- (void)controlTheFlaslight:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        // 开灯
        if([self.captureDevice hasTorch] && [self.captureDevice hasFlash]) {
            if(self.captureDevice.torchMode == AVCaptureTorchModeOff) {
                [self.captureSession beginConfiguration];
                [self.captureDevice lockForConfiguration:nil];
                [self.captureDevice setTorchMode:AVCaptureTorchModeOn];
                [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
                [self.captureDevice unlockForConfiguration];
                [self.captureSession commitConfiguration];
            }
        }
        [self.captureSession startRunning];
    } else {
        // 关灯
        [self.captureSession beginConfiguration];
        [self.captureDevice lockForConfiguration:nil];
        if(self.captureDevice.torchMode == AVCaptureTorchModeOn) {
            [self.captureDevice setTorchMode:AVCaptureTorchModeOff];
            [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
        }
        [self.captureDevice unlockForConfiguration];
        [self.captureSession commitConfiguration];
        [self.captureSession stopRunning];
    }
}

#pragma mark -

- (void)dealloc {
    TBDeallocMark(...);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
