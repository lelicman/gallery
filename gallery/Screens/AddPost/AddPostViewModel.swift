//
//  AddPostViewModel.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//  

import UIKit

extension AddPostViewModel {
    enum Action: Actionable {
        case isLoading(_ isLoading: Bool)
    }

    enum Event: Eventable {
        case back
        case finished(_ post: PostType)
        case showError(_ error: Error)
    }
}

class AddPostViewModel: BaseViewModel<AddPostViewModel.Action, AddPostViewModel.Event>,
                        AddPostViewModelProtocol,
                        AddPostViewModelExternalProtocol {
    private var isLoading: Bool = false {
        didSet {
            post(.isLoading(isLoading))
        }
    }
    private let createPostUseCase: CreatePostUseCaseProtocol
    
    init(with createPostUseCase: CreatePostUseCaseProtocol = CreatePostUseCase()) {
        self.createPostUseCase = createPostUseCase
    }
    
    override func postInitialActions() {
        post(.isLoading(isLoading))
    }
    
    func createPost(with title: String, description: String) {
        isLoading = true
        Task(priority: .userInitiated) {
            let result = await createPostUseCase.create(with: title, description: description)
            isLoading = false
            if let post = result.value {
                postEvent(.finished(post))
            } else if let error = result.error {
                postEvent(.showError(error))
            } else {
                postEvent(.back)
            }
        }
    }
}
