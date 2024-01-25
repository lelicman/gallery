//
//  AddPostViewModel+Protocols.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//  

import Foundation

protocol AddPostViewModelProtocol {
    func createPost(with title: String, description: String)
}

protocol AddPostViewModelExternalProtocol {
    func bindEvents(_ object: AnyObject, _ handler: @escaping ((AddPostViewModel.Event) -> Void))
}
