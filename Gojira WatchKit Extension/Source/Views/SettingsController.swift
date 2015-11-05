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
    @IBOutlet var intervalPicker: WKInterfacePicker!

    private var refresh = DataService.sharedInstance.refresh
    private var minutes: [Minutes] = [.Ten, .Twenty, .Thirty, .Fourty, .Fifty, .Sixty]

    private lazy var pickerItems: [WKPickerItem] = {
        return self.minutes
            .map { minute -> WKPickerItem in
                let item = WKPickerItem()
                item.title = minute.description
                return item
        }
    }()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

    }

    override func willActivate() {
        super.willActivate()

        setTitle("Back")

        intervalPicker.setItems(pickerItems)

        for (index, minute) in minutes.enumerate() {            
            if refresh.rawValue == minute.rawValue {
                intervalPicker.setSelectedItemIndex(index)
                break
            }
        }
    }

    override func willDisappear() {
        DataService.sharedInstance.refresh = refresh
    }

    override func didDeactivate() {

        super.didDeactivate()
    }

    @IBAction func intervalPickerChanged(value: Int) {
        WKInterfaceDevice.currentDevice().playHaptic(.Click)
        
        refresh = minutes[value]
    }
}
