//
//  BaseCoordinator.swift
//  FlightRadar
//
//  Created by Alexey Bondar on 3/28/23.
//  Copyright © 2023 Apalon. All rights reserved.
//

import UIKit
#if canImport(Apalon_DebugMenu)
import Apalon_DebugMenu
#endif

protocol Sessionable {}

class EmptySession: Sessionable {}

protocol BaseCoordinatorType: BaseCoordinatorAction, BaseCoordinatorSession {
    associatedtype Event
    typealias EventHandler = ((Event) -> Void)
    
    func bind(_ object: AnyObject, _ handler: @escaping EventHandler)
    func unbind(_ object: AnyObject)
    func post(_ event: Event)
}

protocol BaseCoordinatorSession {
    associatedtype Session
    var session: Session? { get set }
}

protocol BaseCoordinatorAction {
    func canProcess(request: CoordinatorRequestType) -> Bool
    func handleRequest(_ request: CoordinatorRequestType)
    func executeRequest(_ request: CoordinatorRequestType)
}

class BaseCoordinator<E: Eventable, S: Sessionable>: NSObject, BaseCoordinatorType {
    typealias Event = E
    typealias Session = S
    
    private let sessionRepository: SessionRepositoryProtocol = SessionRepository.shared
    
    var session: Session? {
        get {
            sessionRepository.getSession(of: Session.self) as? Session
        }
        set {
            sessionRepository.setSession(newValue)
        }
    }
    
    private var eventHandlers: [ObjectIdentifier: [EventHandler]] = [:]
    var currentViewController: UIViewController?
    var childCoordinators = [NSObject]()
    var nextCoordinator: BaseCoordinatorAction? {
        childCoordinators.last as? BaseCoordinatorAction
    }
        
    override init() {
        super.init()
    }
    
    func start(with presenter: UIViewController) {}
    
    func bind(_ object: AnyObject, _ handler: @escaping EventHandler) {
        let identifier = ObjectIdentifier(object)
        var existingEventHandlers = eventHandlers[identifier] ?? []
        existingEventHandlers.append(handler)
        eventHandlers[identifier] = existingEventHandlers
    }
    
    func unbind(_ object: AnyObject) {
        let identifier = ObjectIdentifier(object)
        eventHandlers.removeValue(forKey: identifier)
    }
    
    func post(_ action: E) {
        eventHandlers.values.flatMap { $0 }.forEach { element in
            DispatchQueue.main.async {
                element(action)
            }
        }
    }
    
    func childStarted(_ coordinator: NSObject) {
        childCoordinators.append(coordinator)
    }
    
    func childCompleted(_ coordinator: NSObject) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
        self.unbind(coordinator)
    }
    
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   actions: [AlertAction],
                   style: UIAlertController.Style = .alert,
                   sourceView: UIView? = nil,
                   presenter: UIViewController? = UIApplication.shared.topMostViewController()) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            controller.addAction(action.alertAction)
        }
        
        if controller.popoverPresentationController != nil {
            controller.popoverPresentationController?.sourceView = sourceView
        }
        
        (presenter ?? currentViewController)?.present(controller, animated: true, completion: nil)
    }
    
    func showDefaultAlert(with message: String? = nil) {
        guard let message = message else { return }
        let okAction = AlertAction(title: R.string.localizable.ok(),
                              completion: nil,
                              style: .default)
        showAlert(title: R.string.localizable.applicationTitle(),
                  message: message,
                  actions: [okAction],
                  presenter: UIApplication.shared.topMostViewController())
    }
    
    func showNoInternetConnectionAlert(completion: (() -> Void)? = nil) {
        let okAction = AlertAction(title: R.string.localizable.ok(),
                              completion: {
                                if let completion = completion {
                                    completion()
                                }
                              },
                              style: .default)
        showAlert(title: R.string.localizable.applicationTitle(),
                  message: R.string.localizable.noInternetConnection(),
                  actions: [okAction])
    }
    
    func openPushSettings() {
        if let bundleIdentifier = Bundle.main.bundleIdentifier,
           let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }
    }
    
    func canProcess(request: CoordinatorRequestType) -> Bool {
        false
    }
    
    func handleRequest(_ request: CoordinatorRequestType) {
        guard canProcess(request: request) else {
            nextCoordinator?.handleRequest(request)
            return
        }
        
        executeRequest(request)
    }
    
    func executeRequest(_ request: CoordinatorRequestType) {
        fatalError("This method should be overridden in a subclass.")
    }
}

#if canImport(Apalon_DebugMenu)
extension BaseCoordinator: BaseCoordinatorPresentableProtocol {

}
#endif
