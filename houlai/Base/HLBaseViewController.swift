//
//  HLBaseViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/2.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit

class HLBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
