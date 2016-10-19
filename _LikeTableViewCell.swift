//
//  LikeTableViewCell.swift
//  DribbbleApp
//
//  Created by Admin on 01.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet var personAvatar: UIImageView!
    @IBOutlet var personNameText: UILabel!
    @IBOutlet var likeDate: UILabel!
    @IBOutlet var shotTitle: UILabel!
    
    
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
