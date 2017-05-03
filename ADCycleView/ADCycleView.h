//
//  ADCycleView.h
//  GoHome
//
//  Created by kaige on 2017/4/28.
//  Copyright © 2017年 dushukai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ADCycleViewImageType) {
    ADCycleViewImageTypeWeb, //webImage,default
    ADCycleViewImageTypeLocal //localImage
};
@class ADCycleView;
@protocol ADCycleViewDelegate<NSObject>
- (void)adCycleView:(ADCycleView*)adCycleView didSelectAtIndex:(NSInteger)index;
@end
@interface ADCycleView : UIView
@property (nonatomic,copy) NSArray *imageUrls;
@property (nonatomic,strong) UIImage *defaultImage;
@property (nonatomic,weak) id<ADCycleViewDelegate> delegate;
@property (nonatomic,assign) NSInteger delaySeconds;
@property (nonatomic,assign) ADCycleViewImageType imageType;
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray*)imageUrls;
@end
