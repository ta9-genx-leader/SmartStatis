//
//  GuestViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/8.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is the class managing the login view.
 */
class GuestViewController: UIViewController,UITextFieldDelegate {
    var currentUser: User?
    var finalReference: String?
    var userReference: Int?
    let userDefaults = UserDefaults.standard
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    let idHint = "Please remember the ID for the next visits"
    @IBOutlet weak var infoLabelOne: UILabel!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var informationButtouOutlet: UIButton!
    @IBOutlet weak var infoLabelTwo: UILabel!
    @IBOutlet weak var infoLabelThree: UILabel!
    @IBAction func informationButton(_ sender: Any) {
        if infoLabelOne.isHidden {
            infoLabelOne.isHidden = false
            infoLabelTwo.isHidden = false
            infoLabelThree.isHidden = false
            informationButtouOutlet.setTitle("Tap to hide hints", for: .normal)
        }
        else {
            infoLabelOne.isHidden = true
            infoLabelTwo.isHidden = true
            infoLabelThree.isHidden = true
            informationButtouOutlet.setTitle("Tap if you're new", for: .normal)
        }
    }
    @IBOutlet weak var guestField: UITextField!
    @IBAction func generateAction(_ sender: Any) {
        startProcessing()
        generateReference()
    }
    @IBOutlet weak var generateButtonOutlet: UIButton!
    @IBAction func loginAction(_ sender: Any) {
        startProcessing()
        infoLabelOne.isHidden = true
        infoLabelTwo.isHidden = true
        infoLabelThree.isHidden = true
        guestSignIn(reference:guestField.text!)
    }
    @IBAction func textFieldValudChange(_ sender: Any) {
        if guestField.text!.isEmpty {
            guestField.placeholder = ""
        }
    }
    
    /*
        This method is to detect if the text field starts editing.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.placeholder = ""
        }
    }
    
    /*
        This method is to detect if the text fiedl ends editing.
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.placeholder = "Click Generate ID if you're new"
        }
    }
    
    /*
        This method is to initiate the view before the view appears
     */
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            self.view.isHidden = true
            print("App already launched")
        } else {
            performSegue(withIdentifier: "WelcomeSegue", sender: nil)
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        }
        self.view.isHidden = false
    }
    
    /*
        This method is to initiate the view when the view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        processing.transform = CGAffineTransform(scaleX: 2, y: 2)
        checkWiFi()
        self.view.isHidden = true
        infoLabelOne.isHidden = true
        infoLabelTwo.isHidden = true
        infoLabelThree.isHidden = true
        if userDefaults.value(forKey: "userID") != nil {
            guestField.text = userDefaults.value(forKey: "userID") as? String
        }
        self.hideKeyboardWhenTappedAround()
        loginButtonOutlet.addShadowToButton(cornerRadius: 5)
        loginButtonOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
        generateButtonOutlet.addShadowToButton(cornerRadius: 5)
        generateButtonOutlet.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }
    
    /*
        The method is to generate user StartStatis ID for the user.
     */
    func generateReference() {
        let loginURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getalluser"
        guard let url = URL(string: loginURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    if json != nil {
                        self.userReference = (json?.count)! + 1
                        self.finalReference = "guestvisit" + String(self.userReference!)
                        self.guestSignUp(reference: self.finalReference!)
                    }
                    else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                                self.stopProcessing()
                            }))
                            self.present(alert, animated: true)
                        }
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                            self.stopProcessing()
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                        self.stopProcessing()
                    }))
                    self.present(alert, animated: true)
                }
            }
            }.resume()
    }
    
    /*
        This method is to manage the user login.
     */
    func guestSignUp(reference: String) {
        guard let postUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/adduser?firstname=" + "guest" + "&lastname=" + "guest" + "&email=" + reference + "@hotmail.com" + "&password=" + "guest") else { return}
        var postRequest = URLRequest(url: postUrl)
        postRequest.httpMethod = "POST"
        postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postSession = URLSession.shared
        
        let task = postSession.dataTask(with: postRequest, completionHandler:
        { (data: Data?, response: URLResponse?, error: Error?) in
            if let response = response as? HTTPURLResponse{
                    do {
                        _ = try JSONSerialization.jsonObject(with: data!, options: [])
                        DispatchQueue.main.async {
                            self.guestField.text = self.finalReference
                            self.stopProcessing()
                        }
                    }
                    catch {
                        if response.statusCode == 200 {
                            DispatchQueue.main.async {
                                self.guestField.text = self.finalReference
                                self.stopProcessing()
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                                    self.stopProcessing()
                                }))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                DispatchQueue.main.async {
                    self.stopProcessing()
                }
            }
            else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                        self.stopProcessing()
                    }))
                    self.present(alert, animated: true)
                }
            }
        })
        task.resume()
    }
    
    /*
        This method is to manage the user SmartStatis ID registration.
     */
    func guestSignIn(reference:String) {
        let loginURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getuserbyemailandpassword?email=" + reference + "@hotmail.com" + "&password=guest"
        guard let url = URL(string: loginURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    if json?.count != 0 && json != nil {
                        self.currentUser = User(id: json![0]["uid"] as? Int ,firstName: json![0]["firstname"] as? String, lastName: json![0]["lastname"] as? String, email: json![0]["email"] as? String, password: json![0]["password"] as? String)
                        DispatchQueue.main.async {
                            self.userDefaults.set(self.guestField.text!, forKey: "userID")
                            self.performSegue(withIdentifier: "MainSegue", sender: nil)
                            self.stopProcessing()
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Invalid SmartStat ID", message: "Please tap Generate ID if new\r\nor\r\nPlease enter your ID", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            self.stopProcessing()
                        }
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                            self.stopProcessing()
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Fail to connect to Server", message: "Please try again later", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                        self.stopProcessing()
                    }))
                    self.present(alert, animated: true)
                }
            }
            }.resume()
    }
    
    /*
        This method is to start the process animation.
     */
    func startProcessing() {
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    /*
        This method is to stop the process animation.
     */
    func stopProcessing() {
        processing.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }

  
    /*
        This method is to initiate the view controller for the launched segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            let tabBarController: TabBarViewController = segue.destination as! TabBarViewController
            tabBarController.currentUser = currentUser
        }
    }

}

extension UIViewController {
    /*
        This function is to check if the device is connected with Internet.
     */
    func checkWiFi() -> Bool {
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            return false
        case .Online(.WWAN):
            print("Connected via WWAN")
            return true
        case .Online(.WiFi):
            print("Connected via WiFi")
            return true
        }
    }
}

extension UITableViewController {
    /*
     This function is to check if the device is connected with Internet.
     */
    func checkWiFiTableView() -> Bool {
        let networkStatus = Reachability().connectionStatus()
        switch networkStatus {
        case .Unknown, .Offline:
            return false
        case .Online(.WWAN):
            print("Connected via WWAN")
            return true
        case .Online(.WiFi):
            print("Connected via WiFi")
            return true
        }
    }
}
