//
//  RecipeCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/23.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import WebKit
/*
    This class is to manage recipe cell for the recipe view.
 */
class RecipeCell: UITableViewCell {
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var videoView: WKWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
