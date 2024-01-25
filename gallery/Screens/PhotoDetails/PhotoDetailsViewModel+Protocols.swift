//
//  PhotoDetailsViewModel+Protocols.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import Foundation
import UIKit

protocol PhotoDetailsViewModelProtocol {
    func share(_ photo: UIImage?)
}

protocol PhotoDetailsViewModelExternalProtocol {
    func bindEvents(_ object: AnyObject, _ handler: @escaping ((PhotoDetailsViewModel.Event) -> Void))
}
