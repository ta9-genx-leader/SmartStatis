//
//  FreezerTableViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/2.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol FreezerDelegate {
    func updateFreezer(food:[Food])}
class FreezerTableViewController: UITableViewController,AddFoodDelegate {
    func addFood(updated: Bool) {
        if updated {
            let foodURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getfoodbyuidandlocation?id=" + String(uid!) + "&lid=3"
            guard let url = URL(string: foodURL) else { return}
            let session = URLSession.shared
            session.dataTask(with: url){(data,response,error) in
                if let data = data{
                    do {
                        self.freezerFood = [Food]()
                        let formatter = DateConverter()
                        let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                        for food in json! {
                            var expire: Date?
                            if !(food["expiredate"] is NSNull) {
                                expire = formatter.dateFormatter(dateString: food["expiredate"] as! String)
                            }
                            let oneFood = Food(foodId: food["foodid"] as? Int, userId: food["uid"] as? Int, categoryId: food["cid"] as? Int, locationId: food["lid"] as? Int, foodName: food["foodname"] as? String, start: formatter.dateFormatter(dateString: food["startdate"] as! String) , expire: expire,price: food["price"] as? Double)
                            self.freezerFood.append(oneFood)
                        }
                        DispatchQueue.main.async {
                            self.freezerFood = self.freezerFood.sorted(by:{ $0.expire! < $1.expire! })
                            self.freezerDelegate?.updateFreezer(food: self.freezerFood)
                            self.tableView.reloadData()
                        }
                    }
                    catch{
                        print(error)
                    }
                }
                }.resume()
        }
    }
    
    var uid: Int?
    var freezerDelegate: FreezerDelegate?
    var freezerFood = [Food]()
    override func viewDidLoad() {
        super.viewDidLoad()
        freezerFood = freezerFood.sorted(by:{ $0.expire! < $1.expire! })
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Add-30px"), style: .plain, target: self, action: #selector(addFoodButton))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 81/255, green: 142/255, blue: 247/255, alpha: 1.0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else
        {
            return self.freezerFood.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalItemCell", for: indexPath) as! TotalItemCell
            var good = 0
            var normal = 0
            var expire = 0
            if freezerFood.count > 0 {
                for i in 0...freezerFood.count-1 {
                    //let expiry = Calendar.current.date(byAdding:.day,value: foodItem["expiry days"] as! Int,to: Date())
                    if freezerFood[i].expire! < Date() {
                        expire = expire + 1
                    }
                    else if freezerFood[i].expire! >= Date() && freezerFood[i].expire! < Calendar.current.date(byAdding:.day,value: 2,to: Date())! {
                        normal = normal + 1
                    }
                    else {
                        good = good + 1
                    }
                }
            }
            cell.goodFood.text = String(good)
            cell.normalFood.text = String(normal)
            cell.expireFood.text = String(expire)
            return cell
        }
        else {
            let dateFormat = DateConverter()
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
            cell.nameLabel.text = freezerFood[indexPath.row].foodName
            cell.dateLabel.text = dateFormat.dateConvertString(date: freezerFood[indexPath.row].expire!)
            cell.priceLabel.text = String(freezerFood[indexPath.row].price!)
            switch freezerFood[indexPath.row].categoryId {
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
            if freezerFood[indexPath.row].expire! < Date() {
                cell.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 239/255, alpha: 1.0)
            }
            else if freezerFood[indexPath.row].expire! >= Date() && freezerFood[indexPath.row].expire! < Calendar.current.date(byAdding:.day,value: 2,to: Date())! {
                cell.backgroundColor = UIColor(red: 245/255, green: 239/255, blue: 255/255, alpha: 1.0)
            }
            else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 40
        }
        return 100.0
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
//        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
//            print("Edit tapped")
//        })
//        editAction.backgroundColor = UIColor(red: 22/255, green: 135/255, blue: 255/255, alpha: 1.0)
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Bin", handler: { (action, indexPath) in
            self.deleteFood(foodId: self.freezerFood[indexPath.row].foodId)
            self.freezerFood.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.freezerDelegate?.updateFreezer(food: self.freezerFood)
            self.tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddFoodSegue" {
            let controller: FoodDetailController = segue.destination as! FoodDetailController
            controller.food = freezerFood
            controller.uid = uid!
            controller.addFoodDelegate = self
        }
    }
    
    @objc func addFoodButton() {
        self.performSegue(withIdentifier: "AddFoodSegue", sender: nil)
    }
}
