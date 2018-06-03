//
//  HLRootViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/2.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit


class HLRootViewController: HLBaseViewController,QHNavigationControllerProtocol {
   
    @IBOutlet weak var mainScrollV: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mainScrollV.contentOffset = CGPoint(x: UIScreen.main.bounds.width, y: 0)
        
    }
    
    func navigationControllerShouldPush(_ vc: QHNavigationController) -> Bool {
        
        //条件1
        var bScrollBegin =  true
        
        //条件2
        if bScrollBegin == true {
            if mainScrollV.contentOffset.x == mainScrollV.frame.size.width {
                //手势push触发前关闭scrollView滑动
                mainScrollV.isScrollEnabled = false
                bScrollBegin = true
            }
            else {
                bScrollBegin = false
            }
        }
        return bScrollBegin
    }
    
    func navigationControllerDidPushBegin(_ vc: QHNavigationController) -> Bool {
        return true
    }
    //
    func navigationControllerDidPushEnd(_ vc: QHNavigationController) {
        //手势push触发后重新开启scrollView滑动
        mainScrollV.isScrollEnabled = true
    }
    
    
    func doNavigationControllerGesturePush(_ vc: QHNavigationController) -> Bool {
        return true
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
