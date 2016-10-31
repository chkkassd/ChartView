//
//  ViewController.swift
//  ChartView
//
//  Created by 赛峰 施 on 2016/10/31.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //横坐标显示内容
    let dataArrHorizontal = ["周一","周二","周三","周四","周五","周六","周日"]
    //每个横坐标所对应的值
    let dataArrValue = [180.0,190.0,100.0,90.0,200.0,168.0]
    //纵坐标显示内容
    let dataArrVertical = ["0","25","50","75","100","125","150","175","200","225"]
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //设置代理
        lineChartView.datasource = self
        barChartView.datasource = self
    }

    @IBOutlet weak var lineChartView: SSFLineChartView!
    @IBOutlet weak var barChartView: SSFBarChartView!

}

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

extension ViewController: SSFBarChartViewDataSource {
    //Horizontal presentaion
    func numberOfHorizontalAxis(barChartView: SSFBarChartView) -> Int {
        return self.dataArrHorizontal.count
    }
    
    func barChartView(barChartView: SSFBarChartView, titleForHorizontalIndex index: Int) -> String {
        return self.dataArrHorizontal[index]
    }
    
    func barChartView(barChartView: SSFBarChartView, valueForHorizontalIndex index: Int) -> Double? {
        if index > dataArrValue.count - 1 {
            return nil
        }
        return dataArrValue[index]
    }
    
    //Vertical presentaion
    func numberOfVerticalAxis(barChartView: SSFBarChartView) -> Int {
        return self.dataArrVertical.count
    }
    
    func barChartView(barChartView: SSFBarChartView, titleForVerticalIndex index: Int) -> String {
        return self.dataArrVertical[index]
    }
    
    //bar UI
    func colorOfBar(barChartView: SSFBarChartView) -> UIColor {
        return UIColor.blue
    }
    
    func widthOfBar(barChartView: SSFBarChartView) -> Float {
        return 20.0
    }
    
    //Wheather start the animation.
    func openAnimation(barChartView: SSFBarChartView) -> Bool {
        return true
    }
}
