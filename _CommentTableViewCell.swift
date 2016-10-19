//
//  CommentTableViewCell.swift
//  DribbbleApp
//
//  Created by Admin on 14.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet var authorName: UILabel!
    @IBOutlet var authorAvatar: UIImageView!
    @IBOutlet var commentDate: UILabel!
    @IBOutlet var commentText: UILabel!
 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
