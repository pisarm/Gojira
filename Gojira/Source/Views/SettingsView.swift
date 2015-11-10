//
//  SettingsView.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Foundation
import UIKit

final class SettingsView: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var jiraURLField: UITextField!

    private let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBonds()

        title = viewModel.viewTitle
    }

    private func setupBonds() {
        viewModel.observableUsername.bidirectionalBindTo(usernameField.bnd_text)
        viewModel.observablePassword.bidirectionalBindTo(passwordField.bnd_text)
        viewModel.observableJiraURL.bidirectionalBindTo(jiraURLField.bnd_text)
    }
}
