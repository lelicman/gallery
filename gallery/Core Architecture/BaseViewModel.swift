//
//  BaseViewModel.swift
//  FlightRadar
//
//  Created by Alexey Bondar on 3/27/23.
//  Copyright © 2023 Apalon. All rights reserved.
//

import Foundation

protocol Actionable {}
protocol Eventable {}

protocol BaseActionViewModelProtocol {
    associatedtype Action
    typealias ActionHandler = ((Action) -> Void)

    func bind(_ object: AnyObject, _ handler: @escaping ActionHandler)
    func unbind(_ object: AnyObject)
}

protocol BaseEventViewModelProtocol {
    associatedtype Event
    typealias EventHandler = ((Event) -> Void)

    func bindEvents(_ object: AnyObject, _ handler: @escaping EventHandler)
    func unbindEvents(_ object: AnyObject)
}

protocol BaseViewModelType: BaseActionViewModelProtocol, BaseEventViewModelProtocol {
    func postEvent(_ action: Event)
    func post(_ action: Action)
    func post(_ action: Action, after: DispatchTime)
    func postInitialActions()
}

class BaseViewModel<A: Actionable, E: Eventable>: NSObject, BaseViewModelType {
    typealias Action = A
    typealias Event = E
    private var actionHandlers: [ObjectIdentifier: ActionHandler] = [:]
    private var eventHandlers: [ObjectIdentifier: EventHandler] = [:]

    func bind(_ object: AnyObject, _ handler: @escaping ActionHandler) {
        let identifier = ObjectIdentifier(object)
        actionHandlers[identifier] = handler
        postInitialActions()
    }

    func bindEvents(_ object: AnyObject, _ handler: @escaping EventHandler) {
        let identifier = ObjectIdentifier(object)
        eventHandlers[identifier] = handler
    }

    func postInitialActions() {}

    func unbind(_ object: AnyObject) {
        let identifier = ObjectIdentifier(object)
        actionHandlers.removeValue(forKey: identifier)
    }

    func unbindEvents(_ object: AnyObject) {
        let identifier = ObjectIdentifier(object)
        eventHandlers.removeValue(forKey: identifier)
    }

    func post(_ action: A) {
        actionHandlers.values.forEach { element in
            if Thread.isMainThread {
                element(action)
            } else {
                DispatchQueue.main.async {
                    element(action)
                }
            }
        }
    }
    
    func post(_ action: A, after: DispatchTime) {
        actionHandlers.values.forEach { element in
            DispatchQueue.main.asyncAfter(deadline: after) {
                element(action)
            }
        }
    }

    func postEvent(_ action: E) {
        eventHandlers.values.forEach { element in
            if Thread.isMainThread {
                element(action)
            } else {
                DispatchQueue.main.async {
                    element(action)
                }
            }
        }
    }
}
