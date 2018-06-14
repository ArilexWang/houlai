//
//  ListViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/2.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit
import ESPullToRefresh
import CoreData

class ListViewController: HLBaseViewController {
    
    var scrollView: UIScrollView!
    
    var timeline: TimelineView!
    
    var timeFrames: [TimeFrame] = []
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
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
        
        
        self.loadDatabase()
        
        
        
        self.scrollView.es.addPullToRefresh {
            //下拉刷新
            self.loadDatabase()
            self.scrollView.es.stopPullToRefresh()
            self.scrollView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        
        view.sendSubview(toBack: scrollView)
        
    }
    
    //加载本地数据
    private func loadDatabase(){
        if let context = container?.viewContext {
            context.perform {
                self.timeFrames = []
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
//                if let timeFrameArr = (try? context.fetch(TimeFrameModel.fetchRequest())) as? [TimeFrameModel] {
//                    for timeFrame in timeFrameArr{
//                        let newTimeFrame = TimeFrame(text: timeFrame.text ?? "", date: timeFrame.date ?? "", image: timeFrame.image as? UIImage)
//                        self.timeFrames.append(newTimeFrame)
//                    }
//                }
//                self.timeline = TimelineView(bulletType: .circle, timeFrames: self.timeFrames)
//                self.scrollView.addSubview(self.timeline)
//                self.scrollView.addConstraints([
//                    NSLayoutConstraint(item: self.timeline, attribute: .left, relatedBy: .equal, toItem: self.scrollView, attribute: .left, multiplier: 1.0, constant: 0),
//                    NSLayoutConstraint(item: self.timeline, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.scrollView, attribute: .bottom, multiplier: 1.0, constant: 0),
//                    NSLayoutConstraint(item: self.timeline, attribute: .top, relatedBy: .equal, toItem: self.scrollView, attribute: .top, multiplier: 1.0, constant: 0),
//                    NSLayoutConstraint(item: self.timeline, attribute: .right, relatedBy: .equal, toItem: self.scrollView, attribute: .right, multiplier: 1.0, constant: 0),
//
//                    NSLayoutConstraint(item: self.timeline, attribute: .width, relatedBy: .equal, toItem: self.scrollView, attribute: .width, multiplier: 1.0, constant: 0)
//                    ])
//                let offset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
//                self.scrollView.setContentOffset(offset, animated: false)
            
            }
        }
    }
    
    private func printDatabaseStatistics(){
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                if let timeFrameCount = (try? context.fetch(TimeFrameModel.fetchRequest()))?.count {
                    print("\(timeFrameCount) timeFrames")
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
