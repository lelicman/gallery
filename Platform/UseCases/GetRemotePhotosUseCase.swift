//
//  GetRemotePhotosUseCase.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

protocol GetRemotePhotosUseCaseProtocol {
    func get() async -> Result<[PhotoType]>
    func get(by albumId: AlbumType.Identifier) async -> Result<[PhotoType]>
}

class GetRemotePhotosUseCase: GetRemotePhotosUseCaseProtocol {
    private let repository: RemotePhotosRepositoryProtocol
    
    init(repository: RemotePhotosRepositoryProtocol = RemotePhotosRepository()) {
        self.repository = repository
    }
    
    func get() async -> Result<[PhotoType]> {
        await repository.get()
    }
    
    func get(by albumId: AlbumType.Identifier) async -> Result<[PhotoType]> {
        await repository.get(by: albumId)
    }
}
