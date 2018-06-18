//
//  TimeFrameTableViewCell.swift
//  houlai
//
//  Created by Ricardo on 2018/6/14.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit

class TimeFrameTableViewCell: UITableViewCell {

    @IBOutlet weak var dateString: UILabel!
    
    @IBOutlet weak var contentText: UILabel!
    
    @IBOutlet weak var beforeDay: UILabel!
    
    @IBOutlet weak var contentImage: UIImageView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    
    var timeFrame: TimeFrame? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        dateString?.text = timeFrame?.date
        contentText.text = timeFrame?.text
        if let image = timeFrame?.image {
            if (image.size.width > UIScreen.main.bounds.width*0.8){
                let scaleSize = UIScreen.main.bounds.width*0.8 / image.size.width
                let scaleImage = image.scaleImage(scaleSize: scaleSize)
                contentImage.image = scaleImage
            }
        } else {
            contentImage.image = nil
        }
        
        let daysBetween = (timeFrame?.created)?.daysBetweenDate(toDate: Date())
        
        beforeDay.text = "距今" + String(daysBetween!) + "天"
        
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.bounds.size.width / 2
        
        if let imageUrl = UserDefaults.standard.value(forKey: "headimgurl") as? String {
            avatarImage.imageFromURL(imageUrl, placeholder: UIImage(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))!)
        }
        
    }
}


extension UIImage {
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}









