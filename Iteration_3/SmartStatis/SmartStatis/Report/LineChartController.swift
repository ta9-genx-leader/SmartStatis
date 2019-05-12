//
//  LineChartController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/6.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import Charts
/*
    This controller is to manage the view for line charts.
 */
class LineChartController: UIViewController {
    var monthList: [String]?
    var totalFood: [Double]?
    var wasteMoney: [Double]?
    var personReport: [String: Any]?
    var average = [Double]()
    @IBOutlet var lineChart: LineChartView!
    
    /*
        This function is to initialize the view when it is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.addTapRecognizer()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "reportView")
        backgroundImage.alpha = 0.1
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        let averageNumber = personReport!["ASUT"] as? Double
        for _ in 0...3 {
            average.append(averageNumber!)
        }
        self.setChartData(monthList: monthList!, average: average)
    }
    
    /*
        This function is to initialize the data for the chart.
     */
    func setChartData(monthList : [String],average: [Double]) {
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< monthList.count {
            yVals1.append(ChartDataEntry(x:Double(i) , y:wasteMoney![i]))
        }
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Wasted Money($AUD)")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red.withAlphaComponent(0.5))
        set1.setCircleColor(UIColor.red)
        set1.circleRadius = 4.0
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = false
        set1.lineWidth = 3
        var yVals2 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< average.count {
            yVals2.append(ChartDataEntry(x:Double(i) , y: average[i]))
        }

        let set2: LineChartDataSet = LineChartDataSet(values: yVals2, label: "Avg Household Waste($AUD)")
        set2.axisDependency = .left // Line will correlate with left axis values
        set2.setColor(UIColor.darkGray.withAlphaComponent(0.5))
        set2.setCircleColor(UIColor.darkGray)
        set2.circleRadius = 4.0
        set2.fillAlpha = 65 / 255.0
        set2.fillColor = UIColor.darkGray
        set2.highlightColor = UIColor.white
        set2.drawCircleHoleEnabled = false
        set2.drawCirclesEnabled = false
        set2.circleHoleRadius = 0.5
        set2.lineWidth = 2
        set2.lineDashLengths = [4,5]
        var yVals3 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< average.count {
            yVals3.append(ChartDataEntry(x:Double(i) , y: totalFood![i]))
        }
        let set3: LineChartDataSet = LineChartDataSet(values: yVals3, label: "Total Expenditure($AUD)")
        set3.axisDependency = .left // Line will correlate with left axis values
        set3.setColor(UIColor.blue.withAlphaComponent(0.5))
        set3.setCircleColor(UIColor.blue)
        set3.circleRadius = 4.0
        set3.fillAlpha = 65 / 255.0
        set3.fillColor = UIColor.blue.withAlphaComponent(0.5)
        set3.highlightColor = UIColor.white
        set3.drawCircleHoleEnabled = false
        set3.circleHoleRadius = 0.5
        set3.lineWidth = 3
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        dataSets.append(set3)
        dataSets.append(set2)
        //4 - pass our monthList in for our x-axis label value along with our dataSets
        let data : LineChartData = LineChartData(dataSets: dataSets)
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthList)
        //5 - finally set our data
        self.lineChart.data = data
        lineChart.leftAxis.labelFont = UIFont.boldSystemFont(ofSize: 11.0)
        lineChart.xAxis.granularity = 1 //  to show intervals
        lineChart.xAxis.wordWrapEnabled = true
        lineChart.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 11.0)
        lineChart.xAxis.labelPosition = .bottom // lebel position on graph
        lineChart.legend.form = .line // indexing shape
        lineChart.legend.font = UIFont.boldSystemFont(ofSize: 12.0)
        lineChart.xAxis.drawGridLinesEnabled = false // show gird on graph
        lineChart.rightAxis.drawLabelsEnabled = false// to show right side value on graph
        lineChart.data?.setValueFont(UIFont.boldSystemFont(ofSize: 12.0))
        lineChart.doubleTapToZoomEnabled = false
        lineChart.pinchZoomEnabled = false
        lineChart.data?.setDrawValues(false)
        lineChart.scaleXEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }
}

extension LineChartView {
    /*
        This function is to detect 
     */
    func addTapRecognizer() {
        let tapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chartTapped))
        tapRecognizer.minimumPressDuration = 0.1
        self.addGestureRecognizer(tapRecognizer)
    }
    
    /*
        This function is to manage the action when the user tap the charts.
     */
    @objc func chartTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            // show
            let position = sender.location(in: self)
            let highlight = self.getHighlightByTouchPoint(position)
            let dataSet = self.getDataSetByTouchPoint(point: position)
            dataSet?.drawValuesEnabled = true
            highlightValue(highlight)
        } else {
            // hide
            data?.dataSets.forEach{ $0.drawValuesEnabled = false }
            highlightValue(nil)
        }
    }
}
