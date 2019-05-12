//
//  ReceiptTableController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/7.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol ScanReceiptDelegate {
    func scanReceiptDelegate(newFood:[Food])
}
protocol NextFoodIdDelegate {
    func nextFoodIdDelegate(foodId:Int)
}
/*
    This class is to manage the table view for receipt result.
 */
class ReceiptTableController: UITableViewController,FoodDetailDelegate {
    var home: UIViewController?
    var foodIdDelegate: NextFoodIdDelegate?
    var nextFoodIdUpload: Int?
    var nextFoodId: Int?
    var updated = false
    var categoryList: [String]?
    var delegate: ScanReceiptDelegate?
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    var requestStatus = false
    var receiptDetail: Array<Any>?
    var selectedFood: Food?
    var selectedIndex = 0
    var uid: Int?
    var foodList = [Food]()
    
    // method for FoofDetailDelegate
    func foodDetail(edit: Bool, food: Food?) {
        if food != nil {
            food?.userId = uid
            foodList.remove(at: selectedIndex)
            foodList.append(food!)
            foodList = foodList.sorted(by:{$0.price! < $1.price!})
            tableView.reloadData()
        }
        else {
            foodList.remove(at: selectedIndex)
            if foodList.count == 0 {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.tableView.reloadData()
            }
        }
    }
    
    /*
        This method is to initiate view when it is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        nextFoodIdUpload = nextFoodId
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        for i in 0...receiptDetail!.count - 1 {
            let foodItem = receiptDetail![i] as! NSDictionary
            if foodItem["expiry days"] != nil && foodItem["Item"] != nil {
                var categoryId : Int?
                var locationId : Int?
                let expiry = Calendar.current.date(byAdding:.day,value: foodItem["expiry days"] as! Int,to: Date())
                let categoryString = foodItem["category"] as! String
                switch categoryString.uppercased() {
                case "MEAT":
                    categoryId = 1
                    locationId = 3
                case "FRUIT":
                    categoryId = 2
                    locationId = 2
                case "SEAFOOD":
                    categoryId = 3
                    locationId = 3
                case "DAIRY":
                    categoryId = 4
                    locationId = 2
                case "DAIRY_PRODUCT":
                    categoryId = 5
                    locationId = 2
                case "VEGETABLE":
                    categoryId = 6
                    locationId = 2
                case "BEVERAGE":
                    categoryId = 7
                    locationId = 4
                case "BAKERY":
                    categoryId = 8
                    locationId = 4
                case "PROTEIN":
                    categoryId = 9
                    locationId = 2
                default:
                    categoryId = 10
                    locationId = 4
                }
                let name = foodItem["Item"] as! String
                let newFood = Food(foodId: nextFoodId, userId: uid, categoryId: categoryId, locationId: locationId, foodName: name.trimmingCharacters(in: .whitespaces), start: Date(), expire: expiry, price: foodItem["price"] as? Double, quantity: "0", completion: 0, keyword: foodItem["keyword"] as? String)
                nextFoodId = nextFoodId! + 1
                foodList.append(newFood)
            }
        }
        foodList = foodList.sorted(by:{$0.price! < $1.price!})
    }

    /*
        This method is to save the receipt result into database.
     */
    @objc func save() {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: {self.home?.dismiss(animated: false, completion: nil)})
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            var fridgeNumber = 0
            var freezerNumber = 0
            var pantryNumber = 0
            DispatchQueue.main.async {
                if self.foodList.count >= 1 {
                    for i in 0...self.foodList.count - 1 {
                        let newName = self.foodList[i].foodName
                        let newUserId = self.foodList[i].userId
                        let newCateId = self.foodList[i].categoryId
                        let newLocatId = self.foodList[i].locationId!
                        let newStart = self.foodList[i].start
                        let newExpire = self.foodList[i].expire
                        let newPrice = self.foodList[i].price
                        let newKeyword = self.foodList[i].keyword!.uppercased().replacingOccurrences(of: " ", with: "_").trimmingCharacters(in: .whitespaces)
                        self.uploadReceipt(foodId: String(self.nextFoodIdUpload!), userId: String(newUserId!), cateId: String(newCateId!), locationId: String(newLocatId), foodName: newName!, start: (newStart?.toString(dateFormat: "yyyy-MM-dd"))!, price: String(format: "%.1f",(newPrice!)), expire: (newExpire?.toString(dateFormat: "yyyy-MM-dd"))!, keyword: newKeyword)
                        self.nextFoodIdUpload = self.nextFoodIdUpload! + 1
                        switch newLocatId {
                        case 2:
                            fridgeNumber = fridgeNumber + 1
                        case 3:
                            freezerNumber = freezerNumber + 1
                        default:
                            pantryNumber = pantryNumber + 1
                        }
                    }
                    var fridgeMessage = ""
                    if fridgeNumber != 0 {
                        fridgeMessage = "Fridge: " + String(fridgeNumber) + " item"
                    }
                    var freezerMessage = ""
                    if freezerNumber != 0 {
                        if fridgeMessage.count != 0 {
                            freezerMessage = "\r\nFreezer: " + String(freezerNumber) + " item"
                        }
                        else {
                            freezerMessage = "Freezer: " + String(freezerNumber) + " item"
                        }
                    }
                    var pantryMessage = ""
                    if pantryNumber != 0 {
                        if fridgeMessage.count != 0 || freezerMessage.count != 0{
                            pantryMessage = "\r\nPantry: " + String(pantryNumber) + " item"
                        }
                        else {
                            pantryMessage = "Pantry: " + String(pantryNumber) + " item"
                        }
                    }
                    let alertMessage = fridgeMessage + freezerMessage + pantryMessage
                    let alert = UIAlertController(title: "Receipt Saved", message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
                        self.saveComplete()
                    }))
                    self.present(alert, animated: true , completion: nil)
                }
            }
        }
    }
    
    /*
        This method is called after the save process completes.
     */
    func saveComplete() {
        self.delegate?.scanReceiptDelegate(newFood: self.foodList)
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
        This method is to determine the numher of section for the table view.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /*
        This method is to determine the number of rows in each section.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var index = 0
        for array in receiptDetail! {
            if (array as AnyObject).count == 0 {
                receiptDetail?.remove(at: index)
                index = index - 1
            }
            index = index + 1
        }
        return foodList.count
    }

    /*
        This method is to initiate the view for each cell.
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell
            //var locationId : Int?
            cell.segmentButton.isUserInteractionEnabled = false
            cell.segmentButton.tintColor = UIColor.lightGray
            print(foodList.count)
            let foodItem = foodList[indexPath.row]
            cell.nameLabel.text = foodItem.foodName
            cell.priceLabel.text =  "$ " + String(format: "%.2f",(foodItem.price)!)
            let expiry = foodItem.expire?.toString(dateFormat: "MM-dd-yyyy")
            cell.dateLabel.text = expiry
            if indexPath.row == selectedIndex {
                cell.segmentButton.selectedSegmentIndex = foodList[indexPath.row].locationId!
            }
            let categoryNumber = foodItem.categoryId!
            switch foodItem.locationId {
                case 2:
                    cell.segmentButton.selectedSegmentIndex = 0
                case 3:
                    cell.segmentButton.selectedSegmentIndex = 1
                default:
                    cell.segmentButton.selectedSegmentIndex = 2
            }
            switch categoryNumber {
            case 1:
                cell.categoryLabel.image = UIImage(named: "Meat-50px")
            case 2:
                cell.categoryLabel.image = UIImage(named: "Fruit-50px")
            case 3:
                cell.categoryLabel.image = UIImage(named: "seafood-50px")
            case 4:
                cell.categoryLabel.image = UIImage(named: "milk-50px")
            case 5:
                cell.categoryLabel.image = UIImage(named: "cheese-50px")
            case 6:
                cell.categoryLabel.image = UIImage(named: "vegetable-50px")
            case 7:
                cell.categoryLabel.image = UIImage(named: "beverage-50px")
            case 8:
                cell.categoryLabel.image = UIImage(named: "bread-50px")
            case 9:
                cell.categoryLabel.image = UIImage(named: "protein-50px")
            default:
                cell.categoryLabel.image = UIImage(named: "others-50px")
            }
            if cell.contentView.subviews.count < 8 {
                cell.contentView.backgroundColor = UIColor.clear
                let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 120))
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
        This method is to determine the height for the cells.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140.0
    }

    
    /*
        This method is to determine whether the cells are editable.
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    /*
        This method is to manage the action when the users tap the cell.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: {self.home?.dismiss(animated: false, completion: nil)})
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            selectedIndex = indexPath.row
            self.selectedFood = self.foodList[indexPath.row]
            self.performSegue(withIdentifier: "ReceiptItemSegue", sender: nil)
        }
    }
    
    /*
        This method is to determine the edit mode for the users.
     */
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Detail", handler: { (action, indexPath) in
            self.selectedFood = self.foodList[indexPath.row]
            self.selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "ReceiptItemSegue", sender: nil)
        })
        editAction.backgroundColor = UIColor(red: 22/255, green: 135/255, blue: 255/255, alpha: 1.0)
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.foodList.remove(at: indexPath.row)
            self.receiptDetail?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if self.foodList.count == 0{
                self.navigationController?.popViewController(animated: true)
            }
            else {
                self.tableView.reloadData()
            }
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }

    /*
        This method is to initial the controller for the launched segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReceiptItemSegue" {
            let controller: FoodDetailViewController = segue.destination as! FoodDetailViewController
            controller.food = self.selectedFood
            controller.home = self.home
            controller.segueName = "ReceiptItemSegue"
            controller.categoryList = self.categoryList
            controller.delegate = self
        }
    }
    
    /*
        This method is to upload the receipt result into the database.
     */
    func uploadReceipt(foodId:String,userId:String,cateId:String,locationId:String,foodName:String,start:String,price:String,expire:String,keyword:String) {
        let urlString = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/addfoodwithidandkeyword?id=" + foodId + "&uid=" + String(userId) + "&cid=" + String(cateId) + "&lid=" + String(locationId) + "&name=" + foodName.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "%", with: "") + "&start=" + start + "&price=" + price + "&expire=" + expire + "&keyword=" + keyword
        guard let postUrl = URL(string: urlString ) else { return}
        var postRequest = URLRequest(url: postUrl)
        postRequest.httpMethod = "POST"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postSession = URLSession.shared
        
        let task = postSession.dataTask(with: postRequest, completionHandler:
        { (data: Data?, response: URLResponse?, error: Error?) in
            if let response = response as? HTTPURLResponse{
                DispatchQueue.main.async {
                    do {
                        _ = try JSONSerialization.jsonObject(with: data!, options: [])
                        self.foodIdDelegate?.nextFoodIdDelegate(foodId: self.nextFoodId!)
                    }
                    catch {
                        if response.statusCode == 200 {
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
}

extension Date {
    // convert date to string
    func toString(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = dateFormat
        return formatter.string(from: yourDate!)
    }
}
