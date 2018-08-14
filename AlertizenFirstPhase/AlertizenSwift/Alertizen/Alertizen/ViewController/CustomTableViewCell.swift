//
//  CustomTableViewCell.swift
//  Alertizen
//
//  Created by MR on 23/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell
{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileDoubleArrowIcon: UIImageView!
    @IBOutlet weak var profileTitleLabel: UILabel!
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
