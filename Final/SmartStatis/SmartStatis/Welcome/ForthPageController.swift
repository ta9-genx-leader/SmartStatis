//
//  ForthPageController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/29.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This controller class is to manage the view for the fourth leading page.
 */
class ForthPageController: UIViewController {

    // Method called when start button is tapped.
    @IBAction func startAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // Start button outlet
    @IBOutlet weak var startButton: UIButton!
    // Logo image
    @IBOutlet weak var logoImage: UIImageView!
    
    /*
        This method is to initiate this view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addShadowToButton(cornerRadius: 5)
        startButton.backgroundColor = UIColor(red: 1/255, green: 150/255, blue: 63/255, alpha: 1.0)
        logoImage.setImageRadiusWithShadow(100)
        // Do any additional setup after loading the view.
    }
}
