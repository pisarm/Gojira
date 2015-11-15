//
//  InterfaceController.swift
//  Gojira WatchKit Extension
//
//  Created by Flemming Pedersen on 21/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController {
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var totalLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()

        setTitle("Gojira")
        refreshLabels()
        refreshMenus()

        NSNotificationCenter.defaultCenter().addObserverForName(Preferences.ContextTypeDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            self.refreshLabels()
            self.refreshMenus()
        }
    }

    override func didDeactivate() {
        NSNotificationCenter.defaultCenter().removeObserver(self)

        super.didDeactivate()
    }

    //MARK: Actions
    @IBAction func actionFilters() {
        presentControllerWithName("FiltersController", context: nil)
    }

    @IBAction func actionSettings() {
        presentControllerWithName("SettingsController", context: nil)
    }

    @IBAction func actionRefresh() {
        DataFacade.sharedInstance.refreshTotalData {
            self.refreshLabels($0)
        }
    }

    //MARK: Refresh
    private func refreshLabels() {
        refreshLabels(DataFacade.sharedInstance.fetchNewestTotalData())
    }

    private func refreshLabels(totalData: TotalData?) {
        if !DataFacade.sharedInstance.initialized {
            titleLabel.setText("Please")
            totalLabel.setText("init")
            return
        }

        guard let totalData = totalData else {
            totalLabel.setText("No data")
            titleLabel.setText(DataFacade.sharedInstance.title)

            return
        }

        let diff = totalData.total - totalData.oldTotal
        var totalString = "\(totalData.total)"
        if totalData.total > totalData.oldTotal {
            totalString += "(+\(diff))"
            WKInterfaceDevice.currentDevice().playHaptic(.DirectionUp)
        } else if totalData.total < totalData.oldTotal {
            totalString += "(\(diff))"
            WKInterfaceDevice.currentDevice().playHaptic(.DirectionDown)
        }

        titleLabel.setText(DataFacade.sharedInstance.title)
        totalLabel.setText(totalString)
    }

    private func refreshMenus() {
        clearAllMenuItems()
        if DataFacade.sharedInstance.initialized {
            addMenuItemWithItemIcon(.Shuffle, title: "Filter", action: "actionFilters")
            addMenuItemWithItemIcon(.More, title: "Settings", action: "actionSettings")
            addMenuItemWithItemIcon(.Repeat, title: "Refresh", action: "actionRefresh")
        }
    }
}
