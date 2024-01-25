//
//  PhotoResponse.swift
//  gallery
//
//  Created by Alexey Bondar on 1/20/24.
//

import Foundation

struct PhotoResponse: Codable {
    let id: PhotoType.Identifier
    let albumId: AlbumType.Identifier
    let title: String
    let url: String
    let thumbnailUrl: String
}
