//
//  AddFoodViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/16.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol NewFoodlDelegate {
    func addFood(food:Food)
}
/*
    This class is to manage the view for adding food.
 */
class AddFoodViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, ActionDelegate {
    var home: UIViewController?
    var nextFoodId: Int?
    var location: Int?
    var delegate: NewFoodlDelegate?
    var categoryImage: UIImageView?
    var uid: Int?
    var categoryList: [String]?
    var editName: UITextField?
    var editCategory: UITextField?
    var editPrice: UITextField?
    var editBuyDate: UITextField?
    var editExpireDate: UITextField?
    var buyDatePicker = UIDatePicker()
    var expireDatePicker = UIDatePicker()
    var pickerView = UIPickerView()
    // Manage the action when the user taps Exit button.
    @IBAction func exitButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var exitButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    
    /*
        This method is to handle the action for ActionDelegate.
     */
    func action(action: String, selectFood: Food?) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.dismiss(animated: false, completion: {self.home?.dismiss(animated: false, completion: nil)})
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if action == "add" {
            if editName?.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                let alert = UIAlertController(title: "Empty Food Name", message: "Please enter food name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confrim", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if (editName?.text?.trimmingCharacters(in: .whitespaces).count)! > 50 {
                let alert = UIAlertController(title: "Invalide Food Name", message: "Length must not exceed 50 characters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if editPrice?.text?.count == 0 {
                let alert = UIAlertController(title: "Empty Price", message: "Please enter food price", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if (editPrice?.text!.count)! > 10 {
                let alert = UIAlertController(title: "Invalid Price", message: "Price must not exceed 1 billion", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if !(editPrice?.text?.isDouble())! {
                let alert = UIAlertController(title: "Invalid Price", message: "Please Try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                var cid = 0
                switch editCategory?.text {
                case "Meat":
                    cid = 1
                case "Fruit":
                    cid = 2
                case "Seafood":
                    cid = 3
                case "Dairy":
                    cid = 4
                case "Dairy Product":
                    cid = 5
                case "Vegetable":
                    cid = 6
                case "Beverage":
                    cid = 7
                case "Bakery":
                    cid = 8
                case "Protein":
                    cid = 9
                default:
                    cid = 10
                }
                let convert = DateConverter()
                var lid:Int?
                switch location {
                case 0:
                    lid = 2
                case 1:
                    lid = 3
                default:
                    lid = 4
                }
                let newFood = Food(foodId: nextFoodId, userId: uid, categoryId: cid, locationId: lid, foodName: editName?.text?.uppercased().trimmingCharacters(in: .whitespaces), start: convert.dateFormatterWithRule(dateString: editBuyDate!.text!, rule: "yyyy-MM-dd"), expire: convert.dateFormatterWithRule(dateString: editExpireDate!.text!, rule: "yyyy-MM-dd"), price: Double(editPrice!.text!), quantity: "0", completion: 0, keyword: "")
                delegate?.addFood(food: newFood)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /*
        This method is to determine the number of rows in each component.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList!.count
    }
   
    /*
        This method is to handle the action when users tap a row in the picker view.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editCategory?.text = categoryList![row]
        if editCategory != nil {
            switch editCategory!.text! {
            case "Meat":
                categoryImage!.image = UIImage(named: "Meat-50px")
            case "Fruit":
                categoryImage!.image = UIImage(named: "Fruit-50px")
            case "Seafood":
                categoryImage!.image = UIImage(named: "seafood-50px")
            case "Dairy":
                categoryImage!.image = UIImage(named: "milk-50px")
            case "Dairy_Product":
                categoryImage!.image = UIImage(named: "cheese-50px")
            case "Vegetable":
                categoryImage!.image = UIImage(named: "vegetable-50px")
            case "Beverage":
                categoryImage!.image = UIImage(named: "beverage-50px")
            case "Bakery":
                categoryImage!.image = UIImage(named: "bread-50px")
            case "Protein":
                categoryImage!.image = UIImage(named: "protein-50px")
            default:
                categoryImage!.image = UIImage(named: "others-50px")
            }
        }
    }
    
    /*
        This method is to determine the title of the cells in the picker view.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titleString = categoryList![row]
        let title = titleString.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        return title
    }
 
    /*
        This method is to determine the number of rows in each section in the table view.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /*
        This method is to determine the numher of sections in the table view.
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    /*
        This method is to initiate the view for the cells.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateConvert = DateConverter()
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! FoodDetailCell
            categoryImage = cell.categoryImage
            editBuyDate = cell.buyDate
            editExpireDate = cell.expireDate
            if editBuyDate?.text?.count == 0 {
                editBuyDate?.text = dateConvert.dateConvertString(date: Date())
            }
            if editExpireDate?.text?.count == 0 {
                editExpireDate?.text = dateConvert.dateConvertString(date: Date())
            }
            createBuyDatePicker()
            createExpireDatePicker()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! FoodDetailCell
            editName = cell.foodName
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! FoodDetailCell
            editCategory = cell.foodCategory
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
            toolBar.setItems([doneButton], animated: true)
            editCategory!.inputAccessoryView = toolBar
            editCategory?.inputView = pickerView
            if editCategory?.text?.count == 0 {
                cell.foodCategory.text = "Meat"
                categoryImage!.image = UIImage(named: "Meat-50px")
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! FoodDetailCell
            editPrice = cell.foodPrice
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
            toolBar.setItems([doneButton], animated: true)
            editPrice!.keyboardType = .decimalPad
            editPrice!.inputAccessoryView = toolBar
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell", for: indexPath) as! FoodDetailCell
            cell.delegate = self
            cell.editOutlet.addShadowToButton(cornerRadius: 5)
            cell.editOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
            cell.editOutlet.setTitle("Add", for: .normal)
            return cell
        }
    }
    
    /*
        This method is to close the editing mode.
     */
    @objc func dismissEditView(){
        self.view.endEditing(true)
    }
    
    /*
        This method is to determine the numher of components in the picker view.
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    /*
        This method is to initiate the view when it is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        self.hideKeyboardWhenTappedAround()
        self.tableView.alwaysBounceVertical = false
        self.tableView.allowsSelection = false
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 10.0
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        detailView.clipsToBounds = true
        self.detailView.backgroundColor = UIColor(red: 200/255, green: 229/255, blue: 199/255, alpha: 1.0)
        pickerView.delegate = self
        detailView.clipsToBounds = true
        detailView.clipsToBounds = true
        detailView.layer.masksToBounds = false
        detailView.layer.cornerRadius = 10.0
        detailView.layer.shadowOffset = CGSize(width: -1, height: 1)
        detailView.layer.shadowOpacity = 0.4
        detailView.layer.shadowRadius = 2
        exitButtonOutlet.setRadiusWithShadow()
        // Do any additional setup after loading the view.
    }
    
    /*
        This method is to create date picker view for the buy date.
     */
    func createBuyDatePicker() {
        buyDatePicker = UIDatePicker()
        if (editExpireDate?.text)!.count > 0 && (editBuyDate?.text)!.count > 0 {
            buyDatePicker.maximumDate =  DateConverter().dateFormatterWithRule(dateString: (editExpireDate?.text)!,rule: "yyyy-MM-dd")
            buyDatePicker.datePickerMode = .date
            buyDatePicker.date = DateConverter().dateFormatterWithRule(dateString: (editBuyDate?.text)!,rule: "yyyy-MM-dd")
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBuy))
            toolBar.setItems([doneButton], animated: true)
            editBuyDate!.inputAccessoryView = toolBar
            editBuyDate!.inputView = buyDatePicker
        }
    }

    /*
        This method is to manage the action for buy date when users tap done button.
     */
    @objc func doneBuy() {
        editBuyDate!.text = buyDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        self.view.endEditing(true)
    }
    
    /*
     This method is to manage the action for expire date when users tap done button.
     */
    @objc func doneExpire() {
        editExpireDate!.text = expireDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        self.view.endEditing(true)
    }
    
    /*
        This method is to create date picker view for the expire date.
     */
    func createExpireDatePicker() {
        expireDatePicker = UIDatePicker()
        if (editBuyDate?.text)!.count > 0 && (editExpireDate?.text)!.count > 0 {
            expireDatePicker.minimumDate = DateConverter().dateFormatterWithRule(dateString: (editBuyDate?.text)!,rule: "yyyy-MM-dd")
            expireDatePicker.datePickerMode = .date
            expireDatePicker.date = DateConverter().dateFormatterWithRule(dateString: (editExpireDate?.text)!,rule: "yyyy-MM-dd")
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneExpire))
            toolBar.setItems([doneButton], animated: true)
            editExpireDate!.inputAccessoryView = toolBar
            editExpireDate!.inputView = expireDatePicker
        }
    }
    
    /*
        This method is to determine the height for each section.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 80
        }
        return 60
    }
    

}

extension String {
    func isInt() -> Bool {
        if let intValue = Int(self) {
            if intValue >= 0 {
                return true
            }
        }
        return false
    }
    
    func isFloat() -> Bool {
        if let floatValue = Float(self) {
            if floatValue >= 0 {
                return true
            }
        }
        return false
    }
    
    func isDouble() -> Bool {
        if let doubleValue = Double(self) {
            if doubleValue >= 0 {
                return true
            }
        }
        return false
    }
    
    func numberOfCharacters() -> Int {
        return self.count
    }
}
