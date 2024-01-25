//
//  SplashViewModel.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit

extension SplashViewModel {
    enum Action: Actionable {
        case isLoading(_ isLoading: Bool)
    }

    enum Event: Eventable {
        case finish
        case showError(_ error: Error)
    }
}

class SplashViewModel: BaseViewModel<SplashViewModel.Action, SplashViewModel.Event>,
                       SplashViewModelProtocol {
    private var isLoading: Bool = false {
        didSet {
            post(.isLoading(isLoading))
        }
    }
    private let refreshPhotosUseCase: RefreshPhotosUseCaseProtocol
    
    init(refreshPhotosUseCase: RefreshPhotosUseCaseProtocol = RefreshPhotosUseCase()) {
        self.refreshPhotosUseCase = refreshPhotosUseCase
    }
    
    override func postInitialActions() {
        post(.isLoading(isLoading))
        loadPhotos()
    }
}

private extension SplashViewModel {
    func loadPhotos() {
        isLoading = true
        Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let result = await self.refreshPhotosUseCase.refresh()
            self.isLoading = false
            if let error = result.error {
                self.postEvent(.showError(error))
            } else {
                self.postEvent(.finish)
            }
        }
    }
}
