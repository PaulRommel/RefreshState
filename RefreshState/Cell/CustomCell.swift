//
//  CustomCell.swift
//  RefreshState
//
//  Created by Павел Попов on 14.03.2020.
//  Copyright © 2020 Hamburger Studio. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var imgLabel: UIImageView!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
