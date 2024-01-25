//
//  PhotosListItemViewModel+Protocols.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import Foundation

protocol PhotosListItemViewModelProtocol: Hashable {
    var id: PhotoType.Identifier { get }
}

protocol PhotosListItemViewModelExternalProtocol {
    func bindEvents(_ object: AnyObject, _ handler: @escaping ((PhotosListItemViewModel.Event) -> Void))
}
