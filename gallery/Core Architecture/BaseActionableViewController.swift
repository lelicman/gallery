//
//  BaseActionableViewController.swift
//  FlightRadar
//
//  Created by Alexey Bondar on 3/30/23.
//  Copyright © 2023 Apalon. All rights reserved.
//

import UIKit

extension BaseActionableViewController {
    enum InitType {
        case xib
        case code
    }
}

protocol BaseActionableViewControllerType {
    associatedtype Event
    typealias EventHandler = ((Event) -> Void)
    
    func bind(_ object: AnyObject, _ handler: @escaping EventHandler)
    func unbind(_ object: AnyObject)
    func post(_ event: Event)
}

class BaseActionableViewController<E: Eventable>: UIViewController, BaseActionableViewControllerType {
    typealias Event = E
    
    private var eventHandlers: [ObjectIdentifier: [EventHandler]] = [:]
        
    init(with type: InitType = .xib) {
        switch type {
        case .xib:
            super.init(nibName: String(describing: Self.self), bundle: .main)
        case .code:
            super.init(nibName: nil, bundle: nil)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {}
    
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
}

