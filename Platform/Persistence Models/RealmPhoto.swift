//
//  RealmPhoto.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//

import Foundation
import RealmSwift

class RealmPhoto: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var albumId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var thumbnailUrl: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
