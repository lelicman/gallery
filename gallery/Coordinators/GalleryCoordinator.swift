//
//  GalleryCoordinator.swift
//  gallery
//
//  Created by Alexey Bondar on 1/22/24.
//  

import UIKit

extension GalleryCoordinator {
    enum Event: Eventable {

    }
}

class GalleryCoordinator: BaseCoordinator<GalleryCoordinator.Event, EmptySession> {
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
        super.init()
    }
    
    func start() {
        let viewModel = PhotosListViewModel()
        let viewController = PhotosListViewController(with: viewModel, type: .code)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController?.navigationBar.tintColor = R.color.colors.text.default()
        window?.rootViewController = navigationController
        setupObservers(for: viewModel)
    }
}

// MARK: - private functions
private extension GalleryCoordinator {
    func toPhotoDetails(with id: PhotoType.Identifier) {
        let viewModel = PhotoDetailsViewModel(with: id)
        let viewController = PhotoDetailsViewController(with: viewModel, type: .code)
        viewModel.bindEvents(self) { event in
            switch event {
            case .back:
                self.navigationController?.popToRootViewController(animated: true)
            case .share(let photo):
                self.share(photo)
            }
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupObservers(for viewModel: PhotosListViewModel) {
        viewModel.bindEvents(self) { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .selectItem(let id):
                self.toPhotoDetails(with: id)
            case .addItem:
                self.toAddItem()
            case .showError(let error):
                self.showDefaultAlert(with: error.localizedDescription)
            }
        }
    }
    
    func toAddItem() {
        let viewModel = AddPostViewModel()
        let viewController = AddPostViewController(with: viewModel, type: .code)
        viewModel.bindEvents(self) { event in
            switch event {
            case .back:
                self.navigationController?.popToRootViewController(animated: true)
            case .finished(let post):
                let action = AlertAction(title: R.string.localizable.ok(), completion: { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                }, style: .default)
                self.showAlert(message: R.string.localizable.newPostDWasCreated(post.id.rawValue), actions: [action])
            case .showError(let error):
                self.showDefaultAlert(with: error.localizedDescription)
            }
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func share(_ photo: UIImage?) {
        guard let photo else {
            showDefaultAlert(with: R.string.localizable.unableToShareThePhoto())
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = navigationController?.view
        
        activityViewController.excludedActivityTypes = [.print, .saveToCameraRoll, .assignToContact]
        navigationController?.present(activityViewController, animated: true, completion: nil)
    }
}
