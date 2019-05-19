//
//  ReportDetailController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/2.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the history view for the selected chart.
 */
class ReportDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var binFood: [Food]?
    var showList: [Food]?
    @IBOutlet var tableView: UITableView!
    
    /*
        This function is to determine the number of rows in each section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showList!.count
    }
    
    /*
        This function is to determine the height of the row in the table.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    /*
        This function is to determine the number of sections in the table.
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
        This function is to determine the view of the cells in the table.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WasteCell", for: indexPath) as! WasteCell
        switch showList![indexPath.row].categoryId  {
        case 1:
            cell.categoryImage.image = UIImage(named: "Meat-50px")
        case 2:
            cell.categoryImage.image = UIImage(named: "Fruit-50px")
        case 3:
            cell.categoryImage.image = UIImage(named: "seafood-50px")
        case 4:
            cell.categoryImage.image = UIImage(named: "milk-50px")
        case 5:
            cell.categoryImage.image = UIImage(named: "cheese-50px")
        case 6:
            cell.categoryImage.image = UIImage(named: "vegetable-50px")
        case 7:
            cell.categoryImage.image = UIImage(named: "beverage-50px")
        case 8:
            cell.categoryImage.image = UIImage(named: "bread-50px")
        case 9:
            cell.categoryImage.image = UIImage(named: "protein-50px")
        default:
            cell.categoryImage.image = UIImage(named: "others-50px")
        }
        cell.nameLabel.text = showList![indexPath.row].foodName!.replacingOccurrences(of: "_", with: " ")
        cell.expireDate.text = showList![indexPath.row].expire?.toString(dateFormat: "yyyy-MM-dd")
        let waste = 100 - showList![indexPath.row].completion!
        cell.completionLabel.text = String(waste) + "%"
        let wasteMoney = Double(waste)/100 * showList![indexPath.row].price!
        cell.messageLabel.text = "$" + String(format: "%.2f", wasteMoney) + " dollar wasted"
        print(cell.contentView.subviews.count)
        if cell.contentView.subviews.count < 8 {
            cell.contentView.backgroundColor = UIColor.clear
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 118))
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
            whiteRoundedView.layer.masksToBounds = false
            whiteRoundedView.layer.cornerRadius = 5.0
            whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            whiteRoundedView.layer.shadowOpacity = 0.4
            whiteRoundedView.layer.shadowRadius = 2
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubviewToBack(whiteRoundedView)
        }
        return cell
    }
    
    /*
        This function is to initialize the view when it is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "reportView"))
        tableView.backgroundView?.alpha = 0.1
        tableView.allowsSelection = false
        showList = binFood
        showList = showList!.sorted(by:{ $0.completion! < $1.completion! })
    }
}
