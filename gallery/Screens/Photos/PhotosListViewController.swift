//
//  PhotosListViewController.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit

class PhotosListViewController: BaseViewController<PhotosListViewModelProtocol, PhotosListViewModel> {
    typealias DataSource = UITableViewDiffableDataSource<Int, PhotosListItemViewModel>
    
    private lazy var dataSource = makeDataSource()
    
    private lazy var cellProvider: UITableViewDiffableDataSource<Int, PhotosListItemViewModel>.CellProvider
    = { collectionView, indexPath, cellViewModel in
        let cell = self.tableView.dequeueReusableCell(withIdentifier: PhotosListItemTableViewCell.reuseIdentifier(),
                                                      for: indexPath) as? PhotosListItemTableViewCell
        cell?.configure(with: cellViewModel)
        return cell
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.contentInset.bottom = 20
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PhotosListItemTableViewCell.self, forCellReuseIdentifier: PhotosListItemTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        UIBarButtonItem(image: R.image.addIcon(),
                        style: .plain,
                        target: self,
                        action: #selector(add))
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = R.color.colors.text.default()
        return activityIndicator
    }()
    
    private lazy var loaderItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(customView: activityIndicator)
        buttonItem.isHidden = true
        return buttonItem
    }()
    
    override func configureBindings(with viewModel: PhotosListViewModel?) {
        guard let viewModel else { return }
        viewModel.bind(self) { [weak self] action in
            guard let self else { return }
            switch action {
            case .isLoading(let isLoading):
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
                self.loaderItem.isHidden = !isLoading
            }
        }
        viewModel.updateDataSource(dataSource)
    }

    override func setupUI() {
        configureNavigationBar()
        view.backgroundColor = R.color.colors.surface.background()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
}

// MARK: - private functions
private extension PhotosListViewController {
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = R.string.localizable.applicationTitle()
        navigationItem.rightBarButtonItems = [addButton]
        navigationItem.leftBarButtonItems = [loaderItem]
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
        return dataSource
    }
    
    @objc func add() {
        viewModel?.add()
    }
    
    @objc func willEnterForeground(_ notification: NSNotification?) {
        viewModel?.viewWillAppear()
    }
}

// MARK: - UITableViewDelegate
extension PhotosListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectItem(at: indexPath)
    }
}
