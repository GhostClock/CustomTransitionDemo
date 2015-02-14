//
//  SwipeToPop.m
//  CustomTransitionDemo
//
//  Created by YingshanDeng on 15/2/14.
//  Copyright (c) 2015年 YingshanDeng. All rights reserved.
//

#import "SwipeToPop.h"
#import "DirectionalPanGesture.h"
#import "PopAnimation.h"

@interface SwipeToPop ()

/**
 *  navigation controller
 */
@property (nonatomic, strong) UINavigationController *naviController;

/**
 *  pan 手势
 */
@property (nonatomic, strong) DirectionalPanGesture *panGesture;

/**
 *  pop view controller 时的动画
 */
@property (nonatomic, strong) PopAnimation *popAnimation;

/**
 *  pop view controller 时的交互动作
 */
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interaction;

/**
 *  是否正在执行动画
 */
@property (nonatomic, assign) BOOL duringAnimation;

@end

@implementation SwipeToPop

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self)
    {
        self.naviController = navigationController;
        
        // pan 手势
        DirectionalPanGesture *panGesture = [[DirectionalPanGesture alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGesture.maximumNumberOfTouches = 1;
        // 指定向右滑动才响应
        panGesture.direction = PanDirectionRight;
        self.panGesture = panGesture;
        [self.naviController.view addGestureRecognizer:panGesture];
        
        // pop 动画效果
        self.popAnimation = [[PopAnimation alloc] init];
    }
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    UIView *view = self.naviController.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if (self.naviController.viewControllers.count > 1 && !self.duringAnimation)
        {
            self.interaction = [[UIPercentDrivenInteractiveTransition alloc] init];
            self.interaction.completionCurve = UIViewAnimationCurveEaseOut;
            
            [self.naviController popViewControllerAnimated:YES];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:view];
        // 更新交互动作完成百分比
        CGFloat d = translation.x > 0 ? translation.x / CGRectGetWidth(view.bounds) : 0;
        [self.interaction updateInteractiveTransition:d];
    }
    else if (recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self.interaction cancelInteractiveTransition];
        self.interaction = nil;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([recognizer velocityInView:view].x > 0)
        {
            [self.interaction finishInteractiveTransition];
        }
        else
        {
            [self.interaction cancelInteractiveTransition];
            self.duringAnimation = NO;
        }
        self.interaction = nil;
    }
}


#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    // 当事进行 pop 的时候，才返回动画
    if (operation == UINavigationControllerOperationPop)
    {
        return self.popAnimation;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    // 返回切换交互动作
    return self.interaction;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated)
    {
        self.duringAnimation = YES;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.duringAnimation = NO;
    
    if (navigationController.viewControllers.count <= 1)
    {
        self.panGesture.enabled = NO;
    }
    else
    {
        self.panGesture.enabled = YES;
    }
}

@end
