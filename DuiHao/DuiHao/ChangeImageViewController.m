//
//  ChangeImageViewController.m
//  DuiHao
//
//  Created by wjn on 16/5/8.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "ChangeImageViewController.h"
#import "OnceLogin.h"
#import "CropImageViewController.h"

@interface ChangeImageViewController ()<UIScrollViewDelegate,LCActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSString *url;

@end

@implementation ChangeImageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CropOK" object:nil];
}

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name: @"CropOK" object: nil];
    
    UIBarButtonItem *updateItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"UpdateImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(updateItemDidPress:)];
    [self.navigationItem setRightBarButtonItem:updateItem];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setTitle:@"个人头像"];
    
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.imageView];
    [self setImageViewWithUrl:self.url];
}

#pragma mark - updateItemDidPress

- (void)updateItemDidPress:(id)sender {

    //     判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:@[@"拍照", @"从手机相册选择"] redButtonIndex:-1 delegate:self];
        [sheet show];
    } else {
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil buttonTitles:@[@"从手机相册选择"] redButtonIndex:-1 delegate:self];
        [sheet show];
    }
}

#pragma mark - ImageView

- (UIImageView *)imageView {
    if (!_imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

#pragma mark - setImageUrl

- (void)setImageViewWithUrl:(NSString *)url {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.center.x, self.view.center.y);
//    spinner.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.scrollView addSubview:spinner];
    
    [spinner startAnimating];
    
    __weak typeof(UIImageView) *weakimageView = self.imageView;
    
    CGFloat enlarge = 1.5;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        
        [spinner stopAnimating];
        
        if (!image) {
            [self.imageView setImage:[UIImage imageNamed:@"Placeholder"]];
            return;
        }
        
        self.scrollView.userInteractionEnabled = YES;
        
        CGFloat kHeight = self.view.height - weakimageView.image.size.height * self.view.width / weakimageView.image.size.width;
        CGFloat kWidth = self.view.width - self.view.height / weakimageView.image.size.height * weakimageView.image.size.width;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (kHeight >= 0) {
                weakimageView.frame = CGRectMake(0, kHeight / 2.0 - 32, self.view.width, weakimageView.image.size.height * self.view.width / weakimageView.image.size.width);
                weakimageView.width = self.view.width;
                
            } else {
                weakimageView.frame = CGRectMake(kWidth / 2.0, 0, self.view.height/ weakimageView.image.size.height * weakimageView.image.size.width, self.view.height);
            }
            
            self.scrollView.maximumZoomScale = (self.view.height / weakimageView.height > enlarge ? self.view.height / weakimageView.height : (self.view.width / weakimageView.width >= 2.0 ? self.view.width / weakimageView.width : 2.0));
            self.scrollView.minimumZoomScale = 1.0;
        });
    }];

    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    doubleTapGesture.numberOfTapsRequired = 2;
    
    [self.scrollView addGestureRecognizer:doubleTapGesture];

    [self.scrollView setContentSize:CGSizeMake(_imageView.width, _imageView.height)];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {
    
    float newScale;
    UIScrollView *scrollView = (UIScrollView *)gesture.view;
    
    if (scrollView.zoomScale == 1.0) {
        newScale = scrollView.maximumZoomScale;
    } else {
        newScale = 1.0 / scrollView.maximumZoomScale;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter: [gesture locationInView:(UIScrollView *)gesture.view]];
    [(UIScrollView *)gesture.view zoomToRect:zoomRect animated:YES];
}

#pragma mark - private

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - zoomRect.size.width / 2.0;
    zoomRect.origin.y = center.y - zoomRect.size.height / 2.0;
    return zoomRect;
}

#pragma mark - UIScrollViewZoom

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5: 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex {
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0: //相机
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
            case 1: //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
    } else {
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
            }
}

#pragma mark - image picker delegte

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) { case UIImageOrientationDown: case UIImageOrientationDownMirrored: transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height); transform = CGAffineTransformRotate(transform, M_PI); break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) { case UIImageOrientationUpMirrored: case UIImageOrientationDownMirrored: transform = CGAffineTransformTranslate(transform, aImage.size.width, 0); transform = CGAffineTransformScale(transform, -1, 1); break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0, CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage)); CGContextConcatCTM(ctx, transform); switch (aImage.imageOrientation) { case UIImageOrientationLeft: case UIImageOrientationLeftMirrored: case UIImageOrientationRight: case UIImageOrientationRightMirrored:
            
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx); UIImage *img = [UIImage imageWithCGImage:cgimg]; CGContextRelease(ctx); CGImageRelease(cgimg); return img;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    image = [self fixOrientation:image];
    
//
    CropImageViewController *cropImageViewController = [[CropImageViewController alloc] initWithNibName:@"CropImageViewController" bundle:nil withImage:image];
    [self presentViewController:cropImageViewController animated:YES completion:^{
    }];
    
//    image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(320, 320/image.size.width * image.size.height)];
//    
//    NSData *imageData = UIImagePNGRepresentation(image);
    
//    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
//    
//    NSDictionary *dic = @{STUDENTID: onceLogin.studentID, REQUESTSOURCE: @"iOS", IMAGEFILE:imageData};
//    
//    [KVNProgress showWithStatus:@"正在上传"];
//    
//    [SANetWorkingTask requestWithPost:[SAURLManager uploadPersonPic] parmater:dic block:^(id result) {
//        
//        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
//            onceLogin.imageURL = result[RESULT][IMAGEURL];
//            [onceLogin writeToLocal];
//            
//            [self.imageView sd_setImageWithURL:[NSURL URLWithString:onceLogin.imageURL]];
//            self.scrollView.userInteractionEnabled = YES;
//            
//            [KVNProgress showSuccessWithStatus:@"上传成功"];
//            
//        } else {
//            [KVNProgress showErrorWithStatus:result[@"errMsg"]];
//        }
//    }];
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext (newSize);
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [image drawInRect : CGRectMake ( 0 , 0 ,newSize. width ,newSize. height )];
    
    // Get the new image from the context
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    
    // End the context
    
    UIGraphicsEndImageContext ();
    
    // Return the new image.
    
    return newImage;
    
}


- (void)notificationHandler: (NSNotification *)notification {
    
    UIViewController *rootVC = self;
    while (rootVC.presentingViewController) {
        rootVC = rootVC.presentingViewController;
    }
    [rootVC dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = (UIImage *)[notification object];
    image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(320, 320/image.size.width * image.size.height)];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
//    NSDictionary *dic = @{STUDENTID: onceLogin.studentID, REQUESTSOURCE: @"iOS", IMAGEFILE:imageData};
    NSDictionary *dic = @{STUDENTID: onceLogin.studentID, REQUESTSOURCE: @"iOS"};
    
    [KVNProgress showWithStatus:@"正在上传"];
    
    [SANetWorkingTask updataWithPost:[SAURLManager uploadPersonPic] parmater:dic withData:imageData withFileName:nil block:^(id result) {
                if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
                    onceLogin.imageURL = result[RESULT][IMAGEURL];
                    [onceLogin writeToLocal];
        
                    [self.imageView sd_setImageWithURL:[NSURL URLWithString:onceLogin.imageURL] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
                    self.scrollView.userInteractionEnabled = YES;
        
                    [KVNProgress showSuccessWithStatus:@"上传成功"];
        
                } else {
                    [KVNProgress showErrorWithStatus:result[@"errMsg"]];
                }

    }];
    
//    [SANetWorkingTask requestWithPost:[SAURLManager uploadPersonPic] parmater:dic block:^(id result) {
//        
//        if ([result[RESULT_STATUS] isEqualToString:RESULT_OK]) {
//            onceLogin.imageURL = result[RESULT][IMAGEURL];
//            [onceLogin writeToLocal];
//            
//            self.imageView.image = image;
//            self.scrollView.userInteractionEnabled = YES;
//            
//            [KVNProgress showSuccessWithStatus:@"上传成功"];
//            
//        } else {
//            [KVNProgress showErrorWithStatus:result[@"errMsg"]];
//        }
//    }];
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
