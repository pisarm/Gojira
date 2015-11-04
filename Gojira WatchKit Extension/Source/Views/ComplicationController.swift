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
        handler(.None)
    }

    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }

    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }

    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }

    // MARK: - Timeline Population

    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        let now = NSDate()
        var title = "No data"
        var total = 0

        if let titleString = DataService.sharedInstance.title,
            totalValue = DataService.sharedInstance.total {
                title = titleString
                total = totalValue
        }

        var entry: CLKComplicationTimelineEntry?

        if complication.family == .ModularSmall {
            let textTemplate = CLKComplicationTemplateModularSmallSimpleText()
            textTemplate.textProvider = CLKSimpleTextProvider(text: "\(total)", shortText: "\(total)")

            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: textTemplate)
        } else if complication.family == .ModularLarge {
            let textTemplate = CLKComplicationTemplateModularLargeTallBody()
            textTemplate.headerTextProvider = CLKSimpleTextProvider(text: title)
            textTemplate.bodyTextProvider = CLKSimpleTextProvider(text: "\(total)")

            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: textTemplate)
        }

        handler(entry)
    }

    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }

    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }

    // MARK: - Update Scheduling

    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: 666))
    }

    func requestedUpdateDidBegin() {
        refreshTotal()
    }

    func requestedUpdateBudgetExhausted() {
        refreshTotal()
    }

    func refreshTotal() {
        guard let query = DataService.sharedInstance.query else {
            return
        }

        JiraService.sharedInstance.refreshTotal(query) {
            guard let total = $0 else {
                return
            }

            if let oldTotal = DataService.sharedInstance.total {
                if total < oldTotal {
                    WKInterfaceDevice.currentDevice().playHaptic(.DirectionDown)
                } else if total > oldTotal {
                    WKInterfaceDevice.currentDevice().playHaptic(.DirectionUp)
                }
            }

            DataService.sharedInstance.total = total

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
