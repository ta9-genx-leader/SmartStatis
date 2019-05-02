//
//  SettingCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/4.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the cell in setting view.
 */
class SettingCell: UITableViewCell {
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
