//
//  HomePageController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/13.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import UserNotifications
/*
    This class is to manage the view for Home tab.
 */
class HomePageController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIPopoverPresentationControllerDelegate,FoodDetailDelegate,PopOverDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, NewFoodlDelegate,ScanReceiptDelegate,NextFoodIdDelegate {
    var dataloaded = false
    var nextFoodId: Int?
    var categoryList = [String]()
    var receiptData: NSArray?
    var photo : UIImage?
    var selectedIndex = -1
    var selectFood: Food?
    var currentUser: User?
    var totalFood = [Food]()
    var showList = [Food]()
    var fridge = [Food]()
    var freezer = [Food]()
    var pantry = [Food]()
    var bin = [Food]()
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    // Manage the action when the segment is changed.
    @IBAction func segmentAction(_ sender: Any) {
        switch segmentOutlet.selectedSegmentIndex  {
        case 0:
            showList = fridge
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
        case 1:
            showList = freezer
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
        default:
            showList = pantry
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
        }
        tableView.reloadData()
    }
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addAction(_ sender: Any) {
        performSegue(withIdentifier: "PopOverSegue", sender: self)
    }
    
    /*
        This method is to manage NextFoodIdDelegate
     */
    func nextFoodIdDelegate(foodId: Int) {
        nextFoodId = foodId
        let tabBar = tabBarController as! TabBarViewController
        tabBar.nextFoodId = foodId
    }
   
    /*
        This method is to register a tap guesture into the view.
     */
    func tapOnView() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tapAction))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /*
        This method is to determine the tap action for the recongizer.
     */
    @objc func tapAction() {
        self.view.endEditing(true)
    }
    
    /*
        This method is to initiate the notification for the expiry date.
     */
    func checkFoodDateForNotification() {
        let expiryTitle = "1 day already expired: "
        let almostExpireTitle = "1 day will be expired : "
        var finalBody = ""
        let dateFormat = DateConverter()
        var expiryNumberFridge = 0
        var expiryNumberFreezer = 0
        var expiryNumberPantry = 0
        var almostExpiryFridge = 0
        var almostExpiryFreezer = 0
        var almostExpiryPantry = 0
        for food in fridge {
            let dayNumber = dateFormat.numberOfDays(firstDate: Date(), secondDate: food.expire!)
            if dayNumber == -1 {
                expiryNumberFridge = expiryNumberFridge + 1
            }
            else if dayNumber <= 2 {
                almostExpiryFridge = almostExpiryFridge + 1
            }
        }
        for food in freezer {
            let dayNumber = dateFormat.numberOfDays(firstDate: Date(), secondDate: food.expire!)
            if dayNumber == -1 {
                expiryNumberFreezer = expiryNumberFreezer + 1
            }
            else if dayNumber == 1 {
                almostExpiryFreezer = almostExpiryFreezer + 1
            }
        }
        for food in pantry {
            let dayNumber = dateFormat.numberOfDays(firstDate: Date(), secondDate: food.expire!)
            if dayNumber == -1 {
                expiryNumberPantry = expiryNumberPantry + 1
            }
            else if dayNumber == 1 {
                almostExpiryPantry = almostExpiryPantry + 1
            }
        }
        let finalExpiryNumber = expiryNumberFridge + expiryNumberFreezer + expiryNumberPantry
        if finalExpiryNumber != 0 {
            finalBody = finalBody + expiryTitle + String(finalExpiryNumber) + " item"
        }
        let finalAlmostNumber = almostExpiryFridge + almostExpiryFreezer + almostExpiryPantry
        if finalAlmostNumber != 0 {
            finalBody = finalBody + "\r\n" + almostExpireTitle + String(finalAlmostNumber) + " item"
        }
        if !finalBody.isEmpty {
            sentNotitfication(title: "Food Storage Notification", body: finalBody)
        }
    }
    
    /*
        This method is to launch the the notifiaction when the time is triggered.
     */
    func sentNotitfication(title:String,body:String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let date = DateComponents(hour: 18, minute: 46)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
        })
    }
    
    /*
        This method is to manage ScanReceiptDelegate action.
     */
    func scanReceiptDelegate(newFood: [Food]) {
            showList = [Food]()
            totalFood = [Food]()
            fridge = [Food]()
            freezer = [Food]()
            pantry = [Food]()
            bin = [Food]()
            downloadData()
    }
    
    /*
        This method is to add new food into the local device.
     */
    func addFood(food: Food) {
        let userId = String(currentUser!.userId!)
        let price = String(format:"%.2f", (food.price!))
        let location = String(food.locationId!)
        let category = String(food.categoryId!)
        let tabBar = tabBarController as! TabBarViewController
        self.addNewFood(userId: userId, cateId:category, locationId: location, foodName: food.foodName!, start: (food.start?.toString(dateFormat: "yyyy-MM-dd"))!, price: price, expire: (food.expire?.toString(dateFormat: "yyyy-MM-dd"))!)
        switch food.locationId {
        case 2:
            fridge.append(food)
            showList = fridge
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
            tabBar.fridge = fridge
        case 3:
            freezer.append(food)
            showList = freezer
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
            tabBar.freezer = freezer
        default:
            pantry.append(food)
            showList = pantry
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
            tabBar.pantry = pantry
        }
        self.tableView.reloadData()
    }
    
    /*
        This method is to manage the photo for the user if the user take photo with camera or pick from local library.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photo = pickedImage
            dismiss(animated: true, completion: {
                self.startProcessing()
                self.tableView.isHidden = false
                let chosenImage = self.photo
                let imageData = chosenImage?.pngData()
                let uploadUrlString = "https://api.imgur.com/3/upload"
                let uploadUrl = URL(string: uploadUrlString)
                var postRequest = URLRequest.init(url: uploadUrl!)
                postRequest.addValue("Client-ID 546c25a59c58ad7", forHTTPHeaderField: "Authorization")
                postRequest.httpMethod = "POST"
                postRequest.httpBody = imageData
                
                let uploadSession = URLSession.shared
                let executePostRequest = uploadSession.dataTask(with: postRequest as URLRequest) { (data, response, error) -> Void in
                    if let response = response as? HTTPURLResponse
                    {
                        print(response.statusCode)
                    }
                    if let data = data
                    {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            let json2 = json["data"] as! [String: Any]
                            let imageUrl = json2["link"] as! String
                            let uploadUrlString = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/receipt/uploadreceipt?url=" + imageUrl
                            guard let uploadUrl = URL(string: uploadUrlString) else { return}
                            let session = URLSession.shared
                            
                            session.dataTask(with: uploadUrl){(data,response,error) in
                                if let data = data{
                                    do {
                                        let json = try  JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                                        self.receiptData = json
                                        if self.receiptData?.count != 0 {
                                            DispatchQueue.main.async {
                                                self.performSegue(withIdentifier: "ReceiptDetailSegue", sender: nil)
                                                self.stopProcessing()
                                            }
                                        }
                                        else {
                                             DispatchQueue.main.async {
                                                let alert = UIAlertController(title: "Fail To Read Receipt", message: "Please try agian.", preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                                self.present(alert, animated: true)
                                                self.stopProcessing()
                                            }
                                        }
                                    }
                                    catch{
                                        DispatchQueue.main.async {
                                            let alert = UIAlertController(title: "Fail To Read Receipt", message: "Please try agian.", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                            self.present(alert, animated: true)
                                            self.stopProcessing()
                                        }
                                    }
                                }
                                }.resume()
                        }
                        catch {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Fail To Read Receipt", message: "Please try agian.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                self.stopProcessing()
                            }
                        }
                    }
                }
                executePostRequest.resume()
            })
        }
    }
    
    /*
        This method is to manage ActionDelegate.
     */
    func actionDelegate(action: String) {
        switch action {
        case "scan":
            if !self.checkWiFi() {
                let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                    self.navigationController?.dismiss(animated: false, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else {
                let controller = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    controller.sourceType = UIImagePickerController.SourceType.camera
                }
                else {
                    controller.sourceType = UIImagePickerController.SourceType.photoLibrary
                }
                controller.allowsEditing = false
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            }
        default:
            if !self.checkWiFi() {
                let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                    self.navigationController?.dismiss(animated: false, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                performSegue(withIdentifier: "AddSegue", sender: self)
            }
        }
    }
    
    /*
        This method is to manage FoodDetail action.
     */
    func foodDetail(edit: Bool, food: Food?) {
        if food == nil && edit == true {
            bin.append(showList[selectedIndex])
            showList.remove(at: selectedIndex)
            switch segmentOutlet.selectedSegmentIndex  {
                case 0:
                    fridge = showList
                case 1:
                    freezer = showList
                default:
                    pantry = showList
            }
            selectedIndex = -1
            let tabBar = tabBarController as! TabBarViewController
            tabBar.bin = self.bin
            tabBar.updateTabBar()
        }
        else {
            showList[selectedIndex] = food!
        }
        segmentOutlet.isUserInteractionEnabled = true
        if food!.locationId! == 1 {
            showList.remove(at: selectedIndex)
            switch segmentOutlet.selectedSegmentIndex {
            case 0:
                fridge.remove(at: selectedIndex)
            case 1:
                freezer.remove(at: selectedIndex)
            default:
                pantry.remove(at: selectedIndex)
            }
            tableView.reloadData()
        }
        else if food!.locationId! - 2 != segmentOutlet.selectedSegmentIndex {
            showList.remove(at: selectedIndex)
            switch segmentOutlet.selectedSegmentIndex {
            case 0:
                fridge = showList
                switch food?.locationId{
                case 3:
                    freezer.append(food!)
                default:
                    pantry.append(food!)
                }
            case 1:
                freezer = showList
                switch food?.locationId{
                case 2:
                    fridge.append(food!)
                default:
                    pantry.append(food!)
                }
            default:
                pantry = showList
                switch food?.locationId{
                case 2:
                    fridge.append(food!)
                default:
                    freezer.append(food!)
                }
            }
        }
        tableView.reloadData()
    }
    
    /*
        This method is to determine the number of section in the table view.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        if showList.count == 0 {
            return 2
        }
        else {
            return 1
        }
    }
    
    /*
        This methdo is to determine the numher of rows in each section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showList.count == 0 {
            switch section {
            case 0:
                tableView.allowsSelection = false
                if UIScreen.main.bounds.height < 580 {
                    return 2
                }
                else {
                    return 3
                }
            default:
                return 1
            }
        }
        else {
            tableView.allowsSelection = true
            tableView.isScrollEnabled = true
           return showList.count
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    /*
        This method is to manage the action when the users tap a row.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        selectFood = showList[indexPath.row]
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "FoodDetailSegue", sender: self)
    }
    
    /*
        This method is to initiate the view for the cell in the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentOutlet.selectedSegmentIndex {
        case 0:
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "fridgeView"))
            self.tableView.backgroundView?.alpha = 0.4
        case 1:
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "iceView"))
            self.tableView.backgroundView?.alpha = 0.4
        default:
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "pantryView"))
            self.tableView.backgroundView?.alpha = 0.4
        }
        if !dataloaded {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as! FoodItemCell
                cell.backgroundColor = UIColor.clear
                cell.categoryImage.image = UIImage()
                cell.informationImage.image = UIImage()
                cell.circleImage.image = UIImage(named: "grey-circle-50px")
                cell.categoryImage.backgroundColor = UIColor.lightGray
                cell.informationImage.backgroundColor = UIColor.lightGray
                cell.categoryImage.setImageRadius()
                cell.statusImage.setImageRadius()
                cell.informationImage.setImageRadius()
                cell.nameLabel.backgroundColor = UIColor.lightGray
                cell.nameLabel.text = "   "
                cell.nameLabel.textColor = UIColor.lightGray
                cell.dayLabel.backgroundColor = UIColor.lightGray
                cell.nameLabel.layer.cornerRadius = 10
                cell.nameLabel.layer.masksToBounds = true
                cell.dayLabel.layer.cornerRadius = 10
                cell.dayLabel.layer.masksToBounds = true
                cell.dayLabel.text = "30 days"
                cell.dayLabel.textColor = UIColor.lightGray
                cell.statusImage.image = UIImage()
                cell.statusImage.backgroundColor = UIColor.lightGray
                if cell.contentView.subviews.count != 8 {
                    cell.contentView.backgroundColor = UIColor.clear
                    let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 100))
                    whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
                    whiteRoundedView.layer.masksToBounds = false
                    whiteRoundedView.layer.cornerRadius = 5.0
                    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                    whiteRoundedView.layer.shadowOpacity = 0.4
                    whiteRoundedView.layer.shadowRadius = 2
                    cell.contentView.addSubview(whiteRoundedView)
                    cell.contentView.sendSubviewToBack(whiteRoundedView)
                }
                cell.contentView.layer.opacity = Float(0.5/(Double(indexPath.row)+1))
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                cell.backgroundColor = UIColor.clear
                switch segmentOutlet.selectedSegmentIndex {
                case 0:
                    cell.cellTitle?.text = "Your fridge is empty!"
                case 1:
                    cell.cellTitle?.text = "Your freezer is empty!"
                default:
                    cell.cellTitle?.text = "Your pantry is empty!"
                }
                return cell
            }
        }
        else if showList.count == 0 {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as! FoodItemCell
                cell.backgroundColor = UIColor.clear
                cell.informationImage.image = UIImage()
                cell.categoryImage.image = UIImage()
                cell.circleImage.image = UIImage(named: "grey-circle-50px")
                cell.categoryImage.backgroundColor = UIColor.lightGray
                cell.informationImage.backgroundColor = UIColor.lightGray
                cell.informationImage.setImageRadius()
                cell.categoryImage.setImageRadius()
                cell.statusImage.setImageRadius()
                cell.nameLabel.backgroundColor = UIColor.lightGray
                cell.nameLabel.text = "   "
                cell.nameLabel.textColor = UIColor.lightGray
                cell.dayLabel.backgroundColor = UIColor.lightGray
                cell.nameLabel.layer.cornerRadius = 10
                cell.nameLabel.layer.masksToBounds = true
                cell.dayLabel.layer.cornerRadius = 10
                cell.dayLabel.layer.masksToBounds = true
                cell.dayLabel.text = "30 days"
                cell.dayLabel.textColor = UIColor.lightGray
                cell.statusImage.image = UIImage()
                cell.statusImage.backgroundColor = UIColor.lightGray
                if cell.contentView.subviews.count != 8 {
                    cell.contentView.backgroundColor = UIColor.clear
                    let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 100))
                    whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
                    whiteRoundedView.layer.masksToBounds = false
                    whiteRoundedView.layer.cornerRadius = 5.0
                    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                    whiteRoundedView.layer.shadowOpacity = Float(0.3/(Double(indexPath.row)+1))
                    whiteRoundedView.layer.shadowRadius = 2
                    cell.contentView.addSubview(whiteRoundedView)
                    cell.contentView.sendSubviewToBack(whiteRoundedView)
                }
                cell.contentView.layer.opacity = Float(0.5/(Double(indexPath.row)+1))
                return cell
            default:
                 let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
                 cell.cellTitle.backgroundColor = UIColor.clear
                 cell.cellBody.backgroundColor = UIColor.clear
                 cell.cellBody.textColor = UIColor.darkGray
                 switch segmentOutlet.selectedSegmentIndex {
                 case 0:
                    cell.cellTitle?.text = "Your fridge is empty!"
                 case 1:
                    cell.cellTitle?.text = "Your freezer is empty!"
                 default:
                    cell.cellTitle?.text = "Your pantry is empty!"
                 }
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodItemCell", for: indexPath) as! FoodItemCell
        cell.contentView.layer.opacity = 1
        cell.categoryImage.layer.shadowRadius = 0
        cell.statusImage.layer.shadowRadius = 0
        cell.nameLabel.text = showList[indexPath.row].foodName?.replacingOccurrences(of: "_", with: " ")
        cell.informationImage.backgroundColor = UIColor.clear
        cell.categoryImage.backgroundColor = UIColor.clear
        cell.statusImage.backgroundColor = UIColor.clear
        cell.nameLabel.backgroundColor = UIColor.clear
        cell.dayLabel.backgroundColor = UIColor.clear
        cell.nameLabel.textColor = UIColor.black
        cell.dayLabel.textColor = UIColor.black
        switch showList[indexPath.row].categoryId  {
        case 1:
            cell.categoryImage.image = UIImage(named: "Meat-50px")
        case 2:
            cell.categoryImage.image = UIImage(named: "Fruit-50px")
        case 3:
            cell.categoryImage.image = UIImage(named: "seafood-50px")
        case 4:
            cell.categoryImage.image = UIImage(named: "milk-50px")
        case 5:
            cell.categoryImage.image = UIImage(named: "cheese-50px")
        case 6:
            cell.categoryImage.image = UIImage(named: "vegetable-50px")
        case 7:
            cell.categoryImage.image = UIImage(named: "beverage-50px")
        case 8:
            cell.categoryImage.image = UIImage(named: "bread-50px")
        case 9:
            cell.categoryImage.image = UIImage(named: "protein-50px")
        default:
            cell.categoryImage.image = UIImage(named: "others-50px")
        }
        let dateFormat = DateConverter()
        let dayNumber = dateFormat.numberOfDays(firstDate: Date(), secondDate: showList[indexPath.row].expire!) as Int
        if dayNumber > 2 {
            cell.dayLabel.text = "Expired in " + String(dayNumber) + " day"
            cell.statusImage.image = UIImage(named: "good-50px")
            cell.circleImage.image = UIImage(named: "blue-circle-50px")
            cell.informationImage.image = UIImage(named: "blue-info-52px")
        }
        else if dayNumber > 0 {
            cell.dayLabel.text = "Expired in " + String(dayNumber) + " day"
            cell.statusImage.image = UIImage(named: "Alarm-50px")
            cell.circleImage.image = UIImage(named: "red-circle-50px")
            cell.informationImage.image = UIImage(named: "red-info-52px")
        }
        else {
            cell.dayLabel.text = "Expired " + String(dayNumber).dropFirst() + " day ago"
            cell.statusImage.image = UIImage(named: "Sad-50px")
            cell.circleImage.image = UIImage(named: "grey-circle-50px")
            cell.informationImage.image = UIImage(named: "grey-info-52px")
        }
        if cell.contentView.subviews.count != 8 {
            cell.contentView.backgroundColor = UIColor.clear
            let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: 100))
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
        This method is to determine the height the for cell.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 180
    }
    
    /*
        This method is to download data from the database.
     */
    func downloadData() {
        self.startProcessing()
        let tabBar = tabBarController as! TabBarViewController
        nextFoodId = tabBar.nextFoodId
        self.currentUser = tabBar.currentUser
        let userId = currentUser!.userId as! Int
        let foodURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getfoodbyuid?id=" + String(userId)
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
                        var oneFood: Food?
                        if keyword != nil {
                            oneFood = Food(foodId: food["foodid"] as? Int, userId: food["uid"] as? Int, categoryId: food["cid"] as? Int, locationId: food["lid"] as? Int, foodName: food["foodname"] as? String, start: formatter.dateFormatter(dateString: food["startdate"] as! String) , expire: expire,price: food["price"] as? Double, quantity: "0", completion: food["complete_Percent"] as? Int, keyword: keyword)
                        }
                        else {
                            oneFood = Food(foodId: food["foodid"] as? Int, userId: food["uid"] as? Int, categoryId: food["cid"] as? Int, locationId: food["lid"] as? Int, foodName: food["foodname"] as? String, start: formatter.dateFormatter(dateString: food["startdate"] as! String) , expire: expire,price: food["price"] as? Double, quantity: "0", completion: food["complete_Percent"] as? Int, keyword: "")
                        }
                        self.totalFood.append(oneFood!)
                        switch oneFood!.locationId {
                        case 1:
                            self.bin.append(oneFood!)
                        case 2:
                            self.fridge.append(oneFood!)
                        case 3:
                            self.freezer.append(oneFood!)
                        case 4:
                            self.pantry.append(oneFood!)
                        default:
                            print(5)
                        }
                    }
                    tabBar.fridge = self.fridge
                    tabBar.freezer = self.freezer
                    tabBar.pantry = self.pantry
                    tabBar.bin = self.bin
                    self.freezer = self.freezer.sorted(by:{ $0.expire! < $1.expire! })
                    self.pantry = self.pantry.sorted(by:{ $0.expire! < $1.expire! })
                    DispatchQueue.main.async {
                        switch self.segmentOutlet.selectedSegmentIndex {
                            case 0:
                            self.showList = self.fridge
                            case 1:
                            self.showList = self.freezer
                            default:
                            self.showList = self.pantry
                        }
                        self.showList = self.showList.sorted(by:{ $0.expire! < $1.expire! })
                        self.dataloaded = true
                        self.tableView.reloadData()
                        self.stopProcessing()
                    }
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
  
    /*
        This method is to initiate the view when it is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.masksToBounds = false
        downloadCategory()
        downloadData()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
    }
    
    /*
        This method is to initiate the view controller for the launched segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PopOverSegue" {
            let controller: PopOverViewController = segue.destination as! PopOverViewController
            let popoverViewController = segue.destination
            popoverViewController.popoverPresentationController!.delegate = self
            controller.delegate = self
        }
        else if segue.identifier == "FoodDetailSegue" {
             let controller: FoodDetailViewController = segue.destination as! FoodDetailViewController
            controller.food = selectFood
            controller.home = self
            controller.delegate = self
            controller.segueName = "FoodDetailSegue"
            controller.tabBar = self.tabBarController as? TabBarViewController
            controller.uid = currentUser?.userId
            controller.categoryList = self.categoryList
        }
        else if segue.identifier == "ReceiptDetailSegue" {
            let controller: ReceiptTableController = segue.destination as! ReceiptTableController
            controller.delegate = self
            controller.home = self
            controller.foodIdDelegate = self
            let tabBar = tabBarController as! TabBarViewController
            nextFoodId = tabBar.nextFoodId
            controller.nextFoodId = nextFoodId
            controller.categoryList = categoryList
            controller.receiptDetail = receiptData as? Array<Any>
            controller.uid = self.currentUser?.userId
        }
        else {
            let tabBar = tabBarController as! TabBarViewController
            nextFoodId = tabBar.nextFoodId
            let controller: AddFoodViewController = segue.destination as! AddFoodViewController
            controller.home = self
            controller.nextFoodId = nextFoodId
            controller.categoryList = self.categoryList
            controller.uid = self.currentUser?.userId
            controller.location = self.segmentOutlet.selectedSegmentIndex
            controller.delegate = self
        }
    }
    
    /*
        This method is to start the process animation.
     */
    func startProcessing() {
        self.view.isUserInteractionEnabled = false
        self.tabBarController?.view.isUserInteractionEnabled = false
        self.tableView.isHidden = true
        self.navigationController?.view.isUserInteractionEnabled = false
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
    }
    
    /*
        This method is to stop the process animation.
     */
    func stopProcessing() {
        self.view.isUserInteractionEnabled = true
        self.tabBarController?.view.isUserInteractionEnabled = true
        self.tableView.isHidden = false
        self.navigationController?.view.isUserInteractionEnabled = true
        processing.stopAnimating()
        self.viewWillAppear(true)
    }
    
    /*
        This method is to download the category list from the database.
     */
    func downloadCategory() {
        let categoryURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getallcategory"
        guard let url = URL(string: categoryURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    for i in json! {
                        let element = i["categoryname"] as! String
                        self.categoryList.append(element)
                    }
                    let tabBar = self.tabBarController as! TabBarViewController
                    tabBar.categoryList = self.categoryList
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    /*
        This method is to determine the edit mode for each cell.
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if !self.checkWiFi() {
                let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                    self.navigationController?.dismiss(animated: false, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let removeFood = self.showList[indexPath.row]
            let viewController = UIViewController()
            viewController.deleteFoodRequest(foodId: removeFood.foodId)
            switch self.segmentOutlet.selectedSegmentIndex {
            case 0:
                self.fridge.remove(at: indexPath.row)
            case 1:
                self.freezer.remove(at: indexPath.row)
            default:
                self.pantry.remove(at: indexPath.row)
            }
            self.showList.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return [delete]
    }
    
    /*
        This method is to determine if the cells are editable.
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if showList.count == 0 {
            return false
        }
        return true
    }
    
    /*
        This method is to initiate the view before it appears.
     */
    override func viewWillAppear(_ animated: Bool) {
        let tabBar = self.tabBarController as! TabBarViewController
        if tabBar.foodFromShopToStore != nil {
            switch tabBar.foodFromShopToStore?.locationId {
            case 2:
                fridge.append(tabBar.foodFromShopToStore!)
                fridge = fridge.sorted(by:{ $0.expire! < $1.expire! })
            case 3:
                freezer.append(tabBar.foodFromShopToStore!)
                freezer = freezer.sorted(by:{ $0.expire! < $1.expire! })
            default:
                pantry.append(tabBar.foodFromShopToStore!)
                pantry = pantry.sorted(by:{ $0.expire! < $1.expire! })
            }
            switch segmentOutlet.selectedSegmentIndex {
            case 0:
                showList = fridge
            case 1:
                showList = freezer
            default:
                showList = pantry
            }
            tabBar.foodFromShopToStore = nil
            tableView.reloadData()
        }
    }
}

extension UIViewController{
    // Add food into database
    func addNewFood(userId:String,cateId:String,locationId:String,foodName:String,start:String,price:String,expire:String) {
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
                        _ = try JSONSerialization.jsonObject(with: data!, options: [])
                        let tabBar = self.tabBarController as! TabBarViewController
                        tabBar.getNextFoodId()
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
    
    // Delete food from database.
    func deleteFoodRequest(foodId: Int?) {
        guard let foodURL = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/deletefoodbyid?id=" + String(foodId!)) else {return}
        var deleteRequest = URLRequest(url: foodURL)
        deleteRequest.httpMethod = "DELETE"
        deleteRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: deleteRequest){(data,response,error) in
            if let data = data{
                do {
                    _ = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
}
