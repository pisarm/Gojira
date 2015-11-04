//
//  SettingsViewModel.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Bond
import Foundation

struct SettingsViewModel {
    var observableTitle: Observable<String?> {
        return DataService.sharedInstance.observableTitle
    }
    var observableQuery: Observable<String?> {
        return DataService.sharedInstance.observableQuery
    }

    let viewTitle = "Settings"
}
