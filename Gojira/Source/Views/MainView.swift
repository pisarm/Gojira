//
//  MainView.swift
//  Gojira
//
//  Created by Flemming Pedersen on 24/10/15.
//  Copyright © 2015 pisarm.dk. All rights reserved.
//

import Bond
import Foundation
import UIKit

final class MainView: UIViewController {
    @IBOutlet weak var refreshButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var lastRefreshLabel: UILabel!

    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBonds()

        title = viewModel.viewTitle
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }

    private func setupBonds() {
        viewModel.observableTitle
            .bindTo(titleLabel.bnd_text)

        viewModel.observableTotal
            .deliverOn(.Main)
            .observe {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let value = $0 {
                    self.totalLabel.text = "\(value)"
                }
        }

        viewModel.observableLastRefresh
            .deliverOn(.Main)
            .observe {
                guard let date = $0 else {
                    self.lastRefreshLabel.text = ""
                    return
                }

                self.lastRefreshLabel.text = date.description
        }
    }

    //MARK: Actions
    @IBAction func refreshTapped(sender: UIBarButtonItem) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        viewModel.refreshTotal()
    }
}
