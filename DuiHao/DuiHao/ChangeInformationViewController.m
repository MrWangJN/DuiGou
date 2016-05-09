//
//  ChangeInformationViewController.m
//  DuiHao
//
//  Created by wjn on 16/5/7.
//  Copyright © 2016年 WJN. All rights reserved.
//

#import "ChangeInformationViewController.h"
#import "OnceLogin.h"

@interface ChangeInformationViewController ()

@property (strong, nonatomic) IBOutlet UITextField *contentTF;
@property (assign, nonatomic) ChangeInformationType type;

@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) UIKeyboardType keyboardType;

@end

@implementation ChangeInformationViewController

- (instancetype)initWithType:(ChangeInformationType )type withTitle:(NSString *)title whitContent:(NSString *)content withKeyboardType:(UIKeyboardType)keyboardType {
    self = [super init];
    if (self) {
        self.type = type;
        [self.navigationItem setTitle:title];
        
        self.content = content;
        self.keyboardType = keyboardType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.content) {
        self.contentTF.text = self.content;
    }
    
    self.contentTF.keyboardType = self.keyboardType;
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)buttonDidPress:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
