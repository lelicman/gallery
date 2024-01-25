//
//  Post.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

protocol PostType {
    typealias Identifier = IdentifierOf<Post>
    
    var id: Identifier { get }
    var userId: UserType.Identifier { get }
    var title: String { get }
    var description: String { get }
}

struct Post: PostType, Identifiable {
    typealias Identifier = IdentifierOf<Post>
    typealias RawIdentifier = Int
    
    let id: Identifier
    let userId: UserType.Identifier
    let title: String
    let description: String
}
