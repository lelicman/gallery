//
//  Identifiable.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation

public protocol Identifiable {
    associatedtype RawIdentifier: Comparable = String
    associatedtype IdentifierType: Identifiable
    
    var id: IdentifierOf<IdentifierType> { get }
}

public struct IdentifierOf<Value: Identifiable>: RawRepresentable, Comparable {
    public let rawValue: Value.RawIdentifier
    
    public init(rawValue: Value.RawIdentifier) {
        self.rawValue = rawValue
    }
    
    public static func == (lhs: IdentifierOf<Value>, rhs: IdentifierOf<Value>) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public static func < (lhs: IdentifierOf<Value>, rhs: IdentifierOf<Value>) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension IdentifierOf: ExpressibleByIntegerLiteral where Value.RawIdentifier == Int {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }
}
