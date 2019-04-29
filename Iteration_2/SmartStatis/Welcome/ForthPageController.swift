//
//  ForthPageController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/29.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class ForthPageController: UIViewController {

    @IBAction func startAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addShadowToButton(cornerRadius: 10)
        logoImage.setImageRadiusWithShadow(100)
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
