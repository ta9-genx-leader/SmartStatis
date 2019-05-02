//
//  FoodDetailController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/5.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol AddFoodDelegate {
    func addFood(updated:Bool) }
/*
    This class is to layout the view for food detail.
 */
class FoodDetailController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    var addFoodDelegate: AddFoodDelegate?
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var priceField: UITextField!
    @IBAction func addButtonAction(_ sender: Any) {
        if (foodNameField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Name", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (priceField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Price", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if !((priceField.text?.isDouble)!) || Double(priceField.text!)! < 0 {
            let alert = UIAlertController(title: "Empty Price", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (dateField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Expiry Date", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let foodName = foodNameField.text
            let foodPrice = priceField.text!
            let expireDate = dateField.text?.dateFormatter(format: "MM-dd-yyyy").toString(dateFormat: "yyyy-MM-dd")
            var locationId = 0
            switch locationSegment.selectedSegmentIndex {
            case 0:
                locationId = 2
            case 1:
                locationId = 3
            case 2:
                locationId = 4
            default:
                print("Error locationId")
            }
            self.addFood(userId: uid!, categoryId: categoryId!, locationId: locationId, foodName: foodName!, start: Date().toString(dateFormat: "yyyy-MM-dd"), expire: expireDate!, price: foodPrice)
        }
    }
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var locationSegment: UISegmentedControl!
    @IBOutlet weak var foodNameField: UITextField!
    var category = [[String: Any]]()
    var categoryId : Int?
    let datePicker = UIDatePicker()
    var uid: Int?
    /*
        This method is to layout picker view.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        categoryId = category[row]["cid"] as? Int
        
    }
    /*
        This method is to set the number of component in the picker view.
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
        This method is the complete action for selecting date.
     */
    @objc func done() {
        dateField.text = datePicker.date.toString(dateFormat: "MM-dd-yyyy")
        self.view.endEditing(true)
    }
    
   /*
        This method is to create date picker.
     */
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([doneButton], animated: true)
        
        dateField.inputAccessoryView = toolBar
        dateField.inputView = datePicker
    }
    
    /*
        The method layouts the pickview.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (category.count)
    }
    
    /*
     The method layouts the pickview.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if category.count != 0 {
            let titleString = category[row]["categoryname"] as? String
            let title = titleString!.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
            return title
        }
        return ""
    }

    var food : [Food]?
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        self.dateField.delegate = self
        addButton.layer.cornerRadius = 5
        addButton.clipsToBounds = true
        addButton.layer.shadowColor = UIColor.lightGray.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        addButton.layer.masksToBounds = true
        addButton.layer.shadowRadius = 1.0
        addButton.layer.shadowOpacity = 0.5
        
        let categoryURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getallcategory"
        guard let url = URL(string: categoryURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    self.category = json!
                    self.categoryId = self.category[0]["cid"] as? Int
                    DispatchQueue.main.async {
                        self.pickerView.reloadAllComponents()
                    }
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    /*
     The method add new food.
     */
    func addFood(userId: Int, categoryId: Int, locationId: Int, foodName: String, start: String, expire: String, price: String) {
        guard let postUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/food/addfood?uid=" + String(userId) + "&cid=" + String(categoryId) + "&lid=" + String(locationId) + "&name=" + foodName + "&start=" + start + "&price=" + price + "&expire=" + expire ) else { return}
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
                        self.addFoodDelegate?.addFood(updated: true)
                        self.navigationController?.popViewController(animated: true)
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
    
}

/*
    The extension helps managing dates.
 */
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
    
    var isDouble: Bool {
        return Double(self) != nil
    }
    
    
    func dateFormatter( format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date!
    }
}
