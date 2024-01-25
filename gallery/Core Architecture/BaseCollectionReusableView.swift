//
//  BaseCollectionReusableView.swift
//  PDFScanner_free
//
//  Created by AP Alexey Bondar on 8/24/21.
//  Copyright © 2021 Apalon Apps. All rights reserved.
//

import Foundation
import UIKit

class BaseCollectionReusableView<P, ViewModel: BaseActionViewModelProtocol>: UICollectionReusableView {
    var viewModel: P? {
        didSet {
            (oldValue as? ViewModel)?.unbind(self)
            configureBindings(with: viewModel as? ViewModel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        (viewModel as? ViewModel)?.unbind(self)
    }

    override func prepareForReuse() {
        (viewModel as? ViewModel)?.unbind(self)
        viewModel = nil
    }

    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel as? P
    }

    func configureBindings(with viewModel: ViewModel?) {}
    func setupUI() {}
}
