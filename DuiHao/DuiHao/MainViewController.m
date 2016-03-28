//
//  MainViewController.m
//  StudyAssisTant
//
//  Created by wjn on 15/8/25.
//  Copyright (c) 2015年 WJN_work@163.com. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
}


#pragma mark - private

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.imageHeadTableViewCell = [UINib nibWithNibName:@"ImageHeadTableViewCell" bundle:nil];
        [_tableView registerNib:self.imageHeadTableViewCell forCellReuseIdentifier:@"imageHeadTableViewCell"];
        self.mineUITableViewCell = [UINib nibWithNibName:@"MineUITableViewCell" bundle:nil];
        [_tableView registerNib:self.mineUITableViewCell forCellReuseIdentifier:@"MineUITableViewCell"];

    }
    return _tableView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 220;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    if (indexPath.row == 0) {
        ImageHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageHeadTableViewCell"];
        [cell setImageHeaderView:onceLogin.imageURL];
        [cell.userLabel setText:onceLogin.sName];
        return cell;
    } else {
        MineUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineUITableViewCell"];
        
        if (indexPath.row == 1) {
            
            [cell.functionImage setImage:[UIImage imageNamed:@"Message"]];
            [cell.functionLabel setText:@"我的消息"];
            
        } else {
            
            [cell.functionImage setImage:[UIImage imageNamed:@"Set"]];
            [cell.functionLabel setText:@"我的设置"];
            
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIActionSheet *sheet;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
        }
        else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        }
        
        sheet.tag = 255;
        
        [sheet showInView:self.view];
    }
    
    if (indexPath.row == 1) {
        NewsViewController *newsViewController = [[NewsViewController alloc] init];
        [self.navigationController pushViewController:newsViewController animated:YES];
    }
    
    
    if (indexPath.row == 2) {
        MineSetViewController *mineSetViewController = [[MineSetViewController alloc] init];
        [self.navigationController pushViewController:mineSetViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
  
//    for (UITableViewCell *cell in self.tableView.visibleCells) {
//        if ([cell isKindOfClass:[ImageHeadTableViewCell class]]) {
//            ImageHeadTableViewCell *imageHeaderCell = (ImageHeadTableViewCell *)cell;
//            imageHeaderCell.imageHeader.image = image;
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//        }
//    }
    image = [self imageWithImageSimple:image scaledToSize:CGSizeMake(320, 320/image.size.width * image.size.height)];
    
    NSData *imageData = UIImagePNGRepresentation(image);
//    NSString *imageFile = [[NSString alloc] initWithData:imageData encoding:<#(NSStringEncoding)#>]
    
//    NSString* encodeResult = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    NSString *encodeResult = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
//    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:encodeResult options:0];
    //
    
    OnceLogin *onceLogin = [OnceLogin getOnlyLogin];
    
    NSDictionary *dic = @{SCHOOLNUMBER: onceLogin.schoolNumber, STUDENTNUMBERPIC: onceLogin.studentID, IMAGENAME: [NSString stringWithFormat:@"%@_%@.png", onceLogin.schoolNumber, onceLogin.studentID], IMAGEFILE:imageData, MODEL:@"iOS"};
    
    [SANetWorkingTask requestWithPost:[SAURLManager uploadPersonPic] parmater:dic block:^(id result) {
        if ([result[@"flag"] isEqualToString:@"001"]) {
            onceLogin.imageURL = result[@"url"];
            [onceLogin writeToLocal];
            [self.tableView reloadData];
        }
    }];
//    [SANetWorkingTask updataWithPost:[SAURLManager uploadPersonPic] parmater:dic withData:imageData withFileName:@"" block:^(id) {
//        
//    }];
//    [SANetWorkingTask updataWithPost:[SAURLManager uploadPersonPic] parmater:dic withData:imageData withFileName:[NSString stringWithFormat:@"%@_%@.png", onceLogin.schoolNumber, onceLogin.studentID] block:^(id result) {
//    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
