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
        request.predicate = NSPredicate(format: "Date = %@", timeFrameInfo.date)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0{
                assert(matches.count == 1, "already have")
                return matches[0]
            }
        } catch {
            throw error
        }
        let timeFrame = TimeFrameModel(context: context)
        timeFrame.date = timeFrameInfo.date
        timeFrame.text = timeFrameInfo.text
        timeFrame.image = timeFrameInfo.image
        return timeFrame
    }
    
}
