//
//  Cells+ReuseIdentifiable.swift
//  gallery
//
//  Created by Alexey Bondar on 1/22/24.
//

import Foundation
import UIKit

protocol ReuseIdentifiable {
    static func reuseIdentifier() -> String
}

extension ReuseIdentifiable {
    static func reuseIdentifier() -> String {
        return String(describing: self)
    }
}

protocol KindIdentifiable {
    static var kind: String { get }
}

extension KindIdentifiable {
    static var kind: String {
        return String(describing: self) + "Kind"
    }
}

extension UITableViewCell: ReuseIdentifiable {}
extension UICollectionReusableView: ReuseIdentifiable, KindIdentifiable {}
