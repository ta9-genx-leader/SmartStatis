//
//  ShoppingTableViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/21.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This controller class is to manage the table view for shopping list.
 */
class ShoppingTableViewController: UITableViewController,FoodShopDelegate {
    
    // Method called when Add button is tapped.
    @IBAction func addButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "AddShopSegue", sender: self)
    }
    // FoodShopDelegate method
    func foodShopDetail(edit: Bool, food: Food?) {
        if edit {
            let tabBar = tabBarController as! TabBarViewController
            tabBar.shopping.append(food!)
            shoppingFood?.append(food!)
            tableView.reloadData()
        }
    }
    // Method called when segment controll is changed.
    @IBAction func segmentAction(_ sender: Any) {
        switch segmentOutlet.selectedSegmentIndex
        {
        case 0:
            showList = shoppingFood
        case 1:
            showList = plan
        default:
            showList = purchase
        }
        tableView.reloadData()
    }
    // Segment control outlet
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    var editExpireDate: UITextField?
    var showList: [Food]?
    var shoppingFood: [Food]?
    var plan = [Food]()
    var purchase = [Food]()
    var categoryList : [String]?
    var uid: Int?
    var priceField: UITextField?
    var expireDatePicker : UIDatePicker?
    /*
        This method is called when this view is about to appear.
     */
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = tabBarController as! TabBarViewController
        shoppingFood = tabBar.shopping
        plan = [Food]()
        purchase = [Food]()
        for food in shoppingFood! {
            if food.price == -1 {
                plan.append(food)
            }
            else {
                purchase.append(food)
            }
        }
        switch segmentOutlet.selectedSegmentIndex {
        case 0:
            showList = shoppingFood
        case 1:
            showList = plan
        default:
            showList = purchase
        }
        tableView.reloadData()
    }
    /*
        This method is to determine if the cell is editable.
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if showList!.count == 0 {
            return false
        }
        return true
    }
    /*
        This method is to initiate this view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "cartView"))
        self.tableView.backgroundView?.alpha = 0.2
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.masksToBounds = false
        let tabBar = tabBarController as! TabBarViewController
        self.categoryList = tabBar.categoryList
        shoppingFood = tabBar.shopping
        showList = shoppingFood
        uid = tabBar.currentUser?.userId
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
    }
    
    /*
        This method is called when the user tap done button for selecting expire date.
     */
    @objc func doneExpire() {
        editExpireDate!.text = expireDatePicker!.date.toString(dateFormat: "yyyy-MM-dd")
        self.presentedViewController?.view.endEditing(true)
    }
    
    /*
        This method is to create date picker for expire date text field.
     */
    func createExpireDatePicker() {
        expireDatePicker = UIDatePicker()
        expireDatePicker!.minimumDate = Date()
        expireDatePicker!.datePickerMode = .date
        expireDatePicker!.date = Date()
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneExpire))
        toolBar.setItems([doneButton], animated: true)
        editExpireDate!.inputAccessoryView = toolBar
        editExpireDate!.inputView = expireDatePicker
    }
    
    /*
        This method is to determine the number of sections for the table view.
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        if showList!.count == 0 {
            return 2
        }
        else {
            return 1
        }
    }

    /*
        This method is to determine the number of rows in each section of the table view.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showList!.count == 0 {
            switch section {
            case 0:
                tableView.allowsSelection = false
                if UIScreen.main.bounds.height < 580 {
                    return 3
                }
                else {
                    return 4
                }
            default:
                return 1
            }
        }
        else {
            tableView.allowsSelection = true
            tableView.isScrollEnabled = true
            return showList!.count
        }
    }
    
    /*
        This method is to initiate the view for each cell.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if no shopping plan
        if showList!.count == 0 {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath) as! ShoppingCell
                cell.backgroundColor = UIColor.clear
                cell.categoryImage.image = UIImage()
                cell.circleImage.image = UIImage(named: "grey-circle-50px")
                cell.categoryImage.backgroundColor = UIColor.lightGray
                cell.categoryImage.setImageRadius()
                cell.tickImage.setImageRadius()
                cell.shoppingItemLabel.backgroundColor = UIColor.lightGray
                cell.shoppingItemLabel.text = "   "
                cell.shoppingItemLabel.textColor = UIColor.lightGray
                cell.quantityLabel.backgroundColor = UIColor.lightGray
                cell.shoppingItemLabel.layer.cornerRadius = 10
                cell.shoppingItemLabel.layer.masksToBounds = true
                cell.quantityLabel.layer.cornerRadius = 10
                cell.quantityLabel.layer.masksToBounds = true
                cell.quantityLabel.text = "30 days"
                cell.quantityLabel.textColor = UIColor.lightGray
                cell.tickImage.image = UIImage()
                cell.tickImage.backgroundColor = UIColor.lightGray
                if cell.contentView.subviews.count != 7 {
                    cell.contentView.backgroundColor = UIColor.clear
                    let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 80))
                    whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
                    whiteRoundedView.layer.masksToBounds = false
                    whiteRoundedView.layer.cornerRadius = 5.0
                    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                    whiteRoundedView.layer.shadowOpacity = 0.4
                    whiteRoundedView.layer.shadowRadius = 2
                    cell.contentView.addSubview(whiteRoundedView)
                    cell.contentView.sendSubviewToBack(whiteRoundedView)
                }
                cell.contentView.layer.opacity = Float(0.5/(Double(indexPath.row)+1))
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                switch segmentOutlet.selectedSegmentIndex {
                case 0:
                    cell.cellTitle?.text = "All Shopping list is empty!"
                    cell.cellBody?.text = "Tap Add Button below to create your plan"
                    cell.addOutlet.isHidden = false
                case 1:
                    cell.cellTitle?.text = "Shopping plan is empty!"
                    cell.cellBody?.text = "Tap Add Button below to create your plan"
                    cell.addOutlet.isHidden = false
                default:
                    cell.cellTitle?.text = "Purchased list is empty"
                    cell.cellBody?.text = "You haven't purchased any item from your plan"
                    cell.addOutlet.isHidden = true
                    
                }
                return cell
            }
        }
        // if there is shopping plan
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath) as! ShoppingCell
        cell.contentView.layer.opacity = 1
        cell.categoryImage.layer.shadowRadius = 0
        cell.circleImage.layer.shadowRadius = 0
        cell.shoppingItemLabel.text = showList![indexPath.row].foodName?.replacingOccurrences(of: "_", with: " ")
        cell.categoryImage.backgroundColor = UIColor.clear
        cell.tickImage.backgroundColor = UIColor.white
        cell.circleImage.backgroundColor = UIColor.clear
        cell.shoppingItemLabel.backgroundColor = UIColor.clear
        cell.quantityLabel.backgroundColor = UIColor.clear
        cell.shoppingItemLabel.textColor = UIColor.black
        cell.quantityLabel.textColor = UIColor.black
        
        let food = showList![indexPath.row]
        switch food.completion {
        case -1:
            cell.tickImage.image = UIImage(named: "blue-tick-52px")
        default:
            cell.tickImage.image = UIImage(named: "grey-tick-52px")
        }
        switch food.categoryId {
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
        cell.tickImage.setRadiusWithShadow()
        cell.shoppingItemLabel.text = food.foodName!.replacingOccurrences(of: "_", with: " ")
        if food.price != -1 {
            cell.tickImage.image = UIImage(named: "blue-tick-52px")
            cell.quantityLabel.text = "$" + String(format:"%.2f", (food.price)!)
        }
        else {
            cell.tickImage.image = UIImage(named: "grey-tick-52px")
            cell.quantityLabel.text = food.quantity!.replacingOccurrences(of: "_", with: " ")
        }
        if cell.contentView.subviews.count != 7 {
            cell.contentView.backgroundColor = UIColor.clear
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 80))
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
        This method is called when any cell is selected.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = showList![indexPath.row] as Food
        // if not in total list
        if segmentOutlet.selectedSegmentIndex != 0 {
            switch food.price {
            case -1:
                let alert = UIAlertController(title: "Already purchased?", message: "Please Enter Food Price Below", preferredStyle: .alert)
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.placeholder = "$ 0.00"
                    textField.textAlignment = .center
                    let toolBar = UIToolbar()
                    toolBar.sizeToFit()
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissEditView))
                    toolBar.setItems([doneButton], animated: true)
                    textField.inputAccessoryView = toolBar
                    textField.keyboardType = .decimalPad
                }
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
                    if  let newPrice = Double((alert?.textFields![0].text)!) {
                        self.priceField = alert?.textFields![0]
                        food.price = newPrice
                        let cell = tableView.cellForRow(at: indexPath) as! ShoppingCell
                        cell.tickImage.image = UIImage(named: "blue-tick-52px")
                        cell.quantityLabel.text = "$" + String(format:"%.2f", newPrice)
                        self.updateFoodPrice(foodId: self.showList![indexPath.row].foodId!, price: "$ " + self.priceField!.text! )
                        self.updateCompletion(id: self.showList![indexPath.row].foodId!, completion: -1)
                        if self.segmentOutlet.selectedSegmentIndex == 1 {
                            self.purchase.append(food)
                            self.plan.remove(at: indexPath.row)
                            self.showList?.remove(at: indexPath.row)
                            tableView.reloadData()
                        }
                    }
                    else {
                        let alertTwo = UIAlertController(title: "Invalid Price", message: "Please Try Again", preferredStyle: .alert)
                        alertTwo.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alertTwo, animated: true, completion: nil)
                    }
                }))
                self.present(alert, animated: true) {
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                    alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
                }
            default:
                let cell = tableView.cellForRow(at: indexPath) as! ShoppingCell
                cell.tickImage.image = UIImage(named: "grey-tick-52px")
                cell.quantityLabel.text = food.quantity!.replacingOccurrences(of: "_", with: " ")
                let alert = UIAlertController(title: "Purchase Canceled", message: "The purchased item has been canceled", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
                updateFoodPrice(foodId: food.foodId!, price: "-1")
                updateCompletion(id: food.foodId!, completion: -2)
                self.plan.append(food)
                self.purchase.remove(at: indexPath.row)
                self.showList?.remove(at: indexPath.row)
                tableView.reloadData()
                food.price = -1
                food.completion = -2
            }
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadData()
        }
        else {
            switch food.price {
            case -1:
               let alert = UIAlertController(title: "Already purchased?", message: "Please Enter Food Price Below", preferredStyle: .alert)
                //2. Add the text field. You can configure it however you need.
                alert.addTextField { (textField) in
                    textField.placeholder = "$ 0.00"
                    textField.textAlignment = .center
                    let toolBar = UIToolbar()
                    toolBar.sizeToFit()
                    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissEditView))
                    toolBar.setItems([doneButton], animated: true)
                    textField.inputAccessoryView = toolBar
                    textField.keyboardType = .decimalPad
                }
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
                    if  let newPrice = Double((alert?.textFields![0].text)!) {
                        self.priceField = alert?.textFields![0]
                        food.price = newPrice
                        let cell = tableView.cellForRow(at: indexPath) as! ShoppingCell
                        cell.tickImage.image = UIImage(named: "blue-tick-52px")
                        cell.quantityLabel.text = "$" + String(format:"%.2f", newPrice)
                        self.updateFoodPrice(foodId: self.showList![indexPath.row].foodId!, price: "$ " + self.priceField!.text! )
                        self.updateCompletion(id: self.showList![indexPath.row].foodId!, completion: -1)
                        self.purchase.append(food)
                        var index = 0
                        for item in self.plan {
                            if item.foodId == food.foodId {
                                self.plan.remove(at: index)
                                break
                            }
                            index = index + 1
                        }
                    }
                    else {
                        let alertTwo = UIAlertController(title: "Invalid Price", message: "Please Try Again", preferredStyle: .alert)
                        alertTwo.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alertTwo, animated: true, completion: nil)
                    }
                }))
                self.present(alert, animated: true) {
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                    alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
                }
            default:
                let cell = tableView.cellForRow(at: indexPath) as! ShoppingCell
                cell.tickImage.image = UIImage(named: "grey-tick-52px")
                let alert = UIAlertController(title: "Purchase Canceled", message: "The purchased item has been canceled", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
                cell.quantityLabel.text = food.quantity!.replacingOccurrences(of: "_", with: " ")
                updateFoodPrice(foodId: food.foodId!, price: "-1")
                updateCompletion(id: food.foodId!, completion: -2)
                self.plan.append(food)
                var index = 0
                for item in self.purchase {
                    if item.foodId == food.foodId {
                        self.purchase.remove(at: index)
                        break
                    }
                    index = index + 1
                }
                food.price = -1
                food.completion = -2
            }
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadData()
        }
    }
    
    /*
        This method is to close the alert view.
     */
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
        This method is to determine the height for each section.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 200
    }
    
    /*
        This method is to set action when users slide the cell.
     */
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let removeFood = self.showList![indexPath.row]
            let viewController = UIViewController()
            viewController.deleteFoodRequest(foodId: removeFood.foodId)
            
            let tabBar = self.tabBarController as! TabBarViewController
            var index = 0
            for remove in tabBar.shopping {
                if remove.foodId == removeFood.foodId {
                    tabBar.shopping.remove(at: index)
                    break
                }
                index = index + 1
            }
            index = 0
            for item in self.shoppingFood! {
                if item.foodId == removeFood.foodId {
                    self.shoppingFood?.remove(at: index)
                    break
                }
                index = index + 1
            }
            if removeFood.price == -1 {
                index = 0
                for item in self.plan {
                    if item.foodId == removeFood.foodId {
                        self.plan.remove(at: index)
                        break
                    }
                    index = index + 1
                }
            }
            else {
                index = 0
                for item in self.purchase {
                    if item.foodId == removeFood.foodId {
                        self.purchase.remove(at: index)
                        break
                    }
                    index = index + 1
                }
            }
            self.showList?.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let share = UITableViewRowAction(style: .normal, title: "Move") { (action, indexPath) in
            let selectedFood = self.showList![indexPath.row]
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Where to Move?", message: "Please Enter Expiry Date ", preferredStyle: .alert)
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.placeholder = "Expiry Date?"
                textField.textAlignment = .center
                self.editExpireDate = textField
                self.createExpireDatePicker()
            }
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Fridge", style: .default, handler: { [weak alert] (_) in
                if !(alert?.textFields![0].text)!.isEmpty {
                    let expireDate = alert?.textFields![0].text
                    self.updateFood(foodId: selectedFood.foodId!, foodName: selectedFood.foodName!, foodBuy: Date().toString(dateFormat: "yyyy-MM-dd"), foodExpire: expireDate!, foodPrice: String(selectedFood.price!), category: String(selectedFood.categoryId!), location: "2")
                    self.updateCompletion(id: selectedFood.foodId!, completion: 0)
                    let tabBar = self.tabBarController as! TabBarViewController
                    var indexTwo = 0
                    for food in tabBar.shopping {
                        if food.foodId == selectedFood.foodId {
                            break
                        }
                        indexTwo = indexTwo + 1
                    }
                    selectedFood.locationId = 2
                    let convert = DateConverter()
                    selectedFood.expire = convert.dateFormatterWithRule(dateString: expireDate!, rule: "yyyy-MM-dd")
                    tabBar.foodFromShopToStore = selectedFood
                    self.showList?.remove(at: indexPath.row)
                    tabBar.shopping.remove(at: indexTwo)
                    self.shoppingFood?.remove(at: indexTwo)
                    self.tableView.reloadData()
                }
                else {
                    let alertTwo = UIAlertController(title: "Invalid Date", message: "Please Try Again", preferredStyle: .alert)
                    alertTwo.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alertTwo, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Freezer", style: .default, handler: { [weak alert] (_) in
                if !(alert?.textFields![0].text)!.isEmpty {
                    let expireDate = alert?.textFields![0].text
                    self.updateFood(foodId: selectedFood.foodId!, foodName: selectedFood.foodName!, foodBuy: Date().toString(dateFormat: "yyyy-MM-dd"), foodExpire: expireDate!, foodPrice: String(selectedFood.price!), category: String(selectedFood.categoryId!), location: "3")
                    self.updateCompletion(id: selectedFood.foodId!, completion: 0)
                    let tabBar = self.tabBarController as! TabBarViewController
                    var indexTwo = 0
                    for food in tabBar.shopping {
                        if food.foodId == selectedFood.foodId {
                            break
                        }
                        indexTwo = indexTwo + 1
                    }
                    selectedFood.locationId = 3
                    let convert = DateConverter()
                    selectedFood.expire = convert.dateFormatterWithRule(dateString: expireDate!, rule: "yyyy-MM-dd")
                    tabBar.foodFromShopToStore = selectedFood
                    self.showList?.remove(at: indexPath.row)
                    tabBar.shopping.remove(at: indexTwo)
                    self.shoppingFood?.remove(at: indexTwo)
                    self.tableView.reloadData()
                }
                else {
                    let alertTwo = UIAlertController(title: "Invalid Date", message: "Please Try Again", preferredStyle: .alert)
                    alertTwo.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alertTwo, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Pantry", style: .default, handler: { [weak alert] (_) in
                if !(alert?.textFields![0].text)!.isEmpty {
                    let expireDate = alert?.textFields![0].text
                    self.updateFood(foodId: selectedFood.foodId!, foodName: selectedFood.foodName!, foodBuy: Date().toString(dateFormat: "yyyy-MM-dd"), foodExpire: expireDate!, foodPrice: String(selectedFood.price!), category: String(selectedFood.categoryId!), location: "4")
                    self.updateCompletion(id: selectedFood.foodId!, completion: 0)
                    let tabBar = self.tabBarController as! TabBarViewController
                    var indexTwo = 0
                    for food in tabBar.shopping {
                        if food.foodId == selectedFood.foodId {
                            break
                        }
                        indexTwo = indexTwo + 1
                    }
                    
                    selectedFood.locationId = 4
                    let convert = DateConverter()
                    selectedFood.expire = convert.dateFormatterWithRule(dateString: expireDate!, rule: "yyyy-MM-dd")
                    tabBar.foodFromShopToStore = selectedFood
                    self.showList?.remove(at: indexPath.row)
                    tabBar.shopping.remove(at: indexTwo)
                    self.shoppingFood?.remove(at: indexTwo)
                    self.tableView.reloadData()
                }
                else {
                    let alertTwo = UIAlertController(title: "Invalid Date", message: "Please Try Again", preferredStyle: .alert)
                    alertTwo.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alertTwo, animated: true, completion: nil)
                }
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true) {
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
        }
        share.backgroundColor = UIColor.blue
        let cell = tableView.cellForRow(at: indexPath) as! ShoppingCell
        if cell.tickImage.image == UIImage(named: "blue-tick-52px") {
            return [delete, share]
        }
        else {
            return [delete]
        }
    }
    /*
        This method is to dismiss the alert view.
     */
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }

    /*
        This method is to update the completion column value for the food.
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
    
    /*
        This method is to close the editing view.
     */
    @objc func dismissEditView() {
        self.presentedViewController?.view.endEditing(true)
    }
    
    /*
        This method is to update the food price in database.
     */
    func updateFoodPrice(foodId:Int,price:String) {
        let correctPrice = String(price.dropFirst(2))
        let dataString:String?
        if price == "-1" {
            dataString = "id=" + String(foodId) + "&price=" + price
        }
        else {
            dataString = "id=" + String(foodId) + "&price=" + correctPrice
        }
        guard let putUrl = URL(string:"https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodprice?" + dataString!) else { return}
        var putRequest = URLRequest(url: putUrl)
        putRequest.httpMethod = "PATCH"
        putRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = dataString!.data(using: String.Encoding.utf8)
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
        This method is to update food in database.
     */
    func updateFood(foodId:Int,foodName:String,foodBuy:String,foodExpire:String,foodPrice: String,category:String,location:String) {
        let dataString = "id=" + String(foodId) + "&name=" + foodName + "&buy=" + foodBuy + "&expire=" + foodExpire + "&category=" + category + "&price=" + foodPrice + "&location=" + location
        guard let putUrl = URL(string:"https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/updatefoodbyid?" + dataString) else { return}
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddShopSegue" {
            let controller: AddShopFoodController = segue.destination as! AddShopFoodController
            controller.categoryList = self.categoryList
            let tabBar = tabBarController as! TabBarViewController
            controller.nextFoodId = tabBar.nextFoodId
            controller.uid = tabBar.currentUser?.userId
            controller.addDelegate = self
        }
    }
    

}

extension UITableViewController {
    /*
        This method is to dismiss alert view when user tap anywhere of the view.
     */
    func dismissAlertWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissAlert))
        view.addGestureRecognizer(tapGesture)
    }
    /*
        Dismiss view
     */
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
}
