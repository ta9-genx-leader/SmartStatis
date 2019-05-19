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
/*
    This controller is to manage the view for the pop over view when the user taps the "Add" button to add food.
 */
class PopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    // Manage the action for manually adding food.
    @IBAction func ManualAction(_ sender: Any) {
        action = "manual"
        dismiss(animated: true, completion: nil)
    }
    // Manage the action for scanning receipt.
    @IBAction func ScanAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
        delegate?.actionDelegate(action: "scan")
    }
    var action: String?
    var photo : UIImage?
    var delegate: PopOverDelegate?
    
    /*
        This function is to determine the number of sections in the table view.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    /*
        This function is to finalize the view when the view disappears.
     */
    override func viewDidDisappear(_ animated: Bool) {
        if action == "manual" {
            delegate?.actionDelegate(action: "manual")
        }
    }
    
    /*
        This function is to determine the number of rows for each section in the table view.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /*
        This function is to determine the view for each cell.
     */
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

    /*
        This function is to manage the action when the user select a row.
     */
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
    
    /*
        This function is to send the message that the user tap "Scan" button for adding food.
     */
    func sendScan() {
        delegate?.actionDelegate(action: "scan")
    }
    
    /*
        This function is to send the message that the user tap "Manual add" button for adding food.
     */
    func sendAdd(){
        delegate?.actionDelegate(action: "manual")
    }
    
    /*
        This function is to initialize the view when it is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
    }
}
