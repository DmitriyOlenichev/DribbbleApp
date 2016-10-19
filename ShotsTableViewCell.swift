//
//  ShotsTableViewCell.swift
//  DribbbleApp
//
//  Created by Admin on 25.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RxSwift
import FontAwesome_swift

class ShotsTableViewCell: UITableViewCell {
    @IBOutlet var shotImage: UIImageView!
    @IBOutlet var titleText: UILabel!
    @IBOutlet var descriptionText: UILabel!    
    
    @IBOutlet var authorButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var likeCountText: UILabel!
    
    var authorUName: String = ""
    var shotId = 0
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override func prepareForReuse() {
       //debugPrint("*cell prepareForReuse()")
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
