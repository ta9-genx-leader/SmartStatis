//
//  BarChartController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/5.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This controller is to manage the view for bar charts.
*/
class BarChartController: UIViewController {
    var segueName: String?
    var summary: UIViewController?
    var months: [String]!
    var categoryList : [String]?
    var selectedBin: [Food]?
    var frameWidth = 0
    var onePart = 0.0
    var totalCost:Double = 0
    var meatWaste:Double = 0
    var fruitWaste:Double = 0
    var seafoodWaste:Double = 0
    var dairyWaste:Double = 0
    var dairyProductWaste:Double = 0
    var vegetableWaste:Double = 0
    var beverageWaste:Double = 0
    var bakeryWaste:Double = 0
    var proteinWaste:Double = 0
    var otherWaste:Double = 0
    /*
        This function is to initialize the view when it is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(checkDetail))
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "reportView")
        backgroundImage.alpha = 0.1
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        frameWidth = (Int(self.view.frame.width) - 100)
        onePart = Double(frameWidth) / Double(100)
        
        NSLog("frame Width %i  One Part %d", frameWidth,onePart)
        if segueName == "TotalFoodSegue" {
            for food in selectedBin! {
                totalCost = totalCost + food.price!
                switch food.categoryId {
                case 1:
                    meatWaste = meatWaste + food.price!
                case 2:
                    fruitWaste = fruitWaste + food.price!
                case 3:
                    seafoodWaste = seafoodWaste + food.price!
                case 4:
                    dairyWaste = dairyWaste + food.price!
                case 5:
                    dairyProductWaste = dairyProductWaste + food.price!
                case 6:
                    vegetableWaste = vegetableWaste + food.price!
                case 7:
                    beverageWaste = beverageWaste + food.price!
                case 8:
                    bakeryWaste = bakeryWaste + food.price!
                case 9:
                    proteinWaste = proteinWaste + food.price!
                default:
                    otherWaste = otherWaste + food.price!
                }
            }
        }
        else {
            for food in selectedBin! {
                totalCost = totalCost + food.price! * (100-Double(food.completion!))/100
                switch food.categoryId {
                case 1:
                    meatWaste = meatWaste + food.price! * (100-Double(food.completion!))/100
                case 2:
                    fruitWaste = fruitWaste + food.price! * (100-Double(food.completion!))/100
                case 3:
                    seafoodWaste = seafoodWaste + food.price! * (100-Double(food.completion!))/100
                case 4:
                    dairyWaste = dairyWaste + food.price! * (100-Double(food.completion!))/100
                case 5:
                    dairyProductWaste = dairyProductWaste + food.price! * (100-Double(food.completion!))/100
                case 6:
                    vegetableWaste = vegetableWaste + food.price! * (100-Double(food.completion!))/100
                case 7:
                    beverageWaste = beverageWaste + food.price! * (100-Double(food.completion!))/100
                case 8:
                    bakeryWaste = bakeryWaste + food.price! * (100-Double(food.completion!))/100
                case 9:
                    proteinWaste = proteinWaste + food.price! * (100-Double(food.completion!))/100
                default:
                    otherWaste = otherWaste + food.price! * (100-Double(food.completion!))/100
                }
            }
        }
        drawlines(lineNumber:1, percent:meatWaste/totalCost * 100, linename:"Meat")
        drawlines(lineNumber:2, percent:fruitWaste/totalCost * 100, linename:"Fruit")
        drawlines(lineNumber:3, percent:seafoodWaste/totalCost * 100, linename:"Seafood")
        drawlines(lineNumber:4, percent:dairyWaste/totalCost * 100, linename:"Dairy")
        drawlines(lineNumber:5, percent:dairyProductWaste/totalCost * 100, linename:"Dairy Product")
        drawlines(lineNumber:6, percent:vegetableWaste/totalCost * 100, linename:"Vegetable")
        drawlines(lineNumber:7, percent:beverageWaste/totalCost * 100, linename:"Beverage")
        drawlines(lineNumber:8, percent:bakeryWaste/totalCost * 100, linename:"Bakery")
        drawlines(lineNumber:9, percent:proteinWaste/totalCost * 100, linename:"Protein")
        drawlines(lineNumber:10, percent:otherWaste/totalCost * 100, linename:"Other")
    }
    
    /*
        This function is to launch the segue to the history view for the charts.
     */
    @objc func checkDetail() {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: {
                    self.summary?.dismiss(animated: false, completion: nil)
                })
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "WasteDetailSegue", sender: self)
    }
    
    /*
        This function is to draw bars for the bar charts.
     */
    func drawlines (lineNumber num:Int , percent val:Double, linename name:String){
        let startpoint=60
        let distance=Int(self.view.frame.height)/13
        let start = CGPoint(x:20,y:Int(num*distance)+startpoint)
        let end = CGPoint(x:Int(val*onePart)+20,y:Int(num*distance)+startpoint)
        let lbl = UILabel()
        lbl.frame = CGRect(x: start.x, y: start.y - 25, width: 100, height: 15)
        lbl.font = lbl.font.withSize(15)
        lbl.text = name
        view.addSubview(lbl)
        //red part of line
        drawLine(startpoint: start, endpint: end,linecolor: UIColor.red.cgColor,linewidth:11.0, textValue: String(val))
        //gray part of line
        let nextpt = Int(Double(100 - val)*onePart) + Int(val*onePart)
        let nstart = CGPoint(x:Int(val*onePart)+20,y:Int(num*distance)+startpoint)
        let nend = CGPoint(x:Int(nextpt)+20,y:Int(num*distance)+startpoint)
        drawLine(startpoint: nstart, endpint: nend, linecolor: UIColor.lightGray.cgColor,linewidth:11.0, textValue: String(val))
        //value label
        let lbl2 = UILabel()
        lbl2.frame = CGRect(x: nend.x + 15, y: start.y - 10, width: 90, height: 20)
        lbl2.font = lbl2.font.withSize(15)
        lbl2.text = String(format: "%.1f %%", val)
        view.addSubview(lbl2)
    }
    
    /*
        This function is to draw all the bars for the bar charts.
     */
    func drawLine(startpoint start:CGPoint, endpint end:CGPoint, linecolor color: CGColor , linewidth widthline:CGFloat, textValue: String){
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = widthline
        view.layer.addSublayer(shapeLayer)
    }
    
    /*
        This function is to prepare for the launched segue.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WasteDetailSegue" {
            let controller: ReportDetailController = segue.destination as! ReportDetailController
            controller.binFood = selectedBin
        }
    }
}
