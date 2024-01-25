//
//  PhotosConverter.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

protocol PhotosConverterType {
    func from(_ response: [PhotoResponse]) -> [PhotoType]
    func from(_ response: PhotoResponse) -> PhotoType
    func from(_ models: [RealmPhoto]) -> [PhotoType]
    func from(_ model: RealmPhoto) -> PhotoType
}

class PhotosConverter: PhotosConverterType {
    func from(_ response: [PhotoResponse]) -> [PhotoType] {
        response.map(from)
    }
    
    func from(_ response: PhotoResponse) -> PhotoType {
        Photo(id: response.id,
              albumId: response.albumId,
              title: response.title,
              url: URL(string: response.url),
              thumbnailUrl: URL(string: response.thumbnailUrl))
    }
    
    func from(_ models: [RealmPhoto]) -> [PhotoType] {
        models.map(from)
    }
    
    func from(_ model: RealmPhoto) -> PhotoType {
        Photo(id: Photo.Identifier(rawValue: model.id),
              albumId: Photo.AlbumIdentifier(rawValue: model.albumId),
              title: model.title,
              url: URL(string: model.url),
              thumbnailUrl: URL(string: model.thumbnailUrl))
    }
}
