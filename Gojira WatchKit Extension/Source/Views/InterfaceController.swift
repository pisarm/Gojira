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

        //        DataService.sharedInstance.addDelegate(self)
    }

    override func willActivate() {
        super.willActivate()

        setTitle("Gojira")
        refreshLabels()
    }

    override func didDeactivate() {
        //        DataService.sharedInstance.removeDelegate(self)

        super.didDeactivate()
    }

    @IBAction func actionRefresh() {
        DataFacade.sharedInstance.refreshTotal {
            self.refreshLabels($0)
        }
    }

    @IBAction func actionSettings() {
        presentControllerWithName("SettingsController", context: nil)
    }

    private func refreshLabels() {
        refreshLabels(DataFacade.sharedInstance.newestTotalData())
    }

    private func refreshLabels(totalData: TotalData?) {
        totalLabel.setText("No data")
        titleLabel.setText(DataFacade.sharedInstance.title)

        if let totalData = totalData {
            let diff = totalData.total - totalData.oldTotal
            var totalString = "\(totalData.total)"
            if totalData.total > totalData.oldTotal {
                totalString += "(+\(diff))"
                WKInterfaceDevice.currentDevice().playHaptic(.DirectionUp)
            } else if totalData.total < totalData.oldTotal {
                totalString += "(\(diff))"
                WKInterfaceDevice.currentDevice().playHaptic(.DirectionDown)
            }

            totalLabel.setText(totalString)
        }
    }
}

//extension InterfaceController: DataServiceDelegate {
//    //MARK: DataServiceDelegate
//    func dataUpdated<T>(type: DataType, value: T) {
//        switch type {
//        case .Query:
//            break
//        case .Refresh:
//            break
//        case .Title:
//            guard let value = value as? String else {
//                break
//            }
//            titleLabel.setText(value)
//        case .Total:
//            guard let value = value as? Int else {
//                break
//            }
//            totalLabel.setText("\(value)")
//        }
//    }
//}