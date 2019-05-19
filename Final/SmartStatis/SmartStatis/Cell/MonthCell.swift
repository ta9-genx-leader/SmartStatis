//
//  MonthCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/6.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the "Month" text field in the Summary section.
 */
class MonthCell: UITableViewCell {

    @IBOutlet var monthTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
