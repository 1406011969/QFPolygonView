//
//  QFPolygonView.h
//  QFPolygonViewDemo
//
//  Created by cheng on 2020/8/25.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QFPolygonView : UIView

/**
 注:
 半径基础量 baseRadius 属性
 如果 分数全部为0时
 baseRadius = 0 那么就是一个点
 由于可能 影响美观 所以万一有需求 让分数为0时 半径也有一个最小值
 那么就使用这个属性
 */

/// 分数 score (对应属性的分数)
@property (nonatomic, strong) NSArray *scoreArray;
/// 属性数组 (几边型 最小为3)
@property (nonatomic, strong) NSArray *propertyArray;
/// 圈数 (最小为1)
@property (nonatomic, assign) NSInteger turnsNumber;
/// 半径基础量 (决定内圈多边形大小 等于0时 所有多边形半径等比增加 默认为5)
@property (nonatomic, assign) CGFloat baseRadius;
/// label 到图形的距离 (默认为10)
@property (nonatomic, assign) CGFloat labelSpace;
/// 属性 label 宽度 (默认50)
@property (nonatomic, assign) CGFloat propertyWide;
/// 最大分数 (比如百分制 最大分数就是 100 默认100)
@property (nonatomic, assign) CGFloat maxScore;
/// 是否显示分数
//@property (nonatomic, assign) BOOL isShowScore;

/**
 init 创建视图 创建多边形能力图的必须值
 (直接作为参数 应该比作为属性好 因为 创建的时候使用一次 一般没有改变视图的需求 不过还是暴露出来 防止请求后赋值)
 @param frame 视图 位置
 @param array 决定有几个角 是几边形
 @param turnsNumber 有几圈
 @return 当前对象
 */
- (instancetype)initWithFrame:(CGRect)frame propetryArray:(NSArray *)array turnsNumber:(NSInteger)turnsNumber;

@end

NS_ASSUME_NONNULL_END
