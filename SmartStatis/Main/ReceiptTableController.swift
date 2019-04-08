//
//  ReceiptTableController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/7.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol ScanReceiptDelegate {
    func scanReceiptDelegate(scanned:Bool)
}
/*
    This class is to layout receipt table view.
 */
class ReceiptTableController: UITableViewController,EditFoodDelegate {
    func editFood(food: Food) {
        foodList[selectedIndex!] = food
        self.tableView.reloadData()
    }
    var scanReceiptDelegate: ScanReceiptDelegate?
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    var requestStatus = false
    var receiptDetail: Array<Any>?
    var selectedFood: Food?
    var selectedIndex: Int?
    var uid: Int?
    var foodList = [Food]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
    }

    /*
        This method save the food from the receipts.
     */
    @objc func save() {
        DispatchQueue.main.async {
            for i in 0...self.foodList.count - 1 {
                let newName = self.foodList[i].foodName
                let newUserId = self.foodList[i].userId
                let newCateId = self.foodList[i].categoryId
                let newLocatId = self.foodList[i].locationId! + 2
                let newStart = self.foodList[i].start
                let newExpire = self.foodList[i].expire
                let newPrice = self.foodList[i].price
                self.uploadReceipt(userId: String(newUserId!), cateId: String(newCateId!), locationId: String(newLocatId), foodName: newName!, start: (newStart?.toString(dateFormat: "yyyy-MM-dd"))!, price: String(format: "%.1f",(newPrice!)), expire: (newExpire?.toString(dateFormat: "yyyy-MM-dd"))!)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

    /*
        This method is to set the number of sections in the view.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /*
    This method is to set the number of sections in the view.
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (receiptDetail?.count)!
    }

    /*
    This method is to set the number of sections in the view.
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if foodList.count < (receiptDetail?.count)!{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell
            cell.segmentButton.isUserInteractionEnabled = false
            cell.segmentButton.isEnabled = false
            let dateFormat = DateConverter()
            var categoryId : Int?
            var locationId : Int?
            let foodItem = receiptDetail![indexPath.row] as! NSDictionary
            cell.nameLabel.text = foodItem["Item"] as? String
            cell.priceLabel.text = "$" + String(foodItem["price"] as! Double)
            let expiry = Calendar.current.date(byAdding:.day,value: foodItem["expiry days"] as! Int,to: Date())
            let expiryString = dateFormat.dateConvertString(date: expiry!)
            cell.dateLabel.text = expiryString
            let categoryString = foodItem["category"] as! String
            switch categoryString.uppercased() {
            case "MEAT":
                categoryId = 1
                locationId = 1
                cell.segmentButton.selectedSegmentIndex = 1
                cell.categoryLabel.image = UIImage(named: "Meat-50px")
            case "FRUIT":
                categoryId = 2
                locationId = 0
                cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "Fruit-50px")
            case "SEAFOOD":
                categoryId = 3
                locationId = 1
                cell.segmentButton.selectedSegmentIndex = 1
                cell.categoryLabel.image = UIImage(named: "seafood-50px")
            case "DAIRY":
                categoryId = 4
                locationId = 0
                cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "milk-50px")
            case "DAIRY_PRODUCT":
                categoryId = 5
                locationId = 0
                cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "cheese-50px")
            case "VEGETABLE":
                categoryId = 6
                locationId = 0
                cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "vegetable-50px")
            case "BEVERAGE":
                categoryId = 7
                locationId = 2
                cell.segmentButton.selectedSegmentIndex = 2
                cell.categoryLabel.image = UIImage(named: "beverage-50px")
            case "BAKERY":
                categoryId = 8
                locationId = 2
                cell.segmentButton.selectedSegmentIndex = 2
                cell.categoryLabel.image = UIImage(named: "bread-50px")
            case "PROTEIN":
                categoryId = 9
                locationId = 0
                cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "protein-50px")
            default:
                categoryId = 10
                locationId = 2
                cell.segmentButton.selectedSegmentIndex = 2
                cell.categoryLabel.image = UIImage(named: "others-50px")
            }
            let newFood = Food(foodId: 0, userId: uid, categoryId: categoryId, locationId: locationId, foodName: foodItem["Item"] as? String, start: Date(), expire: expiry, price: foodItem["price"] as? Double)
            foodList.append(newFood)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! ReceiptCell
            cell.segmentButton.isUserInteractionEnabled = false
            cell.segmentButton.isEnabled = false
            //var locationId : Int?
            cell.segmentButton.isUserInteractionEnabled = true
            let foodItem = foodList[indexPath.row]
            cell.nameLabel.text = foodItem.foodName
            cell.priceLabel.text =  String(format: "%.1f",(foodItem.price)!)
            let expiry = foodItem.expire?.toString(dateFormat: "MM-dd-yyyy")
            cell.dateLabel.text = expiry
            if indexPath.row == selectedIndex {
                cell.segmentButton.selectedSegmentIndex = foodList[indexPath.row].locationId!
            }
            let categoryNumber = foodItem.categoryId!
            ////
            switch categoryNumber {
            case 1:
                //cell.segmentButton.selectedSegmentIndex = 1
                cell.categoryLabel.image = UIImage(named: "Meat-50px")
            case 2:
                //cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "Fruit-50px")
            case 3:
                //cell.segmentButton.selectedSegmentIndex = 1
                cell.categoryLabel.image = UIImage(named: "seafood-50px")
            case 4:
                //cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "milk-50px")
            case 5:
                //cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "cheese-50px")
            case 6:
                //cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "vegetable-50px")
            case 7:
                //cell.segmentButton.selectedSegmentIndex = 2
                cell.categoryLabel.image = UIImage(named: "beverage-50px")
            case 8:
                //cell.segmentButton.selectedSegmentIndex = 2
                cell.categoryLabel.image = UIImage(named: "bread-50px")
            case 9:
                //cell.segmentButton.selectedSegmentIndex = 0
                cell.categoryLabel.image = UIImage(named: "protein-50px")
            default:
                //cell.segmentButton.selectedSegmentIndex = 2
                cell.categoryLabel.image = UIImage(named: "others-50px")
            }
            return cell
        }
    }
    
    /*
     This method is to set the layout in the view.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140.0
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            self.selectedFood = self.foodList[indexPath.row]
            self.selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "EditFoodSegue", sender: nil)
        })
        editAction.backgroundColor = UIColor(red: 22/255, green: 135/255, blue: 255/255, alpha: 1.0)
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.foodList.remove(at: indexPath.row)
            self.receiptDetail?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    
    /*
        This method is to set the number of sections in the view.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFoodSegue" {
            let controller: EditFoodViewController = segue.destination as! EditFoodViewController
            controller.editFood = self.selectedFood
            controller.uid = self.uid
            controller.editFoodDelegate = self
        }
    }
    
    /*
        This method is to upload receipt.
     */
    func uploadReceipt(userId:String,cateId:String,locationId:String,foodName:String,start:String,price:String,expire:String) {
        guard let postUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/addfood?uid=" + String(userId) + "&cid=" + String(cateId) + "&lid=" + String(locationId) + "&name=" + foodName.replacingOccurrences(of: " ", with: "_") + "&start=" + start + "&price=" + price + "&expire=" + expire ) else { return}
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
    
    /*
        Start animation.
     */
    func startProcessing() {
        self.tableView.isHidden = true
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
    }
    
    /*
        Stop animation.
     */
    func stopProcessing() {
        self.tableView.isHidden = false
        processing.stopAnimating()
        self.viewWillAppear(true)
    }
}

