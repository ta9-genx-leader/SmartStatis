//
//  ShoppingCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/21.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the cell in shopping list.
 */
class ShoppingCell: UITableViewCell {

    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var shoppingItemLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
