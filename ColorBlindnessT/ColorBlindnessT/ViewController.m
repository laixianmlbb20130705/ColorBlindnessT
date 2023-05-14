//
//  ViewController.m
//  ColorBlindnessT
//
//  Created by Makz on 2023/5/13.
//

#import "ViewController.h"

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
@interface ViewController ()

@property(nonatomic,assign) int currentAndom;
@property(nonatomic,assign) int currentCount;
@property(nonatomic,assign) int currentPass;
@property(nonatomic,assign) int currentTime;
@property(nonatomic,strong) UIView *mainView;
@property(nonatomic,strong) UILabel *passLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

//创建主视图
- (void)initView {
    
    self.view.backgroundColor = [UIColor colorWithRed:(241.0/255.0) green:(96.0/255.0) blue:(96.0/255.0) alpha:1];
    
    float mainViewWidth = kWidth-10;
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, mainViewWidth,mainViewWidth)];
    mainView.center = self.view.center;
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 10;
    
    [self.view addSubview:mainView];
    //当前关卡
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, mainView.frame.origin.y-90, kWidth, 40)];
    passLabel.font = [UIFont boldSystemFontOfSize:17];
    passLabel.textColor = [UIColor whiteColor];
    passLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:passLabel];
    
    //剩余时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, mainView.frame.origin.y-60, kWidth, 40)];
    timeLabel.font = [UIFont boldSystemFontOfSize:25];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];
    
    self.passLabel = passLabel;
    self.mainView = mainView;
    self.timeLabel = timeLabel;
}

- (int)currentCount {
    _currentCount = 4;
    if(self.currentPass<2){
        _currentCount = 4;
    }else if (self.currentPass>2 && self.currentPass<5){
        _currentCount = 16;
    }else if (self.currentPass>=5 && self.currentPass<8){
        _currentCount = 25;
    }else if (self.currentPass>=8 && self.currentPass<10){
        _currentCount = 36;
    }else if (self.currentPass>=10){
        _currentCount = 49;
    }
    
    return _currentCount;
}

- (void)createTimer {
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(printTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)initData {
    self.currentPass = 1;
    self.currentTime = 30;
    
    [self clearSubView];
    self.passLabel.text = [NSString stringWithFormat:@"当前关卡：%d",self.currentPass];
    self.timeLabel.text = [NSString stringWithFormat:@"剩余时间：%d",self.currentTime];
    [self createViews:self.currentCount withSuperview:self.mainView];
}

- (void)printTime {
    self.currentTime = self.currentTime - 1;
    
    self.timeLabel.text = [NSString stringWithFormat:@"剩余时间：%d",self.currentTime];
    if(self.currentTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        //结束 跳出一个弹窗
        UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"再来一局" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self initData];
        }];
        [alertContr addAction:cancelAction];
        [self presentViewController:alertContr animated:YES completion:nil];
    }
}
//创建子视图
- (void)createViews:(float)count withSuperview:(UIView *)superview{
    
    float left = 10;
    float top = 10;
    float padding = 3;
    
    float width = (superview.frame.size.width-2*left-(sqrt(count)-1)*padding)/sqrt(count);
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    UIColor *color2 = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.7];
    int andom = arc4random_uniform(count);
    self.currentAndom = andom;
    for (int i=0; i<count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(left, top, width, width)];
        button.tag = i+10;
        button.backgroundColor = color;
        if(andom == i){
            button.backgroundColor = color2;
        }
        [superview addSubview:button];
        
        float br = button.frame.origin.x + button.frame.size.width;
        left = br + padding;
        if (left+width > kWidth) {
            left = 10;
            top = button.frame.origin.y + button.frame.size.height + padding;
        }
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//点击屏幕按钮
- (void)clickButton:(UIButton *)sender {
    if(self.currentAndom == (sender.tag-10)) {
        if(self.currentPass == 1){
            //如果是第一个则开启倒计时
            [self createTimer];
        }
        [self clearSubView];
        self.currentPass = self.currentPass + 1;
        self.passLabel.text = [NSString stringWithFormat:@"当前关卡：%d",self.currentPass];
        [self createViews:self.currentCount withSuperview:self.mainView];
    }
}
//清理主视图所有子视图
- (void)clearSubView {
    for (UIView *subview in self.mainView.subviews) {
        [subview removeFromSuperview];
    }
}

-(UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}
@end
