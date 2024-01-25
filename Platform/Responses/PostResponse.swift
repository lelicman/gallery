//
//  PostResponse.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

struct PostResponse: Codable {
    let id: PostType.Identifier
    let userId: UserType.Identifier
    let title: String
    let body: String
}
