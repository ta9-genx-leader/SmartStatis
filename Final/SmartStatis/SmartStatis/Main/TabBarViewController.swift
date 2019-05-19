//
//  TabBarViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/1.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the tab bar controller.
 */
class TabBarViewController: UITabBarController {
    var hour = 18
    var minute = 0
    var selectedNumberForMemebr = 0
    var numberOfMember: [String: Any]?
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
    var dataArray = [[String: AnyObject]]()
    var report: [[String: Any]]?
    var personReport: [String: Any]?
    var categoryReport: [String: Any]?
    /*
        This method is to initiate the view when the view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "household") != nil{
            selectedNumberForMemebr = Int(defaults.string(forKey: "household")!)!
        } else {
            defaults.set("0", forKey: "household")
        }
        if defaults.string(forKey: "hour") != nil {
            hour = Int(defaults.string(forKey: "hour")!)!
        }
        else {
            defaults.set("18", forKey: "hour")
        }
        if defaults.string(forKey: "minute") != nil {
            minute = Int(defaults.string(forKey: "minute")!)!
        }
        else {
            defaults.set("00", forKey: "minute")
        }
        getReportData()
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
    /*
        This method is to download data from the database.
     */
    func loadData() {
        shopping = [Food]()
        let userId = currentUser!.userId! as Int
        let foodURL = HttpUrl().getShoppingFoodByUid + "?id=" + String(userId)
        guard let url = URL(string: foodURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let formatter = DateConverter()
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    for food in json! {
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
    
    /*
     This method is to get report data from API.
     */
    func getNextFoodId() {
        let foodURL = HttpUrl().getNextFoodId
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
    
    /*
        This function is to update the internal data loacted in the tab bar controller.
     */
    func updateTabBar() {
        let viewControllers = self.viewControllers
        let navController = viewControllers![3] as! UINavigationController
        let reportViewController = navController.children.first as! SummaryController
        reportViewController.tabBar = self
        reportViewController.viewWillAppear(true)
    }
    
    /*
        This function is to update notification.
     */
    func updateNotification() {
        let viewControllers = self.viewControllers
        let navController = viewControllers![0] as! UINavigationController
        let homeController = navController.children.first as! HomePageController
        homeController.checkFoodDateForNotification()
    }
    
    /*
        This method is to get data for report section.
     */
    func getReportData() {
        let reportURL = HttpUrl().getReportData
        guard let url = URL(string: reportURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    self.report = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    self.personReport = self.report![0]
                    self.numberOfMember = self.report![3]
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    /*
        This method is to handle the action when a tab is tapped.
     */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let navController = viewControllers![3] as! UINavigationController
        navController.popToRootViewController(animated: false)
    }
    
    /*
     This method is to search videos for the recipe from Youtube.
     */
    func search(keyword:String) {
        let videoType = keyword.replacingOccurrences(of: " ", with: "+")
        let apiKey = HttpUrl().youtubeApiKey
        var urlString = HttpUrl().getYoutubeUrl(videoType: videoType, apiKey: apiKey)
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        let targetURL = URL(string: urlString)
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: targetURL!) {
            data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Video Not Found", message: "Please try agian.", preferredStyle: .alert)
                self.present(alert, animated: true)
                return
            }
            else {
                do {
                    typealias JSONObject = [String:AnyObject]
                    let  json = try JSONSerialization.jsonObject(with: data!, options: []) as! JSONObject
                    let
                    items = json["items"] as! Array<JSONObject>
                    if items.count  != 0 {
                        for i in 0 ..< items.count {
                            let snippetDictionary = items[i]["snippet"] as! JSONObject
                            // Initialize a new dictionary and store the data of interest.
                            var youVideoDict = JSONObject()
                            youVideoDict["title"] = snippetDictionary["title"]
                            youVideoDict["channelTitle"] = snippetDictionary["channelTitle"]
                            youVideoDict["thumbnail"] = ((snippetDictionary["thumbnails"] as! JSONObject)["high"] as! JSONObject)["url"]
                            youVideoDict["videoID"] = (items[i]["id"] as! JSONObject)["videoId"]
                            self.dataArray.append(youVideoDict)
                        }
                    }
                    else {
                        
                    }
                }
                catch {
                    print("json error: \(error)")
                }
            }
        }
        task.resume()
    }
}
