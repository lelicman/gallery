//
//  BaseView.swift
//  PDFScanner_free
//
//  Created by AP Alexey Bondar on 6/10/21.
//  Copyright © 2021 Apalon Apps. All rights reserved.
//

import UIKit

//TODO: renamed to BaseActionableView to avoid same naming with old BaseView
class BaseActionableView<P, ViewModel: BaseActionViewModelProtocol>: UIView {
    var viewModel: P? {
        didSet {
            (oldValue as? ViewModel)?.unbind(self)
            configureBindings(with: viewModel as? ViewModel)
        }
    }

    init(with viewModel: ViewModel? = nil) {
        self.viewModel = viewModel as? P
        super.init(frame: .zero)
        setupUI()
        configureBindings(with: viewModel)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        (viewModel as? ViewModel)?.unbind(self)
    }

    func configureBindings(with viewModel: ViewModel?) {}
    func setupUI() {}
}
