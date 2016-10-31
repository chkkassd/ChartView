//
//  SSFLineChartView.swift
//  WeightAnalysis
//
//  Created by 赛峰 施 on 2016/10/26.
//  Copyright © 2016年 赛峰 施. All rights reserved.
//

import UIKit

@IBDesignable
class SSFLineChartView: UIView {

    weak var datasource: SSFLineChartViewDataSource? {
        didSet {
            let index = datasource?.numberOfVerticalAxis(lineChartView: self)
            proportion = (Double(self.frame.size.height) - verticalGapWidth * 2)/Double((datasource?.lineChartView(lineChartView: self, titleForVerticalIndex: (index!-1)))!)!
        }
    }
    
    //y方向比例尺
    var ratio: Double {
        return proportion
    }
    
    private var proportion = 0.0
    
    let horizontalGapWidth = 18.0, verticalGapWidth = 15.0, horizontalAxisGap = 10.0, titleToLineGap = 3.0
    
    ///原点
    var origionPoint: LineChartPoint!
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(self.datasource?.colorOfLine(lineChartView: self).cgColor ?? UIColor.white.cgColor)
        drawAxis()
        drawChartLine()
    }

    ///Draw the vertical and horizontal axis with the datasource.
    private func drawAxis() {
        drawAxisLine()
        drawAxisTitle()
    }
    
    private func drawAxisLine() {
        let startPoint = CGPoint(x: horizontalGapWidth, y: (Double(self.frame.size.height) - verticalGapWidth))
        origionPoint = LineChartPoint(x: Double(startPoint.x), y: Double(startPoint.y))
        let endPointHorizontal = CGPoint(x: Double(self.frame.size.width) - horizontalGapWidth, y: Double(self.frame.size.height) - verticalGapWidth)
        let endPointVertical = CGPoint(x: horizontalGapWidth, y: verticalGapWidth)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPointHorizontal)
        path.move(to: startPoint)
        path.addLine(to: endPointVertical)
        path.lineWidth = 1.0
        path.close()
        path.stroke()
    }
    
    var averageGapWidthHorizontal: Double = 0.0
    
    var averageGapWidthVertical: Double = 0.0
    
    private func drawAxisTitle() {
        if let dsource = self.datasource {
            let numberHorizontal = dsource.numberOfHorizontalAxis(lineChartView: self)
            let numberVertical = dsource.numberOfVerticalAxis(lineChartView: self)
            averageGapWidthHorizontal = (Double(self.frame.size.width) - horizontalGapWidth * 2 - horizontalAxisGap)/Double(numberHorizontal - 1)
            averageGapWidthVertical = (Double(self.frame.size.height) - verticalGapWidth * 2)/Double(numberVertical)
            
            var indexArrHorizontal:[Int] = [], indexArrVertical:[Int] = []
            for index in (0..<numberHorizontal) {
                indexArrHorizontal.append(index)
            }
            for index in (0..<numberVertical) {
                indexArrVertical.append(index)
            }
            let titleHorizontalArr = indexArrHorizontal.map{ dsource.lineChartView(lineChartView: self, titleForHorizontalIndex: $0)
            }
            let titleVerticalArr = indexArrVertical.map{ dsource.lineChartView(lineChartView: self, titleForVerticalIndex: $0)
            }
            
            draw(horizontalTexts: titleHorizontalArr, averageGapWidth: averageGapWidthHorizontal)
            draw(verticalTexts: titleVerticalArr, averageGapWidth: averageGapWidthVertical)
        }
    }
    
    private func draw(horizontalTexts textArr: [String], averageGapWidth: Double) {
        let attribute = [
            NSForegroundColorAttributeName:UIColor.white,
            NSFontAttributeName:UIFont.systemFont(ofSize: 8.0)
        ]
        
        for title in textArr {
            let textSize = title.boundingRect(with: self.frame.size, options: NSStringDrawingOptions.usesFontLeading, attributes: attribute, context: nil).size
            let index = textArr.index(of: title)
            let x = origionPoint.x + horizontalAxisGap + averageGapWidth * Double(index!) - Double(textSize.width/2)
            title.draw(at:CGPoint(x: x, y:origionPoint.y + titleToLineGap),withAttributes:attribute)
        }
    }
    
    private func draw(verticalTexts textArr: [String], averageGapWidth: Double) {
        let attribute = [
            NSForegroundColorAttributeName:UIColor.white,
            NSFontAttributeName:UIFont.systemFont(ofSize: 8.0)
        ]
        
        for title in textArr {
            let textSize = title.boundingRect(with: self.frame.size, options: NSStringDrawingOptions.usesFontLeading, attributes: attribute, context: nil).size
            let index = textArr.index(of: title)
            title.draw(at:CGPoint(x:origionPoint.x/2 - Double(textSize.width/2), y: origionPoint.y - averageGapWidth * Double(index!) - Double(textSize.height/2)),withAttributes:attribute)
        }
    }
    
    ///Draw chart line with datasource
    private func drawChartLine() {
        var linePoints: [CGPoint] = []
        if let dsource = self.datasource {
            let numberHorizontal = dsource.numberOfHorizontalAxis(lineChartView: self)
            for index in (0..<numberHorizontal) {
                if let value = dsource.lineChartView(lineChartView: self, valueForHorizontalIndex: index) {
                    let y = origionPoint.y - value * ratio
                    let x = origionPoint.x + horizontalAxisGap + averageGapWidthHorizontal * Double(index)
                    linePoints.append(CGPoint(x: x, y: y))
                }
            }
        }
        drawPoints(points:linePoints)
    }
    
    private var shapeLayer: CAShapeLayer?
    
    private func drawPoints(points: [CGPoint]) {
        let linePath = UIBezierPath()
        linePath.lineJoinStyle = CGLineJoin.round
        linePath.lineCapStyle = CGLineCap.round
        
        for point in points {
            let index = points.index(of: point)
            if index == 0{
                linePath.move(to: point)
            } else {
                linePath.addLine(to: point)
            }
        }
        
        clear()
        shapeLayer = CAShapeLayer()
        shapeLayer?.path = linePath.cgPath
        if let dsource = self.datasource {
            shapeLayer?.strokeColor = dsource.colorOfLine(lineChartView: self).cgColor
            shapeLayer?.fillColor = UIColor.clear.cgColor
            shapeLayer?.lineWidth = CGFloat(dsource.widthOfLine(lineChartView: self))
            shapeLayer?.strokeStart = 0.0
            shapeLayer?.strokeEnd = 1.0
            self.layer.addSublayer(shapeLayer!)
            
            if dsource.openAnimation(lineChartView: self) {
                performAnimation(layer: shapeLayer!)
            }
        }
    }
    
    private func clear() {
        if let layer = shapeLayer {
            layer.removeFromSuperlayer()
            shapeLayer = nil
        }
    }
    
    private func performAnimation(layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = layer.strokeStart
        animation.toValue = layer.strokeEnd
        animation.autoreverses = false
        layer.add(animation, forKey: "strokeEnd")
    }
}

// MARK:protocol
///This protocol describe the presention of lineChartView,only class can adopt it.
protocol SSFLineChartViewDataSource: class {
    
    //Horizontal presentaion
    func numberOfHorizontalAxis(lineChartView: SSFLineChartView) -> Int
    func lineChartView(lineChartView: SSFLineChartView, titleForHorizontalIndex index: Int) -> String
    func lineChartView(lineChartView: SSFLineChartView, valueForHorizontalIndex index: Int) -> Double?
    
    //Vertical presentaion
    func numberOfVerticalAxis(lineChartView: SSFLineChartView) -> Int
    func lineChartView(lineChartView: SSFLineChartView, titleForVerticalIndex index: Int) -> String
    
    //stroke line UI
    func colorOfLine(lineChartView: SSFLineChartView) -> UIColor
    func widthOfLine(lineChartView: SSFLineChartView) -> Float
    
    //Weather start the animation
    func openAnimation(lineChartView: SSFLineChartView) -> Bool
}

extension SSFLineChartViewDataSource {
    func colorOfLine(lineChartView: SSFLineChartView) -> UIColor {
        return UIColor.white
    }
    
    func widthOfLine(lineChartView: SSFLineChartView) -> Float {
        return 1.0
    }
    
    func openAnimation(lineChartView: SSFLineChartView) -> Bool {
        return false
    }
}
