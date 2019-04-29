//
//  LoginViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/3/29.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UserLoginDelegate{

    var currentUser: User?
    let validateClass = Validation()
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        let email = emailTextField.text?.lowercased()
        let password = passwordTextField.text
        if (email?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Email", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if !validateClass.isValidEmailAddress(emailAddressString: email!) {
            let alert = UIAlertController(title: "Invalid email", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (password?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Password", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            let loginURL = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/getuserbyemailandpassword?email=" + email! + "&password=" + password!
            guard let url = URL(string: loginURL) else { return}
            let session = URLSession.shared
            session.dataTask(with: url){(data,response,error) in
                if let data = data{
                    do {
                        let json = try  JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                        if json?.count != 0 {
                            self.currentUser = User(id: json![0]["uid"] as? Int ,firstName: json![0]["firstname"] as? String, lastName: json![0]["lastname"] as? String, email: json![0]["email"] as? String, password: json![0]["password"] as? String)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "MainSegue", sender: nil)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Invalid User", message: "Please try agian.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }.resume()
        }
     
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Login button layout
        loginButtonOutlet.layer.cornerRadius = 5
        loginButtonOutlet.clipsToBounds = true
        loginButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        loginButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        loginButtonOutlet.layer.masksToBounds = true
        loginButtonOutlet.layer.shadowRadius = 1.0
        loginButtonOutlet.layer.shadowOpacity = 0.5
        // Register button layout
        registerButtonOutlet.layer.cornerRadius = 5
        registerButtonOutlet.clipsToBounds = true
        registerButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        registerButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        registerButtonOutlet.layer.masksToBounds = false
        registerButtonOutlet.layer.shadowRadius = 1.0
        registerButtonOutlet.layer.shadowOpacity = 0.5
        // Email field layout
        emailTextField.addShadowToTextField(cornerRadius: 1)
        // Password field layout
        passwordTextField.addShadowToTextField(cornerRadius: 1)
        // Logo image layout
        logoImage.layer.masksToBounds = false
        logoImage.layer.shadowRadius = 1
        logoImage.layer.shadowColor = UIColor.lightGray.cgColor
        logoImage.layer.shadowOffset = CGSize(width: 1, height: 0)
        logoImage.layer.shadowOpacity = 1.0
    }

    func userLogin(user:User) {
        self.currentUser = user
        if self.currentUser != nil {
        self.emailTextField.text = user.userEmail
        self.passwordTextField.text = user.userPassword
        self.viewWillAppear(true)
            print(self.currentUser!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            let tabBarController: TabBarViewController = segue.destination as! TabBarViewController
            tabBarController.currentUser = currentUser
        }
        else {
            let controller: RegisterViewController = segue.destination as! RegisterViewController
            controller.userLoginDelegate = self
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    
    func addShadowToTextField(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.3
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }
}

extension UIButton{
    
    func addShadowToButton(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = cornerRadius
    }
}
