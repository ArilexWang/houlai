//
//  TimeFrameModel.swift
//  houlai
//
//  Created by Ricardo on 2018/6/11.
//  Copyright © 2018年 Ricardo. All rights reserved.
//

import Foundation
import CoreData


class TimeFrameModel: NSManagedObject
{
    class func updateOrCreateTimeFrameModel(matching timeFrameInfo: TimeFrame, in context: NSManagedObjectContext) throws -> TimeFrameModel
    {
        let request: NSFetchRequest<TimeFrameModel> = TimeFrameModel.fetchRequest()
        request.predicate = NSPredicate(format: "date = %@", timeFrameInfo.date)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0{
                if(matches.count > 1){
                    context.delete(matches[1]);
                    try?context.save()
                }
                assert(matches.count == 1, "more than 1")
                matches[0].date = timeFrameInfo.date
                matches[0].text = timeFrameInfo.text
                if let image = timeFrameInfo.image {
                    matches[0].image = image
                } else {
                    matches[0].image = nil
                }
                matches[0].created = timeFrameInfo.created
                return matches[0]
            }
        } catch {
            throw error
        }
        let timeFrame = TimeFrameModel(context: context)
        timeFrame.date = timeFrameInfo.date
        timeFrame.text = timeFrameInfo.text
        if let image = timeFrameInfo.image {
            timeFrame.image = image
        }
        timeFrame.created = timeFrameInfo.created
        return timeFrame
    }
    
}
