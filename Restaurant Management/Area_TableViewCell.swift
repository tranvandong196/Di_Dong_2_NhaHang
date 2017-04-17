//
//  Area_TableViewCell.swift
//  Restaurant Management
//
//  Created by Windy on 4/17/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class Area_TableViewCell: UITableViewCell {

    @IBOutlet weak var Area_Image: UIImageView!
    @IBOutlet weak var Area_Lable: UILabel!
    
    @IBOutlet weak var Area_Content: UIView!
    
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
}
