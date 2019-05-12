//
//  FoodItemCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/13.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the cell in food item.
 */
class FoodItemCell: UITableViewCell {
    @IBOutlet weak var informationImage: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
