//
//  SplashCoordinator.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit

extension SplashCoordinator {
    enum Event: Eventable {
        case finish
    }
}

class SplashCoordinator: BaseCoordinator<SplashCoordinator.Event, EmptySession> {
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        super.init()
    }
    
    func start() {
        let viewModel = SplashViewModel()
        let viewController = SplashViewController(with: viewModel, type: .code)
        window?.rootViewController = viewController
        setupObservers(for: viewModel)
    }
}

private extension SplashCoordinator {
    func setupObservers(for viewModel: SplashViewModel) {
        viewModel.bindEvents(self) { [weak self] event in
            guard let self else { return }
            switch event {
            case .finish:
                self.post(.finish)
            case .showError(let error):
                let action = AlertAction(title: R.string.localizable.ok(), completion: { [weak self] in
                    self?.post(.finish)
                }, style: .default)
                self.showAlert(message: error.localizedDescription, actions: [action])
            }
        }
    }
}

