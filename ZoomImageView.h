//
//  ZoomImageView
//  zoomImage
//
//  Created by Mapollo27 on 15/6/3.
//  Copyright (c) 2015年 Mapollo27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundButton.h"

@interface ZoomImageView : UIView
{
    RoundButton*    topButton[20];
    int             buttonIndex;
    NSMutableArray *imageArray;
    float           roundButtonPosY;
    float           roundButtonPosX;
}

//最底层view
@property (nonatomic ,strong) UIView *backgroundViewDown;
//最大图片
@property (nonatomic ,strong) UIImageView *imageViewBig;
//按钮
@property (nonatomic ,strong) RoundButton *roundButton;
@property (nonatomic ,strong) UIWindow *window;
@property (nonatomic ,strong) UIImageView *imageViewZoom;
@property (nonatomic ,strong) UIView *backgViewTop;

- (id)initWithFrame:(CGRect)frame;
-(void) setImageArray:(NSMutableArray*) array artId:(NSString *)ID;

@end
