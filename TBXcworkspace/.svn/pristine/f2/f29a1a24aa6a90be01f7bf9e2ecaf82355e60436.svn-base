//
//  TBAlertViewController.m
//  TBBusiness
//
//  Created by Apple on 2018/6/27.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "TBAlertViewController.h"

@interface TBAlertViewController ()

@end

@implementation TBAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.cancelAction) {
        [self.cancelAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
        [self addAction:self.cancelAction];
    }
    
    if (self.confirmAction) {
        [self.confirmAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        
        [self addAction:self.confirmAction];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    TBLog(@"【TBAlertViewController已销毁】");
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
