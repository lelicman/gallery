//
//  Photo.swift
//  gallery
//
//  Created by Alexey Bondar on 1/20/24.
//

import Foundation

protocol PhotoType {
    typealias Identifier = IdentifierOf<Photo>
    typealias AlbumIdentifier = IdentifierOf<Album>
    
    var id: Identifier { get }
    var albumId: AlbumIdentifier { get }
    var title: String { get }
    var url: URL? { get }
    var thumbnailUrl: URL? { get }
}

struct Photo: PhotoType, Identifiable {
    typealias Identifier = IdentifierOf<Photo>
    typealias AlbumIdentifier = IdentifierOf<Album>
    typealias RawIdentifier = Int
    
    let id: Identifier
    let albumId: AlbumIdentifier
    let title: String
    let url: URL?
    let thumbnailUrl: URL?
}


