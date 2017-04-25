//
//  Table_TableViewCell.swift
//  Restaurant Management
//
//  Created by Tran Van Dong on 4/15/17.
//  Copyright © 2017 Tran Van Dong. All rights reserved.
//

import UIKit

class Table_TableViewCell: UITableViewCell {
    @IBOutlet weak var TableThumnail_ImageView: UIImageView!
    @IBOutlet weak var TableName_Label: UILabel!
    @IBOutlet weak var Position_Label: UILabel!
    
    @IBOutlet weak var contentCell_View: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
