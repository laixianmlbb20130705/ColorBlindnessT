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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
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
    
    [self createViews:2 withSuperview:mainView];
}

- (void)createViews:(float)count withSuperview:(UIView *)superview{
    
    float left = 10;
    float padding = 3;
    float width = (superview.frame.size.width-2*left-(count-1)*padding)/count;
    for (int i=0; i<count*count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(left, left, width, width)];
        button.backgroundColor = [UIColor redColor];
    }
}
@end
