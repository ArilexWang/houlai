//
//  CommentTableViewCell.swift
//  houlai
//
//  Created by Ricardo on 2018/6/3.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentText: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
