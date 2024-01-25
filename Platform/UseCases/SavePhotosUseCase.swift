//
//  SavePhotosUseCase.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

protocol SavePhotosUseCaseProtocol {
    func save(photos: [PhotoType]) async -> Result<Void>
}

class SavePhotosUseCase: SavePhotosUseCaseProtocol {
    let repository: PhotosRepositoryProtocol
    
    init(repository: PhotosRepositoryProtocol = PhotosRepository()) {
        self.repository = repository
    }
    
    func save(photos: [PhotoType]) async -> Result<Void> {
        await repository.set(photos)
    }
}
