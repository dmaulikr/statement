//
//  StatementDetailsViewController.m
//  statement
//
//  Created by Alexander Kuhar on 4/28/17.
//  Copyright © 2017 Alexander Kuhar. All rights reserved.
//

#import "StatementDetailsViewController.h"

@interface StatementDetailsViewController ()

@end

@implementation StatementDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError* error = nil;
    
    if(![_fetchController performFetch:&error]) {
        
        NSLog(@"Failed to perform fetch: %@", error);
    }
    
    NSLog(@"%@", self.selectedStatement);
    // Do any additional setup after loading the view.
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
