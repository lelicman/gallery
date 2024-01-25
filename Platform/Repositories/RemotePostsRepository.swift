//
//  RemotePostsRepository.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation
import Moya

enum RemotePostsRepositoryError: LocalizedError {
    case postsNotFound
    case unableToCreatePost
    
    var errorDescription: String? {
        switch self {
        case .postsNotFound:
            return R.string.localizable.postsNotFound()
        case .unableToCreatePost:
            return R.string.localizable.unableToCreatePost()
        }
    }
}

protocol RemotePostsRepositoryProtocol {
    func create(with title: String, description: String) async -> Result<PostType>
    func get() async -> Result<[PostType]>
}

class RemotePostsRepository: RemotePostsRepositoryProtocol {
    let provider: MoyaProvider<PostsService>
    let converter: PostsConverterType
    
    init(provider: MoyaProvider<PostsService> = GalleryConfig.defaultProvider(),
         converter: PostsConverterType = PostsConverter()) {
        self.provider = provider
        self.converter = converter
    }
    
    func get() async -> Result<[PostType]> {
        await withCheckedContinuation { [weak self] continuation in
            self?.provider.request(.posts) { [weak self] result in
                guard let self else {
                    continuation.resume(returning: Result(error: RemotePostsRepositoryError.postsNotFound))
                    return
                }
                switch result {
                case let .success(moyaResponse):
                    do {
                        let response = try moyaResponse.map([PostResponse].self)
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
    
    func create(with title: String, description: String) async -> Result<PostType> {
        await withCheckedContinuation { [weak self] continuation in
            let request = CreatePostRequest(title: title, body: description, userId: GalleryConfig.userId)
            self?.provider.request(.create(request)) { [weak self] result in
                guard let self else {
                    continuation.resume(returning: Result(error: RemotePostsRepositoryError.unableToCreatePost))
                    return
                }
                switch result {
                case let .success(moyaResponse):
                    do {
                        let response = try moyaResponse.map(PostResponse.self)
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
