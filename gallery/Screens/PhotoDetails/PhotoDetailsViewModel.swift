//
//  PhotoDetailsViewModel.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit

extension PhotoDetailsViewModel {
    enum Action: Actionable {
        case modelUpdated(_ model: PhotoType)
    }

    enum Event: Eventable {
        case back
        case share(_ photo: UIImage?)
    }
}

class PhotoDetailsViewModel: BaseViewModel<PhotoDetailsViewModel.Action,
                                                       PhotoDetailsViewModel.Event>,
                                         PhotoDetailsViewModelProtocol,
                                         PhotoDetailsViewModelExternalProtocol {
    private let getPhotoUseCase: GetPhotoUseCaseProtocol
    
    private let id: PhotoType.Identifier
    
    init(with id: PhotoType.Identifier, getPhotoUseCase: GetPhotoUseCaseProtocol = GetPhotoUseCase()) {
        self.id = id
        self.getPhotoUseCase = getPhotoUseCase
    }
    
    override func postInitialActions() {
        load()
    }
    
    func share(_ photo: UIImage?) {
        postEvent(.share(photo))
    }
}

// MARK: - private functions
private extension PhotoDetailsViewModel {
    func load() {
        Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            let result = await self.getPhotoUseCase.get(by: self.id)
            if let model = result.value {
                self.post(.modelUpdated(model))
            } else {
                self.postEvent(.back)
            }
        }
    }
}
