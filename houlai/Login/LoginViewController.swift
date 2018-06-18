//
//  LoginViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/14.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit
import Alamofire



class LoginViewController: UIViewController {

    @IBAction func wxLoginBtnAction(_ sender: UIButton) {
        let req = SendAuthReq()
        //应用授权作用域，如获取用户个人信息则填写snsapi_userinfo
        req.scope = "snsapi_userinfo"
        WXApi.send(req)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        if let id = UserDefaults.standard.value(forKey: "openid")  {
            autoLoginWithoutCode(with: id as! String)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func WXLoginSuccess(notification: NSNotification) {
        let code = notification.object as! String
        let para = ["code": code]
        Alamofire.request(loginWithCodeUrl, method: .post, parameters:para).responseJSON{ response in
            switch response.result {
            case.success(let json):

                let dic = json as! Dictionary<String, AnyObject>
                let id = dic["openid"] as! String
                UserDefaults.standard.set(id, forKey: "openid")
                UserDefaults.standard.set(dic["nickname"], forKey: "nickname")
                UserDefaults.standard.set(dic["headimgurl"], forKey: "headimgurl")
                self.performSegue(withIdentifier: "To Main", sender: nil)
            case .failure(_):
                print("error")
            }
        }
    }
    
    func autoLoginWithoutCode(with openid: String){
        Alamofire.request(loginWithoutCodeUrl,method: .get,parameters: ["openid": openid]).responseJSON { response in
            if (response.response?.statusCode == 300){
                print("couldn't auto login")
            } else {
                switch response.result {
                case.success(let json):
                    let dic = json as! Dictionary<String, AnyObject>
                    UserDefaults.standard.set(dic["nickname"], forKey: "nickname")
                    UserDefaults.standard.set(dic["headimgurl"], forKey: "headimgurl")
                    UserDefaults.standard.set(dic["openid"], forKey: "openid")
                    self.performSegue(withIdentifier: "To Main", sender: nil)
                case .failure(_):
                    print("error")
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "To Main", let cvc = segue.destination as? HLRootViewController {
            // to do 
        }
    }

}
