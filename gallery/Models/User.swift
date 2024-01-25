//
//  User.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation

protocol UserType {
    typealias Identifier = IdentifierOf<User>
    
    var id: Identifier { get }
}

struct User: UserType, Identifiable {
    typealias Identifier = IdentifierOf<User>
    typealias RawIdentifier = Int
    
    let id: Identifier
}
