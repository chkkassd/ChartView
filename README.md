# ChartView
一个图表组件，折线图，柱状图，后续补充圆饼图

## 效果图

![效果图](https://github.com/chkkassd/ChartView/blob/master/ChartView/chartView.gif)

## 用法

SSFLineChartView.swift和SSFBarChartView.swift两个文件主要用来绘制折线图以及柱状图，使用swift3语法编写，每个view都有自己对应的datasource，通过datasource在要使用的类中自定义图标的外观以及内容等。
---
```
//设置你图表的数据源
//横坐标显示内容
let dataArrHorizontal = ["周一","周二","周三","周四","周五","周六","周日"]
//每个横坐标所对应的值
let dataArrValue = [180.0,190.0,100.0,90.0,200.0,168.0]
//纵坐标显示内容
let dataArrVertical = ["0","25","50","75","100","125","150","175","200","225"]
    
//设置你协议的代理
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    //设置代理
    lineChartView.datasource = self
    barChartView.datasource = self
}

//让你要使用这个组件的类遵循协议
extension ViewController: SSFLineChartViewDataSource {
    //Horizontal presention
    func numberOfHorizontalAxis(lineChartView: SSFLineChartView) -> Int {
        return dataArrHorizontal.count
    }
    
    func lineChartView(lineChartView: SSFLineChartView, titleForHorizontalIndex index: Int) -> String {
        return dataArrHorizontal[index]
    }
    
    func lineChartView(lineChartView: SSFLineChartView, valueForHorizontalIndex index: Int) -> Double? {
        if index > dataArrValue.count - 1 {
            return nil
        }
        return dataArrValue[index]
    }
    
    //Vertical presentaion
    func numberOfVerticalAxis(lineChartView: SSFLineChartView) -> Int {
        return dataArrVertical.count
    }
    
    func lineChartView(lineChartView: SSFLineChartView, titleForVerticalIndex index: Int) -> String {
        return dataArrVertical[index]
    }
    
    func widthOfLine(lineChartView: SSFLineChartView) -> Float {
        return 3.0
    }
    
    func openAnimation(lineChartView: SSFLineChartView) -> Bool {
        return true
    }
}
```
