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

        DataService.sharedInstance.addDelegate(self)
    }

    override func willActivate() {
        super.willActivate()

        setTitle("Gojira")

        if let titleString = DataService.sharedInstance.title,
            totalValue = DataService.sharedInstance.total {
                titleLabel.setText(titleString)
                totalLabel.setText("\(totalValue)")
        } else {
            titleLabel.setText("No data")
        }
    }

    override func didDeactivate() {
        DataService.sharedInstance.removeDelegate(self)

        super.didDeactivate()
    }

    @IBAction func actionRefresh() {
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

            self.totalLabel.setText("\(total)")
        }
    }
    @IBAction func actionSettings() {
        presentControllerWithName("SettingsController", context: nil)
    }
}

extension InterfaceController: DataServiceDelegate {
    //MARK: DataServiceDelegate
    func dataUpdated<T>(type: DataType, value: T) {
        switch type {
        case .Query:
            break
        case .Title:
            guard let value = value as? String else {
                break
            }
            titleLabel.setText(value)
        case .Total:
            guard let value = value as? Int else {
                break
            }
            totalLabel.setText("\(value)")
        }
    }
}