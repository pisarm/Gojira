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
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var queryField: UITextField!

    private let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBonds()

        title = viewModel.viewTitle
    }

    private func setupBonds() {
        viewModel.observableTitle.bidirectionalBindTo(titleField.bnd_text)
        viewModel.observableQuery.bidirectionalBindTo(queryField.bnd_text)
    }
}
