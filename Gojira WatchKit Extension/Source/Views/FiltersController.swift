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

    private var filterData: [FilterData] = []

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        refreshData(DataFacade.sharedInstance.fetchFilterData())
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
            self.refreshData($0)
            self.refreshTable()
        }
    }

    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if filterData.count == 0 {
            return
        }
        
        let selectedFilterData = filterData[rowIndex]
        DataFacade.sharedInstance.filterId = selectedFilterData.id
        DataFacade.sharedInstance.title = selectedFilterData.name
    }

    private func refreshData(filterData: [FilterData]) {
        self.filterData = filterData.sort()
    }

    private func refreshTable() {
        if filterData.count == 0 {
            table.setNumberOfRows(1, withRowType: "FiltersRow")
            let controller = table.rowControllerAtIndex(0) as! FiltersRow
            controller.rowLabel.setText("No filters\nPlease refresh")
        } else {
            table.setNumberOfRows(filterData.count, withRowType: "FiltersRow")

            for (index, filterData) in self.filterData.enumerate() {
                let controller = table.rowControllerAtIndex(index) as! FiltersRow
                controller.rowLabel.setText(filterData.name)
            }
        }
    }
}