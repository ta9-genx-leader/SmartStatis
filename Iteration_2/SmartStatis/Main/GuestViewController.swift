//
//  GuestViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/8.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class GuestViewController: UIViewController,UITextFieldDelegate {
    @IBAction func textFieldValudChange(_ sender: Any) {
        if guestField.text!.isEmpty {
            guestField.placeholder = ""
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.placeholder = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.placeholder = "Click Generate ID if you're new"
        }
    }
    var currentUser: User?
    var finalReference: String?
    var userReference: Int?
    let userDefaults = UserDefaults.standard
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    let idHint = "Please remember the ID for the next visits"
    @IBOutlet weak var infoLabelOne: UILabel!
    @IBOutlet weak var infoLabelTwo: UILabel!
    @IBOutlet weak var infoLabelThree: UILabel!
    @IBAction func informationButton(_ sender: Any) {
        if infoLabelOne.isHidden {
            infoLabelOne.isHidden = false
            infoLabelTwo.isHidden = false
            infoLabelThree.isHidden = false
        }
        else {
            infoLabelOne.isHidden = true
            infoLabelTwo.isHidden = true
            infoLabelThree.isHidden = true
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
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        
        infoLabelOne.isHidden = true
        infoLabelTwo.isHidden = true
        infoLabelThree.isHidden = true
        if userDefaults.value(forKey: "userID") != nil {
            guestField.text = userDefaults.value(forKey: "userID") as? String
        }
        self.hideKeyboardWhenTappedAround()
        loginButtonOutlet.layer.cornerRadius = 5
        loginButtonOutlet.clipsToBounds = true
        loginButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        loginButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        loginButtonOutlet.layer.masksToBounds = true
        loginButtonOutlet.layer.shadowRadius = 1.0
        loginButtonOutlet.layer.shadowOpacity = 0.5
        generateButtonOutlet.addShadowToButton(cornerRadius: 10)
        generateButtonOutlet.layer.cornerRadius = 5
        generateButtonOutlet.clipsToBounds = true
        generateButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        generateButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        generateButtonOutlet.layer.masksToBounds = true
        generateButtonOutlet.layer.shadowRadius = 1.0
        generateButtonOutlet.layer.shadowOpacity = 0.5
        // Do any additional setup after loading the view.
    }
    
    func generateReference() {
        let loginURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getalluser"
        guard let url = URL(string: loginURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    self.userReference = (json?.count)! + 1
                    self.finalReference = "guestvisit" + String(self.userReference!)
                    self.guestSignUp(reference: self.finalReference!)
                }
                catch{
                    print(error)
                }
            }
            }.resume()
    }
    
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
                    }
                DispatchQueue.main.async {
                    self.stopProcessing()
                }
            }
        })
        task.resume()
    }
    
    func guestSignIn(reference:String) {
        let loginURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getuserbyemailandpassword?email=" + reference + "@hotmail.com" + "&password=guest"
        guard let url = URL(string: loginURL) else { return}
        let session = URLSession.shared
        session.dataTask(with: url){(data,response,error) in
            if let data = data{
                do {
                    let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    if json?.count != 0 {
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
                    print(error)
                }
            }
            }.resume()
    }
    
    func startProcessing() {
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopProcessing() {
        processing.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            let tabBarController: TabBarViewController = segue.destination as! TabBarViewController
            tabBarController.currentUser = currentUser
        }
        else {
            let tabBarController: PageViewController = segue.destination as! PageViewController
        }
    }

}
