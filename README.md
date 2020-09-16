# QFPolygonView
一个绘制多边形能力图的控件

# 使用步骤: 
1. cocoapods 获取
pod 'QFPolygonView'

2. 创建view
其中 属性数组 决定了 底层多边形的 边数, 以及展示的各个属性
圈数 指的是 有多少圈多边形
```
- (QFPolygonView *)polygonView {
    if (!_polygonView) {
        _polygonView = [[QFPolygonView alloc] initWithFrame:CGRectMake(50, 50, 300, 300) propetryArray:@[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"] turnsNumber:5];
    }
    return _polygonView;
}
```

3. 赋值
`self.polygonView.scoreArray = @[@"60", @"70", @"60", @"70", @"60", @"70", @"60", @"70"];`
分值是必须赋值的属性
其他属性依据需求更改
