//
//  ViewController.m
//  coreAnimationTest
//
//  Created by 孙亚锋 on 2017/4/24.
//  Copyright © 2017年 yafeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *view;
    BOOL isOn;
    UIImageView *bgImgView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    view =[[UIView alloc]init];
    view.center = self.view.center;
    view.bounds = CGRectMake(0, 0, 200, 200);
    view.backgroundColor = [UIColor colorWithRed:249/255.0 green:140/255.0 blue:190/255.0 alpha:1];

    [self.view addSubview:view];
    /*
    核心动画中所有类都遵守CAMediaTiming协议。
    CAAnaimation是个抽象类，不具备动画效果，必须用它的子类才有动画效果。
    
     CAAnimationGroup和CATransition才有动画效果，CAAnimationGroup是个动画组，可以同时进行缩放，旋转（同时进行多个动画）。
     
     CATransition是转场动画，界面之间跳转（切换）都可以用转场动画。
     
     CAPropertyAnimation也是个抽象类，本身不具备动画效果，只有子类才有。
     
     CABasicAnimation和CAKeyframeAnimation：
     CABasicAnimation基本动画，做一些简单效果。
     CAKeyframeAnimation帧动画，做一些连续的流畅的动画。
    
    */


//    isOn = YES;
//     [self groupAnimation];
    
    
    
    //做转场动画使用
    bgImgView = [[UIImageView alloc]init];
    bgImgView.frame = CGRectMake(10, 10, 300, 500);
    bgImgView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:bgImgView];
    
}
static int i = 1;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
   // [self basicAnimationTest];
//    [self keyAnimation];
//    if (isOn) {
//        [self pauselayer:view.layer];
//    }else{
      //  [self ContinueLayer:view.layer];
//    }
//    isOn = !isOn;
    
    
//    [UIView transitionWithView:bgImgView duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        i++;
//        if (i == 10) {
//            i = 1;
//        }
//        bgImgView.image =[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
//    } completion:^(BOOL finished) {
//        
//    }];
    i++;
    if (i == 10) {
        i = 1;
    }
    NSString *img = [NSString stringWithFormat:@"%d.jpg",i];
    bgImgView.image = [UIImage imageNamed:img];
    
    CATransition *anima = [CATransition animation];
    anima.duration = 1;
    // fade push moveIn reveal cube oglFilp suckEffect rippleEffect
    // pagrCurl pageUnCurl  cameraIrisHollowOpen cameraIrisHollowClose
    //类型解释
   // http://images2015.cnblogs.com/blog/997095/201609/997095-20160904183937454-823344322.png
    anima.type = @"suckEffect";  // rippleEffect 挺好看的
    anima.startProgress = 0.3;
    anima.endProgress = 0.7;
    [bgImgView.layer addAnimation:anima forKey:nil];
   
}
-(void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion{
    
    
}


-(void)basicAnimationTest{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.y";
    animation.fromValue = @(0);
    animation.toValue = @(100);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"basic"];

}
-(void)keyAnimation{
    
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"transform";
    keyAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(.8, .8, 0)]];
    keyAnimation.keyTimes = @[@(.2),@(.5),@(.7),@(1)];
    keyAnimation.duration = 3;
    [view.layer addAnimation:keyAnimation forKey:@"keyAnimation"];
    
}
-(void)groupAnimation{
    CAAnimationGroup *animationGroup =[CAAnimationGroup animation];
    
    //绕着X轴旋转
    CABasicAnimation *basic1 =[CABasicAnimation animation];
    basic1.keyPath = @"transform.rotation.x";
    basic1.fromValue = @(0);
    basic1.toValue   = @(2*M_PI);
    //缩放
    CABasicAnimation *basic2 =[CABasicAnimation animation];
    basic2.keyPath = @"transform.scale.x";
    basic2.fromValue = @(1);
    basic2.toValue   = @(2);
    //变色
    CABasicAnimation *basic3 =[CABasicAnimation animation];
    basic3.keyPath = @"backgroundColor";
    basic3.fromValue = (__bridge id _Nullable)([[UIColor grayColor]CGColor]);
    basic3.toValue   = (__bridge id _Nullable)([[UIColor greenColor]CGColor]);
    
    
    
    animationGroup.duration = 3;
    animationGroup.animations = @[basic1,basic2,basic3];
   //代表动画执行完毕后就从图层上移除，图形会恢复到动画执行前的状态。如果想让图层保持显示动画执行后的状态，那就设置为NO，不过还要设置fillMode
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.repeatCount = MAXFLOAT;
    [view.layer addAnimation:animationGroup forKey:@"group"];
    
}


-(void)pauselayer:(CALayer *)layer{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 让CALayer的时间停止走动
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
    
    
}
-(void)ContinueLayer:(CALayer *)layer{
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
