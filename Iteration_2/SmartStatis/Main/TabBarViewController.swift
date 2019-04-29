//
//  TabBarViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/1.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var categoryList : [String]?
    var foodFromShopToStore: Food?
    var nextFoodId: Int?
    var currentUser: User?
    var fridge: [Food]?
    var freezer: [Food]?
    var pantry: [Food]?
    var bin: [Food]?
    var shopping = [Food]()
    var bestStoreTemp: Int = 30
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBar.tintColor = UIColor.darkGray // Selected tab color
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
        self.tabBar.barTintColor = UIColor(red: 200/255, green: 229/255, blue: 199/255, alpha: 1.0) /* #c8e5c7 */
        let topBorder = CALayer()
        topBorder.borderColor = UIColor.darkGray.cgColor;
        topBorder.borderWidth = 1;
        topBorder.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.width, height: 1)
        tabBar.layer.addSublayer(topBorder)
        
        
        loadData()
        getNextFoodId()
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    func test() {
        print("tab")
    }
    
    func loadData() {
        shopping = [Food]()
        let userId = currentUser!.userId as! Int
        let foodURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getshoppingfoodbyuid?id=" + String(userId)
        guard let url = URL(string: foodURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let formatter = DateConverter()
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    for food in json! {
                        print(food)
                        var expire: Date?
                        if !(food["expiredate"] is NSNull) {
                            expire = formatter.dateFormatter(dateString: food["expiredate"] as! String)
                        }
                        var keyword = ""
                        if food["keyword"] != nil {
                            keyword = food["keyword"] as! String
                        }
                        let oneFood = Food(foodId: food["foodid"] as? Int, userId: food["uid"] as? Int, categoryId: food["cid"] as? Int, locationId: food["lid"] as? Int, foodName: food["foodname"] as? String, start: formatter.dateFormatter(dateString: food["startdate"] as! String) , expire: expire,price: food["price"] as? Double, quantity: food["quantity"] as? String, completion: food["complete_Percent"] as? Int, keyword: keyword)
                        self.shopping.append(oneFood)
                    }
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    func getNextFoodId() {
        let foodURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getnexyfoodid"
        guard let url = URL(string: foodURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    self.nextFoodId = json![0]["Auto_increment"] as? Int
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
}
