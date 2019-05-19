//
//  SettingTableViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/4.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the setting view.
 */
class SettingTableViewController: UITableViewController,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate{
    var cellList = [SettingCell]()
    var hourPickerView = UIPickerView()
    var minutePickerView = UIPickerView()
    var tabBar: TabBarViewController?
    let hour = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    let minute = [0,5,10,15,20,25,30,35,40,45,50,55]
    @IBOutlet var notificationView: UIView!
    @IBOutlet var hourTextField: UITextField!
    @IBOutlet var minuteTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        let hourValue = Int(hourTextField.text!)
        let minuteValue = Int(minuteTextField.text!)
        tabBar?.hour = hourValue!
        tabBar?.minute = minuteValue!
        tabBar!.updateNotification()
        let defaults = UserDefaults.standard
        defaults.set(hourTextField.text!, forKey: "hour")
        defaults.set(minuteTextField.text!, forKey: "minute")
        notificationView.removeFromSuperview()
        tableView.allowsSelection = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == hourPickerView {
            return 24
        }
        else {
            return 12
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == hourPickerView {
            if hour[row] < 10 {
                return "0" + String(hour[row])
            }
            return String(hour[row])
        }
        else {
            if minute[row] < 10 {
                return "0" + String(minute[row])
            }
            return String(minute[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPickerView {
            if hour[row] < 10 {
                hourTextField.text = "0" + String(hour[row])
            }
            else {
                hourTextField.text = String(hour[row])
            }
        }
        else {
            if minute[row] < 10 {
                minuteTextField.text = "0" + String(minute[row])
            }
            else {
                minuteTextField.text = String(minute[row])
            }
        }
    }
    
    /*
        This method is to initiate the view when it is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        hourTextField.delegate = self
        minuteTextField.delegate = self
        hourPickerView.delegate = self
        minutePickerView.delegate = self
        confirmButton.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
        confirmButton.addShadowToButton(cornerRadius: 5)
        tabBar = tabBarController as? TabBarViewController
        var hourDefault = String(tabBar!.hour as Int)
        if tabBar!.hour < 10 {
            hourDefault = "0" + hourDefault
        }
        var minuteDefault = String(tabBar!.minute as Int)
        if tabBar!.minute < 10 {
            minuteDefault = "0" + minuteDefault
        }
        hourTextField.text = hourDefault
        minuteTextField.text = minuteDefault
        let toolBarUnit = UIToolbar()
        toolBarUnit.sizeToFit()
        let doneButtonUnit = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
        toolBarUnit.setItems([doneButtonUnit], animated: true)
        hourTextField.inputAccessoryView = toolBarUnit
        hourTextField.inputView = hourPickerView
        let toolUnit = UIToolbar()
        toolUnit.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditView))
        toolUnit.setItems([doneButton], animated: true)
        minuteTextField.inputAccessoryView = toolUnit
        minuteTextField.inputView = minutePickerView
        hourPickerView.selectRow(tabBar!.hour, inComponent: 0, animated: false)
        minutePickerView.selectRow(Int(tabBar!.minute/5), inComponent: 0, animated: false)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }

    /*
     This method is to close editing mode.
     */
    @objc func dismissEditView() {
        self.view.endEditing(true)
    }
    
    /*
        This method is to determine the number of section in the table view.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    /*
     This method is to determine the number of row for each section in the table view.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func viewWillAppear(_ animated: Bool) {
        cellList = [SettingCell]()
    }
    
    /*
        This method is to initiate the cell view for the table view.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            cell.settingLabel.text = "Set Notification Time"
            cell.settingImage.image = UIImage(named: "notification-64px")
            cellList.append(cell)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            cell.settingLabel.text = "Log Out"
            cell.settingImage.image = UIImage(named: "exitDoor-80px")
            cellList.append(cell)
            return cell
        }
    }
    
    /*
        This method is called when a cell is selected.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if !self.checkWiFi() {
                let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                    self.navigationController?.dismiss(animated: false, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            view.addSubview(notificationView)
            tableView.allowsSelection = false
            dismissPopOverWhenTappedAround() 
            let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width*0.5,y: UIScreen.main.bounds.size.height*0.4)
            notificationView.center = frameSize
            notificationView.clipsToBounds = true
            notificationView.layer.backgroundColor = UIColor.white.cgColor
            notificationView.layer.masksToBounds = false
            notificationView.layer.cornerRadius = 10.0
            notificationView.layer.shadowOffset = CGSize(width: -1, height: 1)
            notificationView.layer.shadowOpacity = 0.4
            notificationView.layer.shadowRadius = 2
        default:
            let alert = UIAlertController(title: "Log Out", message: "Are you sure to log out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
        This method is to determine the height for the section.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    /*
     This method is to introduce guesture recognizer into the pop over view.
     */
    func dismissPopOverWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissPopOver))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        else if view.subviews.count == 5 {
            tableView.allowsSelection = false
        }
        else {
            tableView.allowsSelection = true
        }
        return true
    }
    
    /*
     This method is to close the pop over view.
     */
    @objc func dismissPopOver() {
        self.notificationView.removeFromSuperview()
    }
}
