//
//  WelcomeViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/18.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {


    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            print("App already launched")
            performSegue(withIdentifier: "LaunchSegue", sender: nil)
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        }
    }

}
