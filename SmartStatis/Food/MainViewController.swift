//
//  MainViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/3/31.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

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
        
//        FridgeButtonOutlet.layer.shadowColor = UIColor.black.cgColor
//        FridgeButtonOutlet.layer.shadowOffset = CGSize(width: 5, height: 5)
//        FridgeButtonOutlet.layer.shadowRadius = 5
//        FridgeButtonOutlet.layer.shadowOpacity = 1.0
        
//        FridgeButtonOutlet.backgroundColor = UIColor(red: 171, green: 178, blue: 186, alpha: 1.0)
//        // Shadow and Radius
//        FridgeButtonOutlet.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        FridgeButtonOutlet.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        FridgeButtonOutlet.layer.shadowOpacity = 1.0
//        FridgeButtonOutlet.layer.shadowRadius = 0.0
//        FridgeButtonOutlet.layer.masksToBounds = false
//        FridgeButtonOutlet.layer.cornerRadius = 4.0
        
        FridgeButtonOutlet.layer.shadowColor = UIColor.darkGray.cgColor
        FridgeButtonOutlet.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        FridgeButtonOutlet.layer.shadowOpacity = 0.8
        FridgeButtonOutlet.layer.shadowRadius = 2
        
        
        let tabBar = tabBarController as! TabBarViewController
        userId = tabBar.currentUser?.userId
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action:#selector(logOut))
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
        
        // Do any additional setup after loading the view.
    }
    
//    @objc func logOut() {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func dateFormatter(dateString:String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: dateString)
        return date!
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier  {
        case "BinSegue":
            let controller: BinTableViewController = segue.destination as! BinTableViewController
            controller.expireFood = bin
        case "FridgeSegue":
            let controller: FridgeTableViewController = segue.destination as!FridgeTableViewController
            controller.fridgeFood = fridge
        //case "FreezerSegue"
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


// stakeOverFlow
