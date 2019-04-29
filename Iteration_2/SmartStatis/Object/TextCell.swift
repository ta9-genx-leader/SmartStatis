//
//  TextCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/26.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {


    @IBOutlet weak var addOutlet: UIButton!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellBody: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
