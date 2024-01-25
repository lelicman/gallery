//
//  IdentifiableExtensions.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

extension IdentifierOf: Codable where Value.RawIdentifier: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Value.RawIdentifier.self)
        self.init(rawValue: rawValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension IdentifierOf: Hashable where Value.RawIdentifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    static func == (lhs: IdentifierOf, rhs: IdentifierOf) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
