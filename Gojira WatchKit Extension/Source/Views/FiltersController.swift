//
//  FiltersController.swift
//  Gojira
//
//  Created by Flemming Pedersen on 11/11/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import WatchKit

final class FiltersController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!

    private var filterData: [FilterData] = DataFacade.sharedInstance.fetchFilterData()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        refreshTable()
     }

    override func willActivate() {
        super.willActivate()

        setTitle("Back")
    }

    override func didDeactivate() {
        
        super.didDeactivate()
    }

    @IBAction func actionRefresh() {
        DataFacade.sharedInstance.refreshFilterData {
            self.filterData = $0
            self.refreshTable()
        }
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        print(rowIndex)
    }

    private func refreshTable() {
        table.setNumberOfRows(filterData.count, withRowType: "FilterRow")

        for (index, filterData) in self.filterData.enumerate() {
            let controller = table.rowControllerAtIndex(index) as! FilterRow
            controller.rowLabel.setText(filterData.name)
        }
    }
}