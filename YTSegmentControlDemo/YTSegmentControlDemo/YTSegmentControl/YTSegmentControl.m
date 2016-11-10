//
//  YTSegmentControl.m
//  YTSegmentControlDemo
//
//  Created by 余婷 on 16/11/10.
//  Copyright © 2016年 余婷. All rights reserved.
//
//

#import "YTSegmentControl.h"

#define Button_TAG 200
#define LineView_TAG 100
#define Slider_Height 3  //滑块高度

@interface YTSegmentControl(){

    //分段标题数组
    NSArray * _items;
    //滑块
    UIView * _silderView;
    
    id _target;
    SEL _action;
    
    UIFont * _selectedFont;
    UIFont * _normalFont;
}



@end

@implementation YTSegmentControl




//1.构造方法
//在这个方法中单纯的创建出所有的子控件对象。设置固定属性值
- (instancetype)initWithItems:(NSArray *)items{

    if (self = [super init]) {
        
        _items = items;
        //a.创建所有的按钮
        int i = 0;
        for (NSString * item in items) {
            
            UIButton * button = [UIButton new];
            [self addSubview:button];
            
            [button setTitle:item forState:UIControlStateNormal];
            button.tag = Button_TAG + i;
            [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
            
            i += 1;
        }
        //b.下面的滑块
        _silderView = [UIView new];
        _silderView.backgroundColor = [UIColor greenColor];
        [self addSubview:_silderView];
        
        //添加观察者
        [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld context:nil];
        
        _selectedFont = [UIFont systemFontOfSize:13];
        _normalFont = [UIFont systemFontOfSize:15];
    }
    
    return self;
}

//2.计算子视图的frame
- (void)layoutSubviews{
    [super layoutSubviews];
    
    int buttonIndex = 0;   //按钮个数
    CGFloat buttonW = self.frame.size.width/_items.count;
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;
    for (UIView * subView in self.subviews) {
        //a.按钮
        if (subView.tag >= Button_TAG) {
            UIButton * button = subView;
            
            //设置frame
            buttonX = buttonIndex * buttonW;
            subView.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
            //设置字体
            button.titleLabel.font = _normalFont;
            
            if (subView.tag - Button_TAG == self.selectedIndex) {
                
                button.selected = YES;
                button.userInteractionEnabled = NO;
                
                button.titleLabel.font = _selectedFont;
                
                _silderView.frame = CGRectMake(buttonX, buttonH - Slider_Height, buttonW, Slider_Height);
            }
            
            buttonIndex += 1;
        }
        
    }//for循环结束
    
}

#pragma mark - 按钮点击
- (void)buttonAction:(UIButton*)button{
    
    self.selectedIndex = button.tag - Button_TAG;
    
    if ([_target respondsToSelector:_action]) {
        
        [_target performSelector:_action withObject:self];
    }
    
}

#pragma mark - 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSNumber* preIndexNum = change[@"old"];
    int preIndex = preIndexNum.intValue;
   
    
    UIButton * preButton = [self viewWithTag:Button_TAG + preIndex];
    preButton.selected = NO;
    preButton.userInteractionEnabled = YES;
    preButton.titleLabel.font = _normalFont;
    
    UIButton * currentButton = [self viewWithTag:self.selectedIndex+Button_TAG];
    currentButton.selected = YES;
    currentButton.userInteractionEnabled = NO;
    currentButton.titleLabel.font = _selectedFont;
    [UIView animateWithDuration:0.3f animations:^{
        _silderView.frame = CGRectMake(currentButton.frame.origin.x, _silderView.frame.origin.y, _silderView.frame.size.width, Slider_Height);
    }];
    
    
}


- (void)addTarget:(id)target action:(SEL)action{

    _target = target;
    _action = action;
}


- (void)setTitleSelectedFont:(UIFont *)sFont normalFont:(UIFont *)nFont{

    
}

- (void)setTitleSelectedColor:(UIColor *)sColor normalColor:(UIColor *)nColor{
    
    _silderView.backgroundColor = sColor;

    for (UIView * subView in self.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton * button = subView;
            [button setTitleColor:sColor forState:UIControlStateSelected];
            [button setTitleColor:nColor forState:UIControlStateNormal];
        }
    }
}


@end
