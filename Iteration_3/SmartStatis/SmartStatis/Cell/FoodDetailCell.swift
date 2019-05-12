//
//  FoodDetailCell.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/15.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
protocol ActionDelegate {
    func action(action:String,selectFood:Food?)
}
/*
    This class is to manage the cell in food detail.
 */
class FoodDetailCell: UITableViewCell {

    var food: Food?
    var editMode = false
    @IBOutlet weak var unitField: UITextField!
    
    @IBOutlet weak var quantityField: UITextField!
    @IBAction func buyButtonAction(_ sender: Any) {
        delegate?.action(action: "buy", selectFood: food)
    }
    @IBOutlet weak var buyButtonOutlet: UIButton!
    @IBAction func recipeButtonAction(_ sender: Any) {
    }
    @IBOutlet weak var recipeButtonOutlet: UIButton!
    @IBOutlet weak var locationSegment: UISegmentedControl!
    @IBOutlet weak var foodPrice: UITextField!
    @IBOutlet weak var foodCategory: UITextField!
    var delegate: ActionDelegate?
    @IBOutlet weak var exitOutlet: UIButton!

    @IBOutlet weak var foodName: UITextField!
    @IBOutlet weak var expireDate: UITextField!
    @IBOutlet weak var buyDate: UITextField!
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBAction func binAction(_ sender: Any) {
        if binOutlet.titleLabel?.text == "Bin" || binOutlet.titleLabel?.text == "Delete" {
            delegate?.action(action: "delete",selectFood:food)
        }
        else {
            delegate?.action(action: "cancel",selectFood:nil)
        }
    }
    @IBOutlet weak var binOutlet: UIButton!
    @IBAction func editAction(_ sender: Any) {
        if editOutlet.titleLabel?.text == "Edit" {
            delegate?.action(action: "edit", selectFood: food)
            editOutlet.setTitle("Save", for: .normal)
            binOutlet.setTitle("Cancel", for: .normal)
        }
        else if editOutlet.titleLabel?.text == "Add" {
             delegate?.action(action: "add", selectFood: nil)
        }
        else {
            delegate?.action(action: "save", selectFood: food)
        }
    }
    @IBOutlet weak var editOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
