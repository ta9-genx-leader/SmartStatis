//
//  SettingViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/1.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBAction func logOutButton(_ sender: Any) {
       
        self.tabBarController?.dismiss(animated: true, completion: nil) 
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
