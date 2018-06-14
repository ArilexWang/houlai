//
//  TimeFrameViewController.swift
//  houlai
//
//  Created by Ricardo on 2018/6/14.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import UIKit
import CoreData

class TimeFrameViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var timeFrames: [TimeFrame] = []
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.deleteDatabase()
        self.loadDatabase()
        
        //下拉刷新
        self.tableView.es.addPullToRefresh {
            self.loadDatabase()
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func deleteDatabase() {
        if let context = container?.viewContext {
            context.perform {
                if let timeFrameArr = (try? context.fetch(TimeFrameModel.fetchRequest())) as? [TimeFrameModel] {
                    for timeFrame in timeFrameArr{
                        context.delete(timeFrame)
                    }
                }
                try?context.save()
            }
        }
    }
    
    
    private func loadDatabase(){
        
        if let context = container?.viewContext {
            context.perform {
                self.timeFrames = []
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                if let timeFrameArr = (try? context.fetch(TimeFrameModel.fetchRequest())) as? [TimeFrameModel] {
                    for timeFrame in timeFrameArr{
                        var contentImage:UIImage? = nil
                        if let image = timeFrame.image as? UIImage {
                            contentImage = image
                        }
                        let newTimeFrame = TimeFrame(text: timeFrame.text ?? "", date: timeFrame.date ?? "", image: contentImage, created: timeFrame.created!)
                        self.timeFrames.append(newTimeFrame)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timeFrames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeFrameCell", for: indexPath)
        let timeFrame = timeFrames[indexPath.row]
        if let timeFrameCell = cell as? TimeFrameTableViewCell {
            timeFrameCell.timeFrame = timeFrame
        }
        
        return cell
    }
    

}
