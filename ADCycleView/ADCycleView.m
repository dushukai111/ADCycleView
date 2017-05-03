//
//  ADCycleView.m
//  GoHome
//
//  Created by kaige on 2017/4/28.
//  Copyright © 2017年 dushukai. All rights reserved.
//  Depend on SDWebImage

#import "ADCycleView.h"
#import "UIImageView+WebCache.h"
#define cellId @"ADCycleViewCell"
@interface ADCycleViewCell:UICollectionViewCell
@property (nonatomic,strong) UIImageView *imgView;
@end
@interface ADCycleView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIImageView *defaultImageView;//初始化时可能还没有数据，先显示一张图片占位
@property (nonatomic,strong) NSTimer *timer;
@end
@implementation ADCycleView
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls{
    self=[super initWithFrame:frame];
    if (self) {
        _imageUrls=imageUrls;
        _imageType=ADCycleViewImageTypeWeb;
        _delaySeconds=3;
        [self initCollectionView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initCollectionView];
        [self initDefaultImageView];
    }
    return self;
}
- (void)initCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.itemSize=CGSizeMake(self.frame.size.width, self.frame.size.height);
    flowLayout.minimumLineSpacing=0;
    flowLayout.minimumInteritemSpacing=0;
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.pagingEnabled=YES;
    self.collectionView.bounces=NO;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.showsVerticalScrollIndicator=NO;
    [self.collectionView registerClass:[ADCycleViewCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    [self initDefaultImageView];
    [self initPageControl];
    if (self.imageUrls) {
        self.defaultImageView.hidden=YES;
        self.pageControl.hidden=NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startTimer];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:50] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        });
        
    }else{
        self.defaultImageView.hidden=NO;
        self.pageControl.hidden=YES;
    }
    
}
- (void)initPageControl{
    self.pageControl=[[UIPageControl alloc] init];
    self.pageControl.numberOfPages=self.imageUrls.count;
    self.pageControl.currentPage=0;
    [self addSubview:self.pageControl];
    self.pageControl.translatesAutoresizingMaskIntoConstraints=NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}
- (void)initDefaultImageView{
    self.defaultImageView=[[UIImageView alloc] init];
    self.defaultImageView.image=self.defaultImage;
    [self addSubview:self.defaultImageView];
    self.defaultImageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.defaultImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}
- (void)startTimer{
    if (!self.timer.valid) {
        self.timer=[NSTimer scheduledTimerWithTimeInterval:self.delaySeconds==0?3:self.delaySeconds target:self selector:@selector(timerRepeat) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    
}
- (void)timerRepeat{
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x+self.bounds.size.width, 0) animated:YES];
}
- (void)cancelTimer{
    [self.timer invalidate];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 100;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageUrls.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ADCycleViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString *imageUrl=self.imageUrls[indexPath.item];
    if (self.imageType==ADCycleViewImageTypeWeb) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:self.defaultImage];
    }else{
        cell.imgView.image=[UIImage imageNamed:imageUrl];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(adCycleView:didSelectAtIndex:)]) {
        [self.delegate adCycleView:self didSelectAtIndex:indexPath.item];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetPosition];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self resetPosition];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self cancelTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
#pragma mark - 重新设置scrollview的contentOffset
- (void)resetPosition{
    NSInteger index=((NSInteger)(self.collectionView.contentOffset.x/self.bounds.size.width))%self.imageUrls.count;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:50] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    self.pageControl.currentPage=index;
}
- (void)setImageUrls:(NSArray *)imageUrls{
    if (_imageUrls!=imageUrls) {
        [self cancelTimer];
        _imageUrls=imageUrls;
        [self.collectionView reloadData];
        if (imageUrls) {
            self.defaultImageView.hidden=YES;
            self.pageControl.hidden=NO;
            self.pageControl.numberOfPages=self.imageUrls.count;
            self.pageControl.currentPage=0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:50] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                if (!self.timer.isValid) {
                    [self startTimer];
                }
                
                
            });
            
            
        }else{
            self.defaultImageView.hidden=NO;
            self.pageControl.hidden=YES;
        }
    }
}
- (void)setDefaultImage:(UIImage *)defaultImage{
    _defaultImage=defaultImage;
    self.defaultImageView.image=defaultImage;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"layoutSubViews");
}
- (void)dealloc{
    [self.timer invalidate];
}
@end

@implementation ADCycleViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.imgView=[[UIImageView alloc] init];
        [self addSubview:self.imgView];
        self.imgView.translatesAutoresizingMaskIntoConstraints=NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

@end
