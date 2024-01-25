//
//  CreatePostUseCase.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

protocol CreatePostUseCaseProtocol {
    func create(with title: String, description: String) async -> Result<PostType>
}

class CreatePostUseCase: CreatePostUseCaseProtocol {
    let repository: RemotePostsRepositoryProtocol
    
    init(repository: RemotePostsRepositoryProtocol = RemotePostsRepository()) {
        self.repository = repository
    }
    
    func create(with title: String, description: String) async -> Result<PostType> {
        await repository.create(with: title, description: description)
    }
}

