//
//  GetPhotosUseCase.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

protocol GetPhotosUseCaseProtocol {
    func get() async -> Result<[PhotoType]>
    func get(by albumId: AlbumType.Identifier) async -> Result<[PhotoType]>
}

class GetPhotosUseCase: GetPhotosUseCaseProtocol {
    private let repository: PhotosRepositoryProtocol
    
    init(repository: PhotosRepositoryProtocol = PhotosRepository()) {
        self.repository = repository
    }
    
    func get() async -> Result<[PhotoType]> {
        await repository.get()
    }
    
    func get(by albumId: AlbumType.Identifier) async -> Result<[PhotoType]> {
        await repository.get(by: albumId)
    }
}
