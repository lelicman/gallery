//
//  PhotosResponse.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

struct PhotosResponse: Codable {
    let photos: [PhotoResponse]
}

extension PhotosResponse {
    static let sample: [Any] = [
        [
            "albumId": 100,
            "id": 4951,
            "title": "ut maxime reiciendis veritatis",
            "url": "https://via.placeholder.com/600/92bfbf",
            "thumbnailUrl": "https://via.placeholder.com/150/92bfbf"
        ],
        [
            "albumId": 100,
            "id": 4952,
            "title": "eos accusamus illum sunt consequatur qui",
            "url": "https://via.placeholder.com/600/7938b2",
            "thumbnailUrl": "https://via.placeholder.com/150/7938b2"
        ]
    ]
}
