//
//  HomeViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/4.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import MapKit
class HomeViewController: UIViewController, CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FridgeDelegate, FreezerDelegate, PantryDelegate {
    func updatePantry(food: [Food]) {
        pantry = food
        showList = pantry
        showList = showList.sorted(by:{ $0.expire! < $1.expire! })
        self.collectionView.reloadData()
    }
    
    
    func updateFreezer(food: [Food]) {
        freezer = food
        showList = freezer
        showList = showList.sorted(by:{ $0.expire! < $1.expire! })
        self.collectionView.reloadData()
    }
    
    func updateFridge(food: [Food]) {
        fridge = food
        showList = fridge
        showList = showList.sorted(by:{ $0.expire! < $1.expire! })
        self.collectionView.reloadData()
    }
    
    @IBOutlet weak var locationSegment: UISegmentedControl!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var expireNoLabel: UILabel!
    
    @IBAction func locationSegmentAction(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            //UpdateData()
            showList = fridge
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case 1:
            //UpdateData()
            showList = freezer
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case 2:
            //UpdateData()
            showList = pantry
            showList = showList.sorted(by:{ $0.expire! < $1.expire! })
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        default:
            print("error segment")
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl = UIRefreshControl()
    var currentItemIndex: Int?
    // Collection
    let numberOfCellsPerRow: CGFloat = 3
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var weatherBaseUrl = "http://api.openweathermap.org/data/2.5/weather?lat="
    var lat: String?
    var lon: String?
    var weatherApiKey = "&appid=383deaf1e20aaebab78691c1d83d06e7"
    var weatherTimer : Timer!
    var currentUser: User?
    var userId : Int?
    var expireNumber = 0
    var totalFood = [Food]()
    var showList = [Food]()
    var bin = [Food]()
    var fridge = [Food]()
    var freezer = [Food]()
    var pantry = [Food]()
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    var bestStoreTemp : Int?
    var firstDownloadData = true
    
    @objc func refreshCollection() {
        if !processing.isAnimating {
            UpdateData()
            sleep(1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"refresh-50px"), style: .plain, target: self, action: #selector(refreshCollection))
        
        self.UpdateData()
        weatherTimer = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(getWeather), userInfo: nil, repeats: true)
        self.startProcessing()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            weatherTimer.fire()
        }
        
        topView.dropShadow()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        expireNumber = 0
        if showList.count != 0 {
            for index in 0...showList.count-1 {
                if showList[index].expire! < Date() {
                    expireNumber = expireNumber + 1
                }
            }
        }
        expireNoLabel.text = String(expireNumber)
    }
    
    func UpdateData() {
        if firstDownloadData {
            self.startProcessing()
        }
        else {
            self.collectionStartProcessing()
        }
        showList = [Food]()
        totalFood = [Food]()
        bin = [Food]()
        fridge = [Food]()
        freezer = [Food]()
        pantry = [Food]()
        let tabBar = tabBarController as! TabBarViewController
        bestStoreTemp = tabBar.bestStoreTemp
        currentUser = tabBar.currentUser
        userId = tabBar.currentUser?.userId
        let foodURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/getfoodbyuid?id=" + String(userId!)
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
                        let oneFood = Food(foodId: food["foodid"] as? Int, userId: food["uid"] as? Int, categoryId: food["cid"] as? Int, locationId: food["lid"] as? Int, foodName: food["foodname"] as? String, start: formatter.dateFormatter(dateString: food["startdate"] as! String) , expire: expire,price: food["price"] as? Double)
                        self.totalFood.append(oneFood)
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
                        DispatchQueue.main.async {
                            switch self.locationSegment.selectedSegmentIndex {
                            case 0:
                                self.showList = self.fridge
                            case 1:
                                self.showList = self.freezer
                            case 2:
                                self.showList = self.pantry
                            default:
                                return
                            }
                            self.showList = self.showList.sorted(by:{ $0.expire! < $1.expire! })
                            self.collectionView.reloadData()
                            if self.firstDownloadData {
                                self.stopProcessing()
                            }
                            else {
                                self.collectionStopProcessing()
                            }
                            self.firstDownloadData = false
                        }
                    }
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    @objc func getWeather() {
        if lat != nil && lon != nil {
            let weatherUrl = weatherBaseUrl + lat! + "&lon=" + lon! + weatherApiKey
            //let weatherUrl = weatherBaseUrl + city + weatherApiKey
            guard let url = URL(string: weatherUrl) else { return}
            let session = URLSession.shared
            session.dataTask(with: url){(data,response,error) in
                if let data = data{
                    do {
                        // Parse json for weather
                        let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let main = json!["main"] as! NSDictionary
                        let city = json!["name"] as! String
                        let temperatureDouble = main["temp"] as! Double
                        let temperature = temperatureDouble - 273.15
                        let sys = json!["sys"] as! NSDictionary
                        let sunrise = sys["sunrise"] as! Int64
                        let sunset = sys["sunset"] as! Int64
                        let sunriseDate = NSDate(timeIntervalSince1970: TimeInterval(sunrise))
                        let sunsetDate = NSDate(timeIntervalSince1970: TimeInterval(sunset))
                        let weatherDist = json!["weather"] as? [[String: Any]]
                        let weather = weatherDist![0]["main"] as! String
                        var iconUrl = ""
                        // Weather icon condition
                        switch weather {
                        case "Thunderstorm":
                            iconUrl = "11d.png"
                        case "Drizzle":
                            iconUrl = "09d.png"
                        case "Rain":
                            iconUrl = "10d.png"
                        case "Snow":
                            iconUrl = "13d.png"
                        case "Atmosphere":
                            iconUrl = "50d.png"
                        case "Clear":
                            if Date() >= sunriseDate as Date && Date() < sunsetDate as Date  {
                                iconUrl = "01d.png"
                            }
                            else {
                                iconUrl = "01n.png"
                            }
                        case "Clouds":
                            if Date() >= sunriseDate as Date && Date() < sunsetDate as Date  {
                                iconUrl = "02d.png"
                            }
                            else {
                                iconUrl = "02n.png"
                            }
                        default:
                            print("Error weather")
                            print("Error weather")
                        }
                        DispatchQueue.main.async {
                            if Int(round(temperature)) > self.bestStoreTemp! {
                                self.temperatureLabel.textColor = UIColor(red: 255/255, green: 17/255, blue: 17/255, alpha: 1.0)
                            }
                            else {
                                self.temperatureLabel.textColor = UIColor.black
                            }
                            self.temperatureLabel.text = String(Int(round(temperature))) + "°C"
                            self.cityLabel.text = city
                            let iconUrl = URL(string: "http://openweathermap.org/img/w/" + iconUrl)
                            self.weatherImage.downloaded(from: iconUrl!)
                            self.stopProcessing()
                        }
                    }
                    catch{
                        print(error)
                    }
                }
                }.resume()
        }
        else {
            guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Melbourne&appid=383deaf1e20aaebab78691c1d83d06e7") else { return}
            let session = URLSession.shared
            session.dataTask(with: url){(data,response,error) in
                if let data = data{
                    do {
                        // Parse json for weather
                        let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let main = json!["main"] as! NSDictionary
                        let city = json!["name"] as! String
                        let temperatureDouble = main["temp"] as! Double
                        let temperature = temperatureDouble - 273.15
                        let sys = json!["sys"] as! NSDictionary
                        let sunrise = sys["sunrise"] as! Int64
                        let sunset = sys["sunset"] as! Int64
                        let sunriseDate = NSDate(timeIntervalSince1970: TimeInterval(sunrise))
                        let sunsetDate = NSDate(timeIntervalSince1970: TimeInterval(sunset))
                        let weatherDist = json!["weather"] as? [[String: Any]]
                        let weather = weatherDist![0]["main"] as! String
                        var iconUrl = ""
                        // Weather icon condition
                        switch weather {
                        case "Thunderstorm":
                            iconUrl = "11d.png"
                        case "Drizzle":
                            iconUrl = "09d.png"
                        case "Rain":
                            iconUrl = "10d.png"
                        case "Snow":
                            iconUrl = "13d.png"
                        case "Atmosphere":
                            iconUrl = "50d.png"
                        case "Clear":
                            if Date() >= sunriseDate as Date && Date() < sunsetDate as Date  {
                                iconUrl = "01d.png"
                            }
                            else {
                                iconUrl = "01n.png"
                            }
                        case "Clouds":
                            if Date() >= sunriseDate as Date && Date() < sunsetDate as Date  {
                                iconUrl = "02d.png"
                            }
                            else {
                                iconUrl = "02n.png"
                            }
                        default:
                            print("Error weather")
                        }
                        DispatchQueue.main.async {
                            if Int(round(temperature)) > self.bestStoreTemp! {
                                self.temperatureLabel.textColor = UIColor(red: 255/255, green: 17/255, blue: 17/255, alpha: 1.0)
                            }
                            else {
                                self.temperatureLabel.textColor = UIColor.black
                            }
                            self.temperatureLabel.text = String(Int(round(temperature))) + "°C"
                            self.cityLabel.text = city
                            let iconUrl = URL(string: "http://openweathermap.org/img/w/" + iconUrl)
                            self.weatherImage.downloaded(from: iconUrl!)
                        }
                    }
                    catch{
                        print(error)
                    }
                }
                }.resume()
            self.cityLabel.text = "GPS Needed"
            self.temperatureLabel.text = "None"
        }
    }
    
    func collectionStartProcessing() {
        self.collectionView.isHidden = true
        locationSegment.isUserInteractionEnabled = false
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
    }

    func collectionStopProcessing() {
        self.collectionView.isHidden = false
        locationSegment.isUserInteractionEnabled = true
        processing.stopAnimating()
        self.viewWillAppear(true)
    }
    
    func startProcessing() {
        self.collectionView.isHidden = true
        self.segmentView.isHidden = true
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
    }
    
    func stopProcessing() {
        self.collectionView.isHidden = false
        self.segmentView.isHidden = false
        processing.stopAnimating()
        self.viewWillAppear(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc: CLLocation=locations.last!
        currentLocation = loc.coordinate
        lat = String(loc.coordinate.latitude)
        lon = String(loc.coordinate.longitude)
        self.getWeather()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (showList.count) >= 9 {
            return 9
        }
        else if showList.count > 0 {
            return (showList.count)
        }
        else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        let dateFormat = DateConverter()
        print(showList.count)
        if showList.count > 0 {
            if indexPath.item < 8 {
                cell.collectionCellLabel.text = showList[indexPath.item].foodName
                switch showList[indexPath.item].categoryId {
                case 1:
                    cell.cellImage.image = UIImage(named: "Meat-50px")
                case 2:
                    cell.cellImage.image = UIImage(named: "Fruit-50px")
                case 3:
                    cell.cellImage.image = UIImage(named: "seafood-50px")
                case 4:
                    cell.cellImage.image = UIImage(named: "milk-50px")
                case 5:
                    cell.cellImage.image = UIImage(named: "cheese-50px")
                case 6:
                    cell.cellImage.image = UIImage(named: "vegetable-50px")
                case 7:
                    cell.cellImage.image = UIImage(named: "beverage-50px")
                case 8:
                    cell.cellImage.image = UIImage(named: "bread-50px")
                case 9:
                    cell.cellImage.image = UIImage(named: "protein-50px")
                default:
                    cell.cellImage.image = UIImage(named: "others-50px")
                }
                cell.timeImage.isHidden = true
                if dateFormat.numberOfDays(firstDate: Date(), secondDate: showList[indexPath.item].expire!) <= 0 {
                    cell.timeImage.isHidden = false
                    cell.timeImage.image = UIImage(named: "Expire-50px")
                }
                else if dateFormat.numberOfDays(firstDate: Date(), secondDate: showList[indexPath.item].expire!) > 0 &&  dateFormat.numberOfDays(firstDate: Date(), secondDate: showList[indexPath.item].expire!) < 2 {
                    cell.timeImage.isHidden = false
                    cell.timeImage.image = UIImage(named: "Expiring-50px")
                }
            }
            else if indexPath.item == 8 {
                cell.timeImage.isHidden = true
                cell.cellImage.image = UIImage(named: "More-50px")
                cell.collectionCellLabel.text = "More"
            }
            return cell
        }
        else {
                cell.timeImage.isHidden = true
                cell.cellImage.image = UIImage(named: "Add-50px")
                cell.collectionCellLabel.text = "Add"
                return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width-30
        return CGSize(width: width/3, height: width/3);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch locationSegment.selectedSegmentIndex {
        case 0:
            self.performSegue(withIdentifier: "FridgeSegue", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "FreezerSegue", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "PantrySegue", sender: nil)
        default:
            return
        }
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FridgeSegue":
            let controller: FridgeTableViewController = segue.destination as! FridgeTableViewController
            controller.fridgeFood = fridge
            controller.uid = self.userId
            controller.fridgeDelegate = self
        case "FreezerSegue":
            let controller: FreezerTableViewController = segue.destination as! FreezerTableViewController
            controller.freezerFood = freezer
            controller.uid = self.userId
            controller.freezerDelegate = self
        case "PantrySegue":
            let controller: PantryTableViewController = segue.destination as! PantryTableViewController
            controller.pantryFood = pantry
            controller.uid = self.userId
            controller.pantryDelegate = self
        default:
            let controller: ScanReceiptController = segue.destination as! ScanReceiptController
            controller.uid = currentUser?.userId
        }
        
    }
}

// Stackoverflow
extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// Stackoverflow
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
}
