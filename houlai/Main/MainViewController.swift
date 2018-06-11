//
//  MainViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/5/8.
//  Copyright © 2018年 Ricardo. All rights reserved.
//


import UIKit

let MENU_HEIGHT:CGFloat = 420


class MainViewController: HLBaseViewController,UIActionSheetDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var dayLabel: UILabel! {
        didSet {
            let today = Date()
            
            let userCalendar = Calendar.current
            let dateCom = userCalendar.dateComponents([.year, .month,.day,.hour], from: today)
            
            dayLabel.text = String(dateCom.day!)
            dayLabel.layer.borderWidth = 10
            dayLabel.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.1176470588, blue: 0.1019607843, alpha: 1)
            dayLabel.layer.cornerRadius = 10
        }
    }
    
    
    
    
    @IBOutlet weak var markTextField: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
 
    @IBOutlet weak var markBtn: UIButton!{
        didSet {
        }
    }

    @IBAction func markBtnClick(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            markTextField.isHidden = true
            imageView.isHidden = true
        } else{
            sender.isSelected = true
            markTextField.isHidden = false
            imageView.isHidden = false
        }
    }
    
    @IBAction func commentBtnClick(_ sender: UIButton) {
        let menu = MenuViewController.init(showFrame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - MENU_HEIGHT, width: UIScreen.main.bounds.size.width, height: MENU_HEIGHT), showStyle: MYPresentedViewShowStyle.fromBottomDropStyle, callback: ({_ in
            }))
        
        self.present(menu!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        markBtn.setImage(UIImage(named: "white.png"), for: .normal)
        markBtn.setImage(UIImage(named: "red.png"), for: .selected)
        
        markTextField.isHidden = true
        markTextField.delegate = self
        
        imageView.isHidden = true
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapAction))
        let imageLongTap = UILongPressGestureRecognizer(target: self, action: #selector(imageLongTapAction))
        imageView.addGestureRecognizer(imageTap)
        imageView.addGestureRecognizer(imageLongTap)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
        let ani = YPDouYinLikeAnimation.shareInstance()
        ani?.createAnimation(withTap: sender)
        
        self.markBtn.isSelected = true
        self.markTextField.isHidden = false
        self.imageView.isHidden = false
    }
    
    @objc func imageTapAction(tap: UITapGestureRecognizer){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    @objc func imageLongTapAction(tap: UITapGestureRecognizer){
        self.imageView.image = UIImage(named: "plus.png")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        markTextField.resignFirstResponder()
        print(markTextField.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let frame:CGRect = textView.frame
        let offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-330)
        if offset > 0  {
            self.view.frame = CGRect(x:0.0, y:-offset, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.frame = CGRect(x:0,y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
    }

}
