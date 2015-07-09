//
//  ZoomImageView
//  zoomImage
//
//  Created by Mapollo27 on 15/6/3.
//  Copyright (c) 2015年 Mapollo27. All rights reserved.
//

#import "ZoomImageView.h"

#define deyTime         0.45f   //图片动画持续时间
#define roundBtnWH      40

static CGRect oldframe;

@implementation ZoomImageView
@synthesize backgroundViewDown;
@synthesize imageViewBig;
@synthesize roundButton;
@synthesize imageViewZoom;
@synthesize backgViewTop;

//初始化图片控件
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        roundButtonPosY = frame.size.height-roundBtnWH-10;
        roundButtonPosX =frame.size.width-roundBtnWH-10;
        
        buttonIndex = 1;
         backgroundViewDown = [[UIView alloc ] initWithFrame:frame];
        [backgroundViewDown setBackgroundColor:[UIColor clearColor]];
        [self addSubview:backgroundViewDown];
        
        //第一次显示的大图
        imageViewBig = [[UIImageView alloc ] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height  )];
        [imageViewBig setUserInteractionEnabled:YES];
        [backgroundViewDown addSubview:imageViewBig];
      
//        //点击大图event按钮显示效果
//        UITapGestureRecognizer *tapFirst  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnFirstTap)];
//        [imageViewBig addGestureRecognizer:tapFirst];

        //创建按钮
        roundButton = [[RoundButton alloc]initWithFrame:CGRectMake(roundButtonPosX , roundButtonPosY, roundBtnWH, roundBtnWH) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor blueColor]];
        [roundButton setUserInteractionEnabled:YES];
        [roundButton setHidden:YES];
        [backgroundViewDown addSubview:roundButton];
        
        //添加手势（放大图片）
        UITapGestureRecognizer *tapButton  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnZoomImage)];
        [roundButton addGestureRecognizer:tapButton];
    }
    return self;
}

//图片数组
-(void) setImageArray:(NSMutableArray*) array artId:(NSString *)ID
{
    imageArray = [NSMutableArray arrayWithArray:array];
    //从数组中删除第一个元素，将第一张图片显示在大图上
    [imageArray removeObjectAtIndex:0];
    //数组为空时
    if ([imageArray count] ==0)
    {
        //只有一张图片
        if([array count] >= 1)
        {
            [imageViewBig sd_setImageWithURL:[array objectAtIndex:0] placeholderImage:[UIImage imageNamed:RecommendArticleDefaultImage] ];
        }
    }
    else
    {
         [imageViewBig sd_setImageWithURL:[array objectAtIndex:0] placeholderImage:[UIImage imageNamed:RecommendArticleDefaultImage] ];
    }
    //创建一个线程加载其他图片
    [self performSelectorInBackground:@selector(loadRoundButtonImage) withObject:nil];
}

//加载网络图片
-(void) loadRoundButtonImage
{
    //异步加载圆按钮图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [roundButton setImageURL:[imageArray objectAtIndex:0] imageFrame:self.frame];
            [roundButton setHidden:NO];
            [roundButton setEnabled:YES];
        });
    });
}


-(void) OnZoomImage
{
    //隐藏按钮
    [roundButton setHidden:YES ];
    [roundButton setEnabled:NO];
    //放大按钮图片
    [self zoomImage:backgroundViewDown.frame image:roundButton.containerImageView];
}

//放大图片
-(void)zoomImage:(CGRect)frame image:(UIImageView*)zoomImageView
{
    UIImage *image=zoomImageView.image;
    //图片缩小到的frame
    oldframe=CGRectMake(roundButtonPosX, roundButtonPosY, roundBtnWH, roundBtnWH);
    //新创建的图层和底层图片位置大小相同
    backgViewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgViewTop.backgroundColor=[UIColor clearColor];
    
    imageViewZoom = [[UIImageView alloc]initWithFrame:oldframe];
    imageViewZoom.image=image;
    imageViewZoom.tag=1;
    [backgViewTop addSubview:imageViewZoom];
    [backgroundViewDown addSubview:backgViewTop];
    
    UITapGestureRecognizer *tapHideImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgViewTop addGestureRecognizer: tapHideImage];
    //图片放大动画
    [UIView animateWithDuration:deyTime delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageViewZoom.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imageViewZoom.layer.masksToBounds = YES;
        imageViewZoom.layer.cornerRadius = 20;
    } completion:^(BOOL finished)
    {
        imageViewZoom.layer.masksToBounds = NO;
        imageViewZoom.layer.cornerRadius = 0;
    }];
    
    [self performSelector:@selector(againCreateButton) withObject:nil afterDelay:deyTime];
}

-(void)hideImage:(UITapGestureRecognizer*)tap
{
    [NSThread sleepForTimeInterval:0.1];
    if(buttonIndex == -1)
        return;
    //在关闭图片时，先隐藏按钮
     [topButton[buttonIndex--] setHidden:YES];

    UIView *backgroundViewTop=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:deyTime animations:^{
        imageView.frame=oldframe;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 20;
    } completion:^(BOOL finished) {
        [backgroundViewTop removeFromSuperview];
    }];
    //延迟执行显示按钮
    [self performSelector:@selector(showButton) withObject:nil afterDelay:0.6f];
}

//显示按钮
-(void)showButton
{
    if (buttonIndex == 0 || buttonIndex== -1)
    {
        //再次点击放大图片时的数组索引
        buttonIndex =1;
        [UIView animateWithDuration:0.5f animations:^{
            [roundButton setHidden:NO];
            [roundButton setEnabled:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            [topButton[buttonIndex] setHidden:NO];
            [topButton[buttonIndex] setEnabled:YES];
        }];
    }
}

-(void) againCreateButton
{
    if(buttonIndex == -1)
        return;
    //如果是最后一张图则不在创建button，否则数组越界
    if ([imageArray count] == buttonIndex)
        return;
    //创建按钮
   topButton[buttonIndex] = [[RoundButton alloc]initWithFrame:CGRectMake(roundButtonPosX, roundButtonPosY, roundBtnWH,roundBtnWH) backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor blueColor]];
    [ topButton[buttonIndex] setUserInteractionEnabled:YES];
    [backgViewTop addSubview: topButton[buttonIndex]];
    
    //添加手势
    UITapGestureRecognizer *tapTopButton  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnAgainZoom)];
    [ topButton[buttonIndex] addGestureRecognizer:tapTopButton];
    [ topButton[buttonIndex] setImageURL:[imageArray objectAtIndex:buttonIndex] imageFrame:self.frame ];

}

-(void)OnAgainZoom
{
    if(buttonIndex == -1)
        return;
    [topButton[buttonIndex] setHidden:YES];
    [topButton[buttonIndex] setEnabled:NO];
    [self zoomImage:backgroundViewDown.frame image: topButton[buttonIndex].containerImageView];
    buttonIndex++;
}


////第一张图点击事件
-(void)OnFirstTap
{
    //    [self showAperture];
}

////点击第一张图显示光晕边框
//-(void) showAperture
//{
//    CGRect pathFrame = CGRectMake(-CGRectGetMidX(roundButton.bounds), -CGRectGetMidY(roundButton.bounds), roundButton.bounds.size.width, roundButton.bounds.size.height);
////    NSLog(@"%f  %f",pathFrame.origin.x,pathFrame.origin.y);
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:roundButton.layer.cornerRadius];
//    // accounts for left/right offset and contentOffset of scroll view
//    CGPoint shapePosition = [self convertPoint:roundButton.center fromView:nil];
//
//    CAShapeLayer *circleShape = [CAShapeLayer layer];
//    circleShape.path = path.CGPath;
//    circleShape.position = shapePosition;
//    circleShape.fillColor = [UIColor clearColor].CGColor;
//    circleShape.opacity = 0;
//    circleShape.strokeColor = [UIColor blackColor].CGColor;
//    circleShape.lineWidth = 3;
//
//    [self.layer addSublayer:circleShape];
//
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3f, 1.3f, 2)];
//
//    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    alphaAnimation.fromValue = @1;
//    alphaAnimation.toValue = @0;
//
//    CAAnimationGroup *animation = [CAAnimationGroup animation];
//    animation.animations = @[scaleAnimation, alphaAnimation];
//    animation.duration = 0.5f;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    [circleShape addAnimation:animation forKey:nil];
//
//}




@end
