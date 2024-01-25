//
//  BaseViewController.swift
//  FlightRadar
//
//  Created by Alexey Bondar on 3/27/23.
//  Copyright © 2023 Apalon. All rights reserved.
//

import UIKit

extension BaseViewController {
    enum InitType {
        case xib
        case code
    }
}

class BaseViewController<P, ViewModel: BaseActionViewModelProtocol>: UIViewController {
    var viewModel: P? {
        didSet {
            (oldValue as? ViewModel)?.unbind(self)
            configureBindings(with: viewModel as? ViewModel)
        }
    }

    init(with viewModel: ViewModel? = nil, type: InitType = .xib) {
        self.viewModel = viewModel as? P
        switch type {
        case .xib:
            super.init(nibName: String(describing: Self.self), bundle: .main)
        case .code:
            super.init(nibName: nil, bundle: nil)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        (viewModel as? ViewModel)?.unbind(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureBindings(with: viewModel as? ViewModel)
    }

    func configureBindings(with viewModel: ViewModel?) {}
    func setupUI() {}
}
