//
//  SettingTableViewController.swift
//  SmartStatis
//
//  Created by Jerry Tang on 2019/4/4.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

/*
 This class is to create the main pages for the SmartStatis. 
 */
class MainViewController: UIViewController {

    @IBOutlet weak var FridgeButtonOutlet: UIButton!
    var currentUser: User?
    var userId : Int?
    var bin = [Food]()
    var fridge = [Food]()
    var freezer = [Food]()
    var pantry = [Food]()
    var expiredFood = [Food]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        FridgeButtonOutlet.layer.shadowColor = UIColor.darkGray.cgColor
        FridgeButtonOutlet.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        FridgeButtonOutlet.layer.shadowOpacity = 0.8
        FridgeButtonOutlet.layer.shadowRadius = 2
        let tabBar = tabBarController as! TabBarViewController
        userId = tabBar.currentUser?.userId
        let foodURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getfoodbyuid?id=" + String(userId!)
        guard let url = URL(string: foodURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    for food in json! {
                        var expire: Date?
                        if !(food["expiredate"] is NSNull) {
                            expire = self.dateFormatter(dateString: food["expiredate"] as! String)
                        }
                        let oneFood = Food(foodId: food["foodid"] as? Int, userId: food["uid"] as? Int, categoryId: food["cid"] as? Int, locationId: food["lid"] as? Int, foodName: food["foodname"] as? String, start: self.dateFormatter(dateString: food["startdate"] as! String) , expire: expire,price: food["price"] as? Double)
                        switch oneFood.locationId {
                        case 1:
                            self.bin.append(oneFood)
                        case 2:
                            self.fridge.append(oneFood)
                        case 3:
                            self.freezer.append(oneFood)
                        case 4:
                            self.pantry.append(oneFood)
                        default:
                            return
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    func dateFormatter(dateString:String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: dateString)
        return date!
    }

    
    /*
        This class is to prepare the action before a segue is launched to the other controllers.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier  {
        case "FridgeSegue":
            let controller: FridgeTableViewController = segue.destination as!FridgeTableViewController
            controller.fridgeFood = fridge
        case "FreezerSegue":
            let controller: FreezerTableViewController = segue.destination as!FreezerTableViewController
            controller.freezerFood = freezer
        case "PantrySegue":
            let controller: PantryTableViewController = segue.destination as!PantryTableViewController
            controller.pantryFood = pantry
        default:
            print("Error location.")
        }
    }
}

/*
    This extension is to help the format of an UIImage object.
 */
extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var squared: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
