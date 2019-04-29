//
//  PopOverViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/14.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol PopOverDelegate {
    func actionDelegate(action: String)
}
class PopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func ManualAction(_ sender: Any) {
        action = "manual"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ScanAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
        delegate?.actionDelegate(action: "scan")
    }
    var action: String?
    var photo : UIImage?
    var delegate: PopOverDelegate?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func viewDidDisappear(_ animated: Bool) {
        if action == "manual" {
            delegate?.actionDelegate(action: "manual")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
             let cell = tableView.dequeueReusableCell(withIdentifier: "ScanButton", for: indexPath) as! PopOverCell
            return cell
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: "ManualButton", for: indexPath) as! PopOverCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true, completion: sendScan)
        default:
            self.tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true, completion: sendAdd)
        }
    }
    
    func sendScan() {
        delegate?.actionDelegate(action: "scan")
    }
    
    func sendAdd(){
        delegate?.actionDelegate(action: "manual")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
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
