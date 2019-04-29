//
//  ThirdPageController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/28.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class ThirdPageController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 10
        imageView.layer.shadowColor = UIColor.darkGray.cgColor
        imageView.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
        imageView.layer.shadowOpacity = 0.9
        imageView.layer.shadowRadius = 10.0
        imageView.layer.masksToBounds = false
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
