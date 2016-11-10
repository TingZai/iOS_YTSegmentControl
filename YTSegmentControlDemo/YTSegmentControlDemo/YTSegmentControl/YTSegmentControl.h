//
//  YTSegmentControl.h
//  YTSegmentControlDemo
//
//  Created by 余婷 on 16/11/10.
//  Copyright © 2016年 余婷. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTSegmentControl : UIView

#pragma mark - 属性
//选中下标
@property(nonatomic,assign) int selectedIndex;


#pragma mark - 方法
/**
 * @brief 创建分段选择器对象.
 *
 * @param  items 分段内容.
 *
 * @return 创建好的分段选择器对象.
 */
- (instancetype)initWithItems:(NSArray*)items;


/**
 * @brief 给分段选择器添加切换的事件.
 */
- (void)addTarget:(id)target action:(nonnull SEL)action;

/**
 * @brief 不同状态设置不同的文字颜色.
 *
 * @param  color 文字颜色.
 * @param  state 状态.
 *
 */
- (void)setTitleSelectedColor:(UIColor *)sColor normalColor:(UIColor *)nColor;

/**
 * @brief 不同状态设置不同的字体.
 *
 * @param  font 字体.
 * @param  state 状态.
 *
 */
- (void)setTitleSelectedFont:(UIFont *)sFont normalFont:(UIFont *)nFont;

@end
