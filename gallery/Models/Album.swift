//
//  Album.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

protocol AlbumType {
    typealias Identifier = IdentifierOf<Album>
    
    var id: Identifier { get }
    var photos: [PhotoType] { get }
}

struct Album: AlbumType, Identifiable {
    typealias Identifier = IdentifierOf<Album>
    typealias RawIdentifier = Int
    
    let id: Identifier
    let photos: [PhotoType]
}
