//
//  MenuViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/3.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit


class MenuViewController: MYPresentedController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextView!{
        didSet{
            commentTextField.layer.borderWidth = 1
            commentTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            commentTextField.layer.cornerRadius = 5
        }
    }
    
    var textFieldHeight: CGFloat?
    
    
    var tableData: [String] = [
        "abc",
        "adfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadga",
        "adfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadga",
        "adfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadga",
        "adfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadgaadfadfecvadgaewcvacagadsgaewadacacacvadga"
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.delegate = self
        tableView.dataSource = self
    
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.commentTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        //设置手势点击数
        tapGesture.numberOfTapsRequired = 1
        self.tableView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDisShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        textFieldHeight = commentTextField.frame.origin.y;
    }
    
    @objc func handleKeyboardDisShow(notification: NSNotification) {
        //得到键盘frame
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let value = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)
        let keyboardRec = (value as AnyObject).cgRectValue
        
        let height = keyboardRec?.size.height

        UITextField.animate(withDuration: 0.1, animations: {
            self.commentTextField.frame = CGRect(x: self.commentTextField.frame.origin.x, y: self.view.frame.height - height! - self.commentTextField.frame.size.height, width: self.commentTextField.frame.size.width, height: self.commentTextField.frame.size.height)
        })
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
        commentTextField.resignFirstResponder()
        
        UITextView.animate(withDuration: 0.1, animations: {
            self.commentTextField.frame = CGRect(x: self.commentTextField.frame.origin.x, y: self.view.frame.height - self.commentTextField.frame.size.height , width: self.commentTextField.frame.size.width, height: self.commentTextField.frame.size.height)
        })
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){ //判断输入的字是否是回车，即按下return

            commentTextField.resignFirstResponder()
        
            UITextView.animate(withDuration: 0.1, animations: {
                self.commentTextField.frame = CGRect(x: self.commentTextField.frame.origin.x, y: self.view.frame.height - self.commentTextField.frame.size.height , width: self.commentTextField.frame.size.width, height: self.commentTextField.frame.size.height)
            })
            
            return false; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        
        return true;
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as! CommentTableViewCell
    
        cell.commentText.text = tableData[indexPath.row]
        cell.commentText.numberOfLines = 0
        
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
