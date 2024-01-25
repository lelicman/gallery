//
//  SplashViewController.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit
import SnapKit

class SplashViewController: BaseViewController<SplashViewModelProtocol, SplashViewModel> {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = R.string.localizable.applicationTitle()
        label.font = .titleBold
        label.textAlignment = .center
        label.textColor = R.color.colors.text.default()
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = R.color.colors.text.default()
        return activityIndicator
    }()
    
    override func configureBindings(with viewModel: SplashViewModel?) {
        guard let viewModel else { return }
        viewModel.bind(self) { [weak self] action in
            guard let self else { return }
            switch action {
            case .isLoading(let isLoading):
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
    }

    override func setupUI() {
        view.backgroundColor = R.color.colors.surface.background()
        setupSubviews()
    }
}

// MARK: - private functions
private extension SplashViewController {
    func setupSubviews() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
}
