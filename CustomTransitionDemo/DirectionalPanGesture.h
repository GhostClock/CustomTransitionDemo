//
//  DirectionalPanGesture.h
//  CustomTransitionDemo
//
//  Created by YingshanDeng on 15/2/14.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PanDirection)
{
    PanDirectionRight,
    PanDirectionDown,
    PanDirectionLeft,
    PanDirectionUp
};

@interface DirectionalPanGesture : UIPanGestureRecognizer

/**
 *  指定 pan 的方向
 */
@property (nonatomic, assign) PanDirection direction;

@end
