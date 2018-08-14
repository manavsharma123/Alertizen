//
//  InboxTableViewCell.swift
//  Alertizen
//
//  Created by Mind Root on 24/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnCheckBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews()
    {
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        
        super.layoutSubviews()
        
        if self.isEditing
        {
            var contentFrame = self.contentView.frame
            
            if (contentFrame.origin.x == 0)
            {
                contentFrame.origin.x = -40.0
            }
            else
            {
                contentFrame.origin.x = 0.0
            }
            self.contentView.frame = contentFrame
        }
        else
        {
            var contentFrame = self.contentView.frame
            contentFrame.origin.x = -40.0
            self.contentView.frame = contentFrame
        }
        UIView.commitAnimations()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        self.layoutSubviews()
    }
    
}
