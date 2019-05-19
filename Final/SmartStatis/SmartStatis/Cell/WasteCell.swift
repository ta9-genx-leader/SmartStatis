//
//  WasteCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/2.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the view for the cell in the history section.
 */
class WasteCell: UITableViewCell {

    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var expireDate: UILabel!
    @IBOutlet var completionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
