//
//  ReportTextCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/5.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the text area in the Summary section.
 */
class ReportTextCell: UITableViewCell {

    @IBOutlet var progressButtonAction: UIButton!
    @IBOutlet var progressButtonOutlet: UIButton!
    @IBOutlet var improveTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
