//
//  PhotosRepository.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation
import RealmSwift

enum PhotosRepositoryError: LocalizedError {
    case photosNotFound
    case photoNotFound
    
    var errorDescription: String? {
        switch self {
        case .photosNotFound:
            return R.string.localizable.photosNotFound()
        case .photoNotFound:
            return R.string.localizable.photoWithRequestedIdIsNotFound()
        }
    }
}

protocol PhotosRepositoryProtocol {
    func get() async -> Result<[PhotoType]>
    func set(_ photos: [PhotoType]) async -> Result<Void>
    func get(by id: PhotoType.Identifier) async -> Result<PhotoType>
    func get(by id: AlbumType.Identifier) async -> Result<[PhotoType]>
}

class PhotosRepository: PhotosRepositoryProtocol {
    private let converter: PhotosConverterType
    private let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
         converter: PhotosConverterType = PhotosConverter()) {
        self.configuration = configuration
        self.converter = converter
    }

    func get(by id: PhotoType.Identifier) async -> Result<PhotoType> {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else { return }
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: self.configuration)
                    guard let result = realm.object(ofType: RealmPhoto.self, forPrimaryKey: id.rawValue) else {
                        continuation.resume(returning: Result(error: PhotosRepositoryError.photoNotFound))
                        return
                    }
                    let photo = self.converter.from(result)
                    continuation.resume(returning: Result(value: photo))
                } catch {
                    continuation.resume(returning: Result(error: error))
                }
            }
        }
    }
    
    func get(by id: AlbumType.Identifier) async -> Result<[PhotoType]> {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else { return }
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: self.configuration)
                    let result = realm
                        .objects(RealmPhoto.self)
                        .filter("albumId == \(id.rawValue)")
                        .sorted(byKeyPath: "id", ascending: true)
                    let photos = self.converter.from(Array(result))
                    continuation.resume(returning: Result(value: photos))
                } catch {
                    continuation.resume(returning: Result(error: error))
                }
            }
        }
    }
    
    func get() async -> Result<[PhotoType]> {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else { return }
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: self.configuration)
                    let result = realm.objects(RealmPhoto.self).sorted(byKeyPath: "id", ascending: true)
                    
                    let photos = self.converter.from(Array(result))
                    continuation.resume(returning: Result(value: photos))
                } catch {
                    continuation.resume(returning: Result(error: error))
                }
            }
        }
    }
    
    func set(_ photos: [PhotoType]) async -> Result<Void> {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else { return }
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: self.configuration)
                    try realm.write {
                        let models: [RealmPhoto] = photos.map { photo in
                            let model = RealmPhoto()
                            model.id = photo.id.rawValue
                            model.albumId = photo.albumId.rawValue
                            model.title = photo.title
                            model.url = photo.url?.absoluteString ?? ""
                            model.thumbnailUrl = photo.thumbnailUrl?.absoluteString ?? ""
                            return model
                        }
                        realm.add(models, update: .modified)
                    }
                    continuation.resume(returning: Result(value: ()))
                } catch {
                    continuation.resume(returning: Result(error: error))
                }
            }
        }
    }
}
