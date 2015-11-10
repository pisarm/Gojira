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
    //MARK: Observables
    var observableUsername: Observable<String?> {
        return Preferences.sharedInstance.observableUsername
    }

    var observablePassword: Observable<String?> {
        return Preferences.sharedInstance.observablePassword
    }

    var observableJiraURL: Observable<String?> {
        return Preferences.sharedInstance.observableJiraURL
    }

    //MARK: Properties
    let viewTitle = "Gojira"
}
