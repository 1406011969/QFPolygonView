//
//  QFPolygonView.m
//  QFPolygonViewDemo
//
//  Created by cheng on 2020/8/25.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "QFPolygonView.h"
#import "UIView+Common.h"
#import "UIColor+Common.h"
#import <objc/runtime.h>

@interface QFPolygonView ()

/// 数值 layer
@property (nonatomic, strong) CAShapeLayer *valueLayer;
/// 多边形 layer
@property (nonatomic, strong) CAShapeLayer *baseLayer;

@end

/// cos
#define ANGLE_COS(Angle) cos(M_PI / 180.0 * (Angle))
/// sin
#define ANGLE_SIN(Angle) sin(M_PI / 180.0 * (Angle))

@implementation QFPolygonView

- (instancetype)initWithFrame:(CGRect)frame propetryArray:(NSArray *)array turnsNumber:(NSInteger)turnsNumber {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configBeginValue];
        self.turnsNumber = turnsNumber;
        self.propertyArray = array;
    }
    return self;
}

/// 设置默认值
- (void)configBeginValue {
    self.baseRadius = 5.0f;
    self.propertyWide = 30;
    self.maxScore = 100;
    self.labelSpace = 10.0f;
}

#pragma mark - 绘制多边形
- (void)drawPloygonViewWithArray:(NSArray *)array turnsNumber:(NSInteger)number {
    
    /// 防止 绘制多层
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    /// 每一圈的半径 增加量
    CGFloat addRadius = (self.width - self.propertyWide * 2 - self.baseRadius * 2) / number / 2.0;
    
    for (NSInteger j = number; j > 0; j --) {
        
        CAShapeLayer *shapePlayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:shapePlayer];
        shapePlayer.zPosition = 0.0;
        
        /// 创建贝塞尔曲线
        UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
        bezierPath.lineWidth = 1.0;
        
        CGFloat radius = addRadius * j + self.baseRadius;
        
        for (NSInteger i = 0; i < array.count; i ++) {
            
            CGPoint cornerPoint = CGPointMake(self.centerX - ANGLE_COS(90 + 360.0 / array.count * i) * radius - self.x, self.centerY - ANGLE_SIN(90 + 360.0 / array.count * i) * radius - self.y);
            
            if (i == 0) {
                [bezierPath moveToPoint:cornerPoint];
            } else {
                [bezierPath addLineToPoint:cornerPoint];
            }
            
            if (j == number) {
                
                /// 创建属性 label
                UILabel *label = [[UILabel alloc] init];
                label.backgroundColor = [UIColor randomColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor blackColor];
                label.font = [UIFont systemFontOfSize:12];
                label.text = array[i];
                [self addSubview:label];
                
                label.bounds = CGRectMake(0, 0, self.propertyWide, 20);
                
                CGFloat cosCount = [NSString stringWithFormat:@"%.2f", ANGLE_COS(90 + 360.0 / array.count * i) * radius].floatValue;
                CGFloat sinCount = [NSString stringWithFormat:@"%.2f", ANGLE_SIN(90 + 360.0 / array.count * i) * radius].floatValue;
                
                if (cosCount == 0) {
                    label.centerX = cornerPoint.x;
                    if (sinCount > 0) {
                        label.y = cornerPoint.y - 5 - 20;
                    } else {
                        label.y = cornerPoint.y + 5;
                    }
                    
                } else if (cosCount < 0) {
                    label.x = cornerPoint.x + 5;
                    label.centerY = cornerPoint.y;
                } else {
                    label.x = cornerPoint.x - 5 - self.propertyWide;
                    label.centerY = cornerPoint.y;
                }
                
            }
            
        }
        /// 封闭路径 (连接第一个和最后一个点)
        [bezierPath closePath];
        /// 结束绘制
        [bezierPath stroke];
        
        shapePlayer.fillColor = [[UIColor themeColor] colorWithAlphaComponent: (0.5 - j * 0.05)].CGColor;
        shapePlayer.strokeColor = [UIColor clearColor].CGColor;
        shapePlayer.path = bezierPath.CGPath;
        
    }
}

#pragma mark - 设置 各项值
- (void)configPloygonViewWithArray:(NSArray *)dataArray {
    
    if (self.valueLayer.superlayer) {
        /// 防止多次 赋值
        [self.valueLayer removeFromSuperlayer];
    }
    
    self.valueLayer = [[CAShapeLayer alloc] init];
    [self.layer addSublayer:self.valueLayer];
    self.valueLayer.zPosition = 1;
    /// 创建贝塞尔曲线
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    /// 用来计算 分值
    CGFloat addRadius = (self.width - self.propertyWide * 2 - self.baseRadius * 2) / 2.0;
    
    for (NSInteger i = 0; i < dataArray.count; i ++) {
        CGFloat count = [dataArray[i] floatValue] / self.maxScore;
        CGFloat radius = addRadius * count + self.baseRadius;
        
        CGPoint cornerPoint = CGPointMake(self.centerX - ANGLE_COS(90 + 360.0 / dataArray.count * i) * radius - self.x, self.centerY - ANGLE_SIN(90 + 360.0 / dataArray.count * i) * radius - self.y);
        
        if (i == 0) {
            [bezierPath moveToPoint:cornerPoint];
        } else {
            [bezierPath addLineToPoint:cornerPoint];
        }
        
    }
    
    /// 封闭路径 (连接第一个和最后一个点)
    [bezierPath closePath];
    /// 结束绘制
    [bezierPath stroke];
    
    self.valueLayer.fillColor = [[UIColor blackColor] colorWithAlphaComponent: 0.2].CGColor;
    self.valueLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.valueLayer.path = bezierPath.CGPath;
}

#pragma mark - Setting && Getting
- (void)setPropertyArray:(NSArray *)propertyArray {
    objc_setAssociatedObject(self, @selector(propertyArray), propertyArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self drawPloygonViewWithArray:self.propertyArray turnsNumber:self.turnsNumber];
}

- (NSArray *)propertyArray {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTurnsNumber:(NSInteger)turnsNumber {
    objc_setAssociatedObject(self, @selector(turnsNumber), @(turnsNumber), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.propertyArray.count > 0) {
        [self drawPloygonViewWithArray:self.propertyArray turnsNumber:self.turnsNumber];
    }
}

- (NSInteger)turnsNumber {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setPropertyWide:(CGFloat)propertyWide {
    objc_setAssociatedObject(self, @selector(propertyWide), @(propertyWide), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.propertyArray.count > 0) {
        [self drawPloygonViewWithArray:self.propertyArray turnsNumber:self.turnsNumber];
    }
    
    if (self.scoreArray.count > 0) {
        [self configPloygonViewWithArray:self.scoreArray];
    }
}

- (CGFloat)propertyWide {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setScoreArray:(NSArray *)scoreArray {
    objc_setAssociatedObject(self, @selector(scoreArray), scoreArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self configPloygonViewWithArray:scoreArray];
}

- (NSArray *)scoreArray {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBaseRadius:(CGFloat)baseRadius {
    objc_setAssociatedObject(self, @selector(baseRadius), @(baseRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.propertyArray.count > 0) {
        [self drawPloygonViewWithArray:self.propertyArray turnsNumber:self.turnsNumber];
    }
    if (self.scoreArray.count > 0) {
        [self configPloygonViewWithArray:self.scoreArray];
    }
}

- (CGFloat)baseRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setMaxScore:(CGFloat)maxScore {
    objc_setAssociatedObject(self, @selector(maxScore), @(maxScore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.scoreArray.count > 0) {
        [self configPloygonViewWithArray:self.scoreArray];
    }
}

- (CGFloat)maxScore {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setLabelSpace:(CGFloat)labelSpace {
    objc_setAssociatedObject(self, @selector(labelSpace), @(labelSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.propertyArray.count > 0) {
        [self drawPloygonViewWithArray:self.propertyArray turnsNumber:self.turnsNumber];
    }
    
    if (self.scoreArray.count > 0) {
        [self configPloygonViewWithArray:self.scoreArray];
    }
}

- (CGFloat)labelSpace {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}



@end
