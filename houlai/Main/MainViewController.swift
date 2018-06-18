//
//  MainViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/5/8.
//  Copyright © 2018年 Ricardo. All rights reserved.
//


import UIKit
import CoreData

let MENU_HEIGHT:CGFloat = 420

class MainViewController: HLBaseViewController,UIActionSheetDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var dateString: String?
    
    @IBOutlet weak var dayLabel: UILabel! {
        didSet {
            let today = Date()
            
            let userCalendar = Calendar.current
            let dateCom = userCalendar.dateComponents([.year, .month,.day,.hour], from: today)
            
            dateString = String(dateCom.year!) + "年" + String(dateCom.month!) + "月" + String(dateCom.day!) + "日"
            
            dayLabel.text = String(dateCom.day!)
            dayLabel.layer.borderWidth = 10
            dayLabel.layer.borderColor = #colorLiteral(red: 0.6941176471, green: 0.1176470588, blue: 0.1019607843, alpha: 1)
            dayLabel.layer.cornerRadius = 10
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var timeFrame: TimeFrame?
    
    @IBOutlet weak var markTextField: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
 
    @IBOutlet weak var markBtn: UIButton!{
        didSet {
        }
    }

    @IBAction func markBtnClick(_ sender: UIButton) {
        if sender.isSelected {  //取消标记
            sender.isSelected = false
            markTextField.isHidden = true
            markTextField.text = nil
            imageView.image = UIImage(named: "plus.png")
            imageView.isHidden = true
            
            self.deleteTimeFrameFromDatabase(with: dateString!)
        } else{             //标记
            sender.isSelected = true
            markTextField.isHidden = false
            imageView.isHidden = false
            timeFrame = TimeFrame(text: "", date: dateString! ,image: nil, created: Date())
            updataDatabase(with: timeFrame!)
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
        
        self.printDatabaseStatistics()
        self.loadDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //双击mark处理事件
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
        let ani = YPDouYinLikeAnimation.shareInstance()
        ani?.createAnimation(withTap: sender)
        
        self.markBtn.isSelected = true
        self.markTextField.isHidden = false
        self.imageView.isHidden = false
        
        timeFrame = TimeFrame(text: "", date: dateString! ,image: nil, created: Date())
        updataDatabase(with: timeFrame!)
    }
    
    
    //加载本地数据
    private func loadDatabase(){
        if let context = container?.viewContext {
            context.perform {
                if let timeFrameArr = (try? context.fetch(TimeFrameModel.fetchRequest())) as? [TimeFrameModel] {
                    for timeFrame in timeFrameArr{
                        if timeFrame.date == self.dateString {
                            self.markBtn.isSelected = true
                            self.markTextField.isHidden = false
                            self.imageView.isHidden = false
                            self.markTextField.text = timeFrame.text
                            if let image = timeFrame.image as? UIImage {
                                let suqareImage = image.cropToSquare()
                                self.imageView.image = suqareImage
                            }
                            self.timeFrame = TimeFrame(text: timeFrame.text ?? "", date: timeFrame.date ?? "", image: timeFrame.image as? UIImage, created: timeFrame.created!)
                        }
                    }
                }
            }
        }
    }
    
    //更新数据库
    private func updataDatabase(with timeFrame: TimeFrame){
        print("starting database load...")
        container?.performBackgroundTask { [weak self] context in
            _ = try? TimeFrameModel.updateOrCreateTimeFrameModel(matching: timeFrame, in: context)
            try?context.save()
            print("done loading database...")
            self?.printDatabaseStatistics()
        }
    }
    
    //取消mark
    private func deleteTimeFrameFromDatabase(with dateString: String) {
        if let context = container?.viewContext {
            context.perform {
                if let timeFrameArr = (try? context.fetch(TimeFrameModel.fetchRequest())) as? [TimeFrameModel] {
                    for timeFrame in timeFrameArr{
                        if(timeFrame.date == dateString) {
                            context.delete(timeFrame)
                        }
                    }
                }
                try?context.save()
            }
        }
    }
    
    
    //debug用 打印数据
    private func printDatabaseStatistics(){
        if let context = container?.viewContext {
            context.perform {
               
                if let timeFrameCount = (try? context.fetch(TimeFrameModel.fetchRequest()))?.count {
                    
                }
                if let timeFrameArr = (try? context.fetch(TimeFrameModel.fetchRequest())) as? [TimeFrameModel]{
                    for timeFrame in timeFrameArr {
                        
                    }
                }
            }
        }
    }
    
    //照片单击事件，跳到选择照片界面
    @objc func imageTapAction(tap: UITapGestureRecognizer){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    //相片长按删除
    @objc func imageLongTapAction(tap: UITapGestureRecognizer){
        self.imageView.image = UIImage(named: "plus.png")
        timeFrame?.image = nil
        updataDatabase(with: timeFrame!)
    }
    
    //选择相片结束
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let squareImage = image.cropToSquare()
            imageView.image = squareImage
            timeFrame?.image = image
            updataDatabase(with: timeFrame!)
        } else {
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //主页单击事件，收回键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        markTextField.resignFirstResponder()
        
        
    }
    
    //打开键盘，主界面上移
    func textViewDidBeginEditing(_ textView: UITextView) {
        let frame:CGRect = textView.frame
        let offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-330)
        if offset > 0  {
            self.view.frame = CGRect(x:0.0, y:-offset, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
    }
    
    //收回键盘，主界面下移
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.frame = CGRect(x:0,y:0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        timeFrame?.text = markTextField.text
        
        updataDatabase(with: timeFrame!)
    }

}
