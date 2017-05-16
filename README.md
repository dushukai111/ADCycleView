# ADCycleView
iOS应用中使用的广告轮播图控件，该控件中使用了SDWebImage，使用时需要导入，该控件能使用本地图片和web图片，通过imageType来设置，默认是网络图片。
## 基本使用方法
    NSArray *array1=@[@"img1.jpg",@"img2.jpg",@"img3.jpg",@"img4.jpg"];
    ADCycleView *adView=[[ADCycleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2) imageUrls:array1];
    adView.delegate=self;
    adView.delaySeconds=2;
    adView.imageType=ADCycleViewImageTypeLocal; //使用本地图片
    //adView.imageType=ADCycleViewImageTypeWeb; //使用网络图片
    adView.defaultImage=[UIImage imageNamed:@"adCycleViewDefault"]; //默认图片
    [self.view addSubview:adView];
## 通过ADCycleViewDelegate代理实现点击回调方法
   - (void)adCycleView:(ADCycleView *)adCycleView didSelectAtIndex:(NSInteger)index;
## 更新图片
    NSArray array=.....<br>
    adView.imageUrls=array;
## 效果图
