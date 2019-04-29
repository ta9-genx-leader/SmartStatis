//
//  SettingTableViewController.swift
//  SmartStatis
//
//  Created by Jerry Tang on 2019/4/4.
//  Copyright © 2019 GenX Leader. All rights reserved.
//


import UIKit
protocol PantryDelegate {
    func updatePantry(food:[Food])}
/*
 This class is to create the table view for pantry.
 */
class PantryTableViewController: UITableViewController,AddFoodDelegate {
    
    /*
        This function is to add a new food into the application.
    */
    func addFood(updated: Bool) {
        if updated {
            let foodURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getfoodbyuidandlocation?id=" + String(uid!) + "&lid=4"
            guard let url = URL(string: foodURL) else { return}
            let session = URLSession.shared
            session.dataTask(with: url){(data,response,error) in
                if let data = data{
                    do {
                        self.pantryFood = [Food]()
                        let formatter = DateConverter()
                        let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                        for food in json! {
                            var expire: Date?
                            if !(food["expiredate"] is NSNull) {
                                expire = formatter.dateFormatter(dateString: food["expiredate"] as! String)
                            }
                            let oneFood = Food(foodId: food["foodid"] as? Int, userId: food["uid"] as? Int, categoryId: food["cid"] as? Int, locationId: food["lid"] as? Int, foodName: food["foodname"] as? String, start: formatter.dateFormatter(dateString: food["startdate"] as! String) , expire: expire,price: food["price"] as? Double)
                            self.pantryFood.append(oneFood)
                        }
                        DispatchQueue.main.async {
                            self.pantryFood = self.pantryFood.sorted(by:{ $0.expire! < $1.expire! })
                            self.pantryDelegate?.updatePantry(food: self.pantryFood)
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
    var pantryDelegate: PantryDelegate?
    var pantryFood = [Food]()
    override func viewDidLoad() {
        super.viewDidLoad()
        pantryFood = pantryFood.sorted(by:{ $0.expire! < $1.expire! })
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"Add-30px"), style: .plain, target: self, action: #selector(addFoodButton))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 81/255, green: 142/255, blue: 247/255, alpha: 1.0)
    }
    

    /*
        This method is to identify the number of sections in a table view.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /*
        This method is to identify the number of rows in each section.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else
        {
            return self.pantryFood.count
        }
    }
    
    /*
        This method is to identify the cell for each row at different section.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TotalItemCell", for: indexPath) as! TotalItemCell
            var good = 0
            var normal = 0
            var expire = 0
            if pantryFood.count > 0 {
                for i in 0...pantryFood.count-1 {
                    //let expiry = Calendar.current.date(byAdding:.day,value: foodItem["expiry days"] as! Int,to: Date())
                    if pantryFood[i].expire! < Date() {
                        expire = expire + 1
                    }
                    else if pantryFood[i].expire! >= Date() && pantryFood[i].expire! < Calendar.current.date(byAdding:.day,value: 2,to: Date())! {
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
            cell.nameLabel.text = pantryFood[indexPath.row].foodName
            cell.dateLabel.text = dateFormat.dateConvertString(date: pantryFood[indexPath.row].expire!)
            cell.priceLabel.text = String(pantryFood[indexPath.row].price!)
            switch pantryFood[indexPath.row].categoryId {
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
            if pantryFood[indexPath.row].expire! < Date() {
                cell.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 239/255, alpha: 1.0)
            }
            else if pantryFood[indexPath.row].expire! >= Date() && pantryFood[indexPath.row].expire! < Calendar.current.date(byAdding:.day,value: 2,to: Date())! {
                cell.backgroundColor = UIColor(red: 245/255, green: 239/255, blue: 255/255, alpha: 1.0)
            }
            else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
    }
    
    /*
        This method is to set the height for the rows.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 40
        }
        return 100.0
    }
    
    /*
        This method is to set the delete button on the side of each row.
     */
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Bin", handler: { (action, indexPath) in
            self.deleteFood(foodId: self.pantryFood[indexPath.row].foodId)
            self.pantryFood.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.pantryDelegate?.updatePantry(food: self.pantryFood)
            self.tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    /*
        This method is to set actions before a segue is launched.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddFoodSegue" {
            let controller: FoodDetailController = segue.destination as! FoodDetailController
            controller.food = pantryFood
            controller.uid = uid!
            controller.addFoodDelegate = self
        }
    }
    
    /*
        This method is to launch AddFoodSegue.
     */
    @objc func addFoodButton() {
        self.performSegue(withIdentifier: "AddFoodSegue", sender: nil)
    }
}
