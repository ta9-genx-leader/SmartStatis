//
//  EditFoodViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/8.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol EditFoodDelegate {
    func editFood(food:Food) }
class EditFoodViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    var editFoodDelegate: EditFoodDelegate?
    let datePicker = UIDatePicker()
    var categoryList = [[String: Any]]()
    var categoryId: Int?
    var uid: Int?
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    

    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var category: UIPickerView!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var expire: UITextField!
    @IBOutlet weak var location: UISegmentedControl!
    @IBOutlet weak var name: UITextField!
    @IBAction func saveAction(_ sender: Any) {
        if (name.text?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Name", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (price.text?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Price", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if !((price.text?.isDouble)!) || Double(price.text!)! < 0 {
            let alert = UIAlertController(title: "Invalid Price", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (expire.text?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Expiry Date", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let newName = name.text
            let newLocation = location.selectedSegmentIndex
            let newExpire = expire.text
            let newPrice = price.text
            let newCategory = categoryId
            let newFood = Food(foodId: 0, userId: uid, categoryId: newCategory, locationId: newLocation, foodName: newName, start: Date(), expire: newExpire?.dateFormatter(format: "MM-dd-yyyy"), price: Double(newPrice!))
            self.editFoodDelegate?.editFood(food: newFood)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var editFood: Food?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        categoryId = editFood?.categoryId
        createDatePicker()
        saveOutlet.layer.cornerRadius = 5
        saveOutlet.clipsToBounds = true
        saveOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        saveOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        saveOutlet.layer.masksToBounds = true
        saveOutlet.layer.shadowRadius = 1.0
        saveOutlet.layer.shadowOpacity = 0.5
        downloadCategory()
        name.text = editFood?.foodName
        price.text = String(format: "%.1f",(editFood?.price)!)
        expire.text = editFood?.expire?.toString(dateFormat: "MM-dd-yyyy")
        location.selectedSegmentIndex = (editFood?.locationId)! 
        // Do any additional setup after loading the view.
    }
    
    func downloadCategory() {
        let categoryURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getallcategory"
        guard let url = URL(string: categoryURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    self.categoryList = json!
                    DispatchQueue.main.async {
                        self.category.reloadAllComponents()
                        self.category.selectRow((self.editFood?.categoryId)! - 1, inComponent: 0, animated: true)
                    }
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        categoryId = (categoryList[row]["cid"] as? Int)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if categoryList.count != 0 {
            let titleString = categoryList[row]["categoryname"] as? String
            let title = titleString!.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
            return title
        }
        return ""
    }
    
    @objc func done() {
        expire.text = datePicker.date.toString(dateFormat: "MM-dd-yyyy")
        self.view.endEditing(true)
    }
    
    func createDatePicker() {
        datePicker.datePickerMode = .date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([doneButton], animated: true)
        
        expire.inputAccessoryView = toolBar
        expire.inputView = datePicker
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
