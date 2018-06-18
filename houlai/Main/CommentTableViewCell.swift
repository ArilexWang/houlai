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
    
    @IBOutlet weak var created: UILabel!
    
    var commentData: NSDictionary?{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        commentText.text = commentData?.value(forKey: "content") as? String
        userName.text = commentData?.value(forKey: "nickname") as? String
        let avatarImage = (commentData?.value(forKey: "headimgurl") as! String).removeAllSlash
        userAvatar.imageFromURL(avatarImage, placeholder: UIImage(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))!)
        let created = getDateFromString(with: commentData?.value(forKey: "created") as! String)
        let timeBetween = Date().timeIntervalSince(created)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        if (timeBetween > 3600*24){
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyyMddHHmm"
            dateFormat.timeZone = TimeZone(abbreviation: "UTC")
            let date = dateFormat.date(from: commentData?.value(forKey: "created") as! String)
            let dateMatt = DateFormatter()
            dateMatt.dateFormat = "MM月dd日"
            let dateStr = dateMatt.string(from: date!)
            self.created.text = dateStr
        } else if (timeBetween > 3600) {
            formatter.allowedUnits = [.hour]
            self.created.text = formatter.string(from: timeBetween)! + " 前"
        } else {
            formatter.allowedUnits = [.minute]
            self.created.text = formatter.string(from: timeBetween)! + " 前"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

func getDateFromString(with dateString: String) -> Date{
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyyMddHHmm"
//    dateFormat.timeZone = TimeZone(abbreviation: "UTC")
    let date = dateFormat.date(from: dateString)
    return date!
}




