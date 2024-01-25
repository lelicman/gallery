//
//  PhotosListViewModel+Protocols.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import Foundation
import UIKit

protocol PhotosListViewModelProtocol {
    func didSelectItem(at indexPath: IndexPath)
    func add()
    func viewWillAppear()
    func updateDataSource(_ dataSource: UITableViewDiffableDataSource<Int, PhotosListItemViewModel>)
}

protocol PhotosListViewModelExternalProtocol {
    func bindEvents(_ object: AnyObject, _ handler: @escaping ((PhotosListViewModel.Event) -> Void))
}
