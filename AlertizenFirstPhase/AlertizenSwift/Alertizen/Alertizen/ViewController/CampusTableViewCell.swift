//
//  CampusTableViewCell.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 19/01/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit

class CampusTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCheckbox: UIButton!
    @IBOutlet var cellView: UIView!
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
