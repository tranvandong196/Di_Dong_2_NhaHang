//
//  FoodCell_TableViewCell.swift
//  Restaurant Management
//
//  Created by Windy on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class FoodCell_TableViewCell: UITableViewCell {

    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var FoodName: UILabel!
    @IBOutlet weak var FoodPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
