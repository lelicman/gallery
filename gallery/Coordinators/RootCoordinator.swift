//
//  RootCoordinator.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import UIKit

extension RootCoordinator {
    enum Event: Eventable {

    }
}

class RootCoordinator: BaseCoordinator<RootCoordinator.Event, EmptySession> {
    var window: UIWindow?
    private var isGalleyLoaded: Bool = false
    private var isAlertPosponed: Bool = false
    
    init(window: UIWindow) {
        self.window = window
        self.window?.rootViewController = ViewController()
        super.init()
    }
    
    func showWokeUpAlert() {
        guard isGalleyLoaded else {
            isAlertPosponed = true
            return
        }
        showDefaultAlert(with: R.string.localizable.iWokeUp())
    }
    
    func start() {
        toSplashLoader()
    }
}

// MARK: - private functions
private extension RootCoordinator {
    func toSplashLoader() {
        let coordinator = SplashCoordinator(window: window)
        coordinator.bind(self) { [weak self, weak coordinator] event in
            guard let self = self else { return }
            switch event {
            case .finish:
                if let coordinator = coordinator {
                    self.childCompleted(coordinator)
                }
                self.isGalleyLoaded = true
                self.toGallery()
                if self.isAlertPosponed {
                    self.showDefaultAlert(with: R.string.localizable.iWokeUp())
                }
            }
        }
        
        childStarted(coordinator)
        coordinator.start()
    }
    
    func toGallery() {
        let coordinator = GalleryCoordinator(window: window)
        coordinator.bind(self) { _ in }
        childStarted(coordinator)
        coordinator.start()
    }
}
