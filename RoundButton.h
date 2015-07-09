//
//  RoundButton.h
//  zoomImage
//
//  Created by Mapollo27 on 15/6/3.
//  Copyright (c) 2015年 Mapollo27. All rights reserved.
//

#import <UIKit/UIKit.h>



#pragma mark - ZoomImageCache interface

@interface ZoomImageCache : NSObject

@property (nonatomic, strong) NSString      *cachePath;
@property (nonatomic, strong) NSFileManager *fileManager;

- (void)setImage:(UIImage *)image forURL:(NSString *)URL;
- (UIImage *)getImageForURL:(NSString *)URL;

@end


@interface RoundButton : UIButton
{
     UIColor *rippleColor;
}
@property (nonatomic, assign, getter = isCacheEnabled) BOOL cacheEnabled;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIImageView *containerImageView;
@property (nonatomic, strong) UIView      *progressContainer;
@property (nonatomic, strong) ZoomImageCache *cache;


- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor progressColor:(UIColor *)progressColor;
- (void)setImageURL:(NSString *)URL imageFrame:(CGRect)frame;

@end

