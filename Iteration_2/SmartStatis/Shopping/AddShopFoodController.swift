//
//  AddShopFoodController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/25.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol FoodShopDelegate {
    func foodShopDetail(edit:Bool,food:Food?)
}
class AddShopFoodController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,ActionDelegate  {
    @IBOutlet weak var exitButtonOutlet: UIButton!
    @IBAction func exitButtionAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var cid:Int?
    func action(action: String, selectFood: Food?) {
        let intQuantity = cellList[0].quantityField.text! as String
        let int = Int(intQuantity)
        if int != nil && int! > 0 && int! < 10000000 {
            let name = cellList[1].foodName.text!.uppercased().trimmingCharacters(in: .whitespaces)
            if name.trimmingCharacters(in: .whitespaces).count > 50 {
                let alert = UIAlertController(title: "Invalide Food Name", message: "Length must not exceed 50 characters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else if name.count > 0 {
                let qty = String(int!) + "_" + cellList[0].unitField.text!
                switch cellList[2].foodCategory.text {
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
                let newFood = Food(foodId: nextFoodId, userId: uid, categoryId: cid, locationId: 5, foodName: name, start: Date(), expire: Date(), price: -1, quantity: qty, completion: -2, keyword: "")
                addNewFoodWithQuantity(userId: String(newFood.userId!), cateId: String(newFood.categoryId!), locationId: "5", foodName: newFood.foodName!, start: (newFood.start?.toString(dateFormat: "yyyy-MM-dd"))!, price: "-1", expire: (newFood.expire?.toString(dateFormat: "yyyy-MM-dd"))!, quantity: newFood.quantity!)
                let alert = UIAlertController(title: "Added", message: "Plan Successfully Added", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:  { [weak alert] (_) in
                    self.addDelegate?.foodShopDetail(edit: true, food: newFood)
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Empty Food Name", message: "Please enter food name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else if int == nil {
            let alert = UIAlertController(title: "Invalid Quantity", message: "Quantity must not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if int! > 1000000 {
            let alert = UIAlertController(title: "Invalid Quantity", message: "Quantity must not exceed 1 million", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Invalid Quantity", message: "Quantity must be at least 1", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            cellList[2].foodCategory.text = categoryList![row]
            switch categoryList![row] {
            case "Meat":
                cellList[0].categoryImage.image = UIImage(named: "Meat-50px")
            case "Fruit":
                cellList[0].categoryImage.image = UIImage(named: "Fruit-50px")
            case "Seafood":
                cellList[0].categoryImage.image = UIImage(named: "seafood-50px")
            case "Dairy":
                cellList[0].categoryImage.image = UIImage(named: "milk-50px")
            case "Dairy_Product":
                cellList[0].categoryImage.image = UIImage(named: "cheese-50px")
            case "Vegetable":
                cellList[0].categoryImage.image = UIImage(named: "vegetable-50px")
            case "Beverage":
                cellList[0].categoryImage.image = UIImage(named: "beverage-50px")
            case "Bakery":
                cellList[0].categoryImage.image = UIImage(named: "bread-50px")
            case "Protein":
                cellList[0].categoryImage.image = UIImage(named: "protein-50px")
            default:
                cellList[0].categoryImage.image = UIImage(named: "others-50px")
            }
            print(categoryList![row])
        }
        else {
            cellList[0].unitField.text = unitList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            let titleString = categoryList![row]
            return titleString
        }
        else {
            let titleString = unitList[row]
            return titleString
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPickerView {
            return categoryList!.count
        }
        else {
            return unitList.count
        }
    }
    var addDelegate: FoodShopDelegate?
    var uid: Int?
    var categoryList: [String]?
    var categoryPickerView = UIPickerView()
    var cellList = [FoodDetailCell]()
    var pickView = UIPickerView()
    var nextFoodId: Int?
    var unitList = ["qty","kg","gram","piece","bottle","pack","can","bag","glass","box"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainShopCell", for: indexPath) as! FoodDetailCell
            cell.categoryImage.setImageRadiusWithShadow()
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
            toolBar.setItems([doneButton], animated: true)
            cell.quantityField.inputAccessoryView = toolBar
            cell.quantityField.keyboardType = .asciiCapableNumberPad
            
            let toolBarUnit = UIToolbar()
            toolBarUnit.sizeToFit()
            let doneButtonUnit = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
            toolBarUnit.setItems([doneButtonUnit], animated: true)
            cell.unitField.inputAccessoryView = toolBarUnit
            cell.unitField.inputView = pickView
            cell.unitField.text = unitList[0]
            if indexPath.section + 1 > cellList.count {
                cellList.append(cell)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameShopCell", for: indexPath) as! FoodDetailCell
            if indexPath.section + 1 > cellList.count {
                cellList.append(cell)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryShopCell", for: indexPath) as! FoodDetailCell
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let doneButtonUnit = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
            toolBar.setItems([doneButtonUnit], animated: true)
            cell.foodCategory.inputAccessoryView = toolBar
            cell.foodCategory.inputView = categoryPickerView
            cell.foodCategory.text = categoryList![0]
            cellList[0].categoryImage.image = UIImage(named: "Meat-50px")
            if indexPath.section + 1 > cellList.count {
                cellList.append(cell)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditShopCell", for: indexPath) as! FoodDetailCell
            cell.delegate = self
            cell.editOutlet.addShadowToButton(cornerRadius: 5)
            if indexPath.section + 1 > cellList.count {
                cellList.append(cell)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 80
        }
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        exitButtonOutlet.setRadiusWithShadow()
        self.hideKeyboardWhenTappedAround()
        pickView.delegate = self
        categoryPickerView.delegate = self
        tableView.allowsSelection = false
        foodView.clipsToBounds = true
        foodView.clipsToBounds = true
        foodView.backgroundColor = UIColor(red: 200/255, green: 229/255, blue: 199/255, alpha: 1.0)
        foodView.layer.masksToBounds = false
        foodView.layer.cornerRadius = 10.0
        foodView.layer.shadowOffset = CGSize(width: -1, height: 1)
        foodView.layer.shadowOpacity = 0.4
        foodView.layer.shadowRadius = 2
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissEditView() {
        self.view.endEditing(true)
    }

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


}
