//
// Created by fantouch on 16/03/2018.
// Copyright (c) 2018 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCMediaPicker.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface QCMediaPicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation QCMediaPicker {
    __weak UIViewController *_controller;

    void(^_onFinishBlock)(NSURL *fileUrl);
}

- (instancetype)initWithController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (void)imageFromLibrary:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;

    [_controller presentViewController:picker animated:YES completion:nil];
}

- (void)imageFromCamera:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera; // 仅从相机获取
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;// 当相机提供多种模式 (拍照, 录视频) 的时候, 优先选择录视频模式
    picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;

    [_controller presentViewController:picker animated:YES completion:nil];
}

- (void)videoFromLibrary:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *) kUTTypeMovie];
    picker.delegate = self;
    picker.allowsEditing = NO;

    [_controller presentViewController:picker animated:YES completion:nil];
}

- (void)videoFromCamera:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera; // 仅从相机获取
    picker.mediaTypes = @[(NSString *) kUTTypeMovie]; // 限定相机只提供录视频模式
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    picker.videoMaximumDuration = 8;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;// 当相机提供多种模式 (拍照, 录视频) 的时候, 优先选择录视频模式
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;

    [_controller presentViewController:picker animated:YES completion:nil];
}

#pragma UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [_controller dismissViewControllerAnimated:YES completion:nil];

    NSURL *fileUrl;
    if ([info[UIImagePickerControllerMediaType] isEqual:@"public.image"]) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//相机拍照
            NSString *path = [self saveImage:info[UIImagePickerControllerOriginalImage]];
            fileUrl = [NSURL fileURLWithPath:path];
        } else {//相册图片
            if (@available(iOS 11, *)) {
                fileUrl = info[UIImagePickerControllerImageURL];
            } else {
                NSString *path = [self saveImage:info[UIImagePickerControllerOriginalImage]];
                fileUrl = [NSURL fileURLWithPath:path];
            }
        }
    } else if ([info[UIImagePickerControllerMediaType] isEqual:@"public.movie"]) {
        fileUrl = info[UIImagePickerControllerMediaURL];
    }
    _onFinishBlock(fileUrl);
    _onFinishBlock = nil;
}

- (NSString *)saveImage:(UIImage *)image {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%f.jpeg", time];
    [UIImageJPEGRepresentation(image, 0.5f) writeToFile:path atomically:YES];
    return path;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_controller dismissViewControllerAnimated:YES completion:nil];
    _onFinishBlock(nil);
    _onFinishBlock = nil;
}

@end
