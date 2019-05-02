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
class SettingTableViewController: UITableViewController {

    /*
        This method is to initiate the view when it is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.4
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }

    /*
        This method is to determine the number of section in the table view.
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    /*
     This method is to determine the number of row for each section in the table view.
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
        This method is to initiate the cell view for the table view.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            cell.settingLabel.text = "Log Out"
        return cell
    }
    
    /*
        This method is called when a cell is selected.
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    /*
        This method is to determine the height for the section.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40.0
    }
}
