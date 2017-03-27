//
//  ViewController.m
//  UIKitDynamics Demo
//
//  Created by LDY on 17/3/27.
//  Copyright © 2017年 LDY. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIDynamicAnimator.h>
@interface ViewController ()<UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate>
@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIImageView *butterflyImageView;

@property(nonatomic,strong)UIDynamicAnimator *dynamicAnimator;

@property(nonatomic,strong)UIAttachmentBehavior *attachmentBehavior;

@property(nonatomic,strong)UIPushBehavior *pushBehavior;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
    
    UIDynamicAnimator *dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.dynamicAnimator = dynamicAnimator;//dynamicAnimator必须作为设置为全局变量，局部变量没有动画效果
    
    [self setGravityBehavior];
    
    [self setCollisionBehavior];
    
//    [self setupAttachmentBehavior];
    
    [self setupPushBehavior];
    
    [self setupDynamicItemBehavior];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizerAction:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizerAction:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
}

#pragma behaviors
-(void)setGravityBehavior{
//    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.imageView,self.butterflyImageView]];
     UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.imageView,self.butterflyImageView]];
    //    [gravityBehavior setXComponent:0.0f yComponent:0.1f];?
    [gravityBehavior setAngle:M_PI/3 magnitude:0.3f];//Angle:重力方向 magnitude:重力倍率
    [self.dynamicAnimator addBehavior:gravityBehavior];
}
-(void)setCollisionBehavior{
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.imageView,self.butterflyImageView]];
    [collisionBehavior setCollisionMode:UICollisionBehaviorModeEverything];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;//是否碰撞边界
    collisionBehavior.collisionDelegate = self;
    [self.dynamicAnimator addBehavior:collisionBehavior];
}

-(void)setupAttachmentBehavior{
    CGPoint fishCenter = CGPointMake(self.imageView.center.x, self.imageView.center.y);
    self.imageView.center = fishCenter;
    self.attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.butterflyImageView attachedToAnchor:fishCenter];//butterfly 附着到fish的起始位置的中心点
    //弹跳效果
    [self.attachmentBehavior setFrequency:1.0f];//振幅
    [self.attachmentBehavior setDamping:0.1f];//校平动画峰值
    [self.attachmentBehavior setLength:100.0f];//
    [self.dynamicAnimator addBehavior:self.attachmentBehavior];
}
-(void)setupSnapBehavior{
    
}
-(void)setupPushBehavior{
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.butterflyImageView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.angle = 0.0f;
    pushBehavior.magnitude = 0.0f;
    self.pushBehavior = pushBehavior;
    [self.dynamicAnimator addBehavior:pushBehavior];
}
-(void)setupDynamicItemBehavior{
    UIDynamicItemBehavior *dynamicItemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.imageView]];
    dynamicItemBehavior.elasticity = 1.0f;
    dynamicItemBehavior.allowsRotation = NO;
    dynamicItemBehavior.angularResistance = 0.0f;
    dynamicItemBehavior.density = 3.0f;
    dynamicItemBehavior.friction = 0.5f;
    dynamicItemBehavior.resistance = 0.5f;
    [self.dynamicAnimator addBehavior:dynamicItemBehavior];
}
#pragma UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p{
    
}
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    NSLog(@"begin:identifier=%@",identifier);
    if ([item isEqual:self.imageView]) {
        NSLog(@"fish");
    }else if([item isEqual:self.butterflyImageView]){
        NSLog(@"butterfly");
    }
    
}

-(void)collapseSecondaryViewController:(UIViewController *)secondaryViewController forSplitViewController:(UISplitViewController *)splitViewController{
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2{
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
    NSLog(@"end:identifier=%@",identifier);
//    if ([item isEqual:self.imageView]) {
//        NSLog(@"fish");
//    }else if([item isEqual:self.butterflyImageView]){
//        NSLog(@"butterfly");
//    }
}

#pragma UIDynamicAnimatorDelegate
-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    NSLog(@"dynamicAnimatorDidPause");
}
-(void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator{
     NSLog(@"dynamicAnimatorWillResume");
}
#pragma others
-(void)setupUI{
    [self.view addSubview:self.imageView];//imageView必须先添加到view上面
    [self.view addSubview:self.butterflyImageView];
}
-(void)gestureRecognizerAction:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint butterflyAnchorPoint = [gestureRecognizer locationInView:self.view];
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
//        //瞬间移动
//        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc]initWithItem:self.butterflyImageView snapToPoint:butterflyAnchorPoint];
//        snapBehavior.damping = 0.75f;
//        [self.dynamicAnimator addBehavior:snapBehavior];
        
        
    }else if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
//         [self.attachmentBehavior setAnchorPoint:butterflyAnchorPoint];
        //推动效果
        CGPoint point = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        CGFloat distance = sqrt(powf(butterflyAnchorPoint.x-point.x,2.0)+powf( butterflyAnchorPoint.y-point.y, 2.0));
        CGFloat angle = atan2(point.y-butterflyAnchorPoint.y, point.x-butterflyAnchorPoint.x);
        distance = MIN(distance, 100.0f);
        [self.pushBehavior setMagnitude:distance/100];
        [self.pushBehavior setAngle:angle];
        [self.pushBehavior setActive:YES];
        
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 数据源
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
        NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"fish.jpg" ofType:nil];
//        _imageView.image = [UIImage imageNamed:@"fish"];
        _imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return _imageView;
}

-(UIImageView *)butterflyImageView{
    if (!_butterflyImageView) {
        _butterflyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 100, 50, 50)];
        _butterflyImageView.image = [UIImage imageNamed:@"butterfly.jpg"];
    }
    return _butterflyImageView;
}

@end
