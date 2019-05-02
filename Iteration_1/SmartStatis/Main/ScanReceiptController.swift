//
//  ScanReceiptController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/6.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import CoreData
import Foundation
/*
    This class is class layout scanning receipt.
 */
class ScanReceiptController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var uid: Int?
    var receiptData: NSArray?
     let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBAction func saveButton(_ sender: Any) {
        if imageView.image != nil {
            uploadImage(image: imageView.image!)
        }
        else {
            let alert = UIAlertController(title: "Empty Image", message: "Please try agian.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    let CLIENT_ID = "546c25a59c58ad7"
    var appDelegate: AppDelegate?
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"camera-50px"), style: .plain, target: self, action: #selector(takePhoto))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 81/255, green: 142/255, blue: 247/255, alpha: 1.0)
        saveButtonOutlet.layer.cornerRadius = 5
        saveButtonOutlet.clipsToBounds = true
        saveButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        saveButtonOutlet.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        saveButtonOutlet.layer.masksToBounds = true
        saveButtonOutlet.layer.shadowRadius = 1.0
        saveButtonOutlet.layer.shadowOpacity = 0.5
        // Do any additional setup after loading the view.
    }
    
    /*
        The method takes photos.
     */
    @objc func takePhoto() {
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
    
    /*
        This method is to set image picker.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    /*
        This method uploads images.
     */
    func uploadImage(image:UIImage) {
        self.startProcessing()
        let chosenImage = imageView.image
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
                    let uploadUrlString = "https://h3tqwthvml.execute-api.us-east-2.amazonaws.com/project/receipt/scanreceipt?url=" + imageUrl
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
                                    let alert = UIAlertController(title: "Receipt required", message: "Please try agian.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                    self.present(alert, animated: true)
                                    self.stopProcessing()
                                    return
                                }
                            }
                            catch{
                                print(error)
                                let alert = UIAlertController(title: "Receipt required", message: "Please try agian.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                self.stopProcessing()
                            }
                        }
                        }.resume()
                }
                catch {
                    let alert = UIAlertController(title: "Receipt required", message: "Please try agian.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    self.stopProcessing()
                }
            }
        }
        executePostRequest.resume()
    }
    
    
    /*
        The method start circle animation for waiting.
     */
    func startProcessing() {
        processing.isHidden = false
        self.imageView.isHidden = true
        self.saveButtonOutlet.isHidden = true
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
    }
    
    /*
        The method stops circle animation for waiting.
     */
    func stopProcessing() {
        self.imageView.isHidden = false
        self.saveButtonOutlet.isHidden = false
        processing.stopAnimating()
        processing.isHidden = true
        self.viewWillAppear(true)
    }
    
    /*
        The method set actions before the segue is launched.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReceiptDetailSegue" {
            let controller: ReceiptTableController = segue.destination as! ReceiptTableController
            controller.receiptDetail = receiptData as? Array<Any>
            controller.uid = self.uid!
        }
    }
}
