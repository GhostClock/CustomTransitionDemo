//
//  DirectionalPanGesture.m
//  CustomTransitionDemo
//
//  Created by YingshanDeng on 15/2/14.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "DirectionalPanGesture.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface DirectionalPanGesture ()
/**
 *  该标志用于判断是否当前正在滑动中
 */
@property (nonatomic, assign) BOOL dragging;

@end

@implementation DirectionalPanGesture

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.dragging = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed)
    {
        return;
    }
    
    CGPoint velocity = [self velocityInView:self.view];
    
    // 只检测一次
    if (!self.dragging)
    {
        NSDictionary *velocities = @{
                                     @(PanDirectionRight) : @(velocity.x),
                                     @(PanDirectionDown) : @(velocity.y),
                                     @(PanDirectionLeft) : @(-velocity.x),
                                     @(PanDirectionUp) : @(-velocity.y)
                                     };
        NSArray *keysSorted = [velocities keysSortedByValueUsingSelector:@selector(compare:)];
        
        // 如果 pan 的方向和指定的方向不同，那么状态为 fail
        if ([[keysSorted lastObject] integerValue] != self.direction)
        {
            self.state = UIGestureRecognizerStateFailed;
        }
        
        self.dragging = YES;
    }
}


@end
