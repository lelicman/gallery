//
//  PostsService.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation
import Moya

enum PostsService {
    case create(_ request: CreatePostRequest)
    case posts
}

extension PostsService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: GalleryConfig.url) else { fatalError() }
        return url
    }
    
    var path: String {
        switch self {
        case .create, .posts:
            return "/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .posts:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .create(let request):
            return .requestJSONEncodable(request)
        case .posts:
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        switch self {
        case .create:
            return Data()
        case .posts:
            return sampleData(from: PostsResponse.sample)   
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

