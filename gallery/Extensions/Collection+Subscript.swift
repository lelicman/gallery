//
//  Collection+Subscript.swift
//  gallery
//
//  Created by Alexey Bondar on 1/22/24.
//

extension Collection {
    public subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else {
            let message = "Accessing collection element by out of bounds index. Collection :\(self), Index: \(index)."
            print(message)
            return nil
        }

        return self[index]
    }
}
