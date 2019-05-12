//
//  RegisterViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/3/30.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol UserLoginDelegate {
    func userLogin(user:User) }
class RegisterViewController: UIViewController {
    var userLoginDelegate: UserLoginDelegate?
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    @IBAction func registerButton(_ sender: Any) {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let email = emailTextField.text?.lowercased()
        let password = passwordTextField.text
        let rePassword = rePasswordTextField.text
        let validateClass = Validation()
        if (firstName?.isEmpty)! {
            let alert = UIAlertController(title: "Empty First name", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if !validateClass.isValidName(nameString: firstName!) {
            let alert = UIAlertController(title: "Incorrect First name", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (lastName?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Last name", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if !validateClass.isValidName(nameString: lastName!) {
            let alert = UIAlertController(title: "Incorrect Last name", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (email?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Email", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if !validateClass.isValidEmailAddress(emailAddressString: email!) {
            let alert = UIAlertController(title: "Incorrect Email", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if (password?.isEmpty)! {
            let alert = UIAlertController(title: "Empty Password", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if rePassword != password {
            let alert = UIAlertController(title: "Password Not Matched", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            guard let postUrl = URL(string: "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/user/adduser?firstname=" + firstName! + "&lastname=" + lastName! + "&email=" + email! + "&password=" + password!) else { return}
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
                            let alert = UIAlertController(title: "Email Exists", message: "Please try agian.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        catch {
                            if response.statusCode == 200 {
                                self.userLoginDelegate?.userLogin(user:User(id:0,firstName: firstName, lastName: lastName, email: email, password: password) )
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
            task.resume()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register button layout
        registerButtonOutlet.layer.cornerRadius = 5
        registerButtonOutlet.clipsToBounds = true
        registerButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        registerButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        registerButtonOutlet.layer.masksToBounds = true
        registerButtonOutlet.layer.shadowRadius = 1.0
        registerButtonOutlet.layer.shadowOpacity = 0.5
        
        // Back button layout
        backButtonOutlet.layer.cornerRadius = 5
        backButtonOutlet.clipsToBounds = true
        backButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        backButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backButtonOutlet.layer.masksToBounds = true
        backButtonOutlet.layer.shadowRadius = 1.0
        backButtonOutlet.layer.shadowOpacity = 0.5
        
        // FirstName text field layout
        firstNameTextField.layer.masksToBounds = false
        firstNameTextField.layer.shadowRadius = 1
        firstNameTextField.layer.shadowColor = UIColor.lightGray.cgColor
        firstNameTextField.layer.shadowOffset = CGSize(width: 1, height: 0)
        firstNameTextField.layer.shadowOpacity = 1.0
        
        // LastName text field layout
        lastNameTextField.layer.masksToBounds = false
        lastNameTextField.layer.shadowRadius = 1
        lastNameTextField.layer.shadowColor = UIColor.lightGray.cgColor
        lastNameTextField.layer.shadowOffset = CGSize(width: 1, height: 0)
        lastNameTextField.layer.shadowOpacity = 1.0
        
        // Email text field layout
        emailTextField.layer.masksToBounds = false
        emailTextField.layer.shadowRadius = 1
        emailTextField.layer.shadowColor = UIColor.lightGray.cgColor
        emailTextField.layer.shadowOffset = CGSize(width: 1, height: 0)
        emailTextField.layer.shadowOpacity = 1.0
        
        // Password text field layout
        passwordTextField.layer.masksToBounds = false
        passwordTextField.layer.shadowRadius = 1
        passwordTextField.layer.shadowColor = UIColor.lightGray.cgColor
        passwordTextField.layer.shadowOffset = CGSize(width: 1, height: 0)
        passwordTextField.layer.shadowOpacity = 1.0
        
        // Re-password text field layout
        rePasswordTextField.layer.masksToBounds = false
        rePasswordTextField.layer.shadowRadius = 1
        rePasswordTextField.layer.shadowColor = UIColor.lightGray.cgColor
        rePasswordTextField.layer.shadowOffset = CGSize(width: 1, height: 0)
        rePasswordTextField.layer.shadowOpacity = 1.0
    }
}
