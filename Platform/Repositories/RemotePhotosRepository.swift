//
//  RemotePhotosRepository.swift
//  gallery
//
//  Created by Alexey Bondar on 1/20/24.
//

import Foundation
import Moya

enum RemotePhotosRepositoryError: LocalizedError {
    case albumNotFound
    case photosNotFound
    
    var errorDescription: String? {
        switch self {
        case .albumNotFound:
            return R.string.localizable.albumWithRequestedIdIsNotFound()
        case .photosNotFound:
            return R.string.localizable.photosNotFound()
        }
    }
}

protocol RemotePhotosRepositoryProtocol {
    //TODO: It is impossible to provide fetching photos page by page with fixed batch size as the remote api does not support such functionality
    func get(by albumId: Album.Identifier) async -> Result<[PhotoType]>
    func get() async -> Result<[PhotoType]>
}

class RemotePhotosRepository: RemotePhotosRepositoryProtocol {
    let provider: MoyaProvider<PhotosService>
    let converter: PhotosConverterType
    
    init(provider: MoyaProvider<PhotosService> = GalleryConfig.defaultProvider(),
         converter: PhotosConverterType = PhotosConverter()) {
        self.provider = provider
        self.converter = converter
    }
    
    func get() async -> Result<[PhotoType]> {
        await withCheckedContinuation { [weak self] continuation in
            self?.provider.request(.photos) { [weak self] result in
                guard let self else {
                    continuation.resume(returning: Result(error: RemotePhotosRepositoryError.photosNotFound))
                    return
                }
                switch result {
                case let .success(moyaResponse):
                    do {
                        let response = try moyaResponse.map([PhotoResponse].self)
                        continuation.resume(returning: Result(value: self.converter.from(response)))
                    } catch {
                        continuation.resume(returning: Result(error: error))
                    }
                case let .failure(error):
                    continuation.resume(returning: Result(error: error))
                }
            }
        }
    }
    
    func get(by albumId: Album.Identifier) async -> Result<[PhotoType]> {
        await withCheckedContinuation { [weak self] continuation in
            let request = PhotosAlbumRequest(id: albumId)
            self?.provider.request(.album(request)) { [weak self] result in
                guard let self else {
                    continuation.resume(returning: Result(error: RemotePhotosRepositoryError.albumNotFound))
                    return
                }
                switch result {
                case let .success(moyaResponse):
                    do {
                        let response = try moyaResponse.map([PhotoResponse].self)
                        continuation.resume(returning: Result(value: self.converter.from(response)))
                    } catch {
                        continuation.resume(returning: Result(error: error))
                    }
                case let .failure(error):
                    continuation.resume(returning: Result(error: error))
                }
            }
        }
    }
}
