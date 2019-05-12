//
//  ReportCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/5.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the view for the cells in the summary section.
 */
class ReportCell: UITableViewCell {

    @IBOutlet var tagValueView: UIView!
    @IBOutlet var tagValue: UILabel!
    @IBOutlet var tagTitle: UILabel!
    @IBOutlet var tagView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
