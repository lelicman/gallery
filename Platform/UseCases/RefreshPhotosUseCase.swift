//
//  RefreshPhotosUseCase.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

protocol RefreshPhotosUseCaseProtocol {
    func refresh() async -> Result<[PhotoType]>
}

class RefreshPhotosUseCase: RefreshPhotosUseCaseProtocol {
    private let getRemotePhotosUseCase: GetRemotePhotosUseCaseProtocol
    private let savePhotosUseCase: SavePhotosUseCaseProtocol
    private let getPhotosUseCase: GetPhotosUseCaseProtocol
    
    init(getRemotePhotosUseCase: GetRemotePhotosUseCaseProtocol = GetRemotePhotosUseCase(),
         savePhotosUseCase: SavePhotosUseCaseProtocol = SavePhotosUseCase(),
         getPhotosUseCase: GetPhotosUseCaseProtocol = GetPhotosUseCase()) {
        self.getRemotePhotosUseCase = getRemotePhotosUseCase
        self.savePhotosUseCase = savePhotosUseCase
        self.getPhotosUseCase = getPhotosUseCase
    }
    
    func refresh() async -> Result<[PhotoType]> {
        let result = await getRemotePhotosUseCase.get()
        if let photos = result.value {
            _ = await savePhotosUseCase.save(photos: photos)
            return await getPhotosUseCase.get()
        } else {
            return result
        }
    }
}
