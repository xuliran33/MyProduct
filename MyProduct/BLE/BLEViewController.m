//
//  BLEViewController.m
//  MyProduct
//
//  Created by dalong on 2022/10/12.
//

#import "BLEViewController.h"
#import "BLEManager.h"

@interface BLEViewController ()

@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BLEManager *manager = [BLEManager sharedBLEManager];
}



@end
