//
//  SettingsController.swift
//  Gojira
//
//  Created by Flemming Pedersen on 03/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import WatchKit

class SettingsController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

    }

    override func willActivate() {
        super.willActivate()

        setTitle("Back")
    }

    override func didDeactivate() {

        super.didDeactivate()
    }
}
