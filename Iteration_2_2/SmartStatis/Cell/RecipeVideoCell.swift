//
//  RecipeVideoCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/1.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import WebKit
class RecipeVideoCell: UITableViewCell {

    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeVideoView: WKWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
