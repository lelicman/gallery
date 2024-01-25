//
//  PhotosListViewModel.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit

extension PhotosListViewModel {
    enum Action: Actionable {
        case isLoading(_ isLoading: Bool)
    }

    enum Event: Eventable {
        case selectItem(_ id: PhotoType.Identifier)
        case addItem
        case showError(_ error: Error)
    }
}

class PhotosListViewModel: BaseViewModel<PhotosListViewModel.Action, PhotosListViewModel.Event>,
                           PhotosListViewModelProtocol,
                           PhotosListViewModelExternalProtocol {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, PhotosListItemViewModel>
    private weak var dataSource: UITableViewDiffableDataSource<Int, PhotosListItemViewModel>?
    
    private var viewModels: [PhotosListItemViewModel] = [] {
        didSet {
            applySnapshot()
        }
    }
    private var isLoading: Bool = false {
        didSet {
            post(.isLoading(isLoading))
        }
    }
    
    private let getPhotosUseCase: GetPhotosUseCaseProtocol
    private let refreshPhotosUseCase: RefreshPhotosUseCaseProtocol
    private var isNeedToUpdatePhotos: Bool = false
    
    init(getPhotosUseCase: GetPhotosUseCaseProtocol = GetPhotosUseCase(),
         refreshPhotosUseCase: RefreshPhotosUseCaseProtocol = RefreshPhotosUseCase()) {
        self.getPhotosUseCase = getPhotosUseCase
        self.refreshPhotosUseCase = refreshPhotosUseCase
    }
    
    override func postInitialActions() {
        post(.isLoading(isLoading))
        getPhotosInitially()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        if let model = viewModels[safe: indexPath.row] {
            postEvent(.selectItem(model.id))
        }
    }
    
    func add() {
        postEvent(.addItem)
    }
    
    func viewWillAppear() {
        if isNeedToUpdatePhotos {
            refreshPhotos()
        } else {
            isNeedToUpdatePhotos = true
        }
    }
    
    func updateDataSource(_ dataSource: UITableViewDiffableDataSource<Int, PhotosListItemViewModel>) {
        self.dataSource = dataSource
    }
}

// MARK: - private functions
private extension PhotosListViewModel {
    func applySnapshot() {
        Task(priority: .utility) { [weak self] in
            guard let self else { return }
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(self.viewModels, toSection: 0)
            await self.dataSource?.applySnapshotUsingReloadData(snapshot)
        }
    }
    
    func refreshPhotos() {
        guard isLoading == false else { return }
        isLoading = true
        Task(priority: .utility) { [weak self] in
            guard let self else { return }
            let result = await self.refreshPhotosUseCase.refresh()
            self.isLoading = false
            if let error = result.error {
                self.postEvent(.showError(error))
            } else {
                self.viewModels = result.value?.map { PhotosListItemViewModel(with: $0) } ?? []
            }
        }
    }
    
    func getPhotosInitially() {
        Task(priority: .userInitiated) {
            let photos = await getPhotosUseCase.get()
            self.viewModels = photos.value?.map { PhotosListItemViewModel(with: $0) } ?? []
        }
    }
}
