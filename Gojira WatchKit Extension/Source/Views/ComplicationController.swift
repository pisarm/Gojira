//
//  ComplicationController.swift
//  Gojira WatchKit Extension
//
//  Created by Flemming Pedersen on 21/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Timeline Configuration
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.None])
    }

    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        //        guard let allTotalData = DataFacade.sharedInstance.allTotalData(), totalData = allTotalData.first else {
        //            handler(nil)
        //            return
        //        }
        //
        //        handler(NSDate(timeIntervalSince1970: totalData.created))
        handler(nil)
    }

    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        //        guard let allTotalData = DataFacade.sharedInstance.allTotalData(), totalData = allTotalData.last else {
        //            handler(nil)
        //            return
        //        }
        //
        //        handler(NSDate(timeIntervalSince1970: totalData.created))
        handler(nil)
    }

    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }

    // MARK: - Timeline Population

    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        guard let totalData = DataFacade.sharedInstance.newestTotalData() else {
            handler(nil)
            return
        }

        handler(timelineEntry(totalData, family: complication.family))
    }

    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        //        if let allTotalData = DataFacade.sharedInstance.allTotalData() {
        //            let entries = allTotalData
        //                .filter { NSDate(timeIntervalSince1970: $0.created).compare(date) == .OrderedDescending }
        //                .map { totalData -> CLKComplicationTimelineEntry in
        //                    return self.timelineEntry(totalData, family: complication.family)!
        //            }
        //            handler(entries)
        //        } else {
        //            handler(nil)
        //        }
        handler(nil)
    }

    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }

    func timelineEntry(totalData: TotalData, family: CLKComplicationFamily) -> CLKComplicationTimelineEntry? {
        let titleString = DataFacade.sharedInstance.title
        var totalString = ""

        let diff = totalData.total - totalData.oldTotal
        totalString = "\(totalData.total)"
        if totalData.total > totalData.oldTotal {
            totalString += " (+\(diff))"
        } else if totalData.total < totalData.oldTotal {
            totalString += " (\(diff))"
        }

        switch family {
        case .CircularSmall:
            let textTemplate = CLKComplicationTemplateCircularSmallSimpleText()
            textTemplate.textProvider = CLKSimpleTextProvider(text: totalString)

            return CLKComplicationTimelineEntry(date: NSDate(timeIntervalSince1970: totalData.created), complicationTemplate: textTemplate)
        case .ModularLarge:
            let textTemplate = CLKComplicationTemplateModularLargeTallBody()
            textTemplate.headerTextProvider = CLKSimpleTextProvider(text: titleString)
            textTemplate.bodyTextProvider = CLKSimpleTextProvider(text: totalString)

            return CLKComplicationTimelineEntry(date: NSDate(timeIntervalSince1970: totalData.created), complicationTemplate: textTemplate)
        case .ModularSmall:
            let textTemplate = CLKComplicationTemplateModularSmallSimpleText()
            textTemplate.textProvider = CLKSimpleTextProvider(text: totalString, shortText: totalString)

            return CLKComplicationTimelineEntry(date: NSDate(timeIntervalSince1970: totalData.created), complicationTemplate: textTemplate)
        case .UtilitarianLarge:
            let textTemplate = CLKComplicationTemplateUtilitarianLargeFlat()
            textTemplate.textProvider = CLKSimpleTextProvider(text: "\(titleString) \(totalString)")

            return CLKComplicationTimelineEntry(date: NSDate(timeIntervalSince1970: totalData.created), complicationTemplate: textTemplate)
        case .UtilitarianSmall:
            let textTemplate = CLKComplicationTemplateUtilitarianSmallFlat()
            textTemplate.textProvider = CLKSimpleTextProvider(text: totalString)

            return CLKComplicationTimelineEntry(date: NSDate(timeIntervalSince1970: totalData.created), complicationTemplate: textTemplate)
        }
    }

    // MARK: - Update Scheduling
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        if DataFacade.sharedInstance.countTotalData() == 0 {
            return handler(NSDate())
        }

        let refresh = DataFacade.sharedInstance.refresh.rawValue
        handler(NSDate(timeIntervalSinceNow: refresh))
    }

    func requestedUpdateDidBegin() {
        refreshTotal()
    }

    func requestedUpdateBudgetExhausted() {
        refreshTotal()
    }

    func refreshTotal() {
        guard let _ = DataFacade.sharedInstance.query else {
            return
        }

        DataFacade.sharedInstance.refreshTotal {
            guard let totalData = $0 else {
                return
            }

            if totalData.total > totalData.oldTotal {
                WKInterfaceDevice.currentDevice().playHaptic(.DirectionUp)
            } else if totalData.total < totalData.oldTotal {
                WKInterfaceDevice.currentDevice().playHaptic(.DirectionDown)
            }

            let server = CLKComplicationServer.sharedInstance()
            guard let complications = server.activeComplications
                where complications.count > 0 else {
                    return
            }

            complications.forEach { server.reloadTimelineForComplication($0) }
        }
    }

    // MARK: - Placeholder Templates
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
