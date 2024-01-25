//
//  CreatePostRequest.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

struct CreatePostRequest: Encodable {
    let title: String
    let body: String
    let userId: UserType.Identifier
}
