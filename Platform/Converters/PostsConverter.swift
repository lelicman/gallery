//
//  PostsConverter.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

protocol PostsConverterType {
    func from(_ model: PostType) -> CreatePostRequest
    func from(_ response: [PostResponse]) -> [PostType]
    func from(_ response: PostResponse) -> PostType
}

class PostsConverter: PostsConverterType {
    func from(_ model: PostType) -> CreatePostRequest {
        CreatePostRequest(title: model.title, body: model.description, userId: model.userId)
    }
    
    func from(_ response: [PostResponse]) -> [PostType] {
        response.map(from)
    }
    
    func from(_ response: PostResponse) -> PostType {
        Post(id: response.id,
             userId: response.userId,
             title: response.title,
             description: response.body)
    }
}
