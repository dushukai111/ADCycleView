//
//  ViewController.m
//  ADCycleViewTest
//
//  Created by kaige on 2017/5/3.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import "ViewController.h"
#import "ADCycleView.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()<ADCycleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        NSArray *array=@[@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2710559885,1867573986&fm=23&gp=0.jpg",@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1283266638,743078694&fm=23&gp=0.jpg"];
    NSArray *array1=@[@"img1",@"img2",@"img3",@"img4"];
    ADCycleView *adView=[[ADCycleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.5) imageUrls:array];
    adView.delegate=self;
    adView.delaySeconds=2;
//    adView.imageType=ADCycleViewImageTypeLocal;
        adView.imageType=ADCycleViewImageTypeWeb;
    adView.defaultImage=[UIImage imageNamed:@"adCycleViewDefault"];
    [self.view addSubview:adView];
}
- (void)adCycleView:(ADCycleView *)adCycleView didSelectAtIndex:(NSInteger)index{
    NSLog(@"page %lu click",index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
