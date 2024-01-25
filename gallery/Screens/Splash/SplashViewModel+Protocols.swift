//
//  SplashViewModel+Protocols.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import Foundation

protocol SplashViewModelProtocol {

}

protocol SplashViewModelExternalProtocol {
    func bindEvents(_ object: AnyObject, _ handler: @escaping ((SplashViewModel.Event) -> Void))
}
