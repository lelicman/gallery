//
//  GetRemotePostsUseCase.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

protocol GetRemotePostsUseCaseProtocol {
    func get() async -> Result<[PostType]>
}

class GetRemotePostsUseCase: GetRemotePostsUseCaseProtocol {
    private let repository: RemotePostsRepositoryProtocol
    
    init(repository: RemotePostsRepositoryProtocol = RemotePostsRepository()) {
        self.repository = repository
    }
    
    func get() async -> Result<[PostType]> {
        await repository.get()
    }
}
