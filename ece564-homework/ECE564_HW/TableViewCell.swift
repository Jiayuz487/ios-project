//
//  TableViewCell.swift
//  ECE564_HW
//
//  Created by zjy on 3/17/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import UIKit

@IBDesignable class TableViewCell: UITableViewCell {
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
