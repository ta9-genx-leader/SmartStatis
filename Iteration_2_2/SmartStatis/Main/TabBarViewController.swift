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
    /*
        This method is to initiate the view when the view is loaded into memory.
     */
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
        search(keyword: "recipe")
    }
    /*
        This method is to download data from the database.
     */
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
        This method is to get next food ID (primary key) in the database.
     */
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
    
    /*
     This method is to search videos for the recipe from Youtube.
     */
    func search(keyword:String) {
        let videoType = keyword.replacingOccurrences(of: " ", with: "+")
        let apiKey = "AIzaSyDSqPMGrUCyPyrZWSkCSABN6cgsU9EaH2I"
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(videoType)&type=video&videoSyndicated=true&chart=mostPopular&maxResults=15&safeSearch=strict&order=relevance&order=viewCount&type=video&relevanceLanguage=en&regionCode=AU&key=\(apiKey)"
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
