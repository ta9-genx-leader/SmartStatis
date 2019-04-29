//
//  TotalItemCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/2.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    Class for total number of food item.
 */
class TotalItemCell: UITableViewCell {
    
    @IBOutlet weak var goodFood: UILabel!
    @IBOutlet weak var normalFood: UILabel!
    @IBOutlet weak var expireFood: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
