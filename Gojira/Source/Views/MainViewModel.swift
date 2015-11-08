//
//  MainViewModel.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Bond
import Foundation

struct MainViewModel {
    var observableTitle: Observable<String?> {
        return DataService.sharedInstance.observableTitle
    }
    var observableTotal: Observable<Int?> {
        return DataService.sharedInstance.observableTotal
    }
    var observableLastRefresh: Observable<NSDate?> {
        return DataService.sharedInstance.observableLastRefresh
    }

    let viewTitle = "Gojira!"

    func refreshTotal() {
        guard let _ = DataService.sharedInstance.observableQuery.value else {
            return
        }

//        JiraService.sharedInstance.refreshTotal(query) {
//            DataService.sharedInstance.observableTotal.value = $0
//            DataService.sharedInstance.observableLastRefresh.value = NSDate()
//        }
    }
}
