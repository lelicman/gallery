//
//  PhotosService.swift
//  gallery
//
//  Created by Alexey Bondar on 1/20/24.
//

import Foundation
import Moya

enum PhotosService {
    case photos
    case album(_ request: PhotosAlbumRequest)
}

extension PhotosService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: GalleryConfig.url) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .photos, .album:
            return "/photos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .photos, .album:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .photos:
            return .requestPlain
        case .album(let request):
            return .requestParameters(parameters: ["albumId": request.id.rawValue], encoding: URLEncoding.queryString)
        }
    }
    
    var sampleData: Data {
        switch self {
        case .photos, .album:
            return sampleData(from: PhotosResponse.sample)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
