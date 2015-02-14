//
//  PopAnimation.m
//  CustomTransitionDemo
//
//  Created by YingshanDeng on 15/2/14.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "PopAnimation.h"

// UIView 的匿名扩展
@implementation UIView (TransitionShadow)

- (void)addLeftSideShadowWithFading
{
    // 在视图的左侧边缘添加一个阴影效果
    CGFloat shadowWidth = 4.0f;
    CGFloat shadowVerticalPadding = -20.0f;
    CGFloat shadowHeight = CGRectGetHeight(self.frame) - 2 * shadowVerticalPadding;
    CGRect shadowRect = CGRectMake(-shadowWidth, shadowVerticalPadding, shadowWidth, shadowHeight);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:shadowRect];
    self.layer.shadowPath = [shadowPath CGPath];
    self.layer.shadowOpacity = 0.1f;
    
    // 在动画执行过程中，阴影透明度降低
    CGFloat toValue = 0.0f;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = @(self.layer.shadowOpacity);
    animation.toValue = @(toValue);
    [self.layer addAnimation:animation forKey:nil];
    self.layer.shadowOpacity = toValue;
}
@end

@interface PopAnimation ()

@property (weak, nonatomic) UIViewController *toViewController;

@end

@implementation PopAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isInteractive] ? 0.4f : 0.5f;
}

// 注意： 这个动画是应用于 pop view controller 的时候，所以 fromVC 是需要 pop 的 VC (位于上层)，而 toVC 是需要展现的 VC (位于下层)。
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // toVC 置于 fromVC 的下面
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    // 增加视觉效果：toVC 从左往右移动。那么先做一个左移动
    CGFloat toViewControllerXTranslation = - CGRectGetWidth([transitionContext containerView].bounds) * 0.3f;
    toViewController.view.transform = CGAffineTransformMakeTranslation(toViewControllerXTranslation, 0);
    
    
    // 为 fromVC 添加一个左侧阴影
    [fromViewController.view addLeftSideShadowWithFading];
    BOOL previousClipsToBounds = fromViewController.view.clipsToBounds;
    fromViewController.view.clipsToBounds = NO;
    
    // 为 toVC 添加一个视图 -- 用于视觉效果（蒙层）
    UIView *dimmingView = [[UIView alloc] initWithFrame:toViewController.view.bounds];
    dimmingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    [toViewController.view addSubview:dimmingView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.transform = CGAffineTransformMakeTranslation(toViewController.view.frame.size.width, 0);
        dimmingView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [dimmingView removeFromSuperview];
        fromViewController.view.transform = CGAffineTransformIdentity;
        fromViewController.view.clipsToBounds = previousClipsToBounds;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
    
    self.toViewController = toViewController;
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    // 当切换动画取消时，重置 toViewController 的 transform
    if (!transitionCompleted)
    {
        self.toViewController.view.transform = CGAffineTransformIdentity;
    }
}

@end
