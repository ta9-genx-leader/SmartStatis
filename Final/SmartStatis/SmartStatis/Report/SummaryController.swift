//
//  SummaryController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/5.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This controller class is to manage the view in the report summary section.
 */
class SummaryController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate {
    var wasteCell: ReportCell?
    var reportCell: ReportCell?
    var numberList = ["1 person","2 people","3 people","4 people","More than 4"]
    var selectedNumberForMemebr: Int?
    var popUpPickerView = UIPickerView()
    // This function is to manage the action for the number of members in the user's household.
    @IBAction func popUpAction(_ sender: Any) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        selectedNumberForMemebr = memberPickerIndex
        //tabBar?.selectedNumberForMemebr = self.selectedNumberForMemebr!
        popUp.removeFromSuperview()
        self.tableView.isUserInteractionEnabled = true
        let defaults = UserDefaults.standard
        defaults.set(String(selectedNumberForMemebr!), forKey: "household")
        viewWillAppear(true)
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet var popUpTextField: UITextField!
    @IBOutlet var popUpButton: UIButton!
    @IBOutlet var popUp: UIView!
    var avgButton: UIButton?
    var numberOfMember: [String: Any]?
    var memberPickerIndex = 0
    var pickerViewSelectedRow = 0
    var selectedBin = [Food]()
    var selectedDate = Date()
    var categoryList : [String]?
    var wastePrice = 0.00
    var totalPrice = 0.00
    var tabBar: TabBarViewController?
    var bin: [Food]?
    var report: [[String: Any]]?
    var personReport: [String: Any]?
    var categoryReport: [String: Any]?
    var monthTextField: UITextField?
    var pickerView = UIPickerView()
    var monthList = [String]()
    // This function is to manage the action when the user stops editting.
    @IBAction func endEdit(_ sender: Any) {
        if monthList[pickerView.selectedRow(inComponent: 0)] != monthTextField?.text {
            var index = 0
            for month in monthList {
                if month == monthTextField?.text {
                    break
                }
                index = index + 1
            }
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    // This function is to manage the action when user taps "Progress" button.
    @IBAction func progressAction(_ sender: Any) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "ProgressSegue", sender: self)
    }
    
    /*
        This function is to detect if the text fields are about to be editted.
     */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    /*
        This function is to determine the number of components in the picker view.
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
        This function is to determine the number of rows in each section for the picker views.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return monthList.count
        }
        return numberList.count
    }
    
    /*
        This function is to determine the title of rows in the picker views.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            let titleString = monthList[row]
            return titleString
        }
        let titleString = numberList[row]
        return titleString
    }
    
    /*
        This function is to determine the height of the cells in the table view.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return 80
        default:
            return 180
        }
    }
    
    /*
        This function is to handle the action when the user taps "Total Expenditure" button.
     */
    @objc func tapHandlerOne(gesture: UITapGestureRecognizer) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if totalPrice == 0 {
            let alert = UIAlertController(title: "No Food Record", message: "No record in the selected month.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confrim", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            performSegue(withIdentifier: "TotalFoodSegue", sender: self)
        }
    }
    
    /*
        This function is to manage the action when the user taps "Total Waste" button.
     */
    @objc func tapHandlerTwo(gesture: UITapGestureRecognizer) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if wastePrice == 0 {
            let alert = UIAlertController(title: "No Food Record", message: "No record in the selected month.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confrim", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            performSegue(withIdentifier: "WasteSegue", sender: self)
        }
    }
    
    /*
        This function is to manage the action when the user taps "Average Waste" button.
     */
    @objc func tapHandlerThree(gesture: UITapGestureRecognizer) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "ProgressSegue", sender: self)
//        self.tableView.isUserInteractionEnabled = false
//        switch reportCell?.tagTitle.text {//cell.tagTitle.text = "Average Waste\r\n(4up People)"
//        case "Average Waste\r\n(1 Person)":
//            popUpTextField.text = "1 Person"
//            memberPickerIndex = 0
//        case "Average Waste\r\n(2 People)":
//            popUpTextField.text = "2 People"
//            memberPickerIndex = 1
//        case "Average Waste\r\n(3 People)":
//            popUpTextField.text = "3 People"
//            memberPickerIndex = 2
//        case "Average Waste\r\n(4 People)":
//            popUpTextField.text = "4 People"
//            memberPickerIndex = 3
//        default:
//            popUpTextField.text = "More than 4 people"
//            memberPickerIndex = 4
//        }
//        popUpPickerView.selectRow(memberPickerIndex, inComponent: 0, animated: false)
//        self.view.addSubview(popUp)
//        dismissPopOverWhenTappedAround()
//        popUp.center = self.view.center
//        popUp.clipsToBounds = true
//        popUp.layer.backgroundColor = UIColor.white.cgColor
//        popUp.layer.masksToBounds = false
//        popUp.layer.cornerRadius = 10.0
//        popUp.layer.shadowOffset = CGSize(width: -1, height: 1)
//        popUp.layer.shadowOpacity = 0.4
//        popUp.layer.shadowRadius = 2
    }
    
    /*
     This method is to introduce guesture recognizer into the pop over view.
     */
    func dismissPopOverWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissPopOver))
        view.addGestureRecognizer(tapGesture)
    }
    
    /*
     This method is to close the pop over view.
     */
    @objc func dismissPopOver() {
        self.popUpTextField.text = numberList[memberPickerIndex]
        popUpPickerView.selectRow(memberPickerIndex, inComponent: 0, animated: false)
        self.popUp.removeFromSuperview()
        self.tableView.isUserInteractionEnabled = true
    }
    
    /*
        This function is to determine the number of rows for each section in the table view.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 1
        }
    }
    
    /*
        This function is to determine the number of sections in the table view.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /*
        This function is to manage the action when the user select a row from the picker views.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView {
            pickerViewSelectedRow = row
        }
        else {
            memberPickerIndex = row
        }
    }
    
    /*
        This function is to manage the action when the user select a row from the table view.
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
        This function is to determine the view of each cell in the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCell", for: indexPath) as! MonthCell
            self.monthTextField = cell.monthTextField
            self.monthTextField?.tintColor = UIColor.clear
            let currentMonth = Calendar.current.date(byAdding: .month, value: 0, to: selectedDate)?.toString(dateFormat: "MMM yyyy")
            monthTextField!.text = currentMonth
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if cell.contentView.subviews.count < 2 {
                cell.contentView.backgroundColor = UIColor.clear
                let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 40))
                whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
                whiteRoundedView.layer.masksToBounds = false
                whiteRoundedView.layer.cornerRadius = 5.0
                whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                whiteRoundedView.layer.shadowOpacity = 0.4
                whiteRoundedView.layer.shadowRadius = 2
                cell.contentView.addSubview(whiteRoundedView)
                cell.contentView.sendSubviewToBack(whiteRoundedView)
            }
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
            toolBar.setItems([doneButton], animated: true)
            monthTextField!.inputAccessoryView = toolBar
            monthTextField!.inputView = pickerView
            let toolBarTwo = UIToolbar()
            toolBarTwo.sizeToFit()
            let doneButtonTwo = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditViewTwo))
            toolBarTwo.setItems([doneButtonTwo], animated: true)
            popUpTextField!.inputAccessoryView = toolBarTwo
            popUpTextField!.inputView = popUpPickerView
            pickerView.delegate = self
            popUpPickerView.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            switch indexPath.row {
            case 0:
                cell.tagValue.isHidden = false
                cell.tagValue.text = "$" + String(format:"%.2f", totalPrice)
                cell.tagValue.textColor = UIColor.blue
                cell.tagTitle.text = "Total Expenditure"
                cell.leftArrow.isHidden = false
            case 1:
                wasteCell = cell
                cell.tagValue.isHidden = false
                cell.tagValue.text = "$" + String(format:"%.2f", wastePrice)
                cell.tagTitle.text = "Total Waste"
                cell.leftArrow.isHidden = false
            default:
                var aust = 0.0
                switch selectedNumberForMemebr {
                case 0:
                    aust = (numberOfMember!["single person"] as? Double)!
                case 1:
                    aust = (numberOfMember!["two person"] as? Double)!
                case 2:
                    aust = (numberOfMember!["three person"] as? Double)!
                case 3:
                    aust = (numberOfMember!["four person"] as? Double)!
                default:
                    aust = (numberOfMember!["four or more"] as? Double)!
                }
                if wastePrice >= aust {
                    wasteCell!.tagValue.textColor = UIColor.red
                }
                else {
                    wasteCell!.tagValue.textColor = UIColor.blue
                }
                cell.leftArrow.isHidden = true
                cell.tagValue.isHidden = true
                cell.tagTitle.text = "Compare Cost"
                self.reportCell = cell
            }
            if cell.tagView.subviews.count < 3 {
                cell.tagView.backgroundColor = UIColor.clear
                let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 60))
                whiteRoundedView.layer.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0).cgColor
                whiteRoundedView.layer.masksToBounds = false
                whiteRoundedView.layer.cornerRadius = 5.0
                whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                whiteRoundedView.layer.shadowOpacity = 0.4
                whiteRoundedView.layer.shadowRadius = 2
                cell.tagView.addSubview(whiteRoundedView)
                cell.tagView.sendSubviewToBack(whiteRoundedView)
            }
            switch indexPath.row {
            case 0:
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandlerOne))
                tap.numberOfTapsRequired = 1
                cell.tagView.addGestureRecognizer(tap)
            case 1:
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandlerTwo))
                tap.numberOfTapsRequired = 1
                cell.tagView.addGestureRecognizer(tap)
            case 2:
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandlerThree))
                tap.numberOfTapsRequired = 1
                cell.tagView.addGestureRecognizer(tap)
            default:
                print("default")
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTextCell", for: indexPath) as! ReportTextCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            var avgPrice = 0.0
            switch selectedNumberForMemebr {
            case 0:
                avgPrice = (numberOfMember!["single person"] as? Double)!
            case 1:
                avgPrice = (numberOfMember!["two person"] as? Double)!
            case 2:
                avgPrice = (numberOfMember!["three person"] as? Double)!
            case 3:
                avgPrice = (numberOfMember!["four person"] as? Double)!
            default:
                avgPrice = (numberOfMember!["four or more"] as? Double)!
            }
            if wastePrice >= avgPrice {
                cell.improveTitle.text = "Oh! You waste too much food!\r\n\r\nAverage Waste/Household: " + String(avgPrice)
                cell.improveTitle.textColor = UIColor.red
            }
            else {
                cell.improveTitle.text = "Great! You are doing well!\r\n\r\nAverage Waste/Household: " + String(avgPrice)
                cell.improveTitle.textColor = UIColor.blue
            }
            cell.progressButtonOutlet.addShadowToButton(cornerRadius: 5)
            cell.progressButtonOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
            cell.progressButtonOutlet.isHidden = true
            return cell
        }
    }
    
    /*
        This function is to determine the view when it will appear.
     */
    override func viewWillAppear(_ animated: Bool) {
        monthList = [String]()
        selectedBin = [Food]()
        tabBar = tabBarController as? TabBarViewController
        categoryList = tabBar?.categoryList
        let convert = DateConverter()
        if tabBar?.personReport != nil {
            bin = tabBar?.bin
            report = tabBar?.report
            selectedNumberForMemebr = tabBar?.selectedNumberForMemebr
            numberOfMember = tabBar?.numberOfMember
            personReport = tabBar?.personReport
            categoryReport = tabBar?.categoryReport
            wastePrice = 0
            totalPrice = 0
            let previousMonth = convert.dateFormatterWithRule(dateString: (Calendar.current.date(byAdding: .month, value: 0, to: selectedDate)?.toString(dateFormat: "MMM yyyy"))!, rule: "MMM yyyy")
            let currentMonth = convert.dateFormatterWithRule(dateString: (Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)?.toString(dateFormat: "MMM yyyy"))!, rule: "MMM yyyy")
            for food in bin! {
                if food.expire! >= previousMonth && food.expire! < currentMonth {
                    totalPrice = totalPrice + food.price!
                    wastePrice = wastePrice + food.price! * Double(100 - food.completion!) / 100
                    selectedBin.append(food)
                }
            }
            tableView.reloadData()
        }
        else {
            let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
            }))
            self.present(alert, animated: true)
        }
        for i in 0...11 {
            let monthCount = 0 - i
            let previousMonth = Calendar.current.date(byAdding: .month, value: monthCount, to: Date())?.toString(dateFormat: "MMM yyyy")
            monthList.append(previousMonth!)
        }
    }

    /*
     This method is to close editing mode.
     */
    @objc func dismissEditView() {
        let convert = DateConverter()
        monthTextField!.text = monthList[pickerViewSelectedRow]
        selectedDate = convert.dateFormatterWithRule(dateString: monthTextField!.text!, rule: "MMM yyy")
        self.view.endEditing(true)
        viewWillAppear(true)
    }
    
    /*
     This method is to close editing mode.
     */
    @objc func dismissEditViewTwo() {
        popUpTextField!.text = numberList[memberPickerIndex]
        self.view.endEditing(true)
    }
    
    /*
        This function is to initialize the view when it is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        monthTextField?.delegate = self
        popUpTextField.delegate = self
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.masksToBounds = false
        popUpButton.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
        popUpTextField!.text = numberList[memberPickerIndex]
        popUpButton.addShadowToButton(cornerRadius: 5)
        hideKeyboardWhenTappedAround()
        tableView.backgroundView = UIImageView(image: UIImage(named: "reportView"))
        tableView.backgroundView?.alpha = 0.1
    }
    
    /*
        This function is to initialize the segue when it will be launched.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WasteSegue" {
            let controller: BarChartController = segue.destination as! BarChartController
            controller.summary = self
            var wasteFood = [Food]()
            for food in selectedBin {
                if food.completion != 100 {
                    wasteFood.append(food)
                }
            }
            controller.selectedBin = wasteFood
            controller.categoryList = categoryList
            controller.segueName = "WasteSegue"
            controller.navigationItem.title = "Category"
        }
        else if segue.identifier == "TotalFoodSegue" {
            let controller: BarChartController = segue.destination as! BarChartController
            controller.summary = self
            controller.selectedBin = selectedBin
            controller.categoryList = categoryList
            controller.segueName = "TotalFoodSegue"
            controller.navigationItem.title = "Category"
        }
        else if segue.identifier == "ProgressSegue" {
            let controller: LineChartController = segue.destination as! LineChartController
            controller.personReport = self.personReport
            controller.tabBar = self.tabBar
            controller.numberOfMember = self.numberOfMember
            var list = [String]()
            var firstTotalFood = 0.0
            var secondTotalFood = 0.0
            var thirdTotalFood = 0.0
            var fourthTotalFood = 0.0
            var firstFood = 0.0
            var secondFood = 0.0
            var thirdFood = 0.0
            var fourthFood = 0.0
            let convert = DateConverter()
            for i in 0...3 {
                let convert = DateConverter()
                let date = convert.dateFormatterWithRule(dateString: monthList[i], rule: "MMM yyyy")
                list.insert(date.toString(dateFormat: "MMM"), at: 0)
            }
            controller.monthList = list
            let currentMonth = convert.dateFormatterWithRule(dateString: (Calendar.current.date(byAdding: .month, value: 1, to: Date())?.toString(dateFormat: "MMM yyyy"))!, rule: "MMM yyyy")
            let lastMonth = convert.dateFormatterWithRule(dateString: (Calendar.current.date(byAdding: .month, value: 0, to: Date())?.toString(dateFormat: "MMM yyyy"))!, rule: "MMM yyyy")
            let lastTwoMonth = convert.dateFormatterWithRule(dateString: (Calendar.current.date(byAdding: .month, value: -1, to: Date())?.toString(dateFormat: "MMM yyyy"))!, rule: "MMM yyyy")
            let lastThreeMonth = convert.dateFormatterWithRule(dateString: (Calendar.current.date(byAdding: .month, value: -2, to: Date())?.toString(dateFormat: "MMM yyyy"))!, rule: "MMM yyyy")
            let lastFourMonth = convert.dateFormatterWithRule(dateString: (Calendar.current.date(byAdding: .month, value: -3, to: Date())?.toString(dateFormat: "MMM yyyy"))!, rule: "MMM yyyy")
            for food in tabBar!.bin! {
                if food.expire! < currentMonth && food.expire! >= lastMonth {
                    firstTotalFood = firstTotalFood + food.price!
                }
                else if food.expire! < lastMonth && food.expire! >= lastTwoMonth {
                    secondTotalFood = secondTotalFood + food.price!
                }
                else if food.expire! < lastTwoMonth && food.expire! >= lastThreeMonth {
                    thirdTotalFood = thirdTotalFood + food.price!
                }
                else if food.expire! < lastThreeMonth && food.expire! >= lastFourMonth {
                    fourthTotalFood = fourthTotalFood + food.price!
                }
                
                if food.completion != 100 {
                    if food.expire! < currentMonth && food.expire! >= lastMonth {
                        firstFood = firstFood + food.price! * (100 - Double(food.completion!))/100
                    }
                    else if food.expire! < lastMonth && food.expire! >= lastTwoMonth {
                        secondFood = secondFood + food.price! * (100 - Double(food.completion!))/100
                    }
                    else if food.expire! < lastTwoMonth && food.expire! >= lastThreeMonth {
                        thirdFood = thirdFood + food.price! * (100 - Double(food.completion!))/100
                    }
                    else if food.expire! < lastThreeMonth && food.expire! >= lastFourMonth {
                        fourthFood = fourthFood + food.price! * (100 - Double(food.completion!))/100
                    }
                }
            }
            controller.totalFood = [fourthTotalFood,thirdTotalFood,secondTotalFood,firstTotalFood]
            controller.wasteMoney = [fourthFood,thirdFood,secondFood,firstFood]
        }
    }
}
