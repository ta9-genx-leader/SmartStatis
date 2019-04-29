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
class AddFoodViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, ActionDelegate {
    var nextFoodId: Int?
    func action(action: String, selectFood: Food?) {
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
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList!.count
    }
   
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titleString = categoryList![row]
        let title = titleString.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        return title
    }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
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
            editPrice!.keyboardType = .asciiCapableNumberPad
            editPrice!.inputAccessoryView = toolBar
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell", for: indexPath) as! FoodDetailCell
            cell.delegate = self
            cell.editOutlet.addShadowToButton(cornerRadius: 5)
            cell.editOutlet.setTitle("Add", for: .normal)
            return cell
        }
    }
    
    @objc func dismissEditView(){
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   


    @IBAction func exitButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var exitButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(nextFoodId)
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

    @objc func doneBuy() {
        editBuyDate!.text = buyDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        self.view.endEditing(true)
    }
    
    @objc func doneExpire() {
        editExpireDate!.text = expireDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        self.view.endEditing(true)
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 80
        }
        return 60
    }
    

}
