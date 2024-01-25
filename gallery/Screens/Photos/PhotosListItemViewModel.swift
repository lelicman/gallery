//
//  PhotosListItemViewModel.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit

extension PhotosListItemViewModel {
    enum Action: Actionable {
        case modelUpdated(_ model: PhotoType)
    }

    enum Event: Eventable {
        
    }
}

class PhotosListItemViewModel: BaseViewModel<PhotosListItemViewModel.Action, PhotosListItemViewModel.Event>,
                               PhotosListItemViewModelProtocol,
                               PhotosListItemViewModelExternalProtocol {
    var id: PhotoType.Identifier {
        model.id
    }
    
    private let model: PhotoType
    
    init(with model: PhotoType) {
        self.model = model
    }
    
    override func postInitialActions() {
        post(.modelUpdated(model))
    }
}

// MARK: - Hashable protocol
extension PhotosListItemViewModel {
    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(model.id)
        return hasher.finalize()
    }
    
    static func == (lhs: PhotosListItemViewModel, rhs: PhotosListItemViewModel) -> Bool {
        return lhs.model.id == rhs.model.id &&
               lhs.model.albumId == rhs.model.albumId &&
               lhs.model.title == rhs.model.title &&
               lhs.model.thumbnailUrl == rhs.model.thumbnailUrl &&
               lhs.model.url == rhs.model.url
    }
}
