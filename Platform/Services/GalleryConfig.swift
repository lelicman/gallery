//
//  GalleryConfig.swift
//  gallery
//
//  Created by Alexey Bondar on 1/20/24.
//

import Foundation
import Moya
import Alamofire

struct GalleryConfig {
    static let url = "https://jsonplaceholder.typicode.com"
    static let userId: UserType.Identifier = 20
    
    
    static func defaultProvider<TargetType>() -> MoyaProvider<TargetType> {
        return MoyaProvider()
    }
}
