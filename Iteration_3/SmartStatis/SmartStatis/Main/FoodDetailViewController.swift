//
//  FoodDetailViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/14.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol FoodDetailDelegate {
    func foodDetail(edit:Bool,food:Food?)
}
/*
    This method is to manage the view for food detail.
 */
class FoodDetailViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate,ActionDelegate {
    var home: UIViewController?
    var editSegment: UISegmentedControl?
    var categoryImage: UIImageView?
    var popOverPickerView = UIPickerView()
    var pickerView = UIPickerView()
    var percentPickerView = UIPickerView()
    var categoryList : [String]?
    var editPrice: UITextField?
    var editCategory: UITextField?
    var editName: UITextField?
    var editBuyDate: UITextField?
    var buyDatePicker = UIDatePicker()
    var editExpireDate: UITextField?
    var expireDatePicker = UIDatePicker()
    var editable = false
    var delegate: FoodDetailDelegate?
    var food: Food?
    var uid:Int?
    var deletedFood: Food?
    var tabBar: TabBarViewController?
    var binButtonOutlet: UIButton?
    var editButtonOutlet: UIButton?
    var segueName: String?
    var percentList = ["0%","20%","40%","60%","80%","100%"]
    var unitList = ["qty","kg","gram","piece","bottle","pack","can","bag","glass","box","bunch"]
    var selectedUnit: String?
    var selectedPercent: String?
    // Manage the action when the user tap Exit button.
    @IBAction func exitAction(_ sender: Any) {
        delegate?.foodDetail(edit: true, food: food)
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    // Manage the action when the user tap "Confirm" button.
    @IBAction func confirmAction(_ sender: Any) {
        if quantityNumberTextfield.text!.isEmpty {
            let alert = UIAlertController(title: "Empty Quantity", message: "Quantity must be at least 1", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if Int(quantityNumberTextfield.text!)! > 1000000 {
            let alert = UIAlertController(title: "Invalid Quantity", message: "Quantity must not exceed 1 million", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let quantity = quantityNumberTextfield.text! + "_" + quantityUnit.text!
            self.addNewFoodWithQuantity(userId: String(uid! as Int), cateId: String(food?.categoryId! as! Int), locationId: "5", foodName: food!.foodName!, start: (food?.start?.toString(dateFormat: "yyyy-MM-dd"))!, price: "-1", expire: (food?.expire?.toString(dateFormat: "yyyy-MM-dd"))!, quantity: quantity)
             let alert = UIAlertController(title: "Item Added", message: "Successfully Added to Plan", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Manage your plan", style: .default, handler: { [weak alert] (_) in
                self.checkShopPlan()
            }))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true , completion: dismissPopOver)
        }
        self.popOverView.removeFromSuperview()
    }
    @IBOutlet var percentView: UIView!
    @IBOutlet weak var percentConfirmOutlet: UIButton!
    // Manage the action when the user gives the percentage of the amount of consumed food.
    @IBAction func percentConfirm(_ sender: Any) {
        let originLocation = deletedFood?.locationId
        deletedFood?.locationId = 1
        let percent = String((percentField.text?.dropLast())!)
        let percentInt = Int(percent)!
        delegate?.foodDetail(edit: true, food: deletedFood)
        deletedFood?.completion = percentInt
        tabBar?.bin?.append(deletedFood!)
        switch originLocation {
        case 2:
            var index = 0
            for i in tabBar!.fridge! {
                if i.foodId == deletedFood?.foodId {
                    tabBar!.fridge?.remove(at: index)
                    break
                }
                index = index + 1
            }
        case 3:
            var index = 0
            for i in tabBar!.freezer! {
                if i.foodId == deletedFood?.foodId {
                    tabBar!.freezer?.remove(at: index)
                    break
                }
                index = index + 1
            }
        default:
            var index = 0
            for i in tabBar!.pantry! {
                if i.foodId == deletedFood?.foodId {
                    tabBar!.pantry?.remove(at: index)
                    break
                }
                index = index + 1
            }
        }
        updateFoodLocatition(foodId: (deletedFood?.foodId)!, location: 1)
        updateCompletion(id: (deletedFood?.foodId)!, completion: percentInt)
        self.percentView.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var percentField: UITextField!
    @IBOutlet weak var confirmButtonOutlet: UIButton!
    @IBOutlet weak var quantityUnit: UITextField!
    @IBOutlet weak var quantityNumberTextfield: UITextField!
    @IBOutlet var popOverView: UIView!
    
    /*
        This function is to initialize the view before the view appears.
     */
    override func viewWillAppear(_ animated: Bool) {
        var index = 0
        for i in unitList {
            if i == quantityUnit.text {
                print(index)
                break
            }
            index = index + 1
        }
        popOverPickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    /*
        This method is to manage the action when the users tap a row.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == popOverPickerView {
            selectedUnit = unitList[row]
            quantityUnit.text = selectedUnit
        }
        else if pickerView == percentPickerView {
            selectedPercent = percentList[row]
            percentField.text = selectedPercent
        }
        else {
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
    }

    /*
     This method is to navigate to shopping list view.
     */
    func checkShopPlan() {
        let navController = self.tabBar?.viewControllers![1] as! UINavigationController
        let shoppingController = navController.viewControllers[0] as! ShoppingTableViewController
        shoppingController.tableView.reloadData()
        sleep(1)
        self.dismiss(animated: true, completion: nil)
        self.tabBar?.selectedIndex = 1
    }
    
    /*
        This method is to initiate the title for the cell.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == popOverPickerView {
            let titleString = unitList[row]
            let title = titleString.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
            return title
        }
        else if pickerView == percentPickerView {
            let titleString = percentList[row]
            return titleString
        }
        let titleString = categoryList![row]
        let title = titleString.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        return title
    }
    
    /*
        This method is to determine the number of components in the picker view.
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
        This method is to determine the number of rows in each component.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == popOverPickerView {
            return unitList.count
        }
        else if pickerView == percentPickerView {
            return percentList.count
        }
            return categoryList!.count
    }
    
    /*
        This method is to add gesture recognizer into the percentage consumption view.
     */
    func dismissPercentViewWhenTap() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissPercent))
        view.addGestureRecognizer(tapGesture)
    }
    
    /*
        This method is to closs the view for consumption input.
     */
    @objc func dismissPercent() {
        self.percentView.removeFromSuperview()
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
        self.quantityNumberTextfield.text = ""
        self.popOverView.removeFromSuperview()
    }
    
    /*
        This method is to handle the ActionDelegate.
     */
    func action(action: String,selectFood:Food?) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.dismiss(animated: false, completion: {
                    self.home?.dismiss(animated: false, completion: nil)
                })
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        switch action {
        case "cancel":
            editBuyDate?.isUserInteractionEnabled = false
            editBuyDate?.borderStyle = .none
            editExpireDate?.isUserInteractionEnabled = false
            editExpireDate?.borderStyle = .none
            editName?.isUserInteractionEnabled = false
            editName?.borderStyle = .none
            editCategory?.isUserInteractionEnabled = false
            editCategory?.borderStyle = .none
            editPrice?.isUserInteractionEnabled = false
            editSegment?.isUserInteractionEnabled = false
            editPrice?.borderStyle = .none
            editable = false
            binButtonOutlet?.setTitle("Bin", for: .normal)
            editButtonOutlet?.setTitle("Edit", for: .normal)
        case "delete":
            if segueName == "FoodDetailSegue" {
                deletedFood = selectFood
                self.view.addSubview(percentView)
                dismissPercentViewWhenTap()
                percentView.center = self.view.center
                percentView.clipsToBounds = true
                percentView.layer.backgroundColor = UIColor.white.cgColor
                percentView.layer.masksToBounds = false
                percentView.layer.cornerRadius = 10.0
                percentView.layer.shadowOffset = CGSize(width: -1, height: 1)
                percentView.layer.shadowOpacity = 0.4
                percentView.layer.shadowRadius = 2
            }
            else {
                delegate?.foodDetail(edit: true, food: nil)
                self.dismiss(animated: true, completion: nil)
            }
        case "edit":
            editable = true
            tableView.reloadData()
        case "save":
            if editName?.text != nil && (editName?.text!.isEmpty)! {
                let alert = UIAlertController(title: "Empty Food Name", message: "Please enter food name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if (editName?.text?.trimmingCharacters(in: .whitespaces).count)! > 50 {
                let alert = UIAlertController(title: "Invalide Food Name", message: "Length  must not exceed 50 characters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if editPrice?.text != nil && (editPrice?.text!.isEmpty)! {
                let alert = UIAlertController(title: "Empty Food Price", message: "Please enter food price", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil ))
                self.present(alert, animated: true)
            }
            else if (editPrice?.text!.count)! > 10 {
                let alert = UIAlertController(title: "Invalid Price", message: "Price must not exceed 1 billion", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if !(editPrice?.text!.isDouble())!{
                let alert = UIAlertController(title: "Invalid Price", message: "Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                let convert = DateConverter()
                editable = false
                if editPrice?.text != nil {
                    food?.price = Double(editPrice?.text as! String)
                }
                if editName?.text != nil {
                    food?.foodName = editName?.text
                }
                switch editCategory?.text {
                case "Meat":
                    food?.categoryId = 1
                case "Fruit":
                    food?.categoryId = 2
                case "Seafood":
                    food?.categoryId = 3
                case "Dairy":
                    food?.categoryId = 4
                case "Dairy Product":
                    food?.categoryId = 5
                case "Vegetable":
                    food?.categoryId = 6
                case "Beverage":
                    food?.categoryId = 7
                case "Bakery":
                    food?.categoryId = 8
                case "Protein":
                    food?.categoryId = 9
                default:
                    food?.categoryId = 10
                }
                food?.start = convert.dateFormatterWithRule(dateString: editBuyDate!.text!, rule: "yyyy-MM-dd")
                food?.expire = convert.dateFormatterWithRule(dateString: (editExpireDate?.text)!, rule: "yyyy-MM-dd")
                food?.locationId = editSegment!.selectedSegmentIndex + 2
                let lid =  food!.locationId as! Int
                let priceString = (editPrice?.text)! as String
                updateFood(foodId: (food?.foodId)!, foodName: food!.foodName!, foodBuy: (editBuyDate?.text)!, foodExpire: (editExpireDate?.text)!, foodPrice: priceString, category: String((food?.categoryId)!), location: String(lid))
                updateFoodLocatition(foodId: (food?.foodId)!, location: editSegment!.selectedSegmentIndex + 2)
                delegate?.foodDetail(edit: true, food: food)
                let alert = UIAlertController(title: "Saved", message: "Food Successfully Updated", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        case "buy":
            self.view.addSubview(popOverView)
            dismissPopOverWhenTappedAround()
            popOverView.center = self.view.center
             popOverView.clipsToBounds = true
             popOverView.layer.backgroundColor = UIColor.white.cgColor
             popOverView.layer.masksToBounds = false
             popOverView.layer.cornerRadius = 10.0
             popOverView.layer.shadowOffset = CGSize(width: -1, height: 1)
             popOverView.layer.shadowOpacity = 0.4
             popOverView.layer.shadowRadius = 2
        default:
            //buy button
            self.addNewFood(userId: String(uid! as Int), cateId: String(food?.categoryId! as! Int), locationId: "5", foodName: food!.foodName!, start: (food?.start?.toString(dateFormat: "yyyy-MM-dd"))!, price: "-1", expire: (food?.expire?.toString(dateFormat: "yyyy-MM-dd"))!)
            let alert = UIAlertController(title: "Item Added", message: "Successfully Added to Plan", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    /*
        This method is to set the done action for the buy date text field.
     */
    @objc func doneBuy() {
        editBuyDate!.text = buyDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        createExpireDatePicker()
        self.view.endEditing(true)
    }
    
    /*
        This method is to set the buy data picker view for the text field.
     */
    func createBuyDatePicker() {
        buyDatePicker = UIDatePicker()
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
    
    /*
     This method is to set the done action for the expire date text field.
     */
    @objc func doneExpire() {
        editExpireDate!.text = expireDatePicker.date.toString(dateFormat: "yyyy-MM-dd")
        createBuyDatePicker()
        self.view.endEditing(true)
    }
    
    /*
     This method is to set the expire data picker view for the text field.
     */
    func createExpireDatePicker() {
        expireDatePicker = UIDatePicker()
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
    
    /*
        This method is to initiate the view when it is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "down-48px")
        quantityUnit.rightView = imageView
        quantityUnit.rightViewMode = .always
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
        toolBar.setItems([doneButton], animated: true)
        quantityNumberTextfield.inputAccessoryView = toolBar
        quantityNumberTextfield.keyboardType = .asciiCapableNumberPad
        
        let toolBarUnit = UIToolbar()
        toolBarUnit.sizeToFit()
        let doneButtonUnit = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
        toolBarUnit.setItems([doneButtonUnit], animated: true)
        quantityUnit.inputAccessoryView = toolBarUnit
        quantityUnit.inputView = popOverPickerView
        switch food?.categoryId {
        case 1:
            quantityUnit.text = "piece"
        case 2:
            quantityUnit.text = "qty"
        case 3:
            quantityUnit.text = "piece"
        case 4:
            quantityUnit.text = "bottle"
        case 5:
            quantityUnit.text = "qty"
        case 6:
            quantityUnit.text = "bunch"
        case 7:
            quantityUnit.text = "bottle"
        case 8:
            quantityUnit.text = "qty"
        case 9:
            quantityUnit.text = "qty"
        default:
            quantityUnit.text = "qty"
        }
        let toolBarThree = UIToolbar()
        toolBarThree.sizeToFit()
        let doneButtonThree = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
        toolBar.setItems([doneButtonThree], animated: true)
        percentField.inputAccessoryView = toolBar
        percentField.inputView = percentPickerView
        percentField.text = percentList[0]
        confirmButtonOutlet.addShadowToButton(cornerRadius: 5)
        percentConfirmOutlet.addShadowToButton(cornerRadius: 5)
        tableView.sectionHeaderHeight = 8.0
        tableView.sectionFooterHeight = 8.0
        pickerView.delegate = self
        popOverPickerView.delegate = self
        percentPickerView.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.tableView.alwaysBounceVertical = false
        self.tableView.allowsSelection = false
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        detailView.clipsToBounds = true
        self.detailView.backgroundColor = UIColor(red: 200/255, green: 229/255, blue: 199/255, alpha: 1.0)
        detailView.layer.masksToBounds = false
        detailView.layer.cornerRadius = 10.0
        detailView.layer.shadowOffset = CGSize(width: -1, height: 1)
        detailView.layer.shadowOpacity = 0.4
        detailView.layer.shadowRadius = 2
    }
    
    /*
        This method is to determine the number of section in the table view.
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        if segueName == "FoodDetailSegue" {
            return 8
        }
        else {
            return 6
        }
    }
    
    /*
        This method is to determine the numher of rows in each section.
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
  
    /*
        This method is to initiate the view for each cell.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dateConvert = DateConverter()
        if segueName == "FoodDetailSegue" {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! FoodDetailCell
                categoryImage = cell.categoryImage
                categoryImage?.setImageRadiusWithShadow()
                cell.exitOutlet.setRadiusWithShadow()
                editBuyDate = cell.buyDate
                editExpireDate = cell.expireDate
                cell.buyDate.text = dateConvert.dateConvertString(date: (food?.start)!)
                cell.expireDate.text = dateConvert.dateConvertString(date: (food?.expire)!)
                if editable == false {
                    cell.buyDate.borderStyle = .none
                    cell.expireDate.borderStyle = .none
                    cell.buyDate.isUserInteractionEnabled = false
                    cell.expireDate.isUserInteractionEnabled = false
                }
                else {
                    cell.buyDate.borderStyle = .roundedRect
                    cell.expireDate.borderStyle = .roundedRect
                    cell.buyDate.isUserInteractionEnabled = true
                    cell.expireDate.isUserInteractionEnabled = true
                    editBuyDate = cell.buyDate
                    editExpireDate = cell.expireDate
                    createBuyDatePicker()
                    createExpireDatePicker()
                }
                switch food?.categoryId {
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
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! FoodDetailCell
                cell.foodName.text = food?.foodName!.replacingOccurrences(of: "_", with: " ")
                if editable == false {
                    cell.foodName.borderStyle = .none
                    cell.foodName.isUserInteractionEnabled = false
                }
                else {
                    cell.foodName.borderStyle = .roundedRect
                    cell.foodName.isUserInteractionEnabled = true
                    editName = cell.foodName
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! FoodDetailCell
                switch food?.categoryId {
                case 1:
                    cell.foodCategory.text = "Meat"
                case 2:
                    cell.foodCategory.text = "Fruit"
                case 3:
                    cell.foodCategory.text = "Seafood"
                case 4:
                    cell.foodCategory.text = "Dairy"
                case 5:
                    cell.foodCategory.text = "Dairy Product"
                case 6:
                    cell.foodCategory.text = "Vegetable"
                case 7:
                    cell.foodCategory.text = "Beverage"
                case 8:
                    cell.foodCategory.text = "Bakery"
                case 9:
                    cell.foodCategory.text = "Protein"
                default:
                    cell.foodCategory.text = "Other"
                }
                var index = 0
                var selectedIndex = 0
                for i in categoryList! {
                    if i == cell.foodCategory.text {
                        selectedIndex = index
                    }
                    index = index + 1
                }
                pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
                if editable == false {
                    cell.foodCategory.borderStyle = .none
                    cell.foodCategory.isUserInteractionEnabled = false
                }
                else {
                    cell.foodCategory.borderStyle = .roundedRect
                    cell.foodCategory.isUserInteractionEnabled = true
                    editCategory = cell.foodCategory
                    let toolBar = UIToolbar()
                    toolBar.sizeToFit()
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
                    toolBar.setItems([doneButton], animated: true)
                    editCategory!.inputAccessoryView = toolBar
                    editCategory?.inputView = pickerView
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! FoodDetailCell
                cell.foodPrice.text = "$ " +  String(format:"%.2f", (food?.price)!)
                if editable == false {
                    cell.foodPrice.borderStyle = .none
                    cell.foodPrice.isUserInteractionEnabled = false
                }
                else {
                    cell.foodPrice.borderStyle = .roundedRect
                    cell.foodPrice.isUserInteractionEnabled = true
                    cell.foodPrice?.text = String((cell.foodPrice?.text?.dropFirst(2))!)
                    let toolBar = UIToolbar()
                    toolBar.sizeToFit()
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
                    toolBar.setItems([doneButton], animated: true)
                    cell.foodPrice.inputAccessoryView = toolBar
                    cell.foodPrice.keyboardType = .decimalPad
                    editPrice = cell.foodPrice
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BuyCell", for: indexPath) as! FoodDetailCell
                cell.delegate = self
                cell.buyButtonOutlet.addShadowToButton(cornerRadius: 5)
                cell.buyButtonOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeButtonCell", for: indexPath) as! FoodDetailCell
                cell.recipeButtonOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
                cell.recipeButtonOutlet.addShadowToButton(cornerRadius: 5)
                return cell
            case 6:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! FoodDetailCell
                switch food?.locationId {
                case 2:
                    cell.locationSegment.selectedSegmentIndex = 0
                case 3:
                    cell.locationSegment.selectedSegmentIndex = 1
                default:
                    cell.locationSegment.selectedSegmentIndex = 2
                }
                if editable {
                    cell.locationSegment.isUserInteractionEnabled = true
                    cell.locationSegment.tintColor = UIColor.blue
                }
                else {
                    cell.locationSegment.isUserInteractionEnabled = false
                    cell.locationSegment.tintColor = UIColor.lightGray
                }
                editSegment = cell.locationSegment
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell", for: indexPath) as! FoodDetailCell
                cell.delegate = self
                binButtonOutlet = cell.binOutlet
                editButtonOutlet = cell.editOutlet
                cell.editOutlet.addShadowToButton(cornerRadius: 5)
                cell.editOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
                cell.binOutlet.addShadowToButton(cornerRadius: 5)
                cell.food = food
                return cell
            }
        }
        else {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! FoodDetailCell
                categoryImage = cell.categoryImage
                categoryImage?.setImageRadiusWithShadow()
                cell.exitOutlet.setRadiusWithShadow()
                editBuyDate = cell.buyDate
                editExpireDate = cell.expireDate
                cell.buyDate.text = dateConvert.dateConvertString(date: (food?.start)!)
                cell.expireDate.text = dateConvert.dateConvertString(date: (food?.expire)!)
                if editable == false {
                    cell.buyDate.borderStyle = .none
                    cell.expireDate.borderStyle = .none
                    cell.buyDate.isUserInteractionEnabled = false
                    cell.expireDate.isUserInteractionEnabled = false
                }
                else {
                    cell.buyDate.borderStyle = .roundedRect
                    cell.expireDate.borderStyle = .roundedRect
                    cell.buyDate.isUserInteractionEnabled = true
                    cell.expireDate.isUserInteractionEnabled = true
                    editBuyDate = cell.buyDate
                    editExpireDate = cell.expireDate
                    createBuyDatePicker()
                    createExpireDatePicker()
                }
                switch food?.categoryId {
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
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! FoodDetailCell
                cell.foodName.text = food?.foodName!.replacingOccurrences(of: "_", with: " ")
                if editable == false {
                    cell.foodName.borderStyle = .none
                    cell.foodName.isUserInteractionEnabled = false
                }
                else {
                    cell.foodName.borderStyle = .roundedRect
                    cell.foodName.isUserInteractionEnabled = true
                    editName = cell.foodName
                }
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! FoodDetailCell
                switch food?.categoryId {
                case 1:
                    cell.foodCategory.text = "Meat"
                case 2:
                    cell.foodCategory.text = "Fruit"
                case 3:
                    cell.foodCategory.text = "Seafood"
                case 4:
                    cell.foodCategory.text = "Dairy"
                case 5:
                    cell.foodCategory.text = "Dairy Product"
                case 6:
                    cell.foodCategory.text = "Vegetable"
                case 7:
                    cell.foodCategory.text = "Beverage"
                case 8:
                    cell.foodCategory.text = "Bakery"
                case 9:
                    cell.foodCategory.text = "Protein"
                default:
                    cell.foodCategory.text = "Other"
                }
                var index = 0
                var selectedIndex: Int?
                for i in categoryList! {
                    if i == cell.foodCategory.text {
                        selectedIndex = index
                    }
                    index = index + 1
                }
                pickerView.selectRow(food!.categoryId!-1, inComponent: 0, animated: false)
                if editable == false {
                    cell.foodCategory.borderStyle = .none
                    cell.foodCategory.isUserInteractionEnabled = false
                }
                else {
                    cell.foodCategory.borderStyle = .roundedRect
                    cell.foodCategory.isUserInteractionEnabled = true
                    editCategory = cell.foodCategory
                    let toolBar = UIToolbar()
                    toolBar.sizeToFit()
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
                    toolBar.setItems([doneButton], animated: true)
                    editCategory!.inputAccessoryView = toolBar
                    editCategory?.inputView = pickerView
                }
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! FoodDetailCell
                cell.foodPrice.text = "$ " +  String(format:"%.2f", (food?.price)!)
                if editable == false {
                    cell.foodPrice.borderStyle = .none
                    cell.foodPrice.isUserInteractionEnabled = false
                }
                else {
                    cell.foodPrice.borderStyle = .roundedRect
                    cell.foodPrice.isUserInteractionEnabled = true
                    cell.foodPrice?.text = String((cell.foodPrice?.text?.dropFirst(2))!)
                    let toolBar = UIToolbar()
                    toolBar.sizeToFit()
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
                    toolBar.setItems([doneButton], animated: true)
                    cell.foodPrice.inputAccessoryView = toolBar
                    cell.foodPrice.keyboardType = .decimalPad
                    editPrice = cell.foodPrice
                }
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! FoodDetailCell
                switch food?.locationId {
                case 2:
                    cell.locationSegment.selectedSegmentIndex = 0
                case 3:
                    cell.locationSegment.selectedSegmentIndex = 1
                default:
                    cell.locationSegment.selectedSegmentIndex = 2
                }
                if editable {
                    cell.locationSegment.isUserInteractionEnabled = true
                    cell.locationSegment.tintColor = UIColor.blue
                }
                else {
                    cell.locationSegment.isUserInteractionEnabled = false
                    cell.locationSegment.tintColor = UIColor.lightGray
                }
                editSegment = cell.locationSegment
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell", for: indexPath) as! FoodDetailCell
                cell.delegate = self
                binButtonOutlet = cell.binOutlet
                editButtonOutlet = cell.editOutlet
                cell.editOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
                cell.editOutlet.addShadowToButton(cornerRadius: 5)
                cell.binOutlet.addShadowToButton(cornerRadius: 5)
                cell.food = food
                return cell
            }
        }
    }
    
    /*
        This method is to close editing mode.
     */
    @objc func dismissEditView() {
        self.view.endEditing(true)
    }
    
    /*
        This method is to update food detail into the database.
     */
    func updateFood(foodId:Int,foodName:String,foodBuy:String,foodExpire:String,foodPrice: String,category:String,location:String) {
        let dataString = "id=" + String(foodId) + "&name=" + foodName.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "%", with: "") + "&buy=" + foodBuy + "&expire=" + foodExpire + "&category=" + category + "&price=" + foodPrice + "&location=" + location
        guard let putUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodbyid?" + dataString) else { return}
        var putRequest = URLRequest(url: putUrl)
        putRequest.httpMethod = "PATCH"
        putRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = dataString.data(using: String.Encoding.utf8)
        putRequest.httpBody = data
        let putSession = URLSession.shared
        let dataTask = putSession.dataTask(with: putRequest as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                
            }
            else {
                _ = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        }
        dataTask.resume()
    }
    
    /*
        This method is to update food storage in the database.
     */
    func updateFoodLocatition(foodId:Int,location:Int) {
        let dataString = "id=" + String(foodId) + "&lid=" + String(location)
        guard let putUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodlocationbyid?" + dataString) else { return}
        var putRequest = URLRequest(url: putUrl)
        putRequest.httpMethod = "PATCH"
        putRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = dataString.data(using: String.Encoding.utf8)
        putRequest.httpBody = data
        let putSession = URLSession.shared
        let dataTask = putSession.dataTask(with: putRequest as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                
            }
            else {
                _ = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        }
        dataTask.resume()
    }

    /*
        This method is to initiate view controller for the launched segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeSegue" {
            let controller: RecipeResultController = segue.destination as! RecipeResultController
            controller.home = self.home
            controller.detailController = self
            let keyword = food?.keyword!.replacingOccurrences(of: "_", with: " ")
            if keyword!.count == 0 {
                let foodName = food?.foodName!.replacingOccurrences(of: "_", with: " ")
                controller.keyword = "Recipe with " + foodName!
            }
            else {
                controller.keyword = "Recipe with " + keyword!
            }
        }
    }
    
    /*
        This method is to update food quantity in the database.
     */
    func updateFoodQuantity(foodId:Int,quantity:String) {
        let dataString = "id=" + String(foodId) + "&quantity=" + quantity
        guard let putUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatequantitybyid?" + dataString) else { return}
        var putRequest = URLRequest(url: putUrl)
        putRequest.httpMethod = "PATCH"
        putRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = dataString.data(using: String.Encoding.utf8)
        putRequest.httpBody = data
        let putSession = URLSession.shared
        let dataTask = putSession.dataTask(with: putRequest as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                
            }
            else {
                _ = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        }
        dataTask.resume()
    }
    
    /*
        This method is to insert food with its quantity into the database.
     */
    func addNewFoodWithQuantity(userId:String,cateId:String,locationId:String,foodName:String,start:String,price:String,expire:String,quantity:String) {
        guard let postUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/addfoodwithquantity?uid=" + String(userId) + "&cid=" + String(cateId) + "&lid=" + String(locationId) + "&name=" + foodName.replacingOccurrences(of: " ", with: "_") + "&start=" + start + "&price=" + price + "&expire=" + expire + "&quantity=" + quantity ) else { return}
        var postRequest = URLRequest(url: postUrl)
        postRequest.httpMethod = "POST"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postSession = URLSession.shared
        
        let task = postSession.dataTask(with: postRequest, completionHandler:
        { (data: Data?, response: URLResponse?, error: Error?) in
            if let response = response as? HTTPURLResponse{
                DispatchQueue.main.async {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        print(json)
                        self.tabBar?.loadData()
                        self.tabBar?.getNextFoodId()
                    }
                    catch {
                        if response.statusCode == 200 {
                            print(1)
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    /*
        This method is to update food completion progress in the database.
     */
    func updateCompletion(id:Int,completion:Int) {
        let dataString = "id=" + String(id) + "&completion=" + String(completion)
        guard let putUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodcompletion?" + dataString) else { return}
        var putRequest = URLRequest(url: putUrl)
        putRequest.httpMethod = "PATCH"
        putRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = dataString.data(using: String.Encoding.utf8)
        putRequest.httpBody = data
        let putSession = URLSession.shared
        let dataTask = putSession.dataTask(with: putRequest as URLRequest) { (data, response, error) -> Void in
            if error != nil {
                
            }
            else {
                _ = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        }
        dataTask.resume()
    }
}

extension UIView {
    /*
        This function is to round the UIView with a shadow added.
    */
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
}

extension UIImageView {
    /*
        This function is to round the UIImageView with a shadow added.
     */
    func setImageRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
    /*
     This function is to round the UIImageView.
     */
    func setImageRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.masksToBounds = false
    }
    
}
