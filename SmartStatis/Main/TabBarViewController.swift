//
//  TabBarViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/1.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var currentUser: User?
    var bestStoreTemp: Int = 30
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    

}
