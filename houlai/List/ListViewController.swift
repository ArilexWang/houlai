//
//  ListViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/2.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit
import ESPullToRefresh


class ListViewController: HLBaseViewController {
    
    
    var scrollView: UIScrollView!
    
    var timeline:   TimelineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        view.addConstraints([
            NSLayoutConstraint(item: scrollView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 29),
            NSLayoutConstraint(item: scrollView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
            ])
        
        timeline = TimelineView(bulletType: .circle, timeFrames: [
            TimeFrame(text: "New Year's Day", date: "January 1", image: UIImage(named: "fireworks.jpeg")),
            TimeFrame(text: "The month of love!", date: "February 14", image: UIImage(named: "heart.png")),
            TimeFrame(text: "Comes like a lion, leaves like a lamb", date: "March",  image: nil),
            TimeFrame(text: "Dumb stupid pranks.", date: "April 1", image: UIImage(named: "april.jpeg")),
            TimeFrame(text: "That's right. No image is necessary!", date: "No image?", image: nil),
            TimeFrame(text: "This control can stretch. It doesn't matter how long or short the text is, or how many times you wiggle your nose and make a wish. The control always fits the content, and even extends a while at the end so the scroll view it is put into, even when pulled pretty far down, does not show the end of the scroll view.", date: "Long text", image: nil),
            TimeFrame(text: "Hope this helps someone!", date: "That's it!", image: nil)
            ])
        scrollView.addSubview(timeline)
        
        
        scrollView.addSubview(timeline)
        scrollView.addConstraints([
            NSLayoutConstraint(item: timeline, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: timeline, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .right, multiplier: 1.0, constant: 0),
            
            NSLayoutConstraint(item: timeline, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0)
            ])

        
        self.scrollView.es.addPullToRefresh {
            self.scrollView.es.stopPullToRefresh()
            self.scrollView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        
        
        
        view.sendSubview(toBack: scrollView)
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
