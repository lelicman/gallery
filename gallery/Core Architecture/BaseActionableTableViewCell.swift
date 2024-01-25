//
//  BaseTableViewCell.swift
//  PDFScanner_free
//
//  Created by AP Alexey Bondar on 6/10/21.
//  Copyright © 2021 Apalon Apps. All rights reserved.
//

import UIKit

class BaseActionableTableViewCell<P, ViewModel: BaseActionViewModelProtocol>: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    var viewModel: P? {
        didSet {
            (oldValue as? ViewModel)?.unbind(self)
            configureBindings(with: viewModel as? ViewModel)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        (viewModel as? ViewModel)?.unbind(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        (viewModel as? ViewModel)?.unbind(self)
        viewModel = nil
    }

    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel as? P
    }

    func configureBindings(with viewModel: ViewModel?) {}
    func setupUI() {}
}
