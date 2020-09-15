
//
//  UIColor+Common.m
//  SPSpecialPlatform
//
//  Created by CQF cqf on 2018/11/7.
//  Copyright © 2018年 CQF. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

/// 主题颜色
+ (UIColor *)themeColor {
    return [UIColor colorWithRed:225/255.0 green:175/255.0 blue:99/255.0 alpha:1];
}

/// 随机色 用来调试
+ (UIColor *)randomColor {
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

   

@end
