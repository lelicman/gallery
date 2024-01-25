//
//  BaseActionableControl.swift
//  FlightRadar
//
//  Created by Alexey Bondar on 8/3/23.
//  Copyright © 2023 Apalon. All rights reserved.
//

import UIKit

class BaseActionableControl<P, ViewModel: BaseActionViewModelProtocol>: UIControl {
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
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: [.curveLinear],
                           animations: { [weak self] in
                guard let self = self else { return }
                self.alpha = self.isHighlighted ? 0.1 : 1
            }, completion: nil)
        }
    }

    func configureBindings(with viewModel: ViewModel?) {}
    func setupUI() {}
}
