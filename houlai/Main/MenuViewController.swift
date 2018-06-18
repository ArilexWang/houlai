//
//  MenuViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/3.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit
import Alamofire

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
    
    var comment: NSMutableDictionary = [
        "dayid": "",
        "content": "",
        "openid": "",
        "created": ""
    ]
    
    var dateid: String? {
        didSet{
            comment.setValue(dateid, forKey: "dayid")
        }
    }
    
    var created: String?{
        didSet{
            comment.setValue(created, forKey: "created")
        }
    }
    
    var commentsData: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.delegate = self
        tableView.dataSource = self
    
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.commentTextField.delegate = self
        
        
        //获取今日日期id, 通过id获取今日评论
        dateid = getTodayDateID()
        loadTodayComment(with: dateid!)
        created = getCurrentDateString()
        
        if let openid = UserDefaults.standard.value(forKey: "openid"){
            comment.setValue(openid as! String, forKey: "openid")
        }
        
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
            if let content = self.commentTextField.text{
                comment.setValue(content, forKey: "content")
                self.createComment(with: comment)
            }
            return false; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        return true;
    }
    
    //从服务器获取今日评论
    func loadTodayComment(with dateid:String){
        let para = ["dayid": dateid]
        Alamofire.request(loadTodayCommentsUrl, method: .get, parameters: para).responseJSON{ response in
            switch response.result {
            case.success(let json):
                self.commentsData = json as! [NSDictionary]
                self.tableView.reloadData()
            case.failure(_):
                print("error")
            }
        }
    }
    
    //新增评论
    func createComment(with comment:NSMutableDictionary){
        
        let para = ["openid": comment.value(forKey: "openid") as! String,
                    "content": comment.value(forKey: "content")  as! String,
                    "dayid": comment.value(forKey: "dayid")  as! String,
                    "created": comment.value(forKey: "created")  as! String]
        Alamofire.request(createCommentUrl, method: .post, parameters:para).responseJSON{ response in
            switch response.result {
            case.success(let json):
                self.commentsData = json as! [NSDictionary]
                self.tableView.reloadData()
                self.commentTextField.text = ""
            case.failure(_):
                print("error")
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as! CommentTableViewCell
        
        let commentData = commentsData.reversed()[indexPath.row]
        
        cell.commentData = commentData

        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
