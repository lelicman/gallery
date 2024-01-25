//
//  GetPhotoUseCase.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

protocol GetPhotoUseCaseProtocol {
    func get(by id: PhotoType.Identifier) async -> Result<PhotoType>
}

class GetPhotoUseCase: GetPhotoUseCaseProtocol {
    private let repository: PhotosRepositoryProtocol
    
    init(repository: PhotosRepositoryProtocol = PhotosRepository()) {
        self.repository = repository
    }
    
    func get(by id: PhotoType.Identifier) async -> Result<PhotoType> {
        await repository.get(by: id)
    }
}
